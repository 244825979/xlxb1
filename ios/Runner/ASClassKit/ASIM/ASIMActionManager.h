//
//  ASIMActionManager.h
//  AS
//
//  Created by SA on 2025/5/14.
//

#import <Foundation/Foundation.h>
#import "NEChatUIKit/NEChatUIKit-Swift.h"
#import "ASIMChatRemoteExtModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASIMActionManager : NSObject
//聊天底部bar的按钮点击
+ (void)chatInputViewItemWithType:(ChatTabbarItemType)type toUserID:(NSString *)toUserID backBlock:(void(^)(id _Nullable data))block;
//发送接口校验消息
+ (void)sendMessage:(NIMMessage *)message
               type:(NSInteger)type
              isTid:(NSInteger)isTid
           toUserID:(NSString *)toUserID
          backBlock:(void(^)(id _Nullable data, ASIMChatRemoteExtModel *model))block
          errorBack:(ResponseFail)errorBack;
//去个人主页
+ (void)goPersonalHomeWithToUserID:(NSString *)toUserID isMy:(BOOL)isMy;
//IM会话列表清理
+ (void)clearMessage;
//搭讪会话列表清理
+ (void)dashanClearMessage;
@end

NS_ASSUME_NONNULL_END
