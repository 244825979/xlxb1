//
//  ASLoginRequest.m
//  AS
//
//  Created by SA on 2025/4/14.
//

#import "ASLoginRequest.h"
#import "ASManNameListModel.h"
#import "ASPhoneLoginController.h"
#import "ASCertificationOneController.h"
#import "ASNewUserGiftModel.h"
#import "ASWeChatLoginController.h"

@implementation ASLoginRequest

+ (void)loginOrRegisterWithParams:(NSDictionary *)params
                          withURL:(NSString *)url
                   showNavigation:(BOOL)showNavigation
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack {
    //url：一键登录or手机号码登录
    [ASBaseRequest postWithUrl:url params:params success:^(id  _Nonnull response) {
        ASUserInfoModel *user = [ASUserInfoModel mj_objectWithKeyValues:response[@"userinfo"]];
        //保存用户的token
        USER_INFO.token = STRING(user.token);
        [ASUserDefaults setValue:STRING(user.token) forKey:@"userinfo_token"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (user.finish_status == 0) {//首次登录未完善资料，去补充资料进行注册
                successBack(@"1");//1表示注册
            } else {
                if (user.is_rp_auth == 0 && user.gender == 1) {//女性且B面，未进行真人认证
                    ASCertificationOneController *vc = [[ASCertificationOneController alloc]init];
                    vc.userModel = user;
                    vc.showNavigation = showNavigation;
                    vc.backBlock = ^{
                        [[ASLoginManager shared] TX_LoginPushFailDispose:NO actionBlock:^{ }];
                    };
                    [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                    [ASMsgTool hideMsg];
                } else {
                    [USER_INFO saveUserDataWithModel:user complete:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            successBack(@"0");//0表示登录
                        });
                    }];
                }
            }
        });
    } fail:^(NSInteger code, NSString *msg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            errorBack(code, msg);
        });
    } showHUD:NO];
}

