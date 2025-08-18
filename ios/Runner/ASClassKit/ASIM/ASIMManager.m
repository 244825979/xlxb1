//
//  ASIMManager.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASIMManager.h"
#import "NEChatUIKit/NEChatUIKit-Swift.h"
#import "ASIMSystemNotifyModel.h"
#import <UserNotifications/UserNotifications.h>
#import "ASHomeController.h"
#import "ASMineController.h"
#import "ASDynamicController.h"
#import "ASIMListController.h"
#import "ASVideoShowPlayController.h"
#import "Runner-Swift.h"
#import "ASCallRtcVideoAnswerController.h"
#import "ASCallRtcVideoController.h"
#import "ASCallRtcVoiceAnswerController.h"
#import "ASCallRtcVoiceController.h"
#import "ASGiftSVGAPlayerController.h"
#import "TZImagePickerController.h"
#import "ASLoginBindPhoneController.h"
#import "ASMyAppRegister.h"

@interface ASIMManager ()<NIMSystemNotificationManagerDelegate, NIMChatManagerDelegate, NIMLoginManagerDelegate, NIMSDKConfigDelegate, NIMEventSubscribeManagerDelegate, NIMConversationManagerDelegate>
@property (nonatomic, strong) zhPopupController *IMNotifyPopView;//IM消息提醒
@property (nonatomic, strong) zhPopupController *friendUpPopView;//好友上线提醒
@property (nonatomic, strong) zhPopupController *giftPopView;//礼物飘屏
@end

@implementation ASIMManager

+ (ASIMManager *)shared {
    static dispatch_once_t onceToken;
    static ASIMManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

//云信登录授权
- (void)NELoginWithAccount:(NSString *)account
                     token:(NSString *)token
                   succeed:(VoidBlock)succeed
                      fail:(VoidBlock)fail {
    //token会为空，就不登录云信，直接让用户重新登陆
    if (kStringIsEmpty(token)) {
        //登录状态清除用户数据
        [USER_INFO removeUserData:^{
            
        }];
        fail();
        return;
    }
    NIMServerSetting *setting = [[NIMServerSetting alloc] init];
    setting.httpsEnabled = YES;
    [[NIMSDK sharedSDK] setServerSetting:setting];
    NIMSDKOption *option = [NIMSDKOption optionWithAppKey: NEIM_AppKey];
    option.apnsCername = NEIM_APNS;
    [[NIMSDK sharedSDK] registerWithOption:option];
    [[NIMSDK sharedSDK] enableConsoleLog]; //开启控制台的log日志
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];//系统通知管理类
    [[NIMSDK sharedSDK].loginManager addDelegate:self];//登录管理类
    [[NIMSDK sharedSDK].chatManager addDelegate:self];//聊天管理类，消息收发
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];//会话管理类
    [NIMSDKConfig sharedConfig].delegate = self;
    [NIMSDKConfig sharedConfig].shouldConsiderRevokedMessageUnreadCount = YES;//是否需要将被撤回的消息计入未读计算考虑
    [[NIMSDKConfig sharedConfig] setShouldSyncStickTopSessionInfos:YES];//是否同步置顶会话记录，默认NO
    [[NIMSDKConfig sharedConfig] setShouldSyncUnreadCount:YES];//未读数多端同步
    [[NIMSDKConfig sharedConfig] setAsyncLoadRecentSessionEnabled:YES];//一次性获取全部会话设置先获取100条
    [[NIMSDK sharedSDK].subscribeManager addDelegate:self];//在线状态订阅
    //注册自定义消息的解析器
    [NIMCustomObject registerCustomDecoder:[[NTMCustomAttachmentDecoder alloc] init]];
    //RTC初始化
    [[ASRtcManager shared] initData];
    //登录IM
    [NIMSDK.sharedSDK.loginManager login:account token:token completion:^(NSError * _Nullable error) {
        if (!error) {
            [ASIMDataConfig configIMServerWithServerUrl:SERVER_URL imageURL:SERVER_IMAGE_URL h5URL:SERVER_AGREEMENT_URL env:SERVER_IM_ENV];
            [ASIMDataConfig configIMKit];
            [ASIMDataConfig configIMBaseData];
            succeed();
        } else {
            kShowToast(@"登录失败，请重新登录");
            [USER_INFO removeUserData:^{
                
            }];
            fail();
        }
    }];
}

#pragma mark NIMLoginManagerDelegate
//强退回调
- (void)onKickout:(NIMLoginKickoutResult *)result {
    if (result.reasonCode == NIMKickReasonByClient) {//被另外一个客户端踢下线
        kShowToast(@"你的账号在其他设备登录，被迫退出当前登录");
        [USER_INFO removeUserData:^{
        }];
    } else if (result.reasonCode == NIMKickReasonByServer) { //被服务器踢下线
        kShowToast(@"被服务器禁止登录");
        [USER_INFO removeUserData:^{
        }];
    } else {
        [USER_INFO removeUserData:^{
        }];
    }
}

