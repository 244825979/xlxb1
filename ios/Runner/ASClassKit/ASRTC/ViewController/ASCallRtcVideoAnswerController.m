//
//  ASCallRtcVideoAnswerController.m
//  AS
//
//  Created by SA on 2025/5/19.
//

#import "ASCallRtcVideoAnswerController.h"
#import "ASWebSocketManager.h"
#import <NERtcSDK/NERtcSDK.h>
#import <NERtcCallKit/NERtcCallKit.h>
#import <FURenderKit/FUCaptureCamera.h>
#import "ASAnswerRiskView.h"
#import "ASCallTopView.h"
#import "ASCallUserView.h"
#import "ASCallVideoItemView.h"
#import "ASVideoShowPlayerView.h"
#import "ASCallHidenHintView.h"
#import "ASRtcCallRingManager.h"
#import "FaceUnityManager.h"
#import "ASRtcAnchorPriceModel.h"
#import "ASRtcRequest.h"
#import "ASIMRequest.h"
#import "ASReportController.h"
#import "ASGiftSVGAPlayerController.h"

@interface ASCallRtcVideoAnswerController ()<NERtcCallKitDelegate, FUCaptureCameraDelegate, ASWebSocketDelegate>
@property (nonatomic, strong) UIView *bgVideoView;//未接听显示自己的摄像头，接听显示对方
@property (nonatomic, strong) UIView *smallVideoView;//接听后小窗显示的摄像头
@property (nonatomic, strong) UIImageView *smallCameraView;//摄像头关闭小窗毛玻璃蒙版覆盖
@property (nonatomic, strong) UIImageView *bigCameraView;//关闭摄像头大窗毛玻璃蒙版
@property (nonatomic, strong) UIImageView *bigCameraCloseIcon;//摄像头关闭的视频图标
@property (nonatomic, strong) UILabel *bigCameraCloseText;//摄像头关闭提示文案
@property (nonatomic, strong) UIButton *FUView;//美颜背景view
@property (nonatomic, strong) UIImageView *gotOutOfLineView;//违规大窗view
@property (nonatomic, strong) UIImageView *gotOutOfLineSmallView;//违规小窗view
@property (nonatomic, strong) ASAnswerRiskView *riskHintView;//接听后防骗提醒view
@property (nonatomic, strong) ASCallTopView *topView;//顶部滚动+举报提示view
@property (nonatomic, strong) ASCallUserView *callUserView;//用户显示view
@property (nonatomic, strong) ASCallVideoItemView *itemBg;//底部可点击item背景
@property (nonatomic, strong) ASVideoShowPlayerView *videoShowPlayView;//我是男用户，女用户有视频秀进行提醒
@property (nonatomic, strong) ASCallHidenHintView *callHidenView;//对ta隐身来电提示
/**数据**/
@property (nonatomic, assign) BOOL isHidenTo;//是否开启对Ta隐身
@property (nonatomic, strong) FUCaptureCamera *mCamera;//美颜相机采集
@end

@implementation ASCallRtcVideoAnswerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    [self createUI];
    [self setWebSocket];
    [self answerInit];
    [self setFU];
    [self requestData];
}

- (BOOL)banScreenshot {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    kWeakSelf(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [wself.mCamera startCapture];
    });
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)createUI {
    [self.view addSubview:self.bgVideoView];
    [self.bgVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (self.callModel.is_video_show == 1 && USER_INFO.gender == 2) {
        [self.view addSubview:self.videoShowPlayView];
        [self.videoShowPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        ASVideoShowDataModel *videoShowModel = [[ASVideoShowDataModel alloc] init];
        videoShowModel.cover_img_url = self.callModel.cover_img_url;
        videoShowModel.video_url = self.callModel.video_url;
        self.videoShowPlayView.model = videoShowModel;
    } else {
        [NERtcCallKit.sharedInstance setupLocalView:self.bgVideoView];
    }
    [self.view addSubview:self.bigCameraView];
    [self.bigCameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.gotOutOfLineView];
    [self.gotOutOfLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgVideoView);
    }];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.height.mas_equalTo(44);
    }];
    [self.view addSubview:self.callUserView];
    [self.callUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom).offset(SCALES(28));
        make.height.mas_equalTo(SCALES(180));
    }];
    [self.view addSubview:self.itemBg];
    [self.itemBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.view addSubview:self.smallVideoView];
    [self.smallVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(SCALES(-16));
        make.top.equalTo(self.topView.mas_bottom).offset(SCALES(28));
        make.height.mas_equalTo(SCALES(130));
        make.width.mas_equalTo(SCALES(90));
    }];
    [self.smallVideoView addSubview:self.smallCameraView];
    [self.smallCameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.smallVideoView);
    }];
    [self.view addSubview:self.gotOutOfLineSmallView];
    [self.gotOutOfLineSmallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.smallVideoView);
    }];
    [self.view addSubview:self.riskHintView];
    [self.riskHintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.smallVideoView);
        make.left.mas_equalTo(SCALES(14));
        make.right.equalTo(self.smallVideoView.mas_left).offset(SCALES(-14));
    }];
    [self.view addSubview:self.callHidenView];
    [self.callHidenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(SCALES(-70));
        make.width.mas_equalTo(SCALES(267));
        make.height.mas_equalTo(SCALES(42));
    }];
    if ([USER_INFO.usesHiddenListModel.hiddenToUserID containsObject:self.callModel.from_uid]) {
        self.callHidenView.hidden = NO;
        self.isHidenTo = YES;
    }
}

