//
//  ASLoginManager.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//通话类型
typedef NS_ENUM(NSInteger, ASLoginType) {
    kLoginTypePhone = 0,        //手机号码登录
    kLoginTypeTXOne = 1,        //一键登录
    kLoginTypeWechat = 2,       //微信登录
};

@interface ASLoginManager : NSObject
+ (ASLoginManager *)shared;//单例
//一键登录初始化:是否成功
@property (nonatomic,assign) BOOL txLoginInitIsSuccess;
//TX一键登录进行初始化
- (void)TX_LoginInit;
//TX一键登录初始化后登录
- (void)TX_LoginInitLogin;
//腾讯一键登录 failDispose:失败是否需要单独处理 actionBlock：处理事件
- (void)TX_LoginPushFailDispose:(BOOL)failDispose actionBlock:(VoidBlock)actionBlock;
//校验登录类型：是否腾讯一键登录or其他登录 block表示取号结束的回调，再执行其他操作
- (void)verifyIsLoginWithBlock:(VoidBlock)block;
//一键登录失败执行登录
- (void)TXLoginFailedLogin;
//手机号码登录页
- (void)phoneLoginVc;
//微信登录页
- (void)weChatVc;
//微信登录
- (void)weChatLogin;
//登录成功，设置根控制器
- (void)loginSuccess;
//绑定手机号一键登录
- (void)TX_BindPhoneLoginWithUser:(ASUserInfoModel *)user isWeChatFirst:(BOOL)isWeChatFirst;
//微信绑定
- (void)weChatBindWithSuccess:(ResponseSuccess)success;
//绑定手机号一键登录弹窗
- (void)TX_BindPhonePopViewWithController:(UIViewController *)vc hitnText:(NSString *)hitnText isPopWindow:(BOOL)isPopWindow close:(VoidBlock)close;
@end

NS_ASSUME_NONNULL_END