#pragma mark NIMSystemNotificationManagerDelegate
/**
 *  收到自定义通知回调
 *  @discussion 这个通知是由开发者服务端/客户端发出,由我们的服务器进行透传的通知,SDK不负责这个信息的存储
 *  @param notification 自定义通知
 */
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification {
    NSDictionary *content = [ASCommonFunc convertJsonStringToNSDictionary:notification.content];
    ASIMSystemNotifyModel *notifyModel = [ASIMSystemNotifyModel mj_objectWithKeyValues:content];
    switch (notifyModel.ID) {
        case kIMConsumptionReminder://消费提醒
        {
            [ASAlertViewManager defaultPopTitle:@"理性消费提示" content:notifyModel.data.message left:@"确定" right:@"" isTouched:YES affirmAction:^{
            } cancelAction:^{
            }];
        }
            break;
        case kIMRealNameStatus://实名认证状态变化通知
        {
            [ASCommonRequest requestAuthStateWithIsRequest:NO success:^(id  _Nullable data) {
            } errorBack:^(NSInteger code, NSString *msg) {
            }];
        }
            break;
        case kIMIntimacyValueChange://亲密值变化
        {
            NSString *user_id = [notifyModel.data.from_uid isEqualToString: USER_INFO.user_id] ? notifyModel.data.to_uid : notifyModel.data.from_uid;
            NSString *intimateKey = [NSString stringWithFormat:@"%@_intimate_%@",USER_INFO.user_id, user_id];
            NSDictionary *valueDict = @{@"user_id": STRING(user_id),
                                        @"grade": @(notifyModel.data.grade),
                                        @"score": STRING(notifyModel.data.score)};
            [ASUserDefaults setValue:valueDict forKey:intimateKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updataIntimateValueNitification" object: valueDict];
        }
            break;
        case kIMIntimacyValuePromote://亲密值弹窗提示
        {
            NSString *user_id = [notifyModel.data.from_uid isEqualToString: USER_INFO.user_id] ? notifyModel.data.to_uid : notifyModel.data.from_uid;
            NSString *intimateKey = [NSString stringWithFormat:@"%@_intimate_%@",USER_INFO.user_id, user_id];
            NSDictionary *valueDict = @{@"user_id": STRING(notifyModel.data.to_uid),
                                        @"grade": @(notifyModel.data.grade),
                                        @"score": STRING(notifyModel.data.current_score)};
            [ASUserDefaults setValue:valueDict forKey:intimateKey];
            [ASAlertViewManager popIntimacyUpgradeWithModel:notifyModel];
        }
            break;
        case kIMClearCache://清除缓存
        {
            [ASCommonFunc clearAppCache];
        }
            break;
        case kIMRecommendationSystem://系统消息处理
        {
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = notifyModel.data.title;
            content.body = notifyModel.data.content;
            content.badge = @1;//角标数
            content.categoryIdentifier = @"customLocalizationIdentifier";
            content.userInfo = @{@"link_type": @(notifyModel.data.link_type),
                                 @"link_url": STRING(notifyModel.data.link_url)};
            /** 通知触发机制
             Trigger 设置本地通知触发条件,它一共有以下几种类型：
             UNPushNotificaitonTrigger 推送服务的Trigger，由系统创建
             UNTimeIntervalNotificationTrigger 时间触发器，可以设置多长时间以后触发，是否重复。如果设置重复，重复时长要大于60s
             UNCalendarNotificationTrigger 日期触发器，可以设置某一日期触发
             UNLocationNotificationTrigger 位置触发器，用于到某一范围之后，触发通知。通过CLRegion设定具体范围。
             */
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
            //创建UNNotificationRequest通知请求对象
            NSString *requestIdentifier = @"customLocalizationIdentifier";
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:trigger];
            //将通知加到通知中心
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                
            }];
        }
            break;
        case kIMDynamicNotify://来动态消息通知
        {
            //创建通知
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = @"动态通知";
            content.body = notifyModel.data.msg;
            content.badge = @1;//角标数
            content.categoryIdentifier = @"customLocalizationIdentifier";
            /** 通知触发机制
             Trigger 设置本地通知触发条件,它一共有以下几种类型：
             UNPushNotificaitonTrigger 推送服务的Trigger，由系统创建
             UNTimeIntervalNotificationTrigger 时间触发器，可以设置多长时间以后触发，是否重复。如果设置重复，重复时长要大于60s
             UNCalendarNotificationTrigger 日期触发器，可以设置某一日期触发
             UNLocationNotificationTrigger 位置触发器，用于到某一范围之后，触发通知。通过CLRegion设定具体范围。
             */
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
            //创建UNNotificationRequest通知请求对象
            NSString *requestIdentifier = @"customLocalizationIdentifier";
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:trigger];
            //将通知加到通知中心
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                
            }];
            //发送通知更新动态数量
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updataDynamicNotifyCountNitification" object: nil];
        }
            break;
        case kIMPopUpFriendReminder://关注好友、密友上线提醒
        {
            if ([[ASCommonFunc currentVc] isKindOfClass: [ASHomeController class]] ||
                [[ASCommonFunc currentVc] isKindOfClass: [ASMineController class]] ||
                [[ASCommonFunc currentVc] isKindOfClass: [ASIMListController class]] ||
                [[ASCommonFunc currentVc] isKindOfClass: [ASDynamicController class]]) {
                if (kObjectIsEmpty(self.friendUpPopView) || self.friendUpPopView.isClose == YES) {
                    self.friendUpPopView = [UIAlertController friendUpPopWithModel:notifyModel.data affirmAction:^{
                        //去私聊页
                        [ASMyAppCommonFunc chatWithUserID:notifyModel.data.man_id nickName:notifyModel.data.nickname action:^(id  _Nonnull data) {
                            
                        }];
                    }];
                }
            }
        }
            break;
        case kIMGiftPiaoPing://礼物飘屏
        {
            if ([[ASCommonFunc currentVc] isKindOfClass: [ASHomeController class]] ||
                [[ASCommonFunc currentVc] isKindOfClass: [ASMineController class]] ||
                [[ASCommonFunc currentVc] isKindOfClass: [ASIMListController class]] ||
                [[ASCommonFunc currentVc] isKindOfClass: [ASDynamicController class]] ||
                [[ASCommonFunc currentVc] isKindOfClass: [ASVideoShowPlayController class]] ||
                [ASIMFuncManager isP2PCartController] == YES ||
                [[ASCommonFunc currentVc] isKindOfClass: [ASCallRtcVideoAnswerController class]] ||
                [[ASCommonFunc currentVc] isKindOfClass: [ASCallRtcVideoController class]] ||
                [[ASCommonFunc currentVc] isKindOfClass: [ASCallRtcVoiceAnswerController class]] ||
                [[ASCommonFunc currentVc] isKindOfClass: [ASCallRtcVoiceController class]] ||
                [[ASCommonFunc currentVc] isKindOfClass: [ASGiftSVGAPlayerController class]]) {
                if (kObjectIsEmpty(self.giftPopView) || self.giftPopView.isClose == YES) {
                    self.giftPopView = [UIAlertController giftPiaoPingWithModel:notifyModel.data];
                } else {
                    [self.giftPopView dismiss];
                    self.giftPopView = [UIAlertController giftPiaoPingWithModel:notifyModel.data];
                }
            }
        }
            break;
        case kIMNotBalancePop://余额不足
        {
            if (kAppType == 1) {
                return;
            }
            if (notifyModel.data.end_time > [ASCommonFunc currentTimeStr].integerValue) {
                [ASMyAppCommonFunc balanceDeficiencyPopViewWithPayScene:[NSString stringWithFormat:@"%zd",notifyModel.data.scene] cancel:^{
                    
                }];
            }
        }
            break;
        case kIMVideoShowNotifiction://视频秀通知
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"videoShowCountNotification" object:[NSString stringWithFormat:@"%zd", notifyModel.data.count]];
        }
            break;
        case kIMToSetMeHiding://ta对我设置隐身状态调用
        {
            if (notifyModel.data.is_hidden == 1) {
                [USER_INFO.usesHiddenListModel.hiddenMeUsersID addObject:notifyModel.data.user_id];
            } else {
                [USER_INFO.usesHiddenListModel.hiddenMeUsersID removeObject:notifyModel.data.user_id];
            }
            [ASIMDataConfig hiddenMeUserListDataWithUsers:USER_INFO.usesHiddenListModel.hiddenMeUsersID];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessageListNotification" object: nil];
        }
            break;
        case kIMLittleHelperSendMsg://收到了女用户的系统通知，男用户插入一条小助手提醒消息
        {
            //构造出具体会话
            NIMSession *session = [NIMSession session:notifyModel.sessionId type:NIMSessionTypeP2P];
            NIMCustomObject *object = [[NIMCustomObject alloc] init];
            IMCustomAttachment *attachment = [[IMCustomAttachment alloc] init];
            attachment.type = 72;
            attachment.data = @{@"type": @(72),
                                @"content": STRING(notifyModel.content)};
            //构造出具体消息
            NIMMessage *message = [[NIMMessage alloc] init];
            message.text = STRING(notifyModel.content);
            message.messageObject = object;
            message.timestamp = notifyModel.time / 1000;
            object.attachment = attachment;
            NIMMessageSetting *setting = [[NIMMessageSetting alloc]init];
            setting.shouldBeCounted = NO;//同时去掉未读统计
            message.setting = setting;
            //更新消息
            [[NIMSDK sharedSDK].conversationManager saveMessage:message forSession:session completion:^(NSError * _Nullable error) {
                if (error == nil) {
                    
                }
            }];
        }
            break;
        case kIMFemaleUserAide://小助手
        {
            if (kAppType == 0 && USER_INFO.gender == 1 && USER_INFO.systemIndexModel.is_fate_helper_show == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"requestMatchHelperNotification" object:nil];
            }
        }
        default:
            break;
    }
}