- (void)answerInit {
    [NERtcCallKit.sharedInstance addDelegate:self];
    [NERtcEngine.sharedEngine enableLocalVideo:YES];
    [[ASRtcCallRingManager shared] play];
    NERtcEngine *coreEngine = [NERtcEngine sharedEngine];
    [coreEngine setExternalVideoSource:YES isScreen:NO];
    NERtcVideoEncodeConfiguration *config = [[NERtcVideoEncodeConfiguration alloc] init];
    config.maxProfile = kNERtcVideoProfileHD720P;
    config.cropMode = kNERtcVideoCropMode16_9;
    config.frameRate = kNERtcVideoFrameRateFps30;
    config.minFrameRate = 15;//视频最小帧率
    config.bitrate = 0;//视频编码码率
    config.minBitrate = 0;//视频编码最小码率
    config.degradationPreference = kNERtcDegradationBalanced;//带宽受限时的视频编码降级偏好
    [coreEngine setLocalVideoConfig:config];
}

//设置长链接
- (void)setWebSocket {
    [ASWebSocketManager shared].room_id = self.callModel.room_id;
    [ASWebSocketManager shared].socket_url = self.callModel.socket_url;
    [[ASWebSocketManager shared] connectServer];
    [ASWebSocketManager shared].delegate = self;
}

//美颜设置初始化
- (void)setFU {
    NSNumber *isOpenFU = [ASUserDefaults valueForKey:@"isOpenFaceUnity"];
    self.FUView.frame = self.view.bounds;
    [self.view addSubview:self.FUView];
    [FaceUnityManager setupFUSDK];
    [[FaceUnityManager shared] loadBeauty];
    [[FaceUnityManager shared] addFUViewToView:self.FUView originY:self.FUView.height - TAB_BAR_HEIGHT];
    if (kObjectIsEmpty(isOpenFU)) {//默认没有调整过美颜状态，就正常开启美颜
        [FURenderKit shareRenderKit].beauty.enable = YES;
    } else {
        [FURenderKit shareRenderKit].beauty.enable = isOpenFU.boolValue;
    }
}

//请求数据
- (void)requestData {
    kWeakSelf(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"updateBalanceNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        wself.itemBg.goPayView.hidden = YES;
    }];
    if (kStringIsEmpty(self.moneyText) && USER_INFO.gender == 2) {
        [ASRtcRequest requestGetPriceWithUserID:self.callModel.from_uid success:^(ASRtcAnchorPriceModel * _Nullable priceModel) {
            wself.itemBg.moneyText = priceModel.videoTxt;
        } errorBack:^(NSInteger code, NSString *msg) {
            
        }];
    }
}

