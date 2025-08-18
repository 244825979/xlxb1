//
//  ASMyAppCommonFunc.m
//  AS
//
//  Created by SA on 2025/4/9.
//

#import "ASMyAppCommonFunc.h"
#import <RiskPerception/NTESRiskUniPerception.h>
#import "NECommonKit/NECommonKit-Swift.h"
#import "ASHomeController.h"
#import "ASMineController.h"
#import "ASDynamicController.h"
#import "ASIMListController.h"
#import "ASVideoShowPlayController.h"
#import "ASPersonalController.h"
#import "ASDynamicRequest.h"
#import "Runner-Swift.h"
#import "NEChatUIKit/NEChatUIKit-Swift.h"
#import "ASRtcRequest.h"
#import "ASRtcAnchorPriceModel.h"
#import "ASIMRequest.h"
#import "ASVipDetailsController.h"
#import "ASEditDataController.h"
#import "ASVideoShowMyListContrller.h"
#import "ASAuthHomeController.h"
#import "ASChongZhiController.h"
#import "ASPayTopUpModel.h"
#import "ASSetBindViewController.h"

@implementation ASMyAppCommonFunc

#pragma mark - 当前APP功能方法
//获取登录易盾token
+ (void)getLoginYDTokenSuccess:(TextBlock)YDLoginBack
                         login:(VoidBlock)loginBack {
    if ([ASUserDataManager shared].systemIndexModel.is_yd_check == 1) {//开启易盾
        [[NTESRiskUniPerception fomentBevelDeadengo] getTokenAsync:YD_LoginBusinessID withTimeout:3000 completeHandler:^(AntiCheatResult * _Nonnull result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result.code == 200) {
                    ASLog(@"getTokenAsync %@", result.token);
                    YDLoginBack(result.token);
                } else {
                    loginBack();
                }
            });
        }];
    } else {
        loginBack();
    }
}

//获取apple支付易盾token
+ (void)getApplePayYDTokenWithSuccess:(TextBlock)successBack
                            errorBack:(VoidBlock)errorBack {
    [[NTESRiskUniPerception fomentBevelDeadengo] getTokenAsync:YD_PayBusinessID withTimeout:3000 completeHandler:^(AntiCheatResult * _Nonnull result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.code == 200) {
                successBack(result.token);
            } else {
                errorBack();
            }
        });
    }];
}

//校验是否有录音权限。麦克风权限
+ (void)verifyMicrophonePermissionBlock:(VoidBlock)block {
    if ([NEAuthManager hasAudioAuthoriztion] == YES) {
        block();
    } else {
        [NEAuthManager requestAudioAuthorization:^(BOOL granted) {//暂无麦克风权限
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block();
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"无麦风克权限，前往开启？" left:@"去开启" right:@"取消" isTouched:YES affirmAction:^{
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        };
                    } cancelAction:^{
                        
                    }];
                });
            }
        }];
    }
}

//校验是否有相机权限
+ (void)verifyCameraPermissionBlock:(VoidBlock)block {
    if ([NEAuthManager hasCameraAuthorization] == YES) {
        block();
    } else {
        [NEAuthManager requestCameraAuthorization:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block();
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"无相机权限，前往开启？" left:@"去开启" right:@"取消" isTouched:YES affirmAction:^{
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        };
                    } cancelAction:^{
                        
                    }];
                });
            }
        }];
    }
}

+ (BOOL)isTabHomeViewController {
    if ([[ASCommonFunc currentVc] isKindOfClass: [ASHomeController class]] ||
        [[ASCommonFunc currentVc] isKindOfClass: [ASMineController class]] ||
        [[ASCommonFunc currentVc] isKindOfClass: [ASDynamicController class]] ||
        [[ASCommonFunc currentVc] isKindOfClass: [ASIMListController class]] ||
        [[ASCommonFunc currentVc] isKindOfClass: [ASVideoShowPlayController class]]) {
        return YES;
    } else {
        return NO;
    }
}