//小助手发送系统消息
- (void)sendLittleHelperWithMessage:(NIMMessage *)message {
    NSInteger time = message.timestamp*1000 - 2000;
    NSDictionary *dict = @{@"id": @"1001",
                           @"sessionId": STRING(USER_INFO.user_id),//对方ID
                           @"fromAccount": STRING(USER_INFO.user_id),//我的ID
                           @"time":@(time),
                           @"content":@"小助手为你匹配了一位陪聊小姐姐，发现你和她很有缘，赶紧聊聊吧，别错过缘分~",
    };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    NSString *json = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
    NIMCustomSystemNotification *systemNotification = [[NIMCustomSystemNotification alloc] initWithContent:json];
    systemNotification.sendToOnlineUsersOnly = NO;
    [[[NIMSDK sharedSDK] systemNotificationManager] sendCustomNotification:systemNotification
                                                                 toSession:message.session
                                                                completion:^(NSError * _Nullable error) {
    }];
}

#pragma mark - NIMEventSubscribeManagerDelegate
/**
 *  收到所订阅的事件的回调
 *  @param events 广播的事件 NIMSubscribeEvent 列表
 */
- (void)onRecvSubscribeEvents:(NSArray *)events {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userStatusNotification" object: events];
    for (NIMSubscribeEvent *userStatus in events) {
        //储存所有的用户的在线状态
        [ASUserDefaults setValue:[NSString stringWithFormat:@"%zd", userStatus.value] forKey:[NSString stringWithFormat:@"event_state_%@", userStatus.from]];
    }
}

