//
//  ASIMActionManager.m
//  AS
//
//  Created by SA on 2025/5/14.
//

#import "ASIMActionManager.h"
#import "ASIMRequest.h"
#import "ASAddUsefulLanController.h"
#import "Runner-Swift.h"
@implementation ASIMActionManager

+ (void)chatInputViewItemWithType:(ChatTabbarItemType)type toUserID:(NSString *)toUserID backBlock:(void(^)(id _Nullable data))block {
    switch (type) {
        case ChatTabbarItemTypeGift://礼物
        {
            [ASCommonRequest requestGiftTitleSuccess:^(id  _Nullable data) {
                [ASAlertViewManager popGiftViewWithTitles:data toUserID:toUserID giftType:kSendGiftTypeIM sendBlock:^(NSString * _Nonnull giftID, NSInteger giftCount, NSString * _Nonnull giftTypeID) {
                    
                }];
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        }
            break;
        case ChatTabbarItemTypeCall://call
        {
            [ASMyAppCommonFunc callPopViewWithUserID:toUserID scene:Call_Scene_Chat  back:^(BOOL isSucceed) {
                
            }];
        }
            break;
        case ChatTabbarItemTypeExpressions://常用语
        {
            ASAddUsefulLanController *vc = [[ASAddUsefulLanController alloc] init];
            vc.sendTextBlock = ^(NSString * _Nonnull text) {
                block(text);
            };
            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
        }
            break;
        case ChatTabbarItemTypeImage://相册
        {
            [[ASUploadImageManager shared] selectImagePickerWithMaxCount:1 isSelfieCamera:false viewController:[ASCommonFunc currentVc] didFinish:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
                block(photos[0]);
            }];
        }
            break;
        default:
            break;
    }
}

//发送接口校验消息
+ (void)sendMessage:(NIMMessage *)message
               type:(NSInteger)type
              isTid:(NSInteger)isTid
           toUserID:(NSString *)toUserID
          backBlock:(void(^)(id _Nullable data, ASIMChatRemoteExtModel *model))block
          errorBack:(ResponseFail)errorBack{
    [ASIMRequest requestSendImWithType:type
                                 msgID:message.messageId
                               content:message.text
                              toUserID:toUserID
                                 isTid:isTid
                               success:^(id  _Nullable data) {
        ASIMChatRemoteExtModel *model = data;
        NSMutableDictionary *remoteExt = [NSMutableDictionary dictionaryWithDictionary:@{@"is_cut": @(model.is_cut),
                                                                                         @"is_chat_card": @(model.is_chat_card),
                                                                                         @"vip": @(model.vip),
                                                                                         @"money": STRING(model.money),
                                                                                         @"cut_coin": @(model.cut_coin),
                                                                                         @"coin": @(model.coin),
                                                                                         @"replace_content": STRING(model.replace_content)}];
        if (isTid == 1) {//匹配小助手
            [remoteExt setObject:@(1) forKey:@"is_beckon_un"];
            [remoteExt setObject:@(1) forKey:@"is_fold"];
        } else {
            if (USER_INFO.gender == 2) {
                [remoteExt setObject:@(model.is_beckon_un) forKey:@"is_beckon_un"];
                [remoteExt setObject:@(model.is_fold) forKey:@"is_fold"];
            }
        }
        [remoteExt setObject:@(model.is_pop) forKey:@"is_pop"];
        message.remoteExt = remoteExt;
        block(message, model);
    } errorBack:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    }];
}

+ (void)goPersonalHomeWithToUserID:(NSString *)toUserID isMy:(BOOL)isMy {
    [ASMyAppCommonFunc goPersonalHomeWithUserID:isMy == YES ? USER_INFO.user_id : toUserID
                                 viewController:[ASCommonFunc currentVc]
                                         action:^(id  _Nonnull data) {
    }];
}