//接通请求数据
- (void)answerRequest {
    kWeakSelf(self);
    [ASCommonRequest requestCallRiskWithSuccess:^(ASCallAnswerRiskModel * _Nullable model) {
        if (model.labelList.count > 0) {
            wself.riskHintView.hidden = NO;
            wself.riskHintView.model = model;
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
    if (self.isHidenTo == YES) {
        [ASIMRequest requestSetHidingWithUserID:self.callModel.from_uid state:NO success:^(id  _Nullable data) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"closeToHidingNotify" object:STRING(self.callModel.from_uid)];
        } errorBack:^(NSInteger code, NSString *msg) {
            
        }];
    }
}

- (void)closeWithCompletion:(void (^ _Nonnull)(void))completion {
    kWeakSelf(self);
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] removeObserver:wself];
        if (NERtcCallKit.sharedInstance.callStatus == NERtcCallStatusInCall) {
            [NERtcCallKit.sharedInstance hangup:^(NSError * _Nullable error) {
                if (error) {
                    ASLog(@"挂断失败，再次点击可以继续取消 error = %@", error);
                    return;
                }
                NSString *data = [ASCommonFunc convertNSDictionaryToJsonString:@{@"method": @"hangup",
                                                                                 @"data": @{@"room_id": STRING(wself.callModel.room_id)}}];
                [[ASWebSocketManager shared] sendDataToServer:data];
            }];
        }
        if (wself.callModel.is_video_show == 1 && USER_INFO.gender == 2) {
            [wself.videoShowPlayView destoryPlayer];
        }
        [[ASRtcCallRingManager shared] stop];
        [NERtcCallKit.sharedInstance removeDelegate:wself];
        [[ASWebSocketManager shared] SRWebSocketClose];
        [ASWebSocketManager shared].socket_url = @"";
        [ASWebSocketManager shared].room_id = @"";
        [wself.mCamera stopCapture];
        [[FaceUnityManager shared] saveBeauty];
        [FaceUnityManager destory];
        completion();
    }];
}

#pragma mark - NERtcCallKitDelegate
/// 接受邀请的回调
/// @param userID 接受者
- (void)onUserEnter:(NSString *)userID {
    ASLog(@"接受邀请的回调 userID = %@", userID);
    [self answerRequest];
    self.callHidenView.hidden = YES;
    if (self.callModel.is_video_show == 1 && USER_INFO.gender == 2) {
        [self.videoShowPlayView destoryPlayer];
        self.videoShowPlayView.hidden = YES;
    }
    [[ASRtcCallRingManager shared] stop];
    self.itemBg.itemType = kItemTypeCallCalling;
    self.smallVideoView.hidden = NO;
    [NERtcCallKit.sharedInstance setupLocalView:self.smallVideoView];
    self.callUserView.hidden = YES;
    self.topView.jubaoBtn.hidden = NO;
    kWeakSelf(self);
    [[RACScheduler mainThreadScheduler]afterDelay:0.5 schedule:^{
        wself.smallVideoView.hidden = NO;
        if (USER_INFO.gender == 2) {
            if (wself.itemBg.isOpenCamera == YES) {//如果设置了开启摄像头
                [NERtcCallKit.sharedInstance enableLocalVideo:YES];
                wself.smallCameraView.hidden = YES;
            } else {//如果设置了关闭摄像头
                [NERtcCallKit.sharedInstance enableLocalVideo:NO];
                wself.smallCameraView.hidden = NO;
                [wself.smallVideoView bringSubviewToFront:wself.smallCameraView];//设置在最顶层
            }
        }
    }];
}

/// 取消邀请的回调
/// @param userID 邀请方
- (void)onUserCancel:(NSString *)userID {
    ASLog(@"我是接听方：取消邀请的回调 userID = %@", userID);
    [self closeWithCompletion:^{ }];
}

/// 用户离开的回调.
/// @param userID 用户userID
- (void)onUserLeave:(NSString *)userID {
    ASLog(@"我是接听方：用户离开的回调 userID = %@", userID);
    [self closeWithCompletion:^{ }];
}

/// 用户异常离开的回调
/// @param userID 用户userID
- (void)onUserDisconnect:(NSString *)userID {
    ASLog(@"我是接听方：用户异常离开的回调 userID = %@", userID);
    [self closeWithCompletion:^{ }];
}

/// 忙线
/// @param userID 忙线的用户ID
- (void)onUserBusy:(NSString *)userID {
    ASLog(@"我是接听方：用户忙线 userID = %@", userID);
    [self closeWithCompletion:^{ }];
}

/// 通话结束
- (void)onCallEnd {
    ASLog(@"我是接听方：通话结束");
    [self closeWithCompletion:^{ }];
}

/// 连接断开
/// @param reason 断开原因
- (void)onDisconnect:(NSError *)reason {
    ASLog(@"我是接听方：连接断开 断开原因 = %@", reason);
    [self closeWithCompletion:^{ }];
}