#pragma mark NIMChatManagerDelegate
/**
 *  收到消息回调
 *
 *  @param messages 消息列表,内部为NIMMessage
 */
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages {
    //每次收到消息，更新一下未读数量
    [self updateUnreadCount];
    NIMMessage *message = messages[0];
    if ([NEKitChatConfig.shared.xitongxiaoxi_id isEqualToString:message.from]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshZushouOrHuodongNotify" object: @"1"];
    }
    if ([NEKitChatConfig.shared.huodongxiaozushou_id isEqualToString:message.from]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshZushouOrHuodongNotify" object: @"2"];
    }
    //密友来消息，更新好友红点状态
    NSString *intimateKey = [NSString stringWithFormat:@"%@_intimate_%@",USER_INFO.user_id, STRING(message.from)];
    NSDictionary *intimateData = [ASUserDefaults valueForKey:intimateKey];
    NSNumber *grade = intimateData[@"grade"];
    if (grade.integerValue > 1) {//好友
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMiyouNotification" object: @"1"];
    }
    //处理消息弹窗逻辑
    //是否开启顶部消息提醒，默认开启
    NSString *isPop = [ASUserDefaults valueForKey:kIsChatMessageNotifyPop];
    if (!kStringIsEmpty(isPop) && isPop.integerValue == 0) {
        return;
    }
    if ([USER_INFO.user_id isEqualToString:message.from]) {//自己发给自己的消息，就不弹出提示
        return;
    }
    if ([self isPopIMNotify] == NO) {
        return;
    }
    NSNumber *remoteIsPop = message.remoteExt[@"is_pop"];//显示弹出消息悬浮提醒
    if (remoteIsPop.integerValue != 1) {
        return;
    }
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:message.from];
    if (kObjectIsEmpty(self.IMNotifyPopView) || self.IMNotifyPopView.isClose == YES) {
        self.IMNotifyPopView = [UIAlertController chatPopWithMessage:message userHeader:user.userInfo.avatarUrl affirmAction:^{
            [ASMyAppCommonFunc chatWithUserID:message.from nickName:message.senderName action:^(id  _Nonnull data) {
                
            }];
        }];
    }
}

#pragma mark NIMSDKConfigDelegate
//SDK 提供消息过滤忽略的功能。消息过滤后，SDK将不存储对应的消息，也不会上抛给接收回调，因此应用层不会收到对应的消息。
- (BOOL)shouldIgnoreMessage:(NIMMessage *)message {
    //    if (!kObjectIsEmpty(message.remoteExt)) {
    //        NSNumber *is_beckon_un = message.remoteExt[@"is_beckon_un"];//是否搭讪
    //        NSNumber *is_fold = message.remoteExt[@"is_fold"];//是否折叠
    //        //女用户是搭讪消息就加入到折叠列表
    //        //男用户是搭讪消息且需要折叠，才加入到折叠列表
    //        if ((USER_INFO.gender == 1 && is_beckon_un.integerValue == 1) || (USER_INFO.gender == 2 && is_beckon_un.integerValue == 1 && is_fold.integerValue == 1)) {
    //            //进行亲密度判断，有亲密度也不做处理
    //            NSString *intimateKey = [NSString stringWithFormat:@"%@_intimate_%@",USER_INFO.user_id, STRING(message.from)];
    //            NSDictionary *intimateData = [ASUserDefaults valueForKey:intimateKey];
    //            NSString *score = intimateData[@"score"];
    //            if (kObjectIsEmpty(intimateData) || score.floatValue == 0) {//没有亲密度数据 或 亲密度=0
    //                //进行本地插入，表示收到消息，不在会话列表插入该条会话
    //                NSMutableDictionary *localExt = [NSMutableDictionary dictionaryWithDictionary:message.localExt];
    //                [localExt setObject:@"1" forKey:@"is_insertion_conversation"];
    //                message.localExt = localExt;
    //                //更新一下消息
    //                [[NIMSDK sharedSDK].conversationManager updateMessage:message forSession:message.session completion:^(NSError * _Nullable error) {
    //
    //                }];
    //                if (kObjectIsEmpty([ASIMHelperDataManager shared].dashanList)) {
    //                    [ASIMHelperDataManager shared].dashanList = [NSMutableArray arrayWithArray:@[STRING(message.session.sessionId)]];
    //                } else {
    //                    if (![[ASIMHelperDataManager shared].dashanList containsObject: STRING(message.session.sessionId)]) {//不包含就添加
    //                        NSMutableArray *dashanList = [ASIMHelperDataManager shared].dashanList;
    //                        [dashanList addObject:STRING(message.session.sessionId)];
    //                        [ASIMHelperDataManager shared].dashanList = dashanList;
    //                    }
    //                }
    //                //发消息告知更新搭讪人数
    //                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDashanDataNotify" object: nil];
    //            }
    //        }
    //    }
    //    //处理小助手自定义消息逻辑
    //    if (message.messageType == NIMMessageTypeCustom && kAppType == 0 && USER_INFO.gender == 1 && USER_INFO.systemIndexModel.is_fate_helper_show == 1) {
    //        if(!kStringIsEmpty(message.rawAttachContent)){
    //            //获取message的rawAttachContent转json数据
    //            NSDictionary *recentMessage = [ASCommonFunc convertJsonStringToNSDictionary:message.rawAttachContent];
    //            //自定义消息类型
    //            NSString *type = STRING([recentMessage objectForKey:@"type"]);
    //            //72小助手缘分牵线消息，进行本地保存
    //            if ([type isEqualToString:@"14"]) {//72是小助手牵线
    //                NSMutableDictionary *localExt = [NSMutableDictionary dictionaryWithDictionary:message.localExt];
    //                [localExt setObject:@"1" forKey:@"is_insertion_conversation"];
    //                message.localExt = localExt;
    //                //更新一下消息
    //                [[NIMSDK sharedSDK].conversationManager updateMessage:message forSession:message.session completion:^(NSError * _Nullable error) {
    //
    //                }];
    //                //插入一条小助手用户到列表
    //                if (kObjectIsEmpty([ASIMHelperDataManager shared].helperList)) {
    //                    [ASIMHelperDataManager shared].helperList = [NSMutableArray arrayWithArray:@[STRING(message.session.sessionId)]];
    //                } else {
    //                    if (![[ASIMHelperDataManager shared].helperList containsObject: STRING(message.session.sessionId)]) {//不包含就添加
    //                        NSMutableArray *helperList = [ASIMHelperDataManager shared].helperList;
    //                        [helperList addObject:STRING(message.session.sessionId)];
    //                        [ASIMHelperDataManager shared].helperList = helperList;
    //                    }
    //                }
    //                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshListLittleHelperNotify" object: nil];
    //            }
    //        }
    //    }
    if (![message.from isEqualToString:USER_INFO.user_id]) {
        //对方发过来的消息，且是语音消息，标记为1，表示未读显示红点
        if (message.messageType == 2) {
            //取需要改的值进行插入数据为1的标记
            NSMutableDictionary *localExt = [NSMutableDictionary dictionaryWithDictionary:message.localExt];
            [localExt setObject:@"1" forKey:@"isReadAudio"];
            message.localExt = localExt;//修改本地数据标记是否已读
            [[NIMSDK sharedSDK].conversationManager updateMessage:message forSession:message.session completion:^(NSError * _Nullable error) {
                
            }];
        }
    }
    return NO;
}