//IM会话的最后一条消息显示的文本
+ (NSString *)lastMessgeHint:(NIMMessage *)message {
    NSString *text;
    switch (message.messageType) {
        case 0:
            text = STRING(message.text);
            break;
        case 1:
            text = @"【图片】";
            break;
        case 2:
            text = @"【语音】";
            break;
        case 100://自定义消息
        {
            text = STRING([ASIMFuncManager backMessgeHintWithMessage:message]);
        }
            break;
        default:
            text = @"【提醒消息】";
            break;
    }
    return text;
}

#pragma mark - 当前APP功能点击
//打招呼
+ (void)greetWithUserID:(NSString *)userID action:(ActionBlock)action {
    if (kStringIsEmpty(userID)) {
        return;
    }
    if ([self verifyOpenHidingWithUserID:userID] == YES) {
        [self openHidingClikedWithIsOpen:YES userID:userID nickName:@"" action:^(BOOL isOpen) {
            
        }];
        return;
    }
    [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthDaShanPop succeed:^{
        [ASCommonRequest requestDaZhaohuWithUserID:userID success:^(id  _Nullable data) {
            action(@1);
        } errorBack:^(NSInteger code, NSString *msg) {
            
        }];
    }];
}

//去聊天
+ (void)chatWithUserID:(NSString *)userID nickName:(NSString *)nickName action:(ActionBlock)action {
    if (kStringIsEmpty(userID)) {
        return;
    }
    if ([userID isEqualToString:NEKitChatConfig.shared.xitongxiaoxi_id] ||
        [userID isEqualToString:NEKitChatConfig.shared.huodongxiaozushou_id] ||
        [userID isEqualToString:NEKitChatConfig.shared.xiaomishu_id] ||
        [userID isEqualToString:NEKitChatConfig.shared.kefuzushou_id]) {
        [ASIMFuncManager chatViewControllerWithUserId:STRING(userID) nickName:STRING(nickName)];
    } else {
        [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthDaShanPop succeed:^{
            [ASIMFuncManager chatViewControllerWithUserId:STRING(userID) nickName:STRING(nickName)];
        }];
    }
}

//去聊天 匹配小助手进入私聊
+ (void)littleHelperChatWithUserID:(NSString *)userID nickName:(NSString *)nickName sendMsgBlock:(VoidBlock)sendMsgBlock {
    if (kStringIsEmpty(userID)) {
        return;
    }
    [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthDaShanPop succeed:^{
        [ASIMFuncManager littleHelperChatControllerWithUserId:STRING(userID) nickName:STRING(nickName) sendFirstBlock:^{
            sendMsgBlock();
        }];
    }];
}

//去拨打电话，弹出选择
+ (void)callPopViewWithUserID:(NSString *)userID scene:(NSString *)scene back:(void(^)(BOOL isSucceed))back {
    if (kStringIsEmpty(userID)) {
        return;
    }
    if ([self verifyOpenHidingWithUserID:userID] == YES) {
        [self openHidingClikedWithIsOpen:YES userID:userID nickName:@"" action:^(BOOL isOpen) { }];
        return;
    }
    [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthDefaultPop succeed:^{
        [ASRtcRequest requestGetPriceWithUserID:userID success:^(ASRtcAnchorPriceModel *_Nullable priceModel) {
            [ASAlertViewManager popCallViewWithModel:priceModel affirmAction:^(ASCallType type) {
                [[ASRtcManager shared] callWithType:type
                                           toUserID:userID
                                          moneyText:type == kCallTypeVideo ? STRING(priceModel.videoTxt) : STRING(priceModel.voiceTxt)
                                              scene:scene
                                           complete:^(BOOL isSucceed) {
                    back(isSucceed);
                }];
            }];
        } errorBack:^(NSInteger code, NSString *msg) {
            back(NO);
        }];
    }];
}