/// 发生错误
- (void)onError:(NSError *)error {
    ASLog(@"我是接听方：发生错误 error = %@", error);
    [self closeWithCompletion:^{
        kShowToast(@"未知错误!");
    }];
}

/// 启用/禁用相机
/// @param available 是否可用
/// @param userID 用户ID
- (void)onCameraAvailable:(BOOL)available userID:(NSString *)userID {
    ASLog(@"我是接听方：启用/禁用相机 available = %d", available);
    if (available == NO) {
        self.bigCameraView.hidden = NO;
        self.bigCameraCloseIcon.hidden = NO;
        self.bigCameraCloseText.hidden = NO;
    } else {
        self.bigCameraView.hidden = YES;
        self.bigCameraCloseIcon.hidden = YES;
        self.bigCameraCloseText.hidden = YES;
    }
}

/// 首帧解码成功的回调
/// @param userID 用户id
/// @param width 宽度
/// @param height 高度
- (void)onFirstVideoFrameDecoded:(NSString *)userID width:(uint32_t)width height:(uint32_t)height {
    ASLog(@"我是接听方：首帧解码成功的回调 userID = %@", userID);
    [NERtcCallKit.sharedInstance setupRemoteView:self.bgVideoView forUser:userID];
}

#pragma mark ----------FUCameraDelegate-----
- (void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer captureDevicePosition:(AVCaptureDevicePosition)position {
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if(fuIsLibraryInit()){
        if ([FaceUnityManager shared].shouldRender) {
            [[FaceUnityRecorder shareRecorder] processFrameWithLog];
            [FaceUnityManager updateBeautyBlurEffect];
            FURenderInput *input = [[FURenderInput alloc] init];
            input.renderConfig.imageOrientation = FUImageOrientationUP;
            input.pixelBuffer = pixelBuffer;
            input.renderConfig.readBackToPixelBuffer = YES;
            //开启重力感应，内部会自动计算正确方向，设置fuSetDefaultRotationMode，无须外面设置
            input.renderConfig.gravityEnable = YES;
            FURenderOutput *output = [[FURenderKit shareRenderKit] renderWithInput:input];
        }
    }
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    NERtcVideoFrame *videoFrame = [[NERtcVideoFrame alloc] init];
    videoFrame.format = kNERtcVideoFormatNV12;
    videoFrame.width = (uint32_t)CVPixelBufferGetWidth(pixelBuffer);
    videoFrame.height = (uint32_t)CVPixelBufferGetHeight(pixelBuffer);
    videoFrame.timestamp = 0;
    videoFrame.buffer = (void *)pixelBuffer;
    [[NERtcEngine sharedEngine] pushExternalVideoFrame:videoFrame];
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}

#pragma mark - WebSocketManagerDelegate
- (void)webSocketManagerDidReceiveMessageWithString:(NSString *)string {
    NSDictionary *dict = [ASCommonFunc convertJsonStringToNSDictionary: [string stringByReplacingOccurrencesOfString:@"@" withString:@""]];
    NSString *method = dict[@"method"];
    if (!kStringIsEmpty(method)) {
        kWeakSelf(self);
        if ([method isEqualToString:@"hangup"]) {
            [wself closeWithCompletion:^{
                NSNumber *type = dict[@"data"][@"type"];
                switch (type.integerValue) {
                    case 1:
                        kShowToast(@"已取消");
                        break;
                    case 2:
                        kShowToast(@"已拒绝");
                        break;
                    case 3:
                        kShowToast(@"超时无应答");
                        break;
                    case 4:
                        kShowToast(@"通话已结束");
                        break;
                    case 5:
                        kShowToast(@"对方已挂断");
                        break;
                    case 6:
                        kShowToast(@"费用不足已断开");
                        break;
                    case 10:
                        kShowToast(@"因对方视频通话违规系统挂断，请严格遵守平台相关规定。");
                        break;
                    case 11:
                        kShowToast(@"本次视频违规，请遵守平台相关规则。");
                        break;
                    default:
                        break;
                }
            }];
        } else if ([method isEqualToString:@"notice"]) {//显示通知余额不足弹窗
            NSString *link_url = dict[@"data"][@"link_url"];
            NSNumber *link_type = dict[@"data"][@"link_type"];
            NSNumber *type = dict[@"data"][@"type"];
            NSDictionary *contentDict = [ASCommonFunc convertJsonStringToNSDictionary: dict[@"data"][@"content"]];
            if (!kStringIsEmpty(link_url)) {
                if ([link_url isEqualToString:@"rechargeCoin"] || link_type.integerValue != 2) {
                    kWeakSelf(self);
                    [ASAlertViewManager defaultPopTitle:@"余额不足" content:@"余额不足，去充值" left:@"确定" right:@"取消" isTouched:YES affirmAction:^{
                        wself.itemBg.goPayView.hidden = NO;
                        [ASMyAppCommonFunc balanceDeficiencyPopViewWithPayScene:Pay_Scene_VideoGift cancel:^{
                            
                        }];
                    } cancelAction:^{
                        wself.itemBg.goPayView.hidden = NO;
                    }];
                }
            }
            if (kObjectIsEmpty(contentDict)) {
                return;
            }
            NSString *gifttype = contentDict[@"gifttype"];
            NSString *giftsvga = contentDict[@"giftsvga"];
            NSString *svgaUrl = [NSString stringWithFormat:@"%@%@", SERVER_IMAGE_URL, STRING(giftsvga)];
            if (type.integerValue == 1 || type.integerValue == 3) {
                if (gifttype.integerValue == 1 && !kStringIsEmpty(giftsvga)) {
                    ASGiftSVGAPlayerController *vc = [[ASGiftSVGAPlayerController alloc] init];
                    vc.playerUrl = svgaUrl;
                    vc.view.backgroundColor = UIColor.clearColor;
                    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    [self presentViewController:vc animated:NO completion:nil];
                }
            }
        } else if ([method isEqualToString:@"violation"]) {//视频违规操作
            NSDictionary *porn = dict[@"data"][@"porn"];
            NSNumber *myStatus = porn[@"self"];//代表自己违规情况，0没有违规  1违规  2未知 前端跳过不处理
            NSNumber *toStatus = porn[@"to"];//代表对方违规情况，0没有违规  1违规  2未知 前端跳过不处理
            if (myStatus.integerValue == 1) {
                self.gotOutOfLineSmallView.hidden = NO;
            } else if (myStatus.integerValue == 0) {
                self.gotOutOfLineSmallView.hidden = YES;
            }
            if (toStatus.integerValue == 1) {
                self.gotOutOfLineView.hidden = NO;
            } else if (toStatus.integerValue == 0) {
                self.gotOutOfLineView.hidden = YES;
            }
        }
    }
}

- (ASVideoShowPlayerView *)videoShowPlayView {
    if (!_videoShowPlayView) {
        _videoShowPlayView = [[ASVideoShowPlayerView alloc] init];
    }
    return _videoShowPlayView;
}

- (UIImageView *)bigCameraView {
    if (!_bigCameraView) {
        _bigCameraView = [[UIImageView alloc]init];
        [_bigCameraView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, self.callModel.to_avatar]]];
        _bigCameraView.hidden = YES;
        _bigCameraView.contentMode = UIViewContentModeScaleAspectFill;
        _bigCameraView.userInteractionEnabled = YES;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [_bigCameraView addSubview:effectView];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(_bigCameraView);
        }];
        UIImageView *closeIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"call_video_weigui"]];
        closeIcon.hidden = YES;
        [_bigCameraView addSubview:closeIcon];
        [closeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bigCameraView);
            make.centerY.equalTo(_bigCameraView).offset(SCALES(-30));
            make.width.height.mas_equalTo(SCALES(33));
        }];
        self.bigCameraCloseIcon = closeIcon;
        UILabel *closeText = [[UILabel alloc]init];
        closeText.text = @"对方摄像头已关闭";
        closeText.font = TEXT_FONT_13;
        closeText.textAlignment = NSTextAlignmentCenter;
        closeText.textColor = UIColor.whiteColor;
        closeText.hidden = YES;
        [_bigCameraView addSubview:closeText];
        [closeText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bigCameraView);
            make.top.equalTo(closeIcon.mas_bottom).offset(SCALES(6));
        }];
        self.bigCameraCloseText = closeText;
    }
    return _bigCameraView;
}