#pragma mark - NIMConversationManagerDelegate
//**
// *  增加最近会话的回调
// *
// *  @param recentSession    最近会话
// *  @param totalUnreadCount 目前总未读数
// *  @discussion 当新增一条消息，并且本地不存在该消息所属的会话时，会触发此回调。
// */
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount {
    //新增会话，判断是否有未读消息，如果有未读消息，通知首页显示未读消息悬浮窗提示
    [[NSNotificationCenter defaultCenter] postNotificationName:@"homeMessageRemindUpdate" object:nil];
    [self recentSessionChange:recentSession];
}

/**
 *  最近会话修改的回调
 *
 *  @param recentSession    最近会话
 *  @param totalUnreadCount 目前总未读数
 *  @discussion 触发条件包括: 1.当新增一条消息，并且本地存在该消息所属的会话。
 *                          2.所属会话的未读清零。
 *                          3.所属会话的最后一条消息的内容发送变化。(例如成功发送后，修正发送时间为服务器时间)
 *                          4.删除消息，并且删除的消息为当前会话的最后一条消息。
 */
- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount {
    //收到消息，判断是否有未读消息，如果有未读消息，通知首页显示未读消息悬浮窗提示
    [[NSNotificationCenter defaultCenter] postNotificationName:@"homeMessageRemindUpdate" object:nil];
    NSDictionary *localExt = recentSession.localExt;
    NSString *conversationType = localExt[@"conversation_type"];
    //判断conversationType为0，代表会话列表进行UI更新，就不再执行会话的小助手和搭讪逻辑
    if (!kStringIsEmpty(conversationType) && [conversationType isEqualToString:@"0"]){
        return;
    }
    [self recentSessionChange:recentSession];
}

/**
 *  删除最近会话的回调
 *
 *  @param recentSession    最近会话
 *  @param totalUnreadCount 目前总未读数
 */
- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount {
    //收到消息，判断是否有未读消息，如果有未读消息，通知首页显示未读消息悬浮窗提示
    [[NSNotificationCenter defaultCenter] postNotificationName:@"homeMessageRemindUpdate" object:nil];
}

