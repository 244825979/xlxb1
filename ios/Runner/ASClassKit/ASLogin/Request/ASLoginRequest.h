//
//  ASLoginRequest.h
//  AS
//
//  Created by SA on 2025/4/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASLoginRequest : NSObject
//一键登录
+ (void)requestTxLoginWithTXToken:(NSString *)txToken
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack;
//一键登录页的绑定手机号操作
+ (void)requestTxOneKeyBindMobileWithTXToken:(NSString *)txToken
                               isWeChatFirst:(BOOL)isWeChatFirst
                                     success:(ResponseSuccess)successBack
                                   errorBack:(ResponseFail)errorBack;
//手机号码绑定手机号操作
+ (void)requestPhoneBindMobileWithMobile:(NSString *)mobile
                                    code:(NSString *)code
                           isWeChatFirst:(BOOL)isWeChatFirst
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack;
//获取验证码
+ (void)requestSmsCodeWithPhone:(NSString *)phone
                           type:(NSString *)type
                        isVoice:(BOOL)isVoice
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack;

//手机号码登录
+ (void)requestPhoneLoginWithPhone:(NSString *)phone
                              code:(NSString *)code
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;
//微信登录
+ (void)requestWXLoginWithOpenid:(NSString *)openid
                           token:(NSString *)token
                         success:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack;
//获取默认昵称列表
+ (void)requestRegisterManNameSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;

//完善用户资料
+ (void)requestProfileRegNewWithNickName:(NSString *)nickName
                                  avatar:(NSString *)avatar
                                  gender:(NSString *)gender
                                     age:(NSString *)age
                              inviteCode:(NSString *)inviteCode
                          showNavigation:(BOOL)showNavigation
                           isWeChatFirst:(BOOL)isWeChatFirst
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack;
//退出登录
+ (void)requestOutLoginSuccess:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack;
//注销
+ (void)requestCancelAccountSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;
//新人礼包
+ (void)requestNewUserGiftBagSuccess:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack;

@end

NS_ASSUME_NONNULL_END