- (UIImageView *)smallCameraView {
    if (!_smallCameraView) {
        _smallCameraView = [[UIImageView alloc]init];
        [_smallCameraView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, self.callModel.from_avatar]]];
        _smallCameraView.hidden = YES;
        _smallCameraView.layer.cornerRadius = SCALES(6);
        _smallCameraView.layer.masksToBounds = YES;
        _smallCameraView.contentMode = UIViewContentModeScaleAspectFill;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [_smallCameraView addSubview:effectView];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(_smallCameraView);
        }];
        UIImageView *closeIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"call_video_weigui"]];
        [_smallCameraView addSubview:closeIcon];
        [closeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_smallCameraView);
            make.top.mas_equalTo(SCALES(28));
            make.width.height.mas_equalTo(SCALES(33));
        }];
        UILabel *closeText = [[UILabel alloc]init];
        closeText.text = @"我的摄像头已关闭";
        closeText.font = TEXT_FONT_12;
        closeText.textAlignment = NSTextAlignmentCenter;
        closeText.numberOfLines = 2;
        closeText.textColor = UIColor.whiteColor;
        [_smallCameraView addSubview:closeText];
        [closeText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_smallCameraView);
            make.top.equalTo(closeIcon.mas_bottom).offset(SCALES(6));
            make.width.mas_equalTo(SCALES(60));
        }];
    }
    return _smallCameraView;
}

