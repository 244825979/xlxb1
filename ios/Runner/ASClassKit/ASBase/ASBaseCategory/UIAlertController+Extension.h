//
//  UIAlertController+Extension.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>
#import "ASIMSystemNotifyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Extension)
//用户主页提示私聊
+ (void)personalHomeChatAlertWithUserInfo:(ASUserInfoModel *)userInfo view:(UIView *)view ;
//来消息提醒
+ (zhPopupController *)chatPopWithMessage:(NIMMessage *)message userHeader:(NSString *)userHeader affirmAction:(VoidBlock)affirmAction;
//上线提醒
+ (zhPopupController *)friendUpPopWithModel:(ASIMSystemNotifyDataModel *)model affirmAction:(VoidBlock)affirmAction;
//礼物飘屏
+ (zhPopupController *)giftPiaoPingWithModel:(ASIMSystemNotifyDataModel *)model;
//会话列表开通消息提醒权限浮窗
+ (zhPopupController *)systemNotifyLimitPopView:(UIView *)view affirmAction:(VoidBlock)affirmAction;
//微信悬浮弹窗提示微信登录
+ (zhPopupController *)wechatLoginWithView:(UIView *)view affirmAction:(VoidBlock)affirmAction;
@end

NS_ASSUME_NONNULL_END
