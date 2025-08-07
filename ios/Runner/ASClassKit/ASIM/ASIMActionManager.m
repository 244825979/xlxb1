//
//  ASIMActionManager.m
//  AS
//
//  Created by SA on 2025/5/14.
//

#import "ASIMActionManager.h"
#import "ASIMRequest.h"
#import "ASAddUsefulLanController.h"
#import "心聊想伴-Swift.h"
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
            [remoteExt setObject:@(model.is_beckon_un) forKey:@"is_beckon_un"];
            [remoteExt setObject:@(model.is_fold) forKey:@"is_fold"];
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
            [ASAlertViewManager defaultPopTitle:@"一键已读" content:@"消息气泡会清除，但消息不会丢失" left:@"确认" right:@"取消" affirmAction:^{
                if ([ASIMFuncManager filtrationUnreadConversation].count > 0) {
                    [[[NIMSDK sharedSDK] conversationManager] batchMarkMessagesReadInSessions:[ASIMFuncManager filtrationUnreadConversation]];
                    [[ASIMManager shared] updateUnreadCount];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"homeMessageRemindUpdate" object:nil];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshZushouOrHuodongNotify" object: @"0"];
            } cancelAction:^{
                
            }];
            return;
        }
        if ([indexName isEqualToString:@"清除消息"]) {
            [ASAlertViewManager defaultPopTitle:@"确定删除全部消息" content:@"删除后数据无法恢复，请谨慎操作" left:@"确定删除" right:@"再考虑下" affirmAction:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMsgListNotification" object:nil];
                [[ASIMManager shared] updateUnreadCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"homeMessageRemindUpdate" object:nil];
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
            [ASAlertViewManager defaultPopTitle:@"一键已读" content:@"消息气泡会清除，但消息不会丢失" left:@"确认" right:@"取消" affirmAction:^{
                if ([[ASIMManager shared] dashanIsUnread] == YES) {
                    [[[NIMSDK sharedSDK] conversationManager] batchMarkMessagesReadInSessions:[ASIMFuncManager dashanConversationSession]];
                    [[ASIMManager shared] updateUnreadCount];
                }
            } cancelAction:^{
                
            }];
            return;
        }
        if ([indexName isEqualToString:@"清除消息"]) {
            [ASAlertViewManager defaultPopTitle:@"确定删除全部消息" content:@"删除后数据无法恢复，请谨慎操作" left:@"确定删除" right:@"再考虑下" affirmAction:^{
                if ([ASIMHelperDataManager shared].dashanList.count > 0) {
                    for (NSString *userid in [ASIMHelperDataManager shared].dashanList) {
                        NIMSession *session = [NIMSession session:STRING(userid) type:NIMSessionTypeP2P];
                        NIMRecentSession *recentSession = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
                        [[NIMSDK sharedSDK].conversationManager deleteRecentSession:recentSession];//删除会话
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
                }
            } cancelAction:^{
                
            }];
            return;
        }
    } cancelAction:^{
        
    }];
}
@end