//去拨打电话，传入类型：CallType，直接拨打
+ (void)callWithUserID:(NSString *)userID callType:(ASCallType)callType scene:(NSString *)scene back:(void(^)(BOOL isSucceed))back {
    if (kStringIsEmpty(userID)) {
        return;
    }
    if ([self verifyOpenHidingWithUserID:userID] == YES) {
        [self openHidingClikedWithIsOpen:YES userID:userID nickName:@"" action:^(BOOL isOpen) {
            
        }];
        return;
    }
    [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthDefaultPop succeed:^{
        [ASRtcRequest requestGetPriceWithUserID:userID success:^(ASRtcAnchorPriceModel *_Nullable priceModel) {
            [[ASRtcManager shared] callWithType:callType
                                       toUserID:userID
                                      moneyText:callType == kCallTypeVideo ? STRING(priceModel.videoTxt) : STRING(priceModel.voiceTxt)
                                          scene:scene//scene:如果是视频秀列表主动呼叫传入：“video_show”
                                       complete:^(BOOL isSucceed) {
                back(isSucceed);
            }];
        } errorBack:^(NSInteger code, NSString *msg) {
            back(NO);
        }];
    }];
}

//去个人主页
+ (void)goPersonalHomeWithUserID:(NSString *)userID viewController:(UIViewController *)vc action:(ActionBlock)action {
    if (kStringIsEmpty(userID) || [userID isEqualToString:@"0"]) {
        return;
    }
    ASPersonalController *personalVc = [[ASPersonalController alloc] init];
    personalVc.userID = userID;
    personalVc.beckonBlock = ^{
        action(@"beckon");//打招呼
    };
    personalVc.attentionBlock = ^(BOOL isAttention) {
        if (isAttention) {
            action(@"addAttention");//已关注
        } else {
            action(@"delAttention");//取消关注
        }
    };
    [vc.navigationController pushViewController:personalVc animated:YES];
    return;
}
//点赞
+ (void)likeWithDynamicID:(NSString *)dynamicID isLike:(NSInteger)isLike action:(ActionBlock)action {
    [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthDefaultNotIDCard succeed:^{
        [ASDynamicRequest requestLikeWithDynamicID:dynamicID type:isLike success:^(id _Nullable data) {
            action(data);
        } errorBack:^(NSInteger code, NSString *msg) {
            
        }];
    }];
}
//关注or取消关注
+ (void)followWithUserID:(NSString *)userID action:(ActionBlock)action {
    [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthDefaultNotIDCard succeed:^{
        [ASCommonRequest requestFollowWithUserID:userID success:^(id _Nullable data) {
            action(data);
        } errorBack:^(NSInteger code, NSString *msg) {
            
        }];
    }];
}
//banner点击跳转处理
+ (void)bannerClikedWithBannerModel:(ASBannerModel *)model viewController:(UIViewController *)vc action:(ActionBlock)action {
        if (model.link_type == 1) {//跳转H5页面
            ASBaseWebViewController *h5Vc = [[ASBaseWebViewController alloc]init];
            h5Vc.webUrl = STRING(model.link_url);
            [vc.navigationController pushViewController:h5Vc animated:YES];
            return;
        }
        if (model.link_type == 2) {//跳转内部页
            if ([model.link_url isEqualToString:@"member"]) {//是跳VIP购买页面
                ASVipDetailsController *popVc = [[ASVipDetailsController alloc] init];
                popVc.isRootPop = YES;
                [vc.navigationController pushViewController:popVc animated:YES];
                return;
            }
            if ([model.link_url isEqualToString:@"rechargeCoin"]) {//跳转到充值金币页面
                ASChongZhiController *popVc = [[ASChongZhiController alloc] init];
                [vc.navigationController pushViewController:popVc animated:YES];
                return;
            }
            if ([model.link_url isEqualToString:@"infoEdit"]) {//编辑资料
                ASEditDataController *popVc = [[ASEditDataController alloc] init];
                [vc.navigationController pushViewController:popVc animated:YES];
                return;
            }
            if ([model.link_url isEqualToString:@"selfVideoShow"]) {//我的视频秀列表
                ASVideoShowMyListContrller *popVc = [[ASVideoShowMyListContrller alloc] init];
                [vc.navigationController pushViewController:popVc animated:YES];
                return;
            }
            if ([model.link_url isEqualToString:@"auth"]) {//去认证主页
                ASAuthHomeController *popVc = [[ASAuthHomeController alloc]init];
                [vc.navigationController pushViewController:popVc animated:YES];
                return;
            }
            if ([model.link_url isEqualToString:@"accountBind"]) {
                ASSetBindViewController *vc = [[ASSetBindViewController alloc] init];
                [vc.navigationController pushViewController:vc animated:YES];
                return;
            }
            if ([model.link_url isEqualToString:@"userHome"]) {
                [self goPersonalHomeWithUserID:STRING(model.userid) viewController:vc action:^(id  _Nonnull data) {
                }];
                return;
            }
            return;
        }
}
//余额不足弹窗
+ (void)balanceDeficiencyPopViewWithPayScene:(NSString *)payScene cancel:(VoidBlock)cancel {
    [ASCommonRequest requestGoodsListWithScene:payScene showHUD:YES success:^(ASPayGoodsDataModel *  _Nullable model) {
        [ASAlertViewManager balanceDeficiencyPopViewWithModel:model scene:payScene cancel:^{
            cancel();
        }];
    } errorBack:^(NSInteger code, NSString *msg) {
        cancel();
    }];
}
//对ta隐身判断是否开启vip
+ (void)openHidingClikedVipAction:(void(^)(void))affirmAction {
    if (USER_INFO.vip != 1) {
        [ASAlertViewManager openHidingVipViewAction:^{
            affirmAction();
        }];
    }
}
//对ta隐身点击
+ (void)openHidingClikedWithIsOpen:(BOOL)isOpen
                            userID:(NSString *)userID
                          nickName:(NSString *)nickName
                            action:(void(^)(BOOL isOpen))action {
    if (!isOpen) {
        if (USER_INFO.vip != 1) {
            [self openHidingClikedVipAction:^{
                
            }];
            return;
        }
        [ASAlertViewManager defaultPopTitle:@"提示"
                                    content:@"开启对Ta隐身后，对方将看不到你的在线状态，并且查看消息对方仍展示未读状态，关闭后可恢复正常状态"
                                       left:@"开启隐身"
                                      right:@"取消"
                                  isTouched:YES
                               affirmAction:^{
            [ASIMRequest requestSetHidingWithUserID:STRING(userID) state:!isOpen success:^(id  _Nullable data) {
                action(!isOpen);
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        } cancelAction:^{
            
        }];
    } else {
        [ASAlertViewManager defaultPopTitle:@"确定要解除对Ta的隐身？"
                                    content:[NSString stringWithFormat:@"解除对 %@ 的隐身才能发送消息、送礼物、发起音视频通话哟~",kStringIsEmpty(nickName) ? @"Ta" : nickName]
                                       left:@"解除"
                                      right:@"取消"
                                  isTouched:YES
                               affirmAction:^{
            [ASIMRequest requestSetHidingWithUserID:STRING(userID) state:!isOpen success:^(id  _Nullable data) {
                action(!isOpen);
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        } cancelAction:^{
            
        }];
    }
}
//对ta隐身判断是否开启vip
+ (BOOL)verifyOpenHidingWithUserID:(NSString *)userID {
    for (ASUserHiddenListModel *model in USER_INFO.usesHiddenListModel.hidden_to_user) {
        if ([model.user_id isEqualToString:userID]) {
            return YES;
        }
    }
    return NO;
}
//赠送vip数据获取
+ (void)sendVipWithUserID:(NSString *)userID action:(VoidBlock)action {
    if (kStringIsEmpty(userID)) {
        return;
    }
    [ASCommonRequest requestSendVipDataWithUserID:userID success:^(id  _Nullable data) {
        [ASAlertViewManager sendVipPopViewWithModel:data toUserID:userID];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}
//支付点击事件
+ (void)applePayRequestWithScene:(NSString *)scene
                    rechargeType:(NSString *)rechargeType//充值类型，1金币充值，2VIP充值
                       productID:(NSString *)productID//充值商品ID
                          isOpen:(NSInteger)isOpen//是否开启易盾
                        toUserID:(NSString *)toUserID//如果是给别人开通vip或者充值的用户ID
                         success:(ActionBlock)successBack
                       errorBack:(void(^)(NSInteger code))errorBack {
    NSMutableDictionary *prame = [NSMutableDictionary dictionary];
    [prame setValue:STRING(scene) forKey:@"recharge_scene"];
    [prame setValue:STRING(rechargeType) forKey:@"recharge_type"];
    [prame setValue:STRING(productID) forKey:@"product_id"];
    if (!kStringIsEmpty(toUserID)) {
        [prame setValue:STRING(toUserID) forKey:@"to_uid"];
    }
    if (isOpen) {//开启了易盾
        [ASMyAppCommonFunc getApplePayYDTokenWithSuccess:^(NSString * _Nonnull ydToken) {
            [prame setValue:STRING(ydToken) forKey:@"yidunToken"];
            [ASCommonRequest requestApplePayWithParams:prame success:^(id  _Nullable data) {
                ASPayTopUpModel *model = [ASPayTopUpModel mj_objectWithKeyValues:data];
                if (!kStringIsEmpty(model.order_notice)) {
                    NSURL *url = [NSURL URLWithString:model.order_notice];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                            ASLog(success ? @"✅ 跳转成功" : @"❌ 跳转失败");
                            [ASMsgTool hideMsg];
                        }];
                    } else {
                        successBack(model);
                    }
                } else {
                    successBack(model);
                }
            } errorBack:^(NSInteger code, NSString *msg) {
                errorBack(code);
                [ASMsgTool hideMsg];
            }];
        } errorBack:^{
            [ASCommonRequest requestApplePayWithParams:prame success:^(id  _Nullable data) {
                ASPayTopUpModel *model = [ASPayTopUpModel mj_objectWithKeyValues:data];
                if (!kStringIsEmpty(model.order_notice)) {
                    NSURL *url = [NSURL URLWithString:model.order_notice];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                            ASLog(success ? @"✅ 跳转成功" : @"❌ 跳转失败");
                            [ASMsgTool hideMsg];
                        }];
                    } else {
                        successBack(model);
                    }
                } else {
                    successBack(model);
                }
            } errorBack:^(NSInteger code, NSString *msg) {
                errorBack(code);
                [ASMsgTool hideMsg];
            }];
        }];
    } else {
        [ASCommonRequest requestApplePayWithParams:prame success:^(id  _Nullable data) {
            ASPayTopUpModel *model = [ASPayTopUpModel mj_objectWithKeyValues:data];
            if (!kStringIsEmpty(model.order_notice)) {
                NSURL *url = [NSURL URLWithString:model.order_notice];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        ASLog(success ? @"✅ 跳转成功" : @"❌ 跳转失败");
                        [ASMsgTool hideMsg];
                    }];
                } else {
                    successBack(model);
                }
            } else {
                successBack(model);
            }
        } errorBack:^(NSInteger code, NSString *msg) {
            errorBack(code);
            [ASMsgTool hideMsg];
        }];
    }
}
//统计
+ (void)behaviorStatisticsWithType:(NSInteger)type {
    [ASCommonRequest requestBehaviorStatsWithType:type success:^(id  _Nonnull response) {
    } errorBack:^(NSInteger code, NSString * _Nonnull message) {
    }];
}
//app启动次数统计
+ (void)appOpenStatistics {
    [ASCommonRequest requestReportAppOpenSuccess:^(id  _Nonnull response) {
    } errorBack:^(NSInteger code, NSString * _Nonnull message) {
    }];
}
//活动弹窗上报
+ (void)activityPopStatisticsWithUrl:(NSString *)linkUrl
                           eventType:(NSInteger)eventType
                           placement:(NSInteger)placement {
    [ASCommonRequest requestTrackingPopupWithUrl:linkUrl eventType:eventType placement:placement success:^(id  _Nonnull response) {
        
    } errorBack:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}

@end
