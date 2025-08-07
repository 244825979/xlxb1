//
//  ASWebSocketManager.h
//  AS
//
//  Created by SA on 2025/5/19.
//

#import <Foundation/Foundation.h>
#import <SRWebSocket.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, WebSocketConnectType){
    WebSocketDefault = 0,             //初始状态,未连接,不需要重新连接
    WebSocketConnect,                 //已连接
    WebSocketDisconnect               //连接后断开,需要重新连接
};

@protocol ASWebSocketDelegate <NSObject>
- (void)webSocketManagerDidReceiveMessageWithString:(NSString *)string;
@end

@interface ASWebSocketManager : NSObject
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *socket_url;
@property(nonatomic,weak) id<ASWebSocketDelegate> delegate;
@property (nonatomic, assign) BOOL isConnect;
@property (nonatomic, assign) WebSocketConnectType connectType;
@property (nonatomic, strong) SRWebSocket *webSocket;
+ (instancetype)shared;
- (void)connectServer;//建立长连接
- (void)reConnectServer;//重新连接
- (void)SRWebSocketClose;//关闭长连接
- (void)sendDataToServer:(NSString *)data;//发送数据给服务器
@end

NS_ASSUME_NONNULL_END