- (UIView *)bgVideoView {
    if (!_bgVideoView) {
        _bgVideoView = [[UIView alloc]init];
        _bgVideoView.backgroundColor = UIColor.blackColor;
    }
    return _bgVideoView;
}

- (UIView *)smallVideoView {
    if (!_smallVideoView) {
        _smallVideoView = [[UIView alloc]init];
        _smallVideoView.layer.cornerRadius = SCALES(6);
        _smallVideoView.layer.masksToBounds = YES;
        _smallVideoView.hidden = YES;
    }
    return _smallVideoView;
}

- (ASCallTopView *)topView {
    if (!_topView) {
        _topView = [[ASCallTopView alloc]init];
        _topView.jubaoBtn.hidden = YES;
        kWeakSelf(self);
        _topView.jubaoBlock = ^{
            ASReportController *vc = [[ASReportController alloc] init];
            vc.uid = wself.callModel.from_uid;
            vc.type = kReportTypeVideo;
            ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [wself presentViewController:nav animated:YES completion:nil];
        };
    }
    return _topView;
}

- (ASCallUserView *)callUserView {
    if (!_callUserView) {
        _callUserView = [[ASCallUserView alloc]init];
        _callUserView.isCaller = YES;
        _callUserView.model = self.callModel;
    }
    return _callUserView;
}

