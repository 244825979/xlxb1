//
//  ASCallRtcVoiceAnswerController.m
//  AS
//
//  Created by SA on 2025/5/19.
//

#import "ASCallRtcVoiceAnswerController.h"
#import <NERtcSDK/NERtcSDK.h>
#import <NERtcCallKit/NERtcCallKit.h>
#import "ASWebSocketManager.h"
#import "ASAnswerRiskView.h"
#import "ASCallTopView.h"
#import "ASCallUserView.h"
#import "ASCallVoiceItemView.h"
#import "ASRtcCallRingManager.h"
#import "ASRtcRequest.h"
#import "ASRtcAnchorPriceModel.h"
#import "ASReportController.h"
#import "ASCallHidenHintView.h"
#import "ASIMRequest.h"

@interface ASCallRtcVoiceAnswerController ()<NERtcCallKitDelegate, ASWebSocketDelegate>
@property (nonatomic, strong) ASAnswerRiskView *riskHintView;//接听后防骗提醒view
@property (nonatomic, strong) ASCallTopView *topView;//顶部滚动+举报提示view
@property (nonatomic, strong) ASCallUserView *callUserView;//用户显示view
@property (nonatomic, strong) ASCallVoiceItemView *itemBg;//底部可点击item背景
@property (nonatomic, strong) ASCallHidenHintView *callHidenView;//对ta隐身来电提示
@property (nonatomic, strong) UIImageView *backgroundMask;//蒙版背景
/**数据**/
@property (nonatomic, assign) BOOL isHidenTo;//是否开启对Ta隐身
@end

@implementation ASCallRtcVoiceAnswerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    [self createUI];
    [self answerInit];
    [self setWebSocket];
    [self requestData];
}

- (BOOL)banScreenshot {
    return YES;
}

- (void)createUI {
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.backgroundMask];
    [self.backgroundMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
    [self.view addSubview:self.riskHintView];
    [self.riskHintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.callUserView.mas_bottom).offset(SCALES(20));
        make.left.mas_equalTo(SCALES(14));
        make.width.mas_equalTo(SCALES(230));
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
    [[ASRtcCallRingManager shared] play];
}

//设置长链接
- (void)setWebSocket {
    [ASWebSocketManager shared].room_id = self.callModel.room_id;
    [ASWebSocketManager shared].socket_url = self.callModel.socket_url;
    [[ASWebSocketManager shared] connectServer];
    [ASWebSocketManager shared].delegate = self;
}

//请求数据
- (void)requestData {
    kWeakSelf(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"updateBalanceNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        wself.itemBg.goPayView.hidden = YES;
    }];
    if (kStringIsEmpty(self.moneyText) && USER_INFO.gender == 2) {
        [ASRtcRequest requestGetPriceWithUserID:self.callModel.from_uid success:^(ASRtcAnchorPriceModel * _Nullable priceModel) {
            wself.itemBg.moneyText = priceModel.voiceTxt;
        } errorBack:^(NSInteger code, NSString *msg) { }];
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
    } errorBack:^(NSInteger code, NSString *msg) { }];
    if (self.isHidenTo == YES) {
        [ASIMRequest requestSetHidingWithUserID:self.callModel.from_uid state:NO success:^(id  _Nullable data) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"closeToHidingNotify" object:STRING(self.callModel.from_uid)];
        } errorBack:^(NSInteger code, NSString *msg) { }];
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
        [[ASRtcCallRingManager shared] stop];
        [NERtcCallKit.sharedInstance removeDelegate:wself];
        [[ASWebSocketManager shared] SRWebSocketClose];
        [ASWebSocketManager shared].socket_url = @"";
        [ASWebSocketManager shared].room_id = @"";
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
    [[ASRtcCallRingManager shared] stop];//铃声暂停
    self.itemBg.itemType = kItemTypeCallCalling;
    self.topView.jubaoBtn.hidden = NO;
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
        kShowToast(@"未知错误！");
    }];
}

#pragma mark - WebSocketManagerDelegate
- (void)webSocketManagerDidReceiveMessageWithString:(NSString *)string {
    NSDictionary *dict = [ASCommonFunc convertJsonStringToNSDictionary: [string stringByReplacingOccurrencesOfString:@"@" withString:@""]];
    NSString *method = dict[@"method"];
    if (!kStringIsEmpty(method)) {
        kWeakSelf(self);
        if ([method isEqualToString:@"hangup"]) { //进行挂断
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
                    [ASAlertViewManager defaultPopTitle:@"余额不足" content:@"余额不足，去充值" left:@"确定" right:@"取消" affirmAction:^{
                        wself.itemBg.goPayView.hidden = NO;
                        [ASMyAppCommonFunc balanceDeficiencyPopViewWithPayScene:Pay_Scene_VoiceGift cancel:^{ }];
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
        }
    }
}

- (UIImageView *)backgroundMask {
    if (!_backgroundMask) {
        _backgroundMask = [[UIImageView alloc]init];
        [_backgroundMask sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, self.callModel.from_avatar]]];
        _backgroundMask.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundMask.userInteractionEnabled = YES;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [_backgroundMask addSubview:effectView];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(_backgroundMask);
        }];
    }
    return _backgroundMask;
}

- (ASCallTopView *)topView {
    if (!_topView) {
        _topView = [[ASCallTopView alloc]init];
        _topView.jubaoBtn.hidden = YES;
        kWeakSelf(self);
        _topView.jubaoBlock = ^{
            ASReportController *vc = [[ASReportController alloc] init];
            vc.uid = wself.callModel.from_uid;
            vc.type = kReportTypeVoice;
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

- (ASCallVoiceItemView *)itemBg {
    if (!_itemBg) {
        _itemBg = [[ASCallVoiceItemView alloc]init];
        _itemBg.moneyText = self.moneyText;
        _itemBg.itemType = kItemTypeAnswerNoCalling;
        kWeakSelf(self);
        _itemBg.closeBlock = ^(BOOL isCancel) {
            [wself closeWithCompletion:^{ }];
            if (isCancel == YES) {
                NSString *data = [ASCommonFunc convertNSDictionaryToJsonString:@{@"method": @"cancel",
                                                                                 @"data": @{@"room_id": STRING(wself.callModel.room_id)}}];
                [[ASWebSocketManager shared] sendDataToServer:data];
            } else {
                NSString *data = [ASCommonFunc convertNSDictionaryToJsonString:@{@"method": @"hangup",
                                                                                 @"data": @{@"room_id": STRING(wself.callModel.room_id)}}];
                [[ASWebSocketManager shared] sendDataToServer:data];
            }
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
                if (code == 1002 || code == 1003) {
                    [ASAlertViewManager defaultPopTitle:@"余额不足" content:@"金币余额不足1分钟，请及时充值避免错过缘分！" left:@"马上充值" right:@"舍不得" affirmAction:^{
                        [ASMyAppCommonFunc balanceDeficiencyPopViewWithPayScene:Pay_Scene_VoiceCalling cancel:^{ }];
                    } cancelAction:^{ }];
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
            } errorBack:^(NSInteger code, NSString *msg) { }];
        };
    }
    return _itemBg;
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
@end