//会话小助手or搭讪逻辑处理
- (void)recentSessionChange:(NIMRecentSession *)recentSession {
    NIMMessage *lastMessage = recentSession.lastMessage;
    BOOL isMySend = lastMessage.isOutgoingMsg;//判断是否自己发送的消息，ture表示我发的
    if (!kObjectIsEmpty(lastMessage.remoteExt)) {
        NSNumber *is_beckon_un = lastMessage.remoteExt[@"is_beckon_un"];//是否搭讪
        NSNumber *is_fold = lastMessage.remoteExt[@"is_fold"];//是否折叠
        //女用户是搭讪消息就加入到折叠列表
        //男用户是搭讪消息且需要折叠，才加入到折叠列表
        if ((USER_INFO.gender == 1 && is_beckon_un.integerValue == 1 && isMySend == YES) ||
            (USER_INFO.gender == 2 && is_beckon_un.integerValue == 1 && is_fold.integerValue == 1 && isMySend == NO)) {
            //进行亲密度判断，有亲密度也不做处理
            NSString *intimateKey = [NSString stringWithFormat:@"%@_intimate_%@",USER_INFO.user_id, STRING(recentSession.session.sessionId)];
            NSDictionary *intimateData = [ASUserDefaults valueForKey:intimateKey];
            NSString *score = intimateData[@"score"];
            if (kObjectIsEmpty(intimateData) || score.floatValue == 0) {//没有亲密度数据 或 亲密度=0
                if (USER_INFO.gender == 2 && [ASIMHelperDataManager shared].dashanList.count >= USER_INFO.systemIndexModel.foldVol) {//男用户且大于等于了限制数量
                    if (![[ASIMHelperDataManager shared].dashanList containsObject: STRING(recentSession.session.sessionId)]) {//不包含就添加
                        //删除会话
                        NSString *userid = [ASIMHelperDataManager shared].dashanList[USER_INFO.systemIndexModel.foldVol - 1];
                        NIMRecentSession *delRecentSession = [[NIMSDK sharedSDK].conversationManager recentSessionBySession: [NIMSession session:STRING(userid) type:NIMSessionTypeP2P]];
                        NSMutableDictionary *delLocalExt = [NSMutableDictionary dictionaryWithDictionary:delRecentSession.localExt];
                        [delLocalExt setObject:@"0" forKey:@"conversation_type"];//3个消息列表。0或者没值为默认会话列表，1为匹配小助手会话列表。2为搭讪消息列表
                        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:delLocalExt recentSession:delRecentSession];
                        NIMDeleteRecentSessionOption *option = [[NIMDeleteRecentSessionOption alloc] init];
                        option.isDeleteRoamMessage = YES;
                        option.shouldMarkAllMessagesReadInSessions = YES;
                        [[NIMSDK sharedSDK].conversationManager deleteRecentSession:delRecentSession option:option completion:^(NSError * _Nullable error) {
                            
                        }];
                        //取消订阅
                        NIMSubscribeRequest *request = [[NIMSubscribeRequest alloc] init];
                        request.type = 1;
                        request.expiry = 60*60*24*1;
                        request.syncEnabled = YES;
                        request.publishers = @[userid];
                        [[NIMSDK sharedSDK].subscribeManager unSubscribeEvent:request completion:^(NSError * _Nullable error, NSArray * _Nullable failedPublishers) {
                            
                        }];
                        //移除数据的ID
                        [[ASIMHelperDataManager shared].dashanList removeObject:userid];
                        //更新会话本地扩展字段
                        NSMutableDictionary *localExt = [NSMutableDictionary dictionaryWithDictionary:recentSession.localExt];
                        [localExt setObject:@"2" forKey:@"conversation_type"];//3个消息列表。0为默认会话列表，1为匹配小助手会话列表。2为搭讪消息列表
                        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:localExt recentSession:recentSession notifyRecentUpdate:NO];//更新会话不更新UI
                        NSMutableArray *dashanList = [ASIMHelperDataManager shared].dashanList;
                        [dashanList addObject:STRING(recentSession.session.sessionId)];
                        [ASIMHelperDataManager shared].dashanList = dashanList;
                        [ASIMHelperDataManager shared].dashanAmount = [ASIMHelperDataManager shared].dashanAmount + 1;//搭讪数量
                        //发消息告知更新搭讪人数
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDashanDataNotify" object: nil];
                        });
                    }
                } else {//女用户 或 男用户且被搭讪的数量小于限制的数量。进行直接添加到搭讪列表逻辑
                    //更新会话本地扩展字段
                    NSMutableDictionary *localExt = [NSMutableDictionary dictionaryWithDictionary:recentSession.localExt];
                    [localExt setObject:@"2" forKey:@"conversation_type"];//3个消息列表。0为默认会话列表，1为匹配小助手会话列表。2为搭讪消息列表
                    [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:localExt recentSession:recentSession notifyRecentUpdate:NO];//更新会话不更新UI
                    //把一键回复成功的用户加入到搭讪列表
                    if (kObjectIsEmpty([ASIMHelperDataManager shared].dashanList)) {
                        [ASIMHelperDataManager shared].dashanList = [NSMutableArray arrayWithArray:@[STRING(recentSession.session.sessionId)]];
                        [ASIMHelperDataManager shared].dashanAmount = 1;
                        //发消息告知更新搭讪人数
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDashanDataNotify" object: nil];
                        });
                    } else {
                        if (![[ASIMHelperDataManager shared].dashanList containsObject: STRING(recentSession.session.sessionId)]) {//不包含就添加
                            NSMutableArray *dashanList = [ASIMHelperDataManager shared].dashanList;
                            [dashanList addObject:STRING(recentSession.session.sessionId)];
                            [ASIMHelperDataManager shared].dashanList = dashanList;
                            [ASIMHelperDataManager shared].dashanAmount = [ASIMHelperDataManager shared].dashanAmount + 1;//搭讪数量
                        }
                        //发消息告知更新搭讪人数
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDashanDataNotify" object: nil];
                        });
                    }
                }
            } else {
                //更新会话本地扩展字段，不显示到搭讪列表，解放显示到会话列表中
                NSMutableDictionary *localExt = [NSMutableDictionary dictionaryWithDictionary:recentSession.localExt];
                [localExt setObject:@"0" forKey:@"conversation_type"];//3个消息列表。0或者没值为默认会话列表，1为匹配小助手会话列表。2为搭讪消息列表
                dispatch_async(dispatch_get_main_queue(), ^{
                    //主线程更新UI
                    [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:localExt recentSession:recentSession notifyRecentUpdate:YES];
                });
            }
        }
    }
    //收到消息，处理小助手自定义72消息逻辑
    if (lastMessage.messageType == NIMMessageTypeCustom && kAppType == 0 && USER_INFO.gender == 1 && USER_INFO.systemIndexModel.is_fate_helper_show == 1) {
        if(!kStringIsEmpty(lastMessage.rawAttachContent) && isMySend == NO){
            //获取message的rawAttachContent转json数据
            NSDictionary *rawAttachMessage = [ASCommonFunc convertJsonStringToNSDictionary:lastMessage.rawAttachContent];
            //自定义消息类型
            NSString *type = STRING([rawAttachMessage objectForKey:@"type"]);
            //72小助手缘分牵线消息
            if ([type isEqualToString:@"72"]) {
                //更新会话本地扩展字段
                NSMutableDictionary *localExt = [NSMutableDictionary dictionaryWithDictionary:recentSession.localExt];
                [localExt setObject:@"1" forKey:@"conversation_type"];//3个消息列表。0为默认会话列表，1为匹配小助手会话列表。2为搭讪消息列表
                //更新会话
                [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:localExt recentSession:recentSession notifyRecentUpdate:NO];
                //插入一条小助手用户到小助手匹配列表
                if (kObjectIsEmpty([ASIMHelperDataManager shared].helperList)) {
                    [ASIMHelperDataManager shared].helperList = [NSMutableArray arrayWithArray:@[STRING(recentSession.session.sessionId)]];
                } else {
                    if (![[ASIMHelperDataManager shared].helperList containsObject: STRING(recentSession.session.sessionId)]) {//不包含就添加
                        NSMutableArray *helperList = [ASIMHelperDataManager shared].helperList;
                        [helperList addObject:STRING(recentSession.session.sessionId)];
                        [ASIMHelperDataManager shared].helperList = helperList;
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshLittleHelperAcountNotify" object: nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshListLittleHelperNotify" object: nil];
            }
        }
    }
    //判断我是女用户，且对方在搭讪列表，来消息了搭讪列表用户挪出
    if (USER_INFO.gender == 1 && isMySend == NO) {
        NSMutableDictionary *localExt = [NSMutableDictionary dictionaryWithDictionary:recentSession.localExt];
        NSString *conversationType = localExt[@"conversation_type"];
        if ([conversationType isEqualToString:@"2"] && [[ASIMHelperDataManager shared].dashanList containsObject: lastMessage.from]) {//搭讪列表的用户
            //搭讪列表来消息了，保存到本地的搭讪用户给移除掉
            [[ASIMHelperDataManager shared].dashanList removeObject:STRING(lastMessage.from)];
            [ASUserDefaults setValue:[ASIMHelperDataManager shared].dashanList forKey:[NSString stringWithFormat:@"userinfo_dashan_list_%@",STRING(USER_INFO.user_id)]];
            NSMutableDictionary *localExt = [NSMutableDictionary dictionaryWithDictionary:recentSession.localExt];
            [localExt setObject:@"0" forKey:@"conversation_type"];//改变下状态，让其可以回到会话列表显示
            [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:localExt recentSession:recentSession notifyRecentUpdate:YES];
            if ([ASIMHelperDataManager shared].dashanAmount > 0) {
                [ASIMHelperDataManager shared].dashanAmount = [ASIMHelperDataManager shared].dashanAmount -1;
            }
            //发消息告知更新搭讪人数
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDashanDataNotify" object: nil];
            });
        }
    }
    //判断我是男用户，我回消息在搭讪列表的用户，把搭讪列表用户挪出
    if (USER_INFO.gender == 2 && isMySend == YES) {
        NSMutableDictionary *localExt = [NSMutableDictionary dictionaryWithDictionary:recentSession.localExt];
        NSString *conversationType = localExt[@"conversation_type"];
        if ([conversationType isEqualToString:@"2"] && [[ASIMHelperDataManager shared].dashanList containsObject: recentSession.session.sessionId]) {//搭讪列表的用户
            //搭讪列表来消息了，保存到本地的搭讪用户给移除掉
            [[ASIMHelperDataManager shared].dashanList removeObject:STRING(recentSession.session.sessionId)];
            [ASUserDefaults setValue:[ASIMHelperDataManager shared].dashanList forKey:[NSString stringWithFormat:@"userinfo_dashan_list_%@",STRING(USER_INFO.user_id)]];
            NSMutableDictionary *localExt = [NSMutableDictionary dictionaryWithDictionary:recentSession.localExt];
            [localExt setObject:@"0" forKey:@"conversation_type"];//改变下状态，让其可以回到会话列表显示
            [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:localExt recentSession:recentSession notifyRecentUpdate:YES];
            if ([ASIMHelperDataManager shared].dashanAmount > 0) {
                [ASIMHelperDataManager shared].dashanAmount = [ASIMHelperDataManager shared].dashanAmount -1;
            }
            //发消息告知更新搭讪人数
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDashanDataNotify" object: nil];
            });
        }
    }
}