+ (void)requestTxLoginWithTXToken:(NSString *)txToken
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack {
    kWeakSelf(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:STRING(txToken) forKey:@"accessToken"];
    [params setValue:@"1" forKey:@"agreement"];
    [ASMyAppCommonFunc getLoginYDTokenSuccess:^(NSString * _Nonnull ydToken) {
        [params setValue:STRING(ydToken) forKey:@"yidunToken"];
        [wself loginOrRegisterWithParams:params withURL:API_TXLogin showNavigation:YES success:^(id  _Nullable data) {
            successBack(data);//返回注册或登录的状态，0是登录，1是注册
        } errorBack:^(NSInteger code, NSString *msg) {
            errorBack(code, msg);
        }];
    } login:^() {
        [wself loginOrRegisterWithParams:params withURL:API_TXLogin showNavigation:YES success:^(id  _Nullable data) {
            successBack(data);//返回注册或登录的状态，0是登录，1是注册
        } errorBack:^(NSInteger code, NSString *msg) {
            errorBack(code, msg);
        }];
    }];
}
//一键登录方式绑定
+ (void)requestTxOneKeyBindMobileWithTXToken:(NSString *)txToken
                                  isRegister:(BOOL)isRegister
                                     success:(ResponseSuccess)successBack
                                   errorBack:(ResponseFail)errorBack {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:STRING(txToken) forKey:@"accessToken"];
    [params setValue:isRegister ? @"register" : @"" forKey:@"scene"];//注册场景传：register，其他不传或者空字符）
    [ASBaseRequest postWithUrl:API_OneKeyBindMobile params:params success:^(id  _Nonnull response) {
        ASUserInfoModel *user = [ASUserInfoModel mj_objectWithKeyValues:response[@"userinfo"]];
        if (!kStringIsEmpty(user.mobile)) {
            if (user.gender == 1) {
                if (user.is_rp_auth == 0) {//女性且，未进行真人认证
                    ASCertificationOneController *vc = [[ASCertificationOneController alloc]init];
                    vc.userModel = user;
                    vc.showNavigation = YES;
                    vc.backBlock = ^{
                        [[ASLoginManager shared] TX_LoginPushFailDispose:NO actionBlock:^{ }];
                    };
                    [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                    [ASMsgTool hideMsg];
                } else {
                    //女用户且已经认证，进行保存本地数据的登录逻辑，进入首页
                    [USER_INFO saveUserDataWithModel:user complete:^{
                        successBack(user);
                    }];
                }
            } else {
                //男用户因为已经执行了登录的逻辑，直接进入到首页即可
                USER_INFO.mobile = STRING(user.mobile);
                [ASUserDefaults setValue:user.mobile forKey:@"userinfo_mobile"];
                successBack(user);
            }
        } else {
            if (user.gender == 1) {
                [USER_INFO saveUserDataWithModel:user complete:^{
                    successBack(user);
                }];
            } else {
                USER_INFO.mobile = STRING(user.mobile);
                [ASUserDefaults setValue:user.mobile forKey:@"userinfo_mobile"];
                successBack(user);
            }
        }
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}
//手机号码验证码方式绑定
+ (void)requestPhoneBindMobileWithMobile:(NSString *)mobile
                                    code:(NSString *)code
                              isRegister:(BOOL)isRegister
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:STRING(mobile) forKey:@"mobile"];
    [params setValue:STRING(code) forKey:@"phone_code"];
    [params setValue:isRegister ? @"register" : @"" forKey:@"scene"];//注册场景传：register，其他不传或者空字符）
    [ASBaseRequest postWithUrl:API_PhoneBindMobile params:params success:^(id  _Nonnull response) {
        ASUserInfoModel *user = [ASUserInfoModel mj_objectWithKeyValues:response[@"userinfo"]];
        if (!kStringIsEmpty(user.mobile)) {
            if (user.gender == 1) {
                if (user.is_rp_auth == 0) {//女性且，未进行真人认证
                    ASCertificationOneController *vc = [[ASCertificationOneController alloc]init];
                    vc.userModel = user;
                    vc.showNavigation = NO;
                    vc.backBlock = ^{
                        [[ASLoginManager shared] TX_LoginPushFailDispose:NO actionBlock:^{ }];
                    };
                    [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                    [ASMsgTool hideMsg];
                } else {
                    //女用户且已经认证，进行保存本地数据的登录逻辑，进入首页
                    [USER_INFO saveUserDataWithModel:user complete:^{
                        successBack(user);
                    }];
                }
            } else {
                //男用户因为已经执行了登录的逻辑，直接进入到首页即可
                USER_INFO.mobile = STRING(user.mobile);
                [ASUserDefaults setValue:user.mobile forKey:@"userinfo_mobile"];
                successBack(user);
            }
        } else {
            if (user.gender == 1) {
                [USER_INFO saveUserDataWithModel:user complete:^{
                    successBack(user);
                }];
            } else {
                USER_INFO.mobile = STRING(user.mobile);
                [ASUserDefaults setValue:user.mobile forKey:@"userinfo_mobile"];
                successBack(user);
            }
        }
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestSmsCodeWithPhone:(NSString *)phone
                           type:(NSString *)type
                        isVoice:(BOOL)isVoice
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"mobile":STRING(phone),
                             @"type":STRING(type),
                             @"voice_code":@(isVoice)
    };
    [ASBaseRequest postWithUrl:API_SendCode params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestPhoneLoginWithPhone:(NSString *)phone
                              code:(NSString *)code
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack {
    kWeakSelf(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:STRING(phone) forKey:@"mobile"];
    [params setValue:STRING(code) forKey:@"phone_code"];
    [params setValue:@"1" forKey:@"agreement"];
    [ASMyAppCommonFunc getLoginYDTokenSuccess:^(NSString * _Nonnull ydToken) {//加入易盾
        [params setValue:STRING(ydToken) forKey:@"yidunToken"];
        [wself loginOrRegisterWithParams:params withURL:API_CodeLogin showNavigation:NO success:^(id  _Nullable data) {
            successBack(data);//返回注册或登录的状态，0是登录，1是注册
        } errorBack:^(NSInteger code, NSString *msg) {
            errorBack(code, msg);
        }];
    } login:^() {
        [wself loginOrRegisterWithParams:params withURL:API_CodeLogin showNavigation:NO success:^(id  _Nullable data) {
            successBack(data);//返回注册或登录的状态，0是登录，1是注册
        } errorBack:^(NSInteger code, NSString *msg) {
            errorBack(code, msg);
        }];
    }];
}

//微信登录
+ (void)requestWXLoginWithOpenid:(NSString *)openid
                           token:(NSString *)token
                         success:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:STRING(openid) forKey:@"openid"];
    [params setValue:STRING(token) forKey:@"access_token"];
    [params setValue:@"wechat" forKey:@"platform"];
    [ASBaseRequest postWithUrl:API_WXLogin params:params success:^(id  _Nonnull response) {
        ASUserInfoModel *user = [ASUserInfoModel mj_objectWithKeyValues:response[@"userinfo"]];
        USER_INFO.token = STRING(user.token);
        [ASUserDefaults setValue:STRING(user.token) forKey:@"userinfo_token"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (user.finish_status == 0) {//首次登录未完善资料，去补充资料进行注册
                successBack(@"1");//1表示注册
            } else {
                if (!kStringIsEmpty(user.mobile)) {
                    if (user.is_rp_auth == 0 && user.gender == 1) {//女性且未进行真人认证
                        ASCertificationOneController *vc = [[ASCertificationOneController alloc]init];
                        vc.userModel = user;
                        vc.showNavigation = YES;
                        vc.backBlock = ^{
                            [[ASLoginManager shared] TX_LoginPushFailDispose:NO actionBlock:^{ }];
                        };
                        [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                        [ASMsgTool hideMsg];
                    } else {
                        [USER_INFO saveUserDataWithModel:user complete:^{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                successBack(@"0");//0表示登录
                            });
                        }];
                    }
                } else {
                    [ASMsgTool hideMsg];
                    if (user.gender == 2) {//男用户表示登录成功
                        [USER_INFO saveUserDataWithModel:user complete:^{ }];
                    }
                    //进入绑定手机号流程
                    [[ASLoginManager shared] TX_BindPhoneLoginWithUser:user];
                }
            }
        });
    } fail:^(NSInteger code, NSString *msg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            errorBack(code, msg);
        });
    } showHUD:NO];
}

