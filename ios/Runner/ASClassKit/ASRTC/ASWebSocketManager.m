//
//  ASWebSocketManager.m
//  AS
//
//  Created by SA on 2025/5/19.
//

#import "ASWebSocketManager.h"

@interface ASWebSocketManager()<SRWebSocketDelegate>
@property (nonatomic, strong) NSTimer *heartBeatTimer;
@property (nonatomic, strong) NSTimer *netWorkTestingTimer;
@property (nonatomic, assign) NSTimeInterval reConnectTime;
@property (nonatomic, strong) NSMutableArray *sendDataArray;
@property (nonatomic, assign) BOOL isActivelyClose;
@end

@implementation ASWebSocketManager

+ (instancetype)shared {
    static ASWebSocketManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if(self){
        self.reConnectTime = 0;
        self.isActivelyClose = NO;
        self.sendDataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

//建立长连接
- (void)connectServer {
    self.isActivelyClose = NO;
    self.webSocket.delegate = nil;
    [self.webSocket close];
    _webSocket = nil;
    self.webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:STRING(self.socket_url)]];
    self.webSocket.delegate = self;
    [self.webSocket open];
}

- (void)sendPing:(id)sender {
    [self.webSocket sendPing:nil error:NULL];
}

#pragma mark - socket delegate
//开始连接
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    ASLog(@"socket 开始连接");
    self.isConnect = YES;
    self.connectType = WebSocketConnect;
    [self initHeartBeat];///开始心跳
}

//连接失败
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    ASLog(@"连接失败");
    self.isConnect = NO;
    self.connectType = WebSocketDisconnect;
    ASLog(@"连接失败，这里可以实现掉线自动重连，要注意以下几点");
    ASLog(@"1.判断当前网络环境，如果断网了就不要连了，等待网络到来，在发起重连");
    ASLog(@"3.连接次数限制，如果连接失败了，重试10次左右就可以了");
    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable){ //没有网络
        [self noNetWorkStartTestingTimer];//开启网络检测定时器
    } else {
        [self reConnectServer];//连接失败就重连
    }
}

//接收消息
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(NSString *)string{
    ASLog(@"接收消息---- %@",string);
    if ([self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessageWithString:)]) {
        [self.delegate webSocketManagerDidReceiveMessageWithString:string];
    }
}

//关闭连接
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    self.isConnect = NO;
    if(self.isActivelyClose) {
        self.connectType = WebSocketDefault;
        return;
    } else {
        self.connectType = WebSocketDisconnect;
    }
    ASLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",code,reason,wasClean);
    [self destoryHeartBeat]; //断开连接时销毁心跳
    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) { //没有网络
        [self noNetWorkStartTestingTimer];//开启网络检测
    } else { //有网络
        ASLog(@"关闭连接");
        _webSocket = nil;
        [self reConnectServer];//连接失败就重连
    }
}

//ping
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongData {
    ASLog(@"接受pong数据--> %@",pongData);
}

#pragma mark - NSTimer
//初始化心跳
- (void)initHeartBeat {
    if(self.heartBeatTimer) {//心跳没有被关闭
        return;
    }
    [self destoryHeartBeat];
    dispatch_main_async_safe(^{
        self.heartBeatTimer = [NSTimer timerWithTimeInterval:6 target:self selector:@selector(senderheartBeat) userInfo:nil repeats:true];
        [[NSRunLoop currentRunLoop]addTimer:self.heartBeatTimer forMode:NSRunLoopCommonModes];
    })
}

//重新连接
- (void)reConnectServer {
    if(self.webSocket.readyState == SR_OPEN) {
        return;
    }
    if(self.reConnectTime > 1024) { //重连10次 2^10 = 1024
        self.reConnectTime = 0;
        return;
    }
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.reConnectTime *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(wself.webSocket.readyState == SR_OPEN && wself.webSocket.readyState == SR_CONNECTING) {
            return;
        }
        [wself connectServer];
        if (wself.reConnectTime == 0) {//重连时间2的指数级增长
            wself.reConnectTime = 2;
        } else {
            wself.reConnectTime *= 2;
        }
    });
}

//发送心跳
- (void)senderheartBeat {
    kWeakSelf(self);
    dispatch_main_async_safe((^{
        if(wself.webSocket.readyState == SR_OPEN){
            NSString *data = [ASCommonFunc convertNSDictionaryToJsonString:@{@"method": @"heartbeat",
                                                                             @"data": @{@"room_id": STRING(wself.room_id)}}];
            ASLog(@"每隔6秒发送心跳包------data = %@", data);
            [wself.webSocket sendString:data error:NULL]; //发送数据
        }
    }));
}

//没有网络的时候开始定时 -- 用于网络检测
- (void)noNetWorkStartTestingTimer {
    kWeakSelf(self);
    dispatch_main_async_safe(^{
        wself.netWorkTestingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:wself selector:@selector(noNetWorkStartTesting) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:wself.netWorkTestingTimer forMode:NSDefaultRunLoopMode];
    });
}

//定时检测网络
- (void)noNetWorkStartTesting {
    if(AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable) {
        [self destoryNetWorkStartTesting];
        [self reConnectServer];
    }
}

//取消网络检测
- (void)destoryNetWorkStartTesting {
    kWeakSelf(self);
    dispatch_main_async_safe(^{
        if(wself.netWorkTestingTimer) {
            [wself.netWorkTestingTimer invalidate];
            wself.netWorkTestingTimer = nil;
        }
    });
}

//取消心跳
- (void)destoryHeartBeat{
    ASLog(@"----取消心跳----");
    kWeakSelf(self);
    dispatch_main_async_safe(^{
        if(wself.heartBeatTimer) {
            [wself.heartBeatTimer invalidate];
            wself.heartBeatTimer = nil;
        }
    });
}

//关闭长连接
- (void)SRWebSocketClose {
    self.isActivelyClose = YES;
    self.isConnect = NO;
    self.connectType = WebSocketDefault;
    if(self.webSocket) {
        [self.webSocket close];
        _webSocket = nil;
    }
    //关闭心跳定时器
    [self destoryHeartBeat];
    //关闭网络检测定时器
    [self destoryNetWorkStartTesting];
}

//发送数据给服务器
- (void)sendDataToServer:(NSString *)data {
    [self.sendDataArray addObject:data];
    ASLog(@"----发送数据给服务器--- data = %@", data);
    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [self noNetWorkStartTestingTimer];
    } else { //有网络
        if(self.webSocket != nil) {
            if(self.webSocket.readyState == SR_OPEN) {
                [_webSocket sendString:data error:NULL]; //发送数据
            } else if (self.webSocket.readyState == SR_CONNECTING) {//正在连接
                ASLog(@"正在连接中，重连后会去自动同步数据");
            } else if (self.webSocket.readyState == SR_CLOSING || self.webSocket.readyState == SR_CLOSED) {//断开连接
                [self reConnectServer];
            }
        } else {
            [self connectServer]; //连接服务器
        }
    }
}
@end