- (ASCallVideoItemView *)itemBg {
    if (!_itemBg) {
        _itemBg = [[ASCallVideoItemView alloc]init];
        _itemBg.moneyText = STRING(self.moneyText);
        _itemBg.itemType = kItemTypeAnswerNoCalling;
        kWeakSelf(self);
        _itemBg.cameraCutBlock = ^(BOOL isSelect) {//翻转
            [wself.mCamera changeCameraInputDeviceisFront:isSelect];
            [FaceUnityManager resetTrackedResult];
        };
        _itemBg.cameraSwitchBlock = ^(BOOL isOpen) {
            if (isOpen == YES) {
                if (NERtcCallKit.sharedInstance.callStatus == NERtcCallStatusCalling ||
                    NERtcCallKit.sharedInstance.callStatus == NERtcCallStatusCalled) {
                    wself.bigCameraView.hidden = YES;
                } else {
                    wself.smallCameraView.hidden = YES;
                }
            } else {
                if (NERtcCallKit.sharedInstance.callStatus == NERtcCallStatusCalling ||
                    NERtcCallKit.sharedInstance.callStatus == NERtcCallStatusCalled) {
                    wself.bigCameraView.hidden = NO;
                } else {
                    wself.smallCameraView.hidden = NO;
                }
            }
        };
        _itemBg.closeBlock = ^(BOOL isCancel) {
            [wself closeWithCompletion:^{ }];
            if (isCancel == YES) {
                NSString *data = [ASCommonFunc convertNSDictionaryToJsonString:@{@"method": @"refuse",
                                                                                 @"data": @{@"room_id": STRING(wself.callModel.room_id)}}];
                [[ASWebSocketManager shared] sendDataToServer:data];
            } else {
                NSString *data = [ASCommonFunc convertNSDictionaryToJsonString:@{@"method": @"hangup",
                                                                                 @"data": @{@"room_id": STRING(wself.callModel.room_id)}}];
                [[ASWebSocketManager shared] sendDataToServer:data];
            }
        };
        _itemBg.meiyanBlock = ^{
            wself.FUView.hidden = NO;
        };
        _itemBg.answerBlock = ^{
            [ASRtcRequest requestCheckCallMoneyWithUserID:wself.callModel.from_uid success:^(id  _Nullable data) {
                [[NERtcCallKit sharedInstance] accept:^(NSError * _Nullable error) {
                    if (error) {
                        return;
                    }
                    [[ASRtcCallRingManager shared] stop];
                    NSString *data = [ASCommonFunc convertNSDictionaryToJsonString:@{@"method": @"agree",
                                                                                     @"data": @{@"room_id": STRING(wself.callModel.room_id)}}];
                    [[ASWebSocketManager shared] sendDataToServer:data];
                }];
            } errorBack:^(NSInteger code, NSString *msg) {
                if (code == 1002 || code == 1003) {//您的可用金币不足
                    [ASAlertViewManager defaultPopTitle:@"余额不足" content:@"金币余额不足1分钟，请及时充值避免错过缘分！" left:@"马上充值" right:@"舍不得" isTouched:YES affirmAction:^{
                        [ASMyAppCommonFunc balanceDeficiencyPopViewWithPayScene:Pay_Scene_VideoCalling cancel:^{
                            
                        }];
                    } cancelAction:^{
                        
                    }];
                }
            }];
        };
        _itemBg.sendGiftBlock = ^{
            [ASCommonRequest requestGiftTitleSuccess:^(id  _Nullable data) {
                [ASAlertViewManager popGiftViewWithTitles:data toUserID:wself.callModel.from_uid giftType:kSendGiftTypeCall sendBlock:^(NSString * _Nonnull giftID, NSInteger giftCount, NSString * _Nonnull giftTypeID) {
                    NSString *data = [ASCommonFunc convertNSDictionaryToJsonString:@{@"method": @"gift",
                                                                                     @"data": @{@"room_id": STRING(wself.callModel.room_id),
                                                                                                @"gift_count": @(giftCount),
                                                                                                @"gift_id": STRING(giftID),
                                                                                                @"gift_type_id": STRING(giftTypeID)
                                                                                     }}];
                    [[ASWebSocketManager shared] sendDataToServer:data];
                }];
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        };
    }
    return _itemBg;
}

- (UIButton *)FUView {
    if (!_FUView) {
        _FUView = [[UIButton alloc]init];
        _FUView.userInteractionEnabled = YES;
        _FUView.backgroundColor = UIColor.clearColor;
        _FUView.hidden = YES;
        kWeakSelf(self);
        [[_FUView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            wself.FUView.hidden = YES;
        }];
    }
    return _FUView;
}

- (FUCaptureCamera *)mCamera {
    if (_mCamera == nil) {
        _mCamera = [[FUCaptureCamera alloc] initWithCameraPosition:(AVCaptureDevicePositionFront) captureFormat:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
        _mCamera.delegate = self;
    }
    return _mCamera;
}

- (ASAnswerRiskView *)riskHintView {
    if (!_riskHintView) {
        _riskHintView = [[ASAnswerRiskView alloc]init];
        _riskHintView.hidden = YES;
    }
    return _riskHintView;
}

- (ASCallHidenHintView *)callHidenView {
    if (!_callHidenView) {
        _callHidenView = [[ASCallHidenHintView alloc]init];
        _callHidenView.hidden = YES;
    }
    return _callHidenView;
}

- (UIImageView *)gotOutOfLineView {
    if (!_gotOutOfLineView) {
        _gotOutOfLineView = [[UIImageView alloc]init];
        _gotOutOfLineView.image = [UIImage imageNamed:@"call_weigui"];
        _gotOutOfLineView.contentMode = UIViewContentModeScaleAspectFill;
        _gotOutOfLineView.hidden = YES;
        _gotOutOfLineView.userInteractionEnabled = YES;
    }
    return _gotOutOfLineView;
}

- (UIImageView *)gotOutOfLineSmallView {
    if (!_gotOutOfLineSmallView) {
        _gotOutOfLineSmallView = [[UIImageView alloc]init];
        _gotOutOfLineSmallView.image = [UIImage imageNamed:@"call_weigui1"];
        _gotOutOfLineSmallView.contentMode = UIViewContentModeScaleAspectFill;
        _gotOutOfLineSmallView.hidden = YES;
        _gotOutOfLineSmallView.userInteractionEnabled = YES;
    }
    return _gotOutOfLineSmallView;
}

@end