//判断是否可以弹出消息
- (BOOL)isPopIMNotify {
    NSInteger index = [[ASCommonFunc currentVc].tabBarController selectedIndex];
    if (index == 3) {//消息模块不弹出
        return NO;
    }
    if ([[ASCommonFunc currentVc] isKindOfClass: [ASCallRtcVideoAnswerController class]]) {
        return NO;
    }
    if ([[ASCommonFunc currentVc] isKindOfClass: [ASCallRtcVideoController class]]) {
        return NO;
    }
    if ([[ASCommonFunc currentVc] isKindOfClass: [ASCallRtcVoiceAnswerController class]]) {
        return NO;
    }
    if ([[ASCommonFunc currentVc] isKindOfClass: [ASCallRtcVoiceController class]]) {
        return NO;
    }
    if ([[ASCommonFunc currentVc] isKindOfClass: [TZImagePickerController class]]) {
        return NO;
    }
    if ([[ASCommonFunc currentVc] isKindOfClass: [ASGiftSVGAPlayerController class]]) {
        return NO;
    }
    if ([[ASCommonFunc currentVc] isKindOfClass: [ASLoginBindPhoneController class]]) {//绑定手机号页不弹出
        return NO;
    }
    if ([ASIMFuncManager isP2PCartController] == YES) {
        return NO;
    }
    NSString *classStr = NSStringFromClass([[ASCommonFunc currentVc] class]);
    if ([classStr isEqualToString:@"TZPhotoPickerController"]) {
        return NO;
    }
    NSString *navigationClassStr = NSStringFromClass([[ASCommonFunc currentVc].navigationController class]);
    if ([navigationClassStr isEqualToString:@"UANavigationController"]) {
        return NO;
    }
    return YES;
}