+ (void)clearMessage {
    [ASAlertViewManager bottomPopTitles:@[@"一键已读", @"清除消息"] indexAction:^(NSString *indexName) {
        if ([indexName isEqualToString:@"一键已读"]) {
            [ASAlertViewManager defaultPopTitle:@"一键已读" content:@"消息气泡会清除，但消息不会丢失" left:@"确认" right:@"取消" isTouched:YES affirmAction:^{
                NSArray *recentSessions = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
                for (NIMRecentSession *recentSession in recentSessions) {
                    NSDictionary *localExt = recentSession.localExt;
                    NSString *conversationType = localExt[@"conversation_type"];
                    if ([conversationType isEqualToString:@"1"] ||
                        [conversationType isEqualToString:@"2"]) {
                        continue;
                    }
                    [[[NIMSDK sharedSDK] conversationManager] markAllMessagesReadInSession:recentSession.session];
                }
                [[ASIMManager shared] updateUnreadCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"homeMessageRemindUpdate" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshZushouOrHuodongNotify" object: @"0"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMiyouNotification" object: @"2"];
            } cancelAction:^{
                
            }];
            return;
        }
        if ([indexName isEqualToString:@"清除消息"]) {
            [ASAlertViewManager defaultPopTitle:@"确定删除全部消息" content:@"删除后数据无法恢复，请谨慎操作" left:@"确定删除" right:@"再考虑下" isTouched:YES affirmAction:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMsgListNotification" object:nil];
                [[ASIMManager shared] updateUnreadCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"homeMessageRemindUpdate" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMiyouNotification" object: @"2"];
            } cancelAction:^{
                
            }];
            return;
        }
    } cancelAction:^{
        
    }];
}

//搭讪会话列表清理
+ (void)dashanClearMessage {
    [ASAlertViewManager bottomPopTitles:USER_INFO.gender == 2 ? @[@"一键已读", @"清除消息"] : @[@"清除消息"] indexAction:^(NSString *indexName) {
        if ([indexName isEqualToString:@"一键已读"]) {
            [ASAlertViewManager defaultPopTitle:@"一键已读" content:@"消息气泡会清除，但消息不会丢失" left:@"确认" right:@"取消" isTouched:YES affirmAction:^{
                if ([ASIMHelperDataManager shared].dashanList.count > 0) {
                    for (NSString *userid in [ASIMHelperDataManager shared].dashanList) {
                        NIMSession *session = [NIMSession session:userid type:NIMSessionTypeP2P];
                        [[[NIMSDK sharedSDK] conversationManager] markAllMessagesReadInSession:session];
                    }
                    [[ASIMManager shared] updateUnreadCount];
                }
            } cancelAction:^{
                
            }];
            return;
        }
        if ([indexName isEqualToString:@"清除消息"]) {
            [ASAlertViewManager defaultPopTitle:@"确定删除全部消息" content:@"删除后数据无法恢复，请谨慎操作" left:@"确定删除" right:@"再考虑下" isTouched:YES affirmAction:^{
                if ([ASIMHelperDataManager shared].dashanList.count > 0) {
                    for (NSString *userid in [ASIMHelperDataManager shared].dashanList) {
                        NIMSession *session = [NIMSession session:STRING(userid) type:NIMSessionTypeP2P];
                        NIMRecentSession *recentSession = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
                        NSMutableDictionary *localExt = [NSMutableDictionary dictionaryWithDictionary:recentSession.localExt];
                        [localExt setObject:@"3" forKey:@"conversation_type"];//3个消息列表。0或者没值为默认会话列表，1为匹配小助手会话列表。2为搭讪消息列表。3都不显示
                        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:localExt recentSession:recentSession];
                        NIMDeleteRecentSessionOption *option = [[NIMDeleteRecentSessionOption alloc] init];
                        option.isDeleteRoamMessage = YES;
                        option.shouldMarkAllMessagesReadInSessions = YES;
                        [[NIMSDK sharedSDK].conversationManager deleteRecentSession:recentSession option:option completion:^(NSError * _Nullable error) {
                            
                        }];
                        //取消订阅
                        NIMSubscribeRequest *request = [[NIMSubscribeRequest alloc] init];
                        request.type = 1;
                        request.expiry = 60*60*24*1;
                        request.syncEnabled = YES;
                        request.publishers = @[userid];
                        [[NIMSDK sharedSDK].subscribeManager unSubscribeEvent:request completion:^(NSError * _Nullable error, NSArray * _Nullable failedPublishers) {
                            
                        }];
                    }
                    [[ASIMHelperDataManager shared].dashanList removeAllObjects];
                    [ASIMHelperDataManager shared].dashanList = [NSMutableArray arrayWithArray:@[]];
                    [ASIMHelperDataManager shared].dashanAmount = 0;
                    [[ASIMManager shared] updateUnreadCount];
                }
            } cancelAction:^{
                
            }];
            return;
        }
    } cancelAction:^{
        
    }];
}
@end
