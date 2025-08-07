
#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASMsgTool : NSObject<MBProgressHUDDelegate>

/**
 单例
 */
+ (instancetype)shared;
/**
 显示提示
 */
+ (void)showTips:(NSString *)tips;
+ (void)showTips:(NSString *)tips toView:(UIView *)toView;

/**
 显示加载中消息，菊花样式
 */
+ (void)showLoading;
+ (void)showLoading:(NSString *)message;

/**
 显示成功
 */
+ (void)showSuccess:(NSString *)success;
/**
 显示失败
 */
+ (void)showError:(NSString *)error;
/**
 图标提示
 */
+ (void)showMessage:(NSString *)message toView:(UIView *)toView imageName:(NSString *)imageName;
/**
 隐藏加载中
 */
+ (void)hideMsg;

@end

NS_ASSUME_NONNULL_END