//判断搭讪列表是否有未读消息，男用户
- (BOOL)dashanIsUnread {
    if ([ASIMHelperDataManager shared].dashanList.count == 0) {
        return NO;
    }
    for (NSString *userid in [ASIMHelperDataManager shared].dashanList) {
        NIMSession *session = [NIMSession session:userid type:NIMSessionTypeP2P];
        NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
        NSInteger unreadCount = recent.unreadCount;
        if (unreadCount > 0) {
            return YES;
        }
    }
    return NO;
}

//判断密友是否有未读消息
- (BOOL)miyouIsUnread {
    NSArray *recentSessions = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
    for (NIMRecentSession *recentSession in recentSessions) {
        NSString *intimateKey = [NSString stringWithFormat:@"%@_intimate_%@",USER_INFO.user_id, STRING(recentSession.session.sessionId)];
        NSDictionary *intimateData = [ASUserDefaults valueForKey:intimateKey];
        NSNumber *grade = intimateData[@"grade"];
        if (grade.integerValue > 1 && recentSession.unreadCount > 0) {//好友
            return YES;
        }
    }
    return NO;
}

//系统通知新消息
- (BOOL)xitongIsUnread {
    NIMSession *xitongxiaoxiSession = [NIMSession session:NEKitChatConfig.shared.xitongxiaoxi_id type:NIMSessionTypeP2P];
    NIMRecentSession *xitongxiaoxiSessionRecent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:xitongxiaoxiSession];
    if (xitongxiaoxiSessionRecent.unreadCount > 0) {
        return YES;
    }
    return NO;
}

//活动小助手新消息
- (BOOL)huodongIsUnread {
    NIMSession *huodongxiaozhushouSession = [NIMSession session:NEKitChatConfig.shared.huodongxiaozushou_id type:NIMSessionTypeP2P];
    NIMRecentSession *huodongxiaozhushouSessionRecent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:huodongxiaozhushouSession];
    if (huodongxiaozhushouSessionRecent.unreadCount > 0) {
        return YES;
    }
    return NO;
}

//会话列表未读消息总数
- (NSInteger)conversationCount {
    NSInteger unreadCount = 0;
    NSArray *recentSessions = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
    for (NIMRecentSession *recentSession in recentSessions) {
        NSDictionary *localExt = recentSession.localExt;
        NSString *conversationType = localExt[@"conversation_type"];
        if ([conversationType isEqualToString:@"1"] ||
            [conversationType isEqualToString:@"2"] ||
            [recentSession.session.sessionId isEqualToString:NEKitChatConfig.shared.xitongxiaoxi_id] ||
            [recentSession.session.sessionId isEqualToString:NEKitChatConfig.shared.huodongxiaozushou_id]) {
            continue;
        }
        unreadCount = unreadCount + recentSession.unreadCount;
    }
    return unreadCount;
}

- (void)updateUnreadCount {
    if (![[ASMyAppRegister shared].window.rootViewController isKindOfClass: [ASBaseTabBarController class]]) {
        return;
    }
    ASBaseTabBarController *tabbarVC = (ASBaseTabBarController *)[ASMyAppRegister shared].window.rootViewController;
    if (kObjectIsEmpty(tabbarVC)) {
        return;
    }
    NSInteger unreadCount = 0;
    if ([self dashanIsUnread] == YES) {
        unreadCount += 1;
    }
    //系统通知
    if ([self xitongIsUnread] == YES) {
        unreadCount += 1;
    }
    //活动通知
    if ([self huodongIsUnread] == YES) {
        unreadCount += 1;
    }
    unreadCount += [self conversationCount];
    UITabBarItem *tabBarItem = tabbarVC.tabBar.items[3];
    if (unreadCount == 0) {
        tabBarItem.badgeValue = nil;
        return;
    }
    if (unreadCount > 99) {
        tabBarItem.badgeValue = @"99+";
    } else {
        tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd", unreadCount];
    }
}
@end