+ (void)requestRegisterManNameSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_ManNameList params:@{} success:^(id  _Nonnull response) {
        ASManNameListModel *model = [ASManNameListModel mj_objectWithKeyValues:response[@"male"]];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestProfileRegNewWithNickName:(NSString *)nickName
                                  avatar:(NSString *)avatar
                                  gender:(NSString *)gender
                                     age:(NSString *)age
                              inviteCode:(NSString *)inviteCode
                          showNavigation:(BOOL)showNavigation
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:STRING(nickName) forKey:@"nickname"];
    [params setValue:STRING(avatar) forKey:@"avatar"];
    [params setValue:STRING(gender) forKey:@"gender"];
    [params setValue:STRING(age) forKey:@"age"];
    [params setValue:STRING(inviteCode) forKey:@"invite_code"];
    [ASMsgTool showLoading];
    [ASMyAppCommonFunc getLoginYDTokenSuccess:^(NSString * _Nonnull ydToken) {
        [params setValue:STRING(ydToken) forKey:@"yidunToken"];
        [ASBaseRequest postWithUrl:API_ProfileRegNew params:params success:^(id  _Nonnull response) {
            ASUserInfoModel *user = [ASUserInfoModel mj_objectWithKeyValues:response[@"userinfo"]];
            USER_INFO.token = STRING(user.token);
            [ASUserDefaults setValue:STRING(user.token) forKey:@"userinfo_token"];
            //保存用户的头像，进行认证填充
            [ASUserDefaults setValue:STRING(user.avatar) forKey:@"register_avatar"];
            if (!kStringIsEmpty(user.mobile)) {
                if (user.is_rp_auth == 0 && user.gender == 1) {//女性且，未进行真人认证
                    ASCertificationOneController *vc = [[ASCertificationOneController alloc]init];
                    vc.userModel = user;
                    vc.showNavigation = showNavigation;
                    vc.backBlock = ^{
                        [[ASLoginManager shared] TX_LoginPushFailDispose:NO actionBlock:^{ }];
                    };
                    [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                    [ASMsgTool hideMsg];
                } else {
                    [USER_INFO saveUserDataWithModel:user complete:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            successBack(response);
                        });
                    }];
                }
                [ASMsgTool hideMsg];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ASMsgTool hideMsg];
                    if (user.gender == 2) {//男用户表示登录成功
                        [USER_INFO saveUserDataWithModel:user complete:^{ }];
                    }
                    //进入绑定手机号流程
                    [[ASLoginManager shared] TX_BindPhoneLoginWithUser:user];
                });
            }
        } fail:^(NSInteger code, NSString *msg) {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBack(code, msg);
                [ASMsgTool hideMsg];
            });
        } showHUD:YES];
    } login:^() {
        [ASBaseRequest postWithUrl:API_ProfileRegNew params:params success:^(id  _Nonnull response) {
            ASUserInfoModel *user = [ASUserInfoModel mj_objectWithKeyValues:response[@"userinfo"]];
            USER_INFO.token = STRING(user.token);
            [ASUserDefaults setValue:STRING(user.token) forKey:@"userinfo_token"];
            //保存用户的头像，进行认证填充
            [ASUserDefaults setValue:STRING(user.avatar) forKey:@"register_avatar"];
            if (!kStringIsEmpty(user.mobile)) {
                if (user.is_rp_auth == 0 && user.gender == 1) {//女性且，未进行真人认证
                    ASCertificationOneController *vc = [[ASCertificationOneController alloc]init];
                    vc.userModel = user;
                    vc.showNavigation = showNavigation;
                    vc.backBlock = ^{
                        [[ASLoginManager shared] TX_LoginPushFailDispose:NO actionBlock:^{ }];
                    };
                    [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                    [ASMsgTool hideMsg];
                } else {
                    [USER_INFO saveUserDataWithModel:user complete:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            successBack(response);
                        });
                    }];
                }
                [ASMsgTool hideMsg];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ASMsgTool hideMsg];
                    if (user.gender == 2) {//男用户表示登录成功
                        [USER_INFO saveUserDataWithModel:user complete:^{ }];
                    }
                    //进入绑定手机号流程
                    [[ASLoginManager shared] TX_BindPhoneLoginWithUser:user];
                });
            }
        } fail:^(NSInteger code, NSString *msg) {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBack(code, msg);
                [ASMsgTool hideMsg];
            });
        } showHUD:YES];
    }];
}

+ (void)requestOutLoginSuccess:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack {
    [ASMsgTool showLoading];
    [ASBaseRequest postWithUrl:API_LoginOut params:@{} success:^(id  _Nonnull response) {
        [USER_INFO removeUserData:^{
            successBack(response);
        }];
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestCancelAccountSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"user_id": STRING(USER_INFO.user_id)};
    [ASBaseRequest postWithUrl:API_CloseAccount params:params success:^(id  _Nonnull response) {
        [USER_INFO removeUserData:^{
            kShowToast(@"注销成功");
            successBack(response);
        }];
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestNewUserGiftBagSuccess:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_NewUserGiftBag params:@{} success:^(id  _Nonnull response) {
        ASNewUserGiftModel *model = [ASNewUserGiftModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}
@end
