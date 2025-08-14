//
//  ASLoginManager.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASLoginManager.h"
#import <TXLoginOauthSDK/TXLoginOauthSDK.h>
#import "ASLoginTXDelegateController.h"
#import "ASPhoneLoginController.h"
#import "ASRegisterUserController.h"
#import "ASLoginOtherView.h"
#import "ASWeChatLoginController.h"
#import "WXApi.h"
#import "ASLoginBindPhoneController.h"
#import "CustomButton.h"
#import "ASSetRequest.h"
#import "ASMyAppRegister.h"

@interface ASLoginManager()
@property (nonatomic, strong) ASLoginTXDelegateController *delegateVc;
@property (nonatomic, strong) UIImageView *agreementHintIcon;
@property (nonatomic, strong) TXLoginUIModel *uiModel;
@property (nonatomic, strong) TXLoginUIModel *bindModel;
@property (nonatomic, strong) TXLoginUIModel *windowBindModel;
@property (nonatomic,assign) BOOL checked;//是否点击协议
@end

@implementation ASLoginManager

+ (ASLoginManager *)shared {
    static dispatch_once_t onceToken;
    static ASLoginManager *shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

- (ASLoginTXDelegateController *)delegateVc {
    if (!_delegateVc) {
        _delegateVc = [[ASLoginTXDelegateController alloc]init];
        _delegateVc.isChecked = NO;
        kWeakSelf(self);
        _delegateVc.txProtocolBlock = ^(BOOL isChecked) {
            wself.checked = isChecked;
            if (isChecked) {
                wself.agreementHintIcon.hidden = YES;
            } else {
                wself.agreementHintIcon.hidden = NO;
            }
        };
    }
    return _delegateVc;
}

- (UIImageView *)agreementHintIcon {
    if (!_agreementHintIcon) {
        _agreementHintIcon = [[UIImageView alloc]init];
        _agreementHintIcon.image = [UIImage imageNamed:@"xieyi_bangding"];
        _agreementHintIcon.hidden = YES;
        UILabel *agreementHintText = [[UILabel alloc] init];
        agreementHintText.frame = CGRectMake(SCALES(8), 0, SCALES(160), SCALES(24));
        agreementHintText.font = TEXT_FONT_12;
        agreementHintText.text = @"请先勾选，同意后进行绑定";
        agreementHintText.textColor = UIColor.whiteColor;
        [_agreementHintIcon addSubview:agreementHintText];
    }
    return _agreementHintIcon;
}

//进行初始化
- (void)TX_LoginInit {
    kWeakSelf(self);
    [TXLoginOauthSDK initLoginWithId:TX_LoginID completionBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            ASLog(@"TX初始化成功");
            wself.txLoginInitIsSuccess = YES;//一键登录初始化成功
        } else {
            ASLog(@"TX初始化失败");
            wself.txLoginInitIsSuccess = NO;//一键登录初始化失败
        }
    }];
}

//初始化后直接进行登录
- (void)TX_LoginInitLogin {
    kWeakSelf(self);
    [TXLoginOauthSDK initLoginWithId:TX_LoginID completionBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            //1初始化成功
            wself.txLoginInitIsSuccess = YES;
            //2、使用预登录取号
            [TXLoginOauthSDK preLoginWithBack:^(NSDictionary * _Nonnull resultDic){
                ASLog(@"预登录成功%@", resultDic);
                //3、调用登录页面。判断login_select_first字段，1一键登录方式 2微信登录方式
                if (USER_INFO.systemIndexModel.login_select_first == 1) {
                    [wself TX_LoginPushFailDispose:NO actionBlock:^{ }];
                } else {
                    [wself weChatVc];
                }
            } failBlock:^(id  _Nonnull error) {
                ASLog(@"预登录失败：%@",error);
                //执行其他登录
                [wself TXLoginFailedLogin];
            }];
        } else {
            //初始化失败进行手机号登录
            wself.txLoginInitIsSuccess = NO;
            [wself TXLoginFailedLogin];
        }
    }];
}

//校验登录类型 一键登录or默认登录
- (void)verifyIsLoginWithBlock:(void (^ _Nonnull)(void))block {
    if ([ASLoginManager shared].txLoginInitIsSuccess) {//如果已经初始化成功了，直接取号登录
        kWeakSelf(self);
        //1、使用预登录取号
        [TXLoginOauthSDK preLoginWithBack:^(NSDictionary * _Nonnull resultDic){
            block();
            //2、调用登录页面。判断login_select_first字段，1一键登录方式 2微信登录方式
            if (USER_INFO.systemIndexModel.login_select_first == 1) {
                [wself TX_LoginPushFailDispose:NO actionBlock:^{ }];
            } else {
                [wself weChatVc];
            }
        } failBlock:^(id  _Nonnull error) {
            block();
            //执行其他登录
            [wself TXLoginFailedLogin];
        }];
    } else {//没有初始化成功，就去初始化再登录
        block();
        [self TX_LoginInitLogin];
    }
}

//进行腾讯一键登录
- (void)TX_LoginPushFailDispose:(BOOL)failDispose actionBlock:(VoidBlock)actionBlock {
    if (self.txLoginInitIsSuccess == NO && failDispose == YES) {
        actionBlock();
        return;
    }
    [ASMsgTool showLoading];
    kWeakSelf(self);
    [TXLoginOauthSDK loginWithController:[ASCommonFunc currentVc]
                              andUIModel:[self loginUIModel]
                            successBlock:^(NSDictionary * _Nonnull resultDic) {
        if ([resultDic[@"loginResultCode"] isEqualToString:@"200087"]) {
            ASLog(@"拉起登录授权页面成功");
            [ASMsgTool hideMsg];
        } else {
            //授权成功，返回token进行服务器登录操作
            NSString *token = STRING([resultDic valueForKey:@"token"]);
            [ASLoginRequest requestTxLoginWithTXToken:token success:^(id  _Nullable data) {
                NSString *number = data;
                if (number.integerValue == 1) {
                    ASRegisterUserController *vc = [[ASRegisterUserController alloc] init];
                    vc.showNavigation = YES;
                    vc.backBlock = ^{
                        [wself TX_LoginPushFailDispose:NO actionBlock:^{ }];
                    };
                    [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                } else {
                    [wself loginSuccess];
                }
                [ASMsgTool hideMsg];
            } errorBack:^(NSInteger code, NSString *msg) {
                [ASMsgTool hideMsg];
            }];
        }
    } failBlock:^(id  _Nonnull error) {
        [ASMsgTool hideMsg];
        [TXLoginOauthSDK delectScrip];
        if (failDispose == YES) {
            actionBlock();
        } else {
            //直接执行其他登录
            [wself TXLoginFailedLogin];
        }
    }];
}

//绑定手机号一键登录
- (void)TX_BindPhoneLoginWithUser:(ASUserInfoModel *)user {
    [ASMsgTool showLoading];
    kWeakSelf(self);
    [TXLoginOauthSDK loginWithController:[ASCommonFunc currentVc]
                              andUIModel:[self loginBindUIWithUser:user]
                            successBlock:^(NSDictionary * _Nonnull resultDic) {
        if ([resultDic[@"loginResultCode"] isEqualToString:@"200087"]) {
            ASLog(@"拉起登录授权页面成功");
            [ASMsgTool hideMsg];
        } else {
            //授权成功，返回token进行服务器登录操作
            NSString *token = STRING([resultDic valueForKey:@"token"]);
            [ASLoginRequest requestTxOneKeyBindMobileWithTXToken:token isRegister:YES success:^(id  _Nonnull response) {
                //绑定成功，进入到首页
                [wself loginSuccess];
                [ASMsgTool hideMsg];
            } errorBack:^(NSInteger code, NSString * _Nonnull message) {
                [ASMsgTool hideMsg];
            }];
        }
    } failBlock:^(id  _Nonnull error) {
        [ASMsgTool hideMsg];
        [TXLoginOauthSDK delectScrip];
        //执行普通绑定手机号方式
        [wself TXLoginBindPhoneWithUser:user];
    }];
}

//绑定手机号一键登录弹窗
- (void)TX_BindPhonePopViewWithController:(UIViewController *)vc isPopWindow:(BOOL)isPopWindow close:(VoidBlock)close {
    [ASMsgTool showLoading];
    [TXLoginOauthSDK loginWithController:vc
                              andUIModel:[self bindPopViewUIWithIsPopWindow:isPopWindow vc:vc close:^{
        close();
    }]
                            successBlock:^(NSDictionary * _Nonnull resultDic) {
        if ([resultDic[@"loginResultCode"] isEqualToString:@"200087"]) {
            ASLog(@"拉起登录授权页面成功");
            [ASMsgTool hideMsg];
        } else {
            //授权成功，返回token进行服务器登录操作
            NSString *token = STRING([resultDic valueForKey:@"token"]);
            [ASLoginRequest requestTxOneKeyBindMobileWithTXToken:token isRegister:NO success:^(id  _Nonnull response) {
                //绑定成功，关闭当前弹窗
                [ASMsgTool hideMsg];
                [TXLoginOauthSDK dismissViewControllerAnimated:NO completion:^{
                    kShowToast(@"绑定成功，可直接用手机号码登录此账号");
                    close();
                }];
            } errorBack:^(NSInteger code, NSString * _Nonnull message) {
                [ASMsgTool hideMsg];
            }];
        }
    } failBlock:^(id  _Nonnull error) {
        [ASMsgTool hideMsg];
        [TXLoginOauthSDK delectScrip];
        //执行普通绑定手机号方式的弹窗
        [ASAlertViewManager popPhoneBindAlertViewWithVc:vc content:@"" isPopWindow:isPopWindow affirmAction:^{
            ASLoginBindPhoneController *bindVc = [[ASLoginBindPhoneController alloc] init];
            [vc.navigationController pushViewController:bindVc animated:YES];
        } cancelBlock:^{
            close();
        }];
    }];
}

//一键登录失败
- (void)TXLoginFailedLogin {
    if (USER_INFO.systemIndexModel.login_jump_page_status == 1) {//手机号码登录
        [self phoneLoginVc];
    } else {//微信登录
        [self weChatVc];
    }
}

//绑定手机号的手机号码登录
- (void)TXLoginBindPhoneWithUser:(ASUserInfoModel *)user {
    ASLoginBindPhoneController *vc = [[ASLoginBindPhoneController alloc] init];
    vc.userModel = user;
    ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}

//执行手机号码登录
- (void)phoneLoginVc {
    ASPhoneLoginController *vc = [[ASPhoneLoginController alloc] init];
    ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}

//微信登录页
- (void)weChatVc {
    ASWeChatLoginController *vc = [[ASWeChatLoginController alloc] init];
    ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}

//微信登录
- (void)weChatLogin {
    kWeakSelf(self);
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (!error) {
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            ASLog(@"Wechat uid: %@", resp.uid);
            ASLog(@"Wechat openid: %@", resp.openid);
            ASLog(@"Wechat unionid: %@", resp.unionId);
            ASLog(@"Wechat accessToken: %@", resp.accessToken);
            ASLog(@"Wechat refreshToken: %@", resp.refreshToken);
            ASLog(@"Wechat expiration: %@", resp.expiration);
            // 用户信息
            ASLog(@"Wechat name: %@", resp.name);
            ASLog(@"Wechat iconurl: %@", resp.iconurl);
            ASLog(@"Wechat gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
            ASLog(@"Wechat originalResponse: %@", resp.originalResponse);
            if (kStringIsEmpty(resp.openid) || kStringIsEmpty(resp.accessToken)) {
                return;
            }
            [ASMsgTool showLoading];
            [ASLoginRequest requestWXLoginWithOpenid:resp.openid token:resp.accessToken success:^(id  _Nonnull response) {
                NSString *number = response;
                if (number.integerValue == 1) {
                    ASRegisterUserController *vc = [[ASRegisterUserController alloc] init];
                    vc.iconurl = resp.iconurl;
                    vc.name = resp.name;
                    vc.showNavigation = YES;
                    vc.backBlock = ^{
                        //因为从一键登录页进入的微信登录，返回到一键登录页
                        [wself TX_LoginPushFailDispose:NO actionBlock:^{ }];
                    };
                    [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                } else {
                    [wself loginSuccess];
                }
                [ASMsgTool hideMsg];
            } errorBack:^(NSInteger code, NSString * _Nonnull message) {
                [ASMsgTool hideMsg];
            }];
        }
    }];
}

//微信绑定
- (void)weChatBindWithSuccess:(ResponseSuccess)success {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (!error) {
            UMSocialUserInfoResponse *resp = result;
            if (kStringIsEmpty(resp.openid) || kStringIsEmpty(resp.accessToken)) {
                return;
            }
            [ASSetRequest requestSetBindWxWithOpenid:resp.openid token:resp.accessToken success:^(id  _Nonnull response) {
                success(response);
            } errorBack:^(NSInteger code, NSString * _Nonnull message) {
                
            }];
        }
    }];
}

//联系客服
- (void)chatService {
    ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
    vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Customer];
    ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationPageSheet;
    [[ASCommonFunc currentVc] presentViewController:nav animated:YES completion:nil];
}

//设置根控制器
- (void)loginSuccess {
    [ASMyAppCommonFunc appOpenStatistics];
    ASBaseTabBarController *vc = [[ASBaseTabBarController alloc] init];
    [ASMyAppRegister shared].window.rootViewController = vc;
}

#pragma mark - TX一键登录样式
- (TXLoginUIModel *)loginUIModel {
    self.uiModel = [[TXLoginUIModel alloc] init];
    /**状态栏设置*/
    self.uiModel.statusBarStyle = UIStatusBarStyleLightContent;
    /**logo的图片设置*/
    self.uiModel.iconImage = [UIImage imageNamed:@"app_logo"];
    self.uiModel.logoFrame = CGRectMake((SCREEN_WIDTH - SCALES(78))/2.0 , HEIGHT_NAVBAR + SCALES(72), SCALES(78), SCALES(78));/**LOGO图片frame*/
    self.uiModel.logoHidden = NO;
    /**手机号码相关设置*/
    [self.uiModel setNumberOffsetX:@0];
    [self.uiModel setNumberTextAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor, NSFontAttributeName:TEXT_MEDIUM(32)}];
    /**品牌logo 相关属性*/
    [self.uiModel setSloganTextColor:UIColor.whiteColor];
    [self.uiModel setBrandLabelTextSize:TEXT_FONT_12];
    [self.uiModel setSloganHidden:NO];
    self.uiModel.appLanguageType = AuthLanguageSimplifiedChinese;
    /**登录按钮相关*/
    [self.uiModel setLogBtnText: [[NSAttributedString alloc]initWithString:@"本机号码一键登录" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:TEXT_FONT_18}]];
    self.uiModel.logBtnOriginLR = @[@(SCALES(28)), @(SCALES(28))];
    [self.uiModel setLogBtnHeight:SCALES(50)];
    [self.uiModel setLoginBtnImgs:@[[UIImage imageNamed:@"button_bg"],
                                    [UIImage imageNamed:@"button_bg"],
                                    [UIImage imageNamed:@"button_bg"]]];
    /**底部协议复选框设置*/
    [self.uiModel setCheckBoxWH:SCALES(14)];//修改隐私复选框的大小，联通和移动可用
    [self.uiModel setCheckboxOffsetX:@(SCALES(36))];//屏幕左边缘
    [self.uiModel setCheckedImg:[UIImage imageNamed:@"login_agree"]];
    [self.uiModel setUncheckedImg:[UIImage imageNamed:@"login_agree1"]];
    [self.uiModel setPrivacyState:NO];//协议是否勾选
    //****想登录按钮始终可点击 就用下面方法，可在未勾选隐私协议的时候进行二次弹窗，确认后继续登录
    /**忽略隐私条款check框状态，登陆按钮一直可点击 默认:NO(不忽略) */
    self.uiModel.ignorePrivacyState = YES;//始终允许点击一键登录按钮
    //当忽略隐私条款check框状态，登陆按钮一直可点击时，不需要抖动提示
    if (self.uiModel.ignorePrivacyState) {
        self.delegateVc.isChecked = NO;
        self.delegateVc.isPop = YES;
        [TXLoginOauthSDK setLoginDelegate:self.delegateVc];
    }
    /**底部协议相关设置*/
    NSString *pryStr = @"阅读并同意《用户协议》《隐私协议》和&&默认&&并使用本机号码登录";
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = SCALES(4);
    NSAttributedString *strappPrivacy = [[NSAttributedString alloc]initWithString:pryStr attributes:@{NSFontAttributeName:TEXT_FONT_13, NSForegroundColorAttributeName:UIColorRGB(0xBABAC0), NSParagraphStyleAttributeName:style}];
    NSAttributedString *str1 = [[NSAttributedString alloc]initWithString:@"《用户协议》" attributes:@{NSLinkAttributeName:[NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_UserProtocol]}];
    NSAttributedString *str2 = [[NSAttributedString alloc]initWithString:@"《隐私协议》" attributes:@{NSLinkAttributeName:[NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Privacy]}];
    [self.uiModel setAppPrivacyDemo:strappPrivacy];
    //隐私条款:数组对象
    self.uiModel.privacySymbol = YES;//隐私协议书名号，默认YES
    self.uiModel.appPrivacy = @[str1, str2];
    //隐私协议标签Y偏移量该控件底部（bottom）相对于屏幕（safeArea）底部（bottom）的距离
    self.uiModel.appPrivacyOriginLR = @[@(SCALES(51)),@(SCALES(36))];
    [self.uiModel setPrivacyColor: UIColor.whiteColor];
    /**隐私协议详情页面导航栏相关设置*/
    [self.uiModel setWebNavColor:[UIColor whiteColor]];
    [self.uiModel setWebNavTitleAttrs:@{NSForegroundColorAttributeName: TITLE_COLOR, NSFontAttributeName: TEXT_FONT_18}];
    [self.uiModel setWebNavReturnImg:[UIImage imageNamed:@"back"]];
    /**设置登录页面y轴位置（全屏模式下）*/
    CGFloat loginNumberY = SCALES(300) + SCALES(50);
    [self.uiModel setLogBtnOffsetY:loginNumberY - SCALES(12)];//登录按钮Y偏移量
    self.uiModel.privacyLabelOffsetY = loginNumberY - SCALES(80) - SCALES(52);//隐私协议标签Y偏移量该控件底部（bottom）相对于屏幕（safeArea）底部（bottom）的距离
    [self.uiModel setCheckboxOffsetY_B:@(loginNumberY - SCALES(80) - SCALES(52) + SCALES(20))];//屏幕底部
    [self.uiModel setTxMobliNumberOffsetY:@(loginNumberY + SCALES(50) + SCALES(36))];/**移动卡号码栏Y偏移量*/
    [self.uiModel setSloganLabelOffsetY:loginNumberY + SCALES(30) + TAB_BAR_MAGIN];//品牌logo图片及标签的Y偏移量
    /**登录页面背景图设置*/
    [self.uiModel setViewBackImg:[UIImage imageNamed:@"login_bg"]];
    /**其他登录方式view*/
    [self.uiModel setIfCreateCustomView:YES];
    [self.uiModel setPresentAnimated:NO];
    UIButton *weChatBtn = [self setWeChatLoginWithframe:CGRectMake(SCALES(28), SCREEN_HEIGHT - self.uiModel.logBtnOffsetY + SCALES(15), SCREEN_WIDTH - SCALES(56), SCALES(50))];
    UIButton *serviceBtn = [self setServiceWithframe:CGRectMake(SCREEN_WIDTH - SCALES(122), STATUS_BAR_HEIGHT, SCALES(100), 44)];
    ASLoginOtherView *otherView = [[ASLoginOtherView alloc] init];
    otherView.frame = CGRectMake(SCREEN_WIDTH/2 - SCALES(120), SCREEN_HEIGHT - TAB_BAR_MAGIN - SCALES(130), SCALES(240), SCALES(130));
    otherView.type = kPhoneType;
    kWeakSelf(self);
    otherView.actionBlock = ^(NSString * _Nonnull indexName) {
        if ([indexName isEqualToString:@"手机号登录"]) {
            [wself phoneLoginVc];
            return;
        }
    };
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(0, HEIGHT_NAVBAR + SCALES(72) + SCALES(78) + SCALES(16), SCREEN_WIDTH, SCALES(25));
    nameLabel.font = TEXT_MEDIUM(18);
    nameLabel.text = @"心 聊 想 伴";
    nameLabel.textColor = UIColor.whiteColor;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.uiModel setCustomOtherLoginViews:@[weChatBtn, nameLabel, serviceBtn, otherView]];
    return self.uiModel;
}

#pragma mark - TX一键登录样式，绑定手机号
- (TXLoginUIModel *)loginBindUIWithUser:(ASUserInfoModel *)user {
    kWeakSelf(self);
    self.bindModel = [[TXLoginUIModel alloc] init];
    /**状态栏设置*/
    self.bindModel.statusBarStyle = UIStatusBarStyleDefault;
    self.bindModel.logoHidden = YES;
    /**手机号码相关设置*/
    [self.bindModel setNumberOffsetX:@0];
    [self.bindModel setNumberTextAttributes:@{NSForegroundColorAttributeName:TITLE_COLOR, NSFontAttributeName:TEXT_MEDIUM(32)}];
    [self.bindModel setSloganTextColor:TITLE_COLOR];
    [self.bindModel setBrandLabelTextSize:TEXT_FONT_12];
    [self.bindModel setSloganHidden:NO];
    self.bindModel.appLanguageType = AuthLanguageSimplifiedChinese;
    /**登录按钮相关*/
    [self.bindModel setLogBtnText: [[NSAttributedString alloc]initWithString:@"本机号码一键登录" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:TEXT_FONT_18}]];
    self.bindModel.logBtnOriginLR = @[@(SCALES(32)), @(SCALES(32))];
    [self.bindModel setLogBtnHeight:SCALES(50)];
    [self.bindModel setLoginBtnImgs:@[[UIImage imageNamed:@"button_bg"],
                                      [UIImage imageNamed:@"button_bg"],
                                      [UIImage imageNamed:@"button_bg"]]];
    /**底部协议复选框设置*/
    [self.bindModel setCheckBoxWH:SCALES(14)];//修改隐私复选框的大小，联通和移动可用
    [self.bindModel setCheckboxOffsetX:@(SCALES(36))];//屏幕左边缘
    [self.bindModel setCheckedImg:[UIImage imageNamed:@"login_agree"]];
    [self.bindModel setUncheckedImg:[UIImage imageNamed:@"login_agree2"]];
    [self.bindModel setPrivacyState:NO];//协议是否勾选
    /**隐私协议详情页面导航栏相关设置*/
    [self.bindModel setWebNavColor:[UIColor whiteColor]];
    [self.bindModel setWebNavTitleAttrs:@{NSForegroundColorAttributeName: TITLE_COLOR, NSFontAttributeName: TEXT_FONT_18}];
    [self.bindModel setWebNavReturnImg:[UIImage imageNamed:@"back"]];
    //****想登录按钮始终可点击 就用下面方法，可在未勾选隐私协议的时候进行二次弹窗，确认后继续登录
    /**忽略隐私条款check框状态，登陆按钮一直可点击 默认:NO(不忽略) */
    self.bindModel.ignorePrivacyState = YES;//始终允许点击一键登录按钮
    //当忽略隐私条款check框状态，登陆按钮一直可点击时，不需要抖动提示
    if (self.bindModel.ignorePrivacyState) {
        self.delegateVc.isChecked = NO;
        self.delegateVc.isPop = NO;
        [TXLoginOauthSDK setLoginDelegate:self.delegateVc];
    }
    /**底部协议相关设置*/
    NSString *pryStr = @"我已阅读并同意&&默认&&";
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    NSAttributedString *strappPrivacy = [[NSAttributedString alloc]initWithString:pryStr attributes:@{NSFontAttributeName:TEXT_FONT_13, NSForegroundColorAttributeName:TITLE_COLOR, NSParagraphStyleAttributeName:style}];
    [self.bindModel setAppPrivacyDemo:strappPrivacy];
    //隐私条款:数组对象
    self.bindModel.privacySymbol = YES;//隐私协议书名号，默认YES
    //隐私协议标签Y偏移量该控件底部（bottom）相对于屏幕（safeArea）底部（bottom）的距离
    self.bindModel.appPrivacyOriginLR = @[@(SCALES(51)),@(SCALES(36))];
    [self.bindModel setPresentAnimated:NO];//弹出是否动画
    [self.bindModel setPrivacyColor: MAIN_COLOR];
    /**设置登录页面y轴位置（全屏模式下）*/
    CGFloat loginNumberY = SCALES(300) + SCALES(50);
    [self.bindModel setLogBtnOffsetY:loginNumberY - SCALES(12)];//登录按钮Y偏移量
    self.bindModel.privacyLabelOffsetY = loginNumberY - SCALES(200) + SCALES(20);//隐私协议标签Y偏移量该控件底部（bottom）相对于屏幕（safeArea）底部（bottom）的距离
    [self.bindModel setCheckboxOffsetY_B:@(loginNumberY - SCALES(200) + SCALES(20))];//屏幕底部
    [self.bindModel setTxMobliNumberOffsetY:@(loginNumberY + SCALES(70) + SCALES(36))];/**移动卡号码栏Y偏移量*/
    [self.bindModel setSloganLabelOffsetY:loginNumberY + SCALES(50) + TAB_BAR_MAGIN];//品牌logo图片及标签的Y偏移量
    /**其他登录方式view*/
    [self.bindModel setIfCreateCustomView:YES];
    UIButton *phoneBtn = [self setPhoneBtnWithframe:CGRectMake(SCREEN_WIDTH/2 - SCALES(65), SCREEN_HEIGHT - self.bindModel.logBtnOffsetY + SCALES(15), SCALES(130), SCALES(20)) user:user vc:nil isPopWindow:NO close:^{
        
    }];
    UIButton *skipBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    skipBtn.frame = CGRectMake(SCREEN_WIDTH - 64, STATUS_BAR_HEIGHT, 44, 44);
    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    skipBtn.titleLabel.font = TEXT_MEDIUM(15);
    [skipBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    skipBtn.hidden = user.gender == 2 ? NO : YES;
    [[skipBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[ASLoginManager shared] loginSuccess];
    }];
    UIButton *backBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    backBtn.frame = CGRectMake(12, STATUS_BAR_HEIGHT, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.hidden = user.gender == 1 ? NO : YES;
    [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wself TX_LoginPushFailDispose:NO actionBlock:^{ }];
    }];
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, HEIGHT_NAVBAR + SCALES(50), SCREEN_WIDTH, SCALES(34));
    title.font = TEXT_MEDIUM(22);
    title.text = @"绑定手机号";
    title.textColor = TITLE_COLOR;
    title.textAlignment = NSTextAlignmentCenter;
    UILabel *hintText = [[UILabel alloc] init];
    hintText.frame = CGRectMake(0, HEIGHT_NAVBAR + SCALES(40) + SCALES(34) + SCALES(12), SCREEN_WIDTH, SCALES(18));
    hintText.font = TEXT_FONT_12;
    hintText.text = @"根据国家政策及法律规定，发言等功能需绑定手机号";
    hintText.textColor = TEXT_SIMPLE_COLOR;
    hintText.textAlignment = NSTextAlignmentCenter;
    self.agreementHintIcon.frame = CGRectMake(SCALES(36), (SCREEN_HEIGHT - self.bindModel.privacyLabelOffsetY) - SCALES(48), SCALES(160), SCALES(24));
    [self.bindModel setCustomOtherLoginViews:@[title, hintText, phoneBtn, skipBtn, self.agreementHintIcon, backBtn]];
    return self.bindModel;
}

- (TXLoginUIModel *)bindPopViewUIWithIsPopWindow:(BOOL)isPopWindow vc:(UIViewController *)vc close:(VoidBlock)close {
    self.windowBindModel = [[TXLoginUIModel alloc] init];
    /**状态栏设置*/
    self.windowBindModel.logoHidden = YES;
    self.windowBindModel.authWindow = YES;
    self.windowBindModel.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.windowBindModel.cornerRadius = SCALES(16);
    self.windowBindModel.scaleW = SCALES(311)/SCREEN_WIDTH;
    self.windowBindModel.scaleH = SCALES(470)/SCREEN_HEIGHT;
    /**手机号码相关设置*/
    [self.windowBindModel setNumberOffsetX:@0];
    [self.windowBindModel setNumberTextAttributes:@{NSForegroundColorAttributeName:TITLE_COLOR, NSFontAttributeName:TEXT_MEDIUM(20)}];
    [self.windowBindModel setSloganHidden:YES];
    self.windowBindModel.appLanguageType = AuthLanguageSimplifiedChinese;
    /**登录按钮相关*/
    [self.windowBindModel setLogBtnText: [[NSAttributedString alloc]initWithString:@"立即绑定" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:TEXT_FONT_18}]];
    self.windowBindModel.logBtnOriginLR = @[@(SCALES(32)), @(SCALES(32))];
    [self.windowBindModel setLogBtnHeight:SCALES(48)];
    [self.windowBindModel setLoginBtnImgs:@[[UIImage imageNamed:@"bind_btn_bg"],
                                            [UIImage imageNamed:@"bind_btn_bg"],
                                            [UIImage imageNamed:@"bind_btn_bg"]]];
    /**底部协议复选框设置*/
    [self.windowBindModel setCheckBoxWH:SCALES(14)];//修改隐私复选框的大小，联通和移动可用
    [self.windowBindModel setCheckboxOffsetX:@(SCALES(21))];//屏幕左边缘
    [self.windowBindModel setCheckedImg:[UIImage imageNamed:@"login_agree"]];
    [self.windowBindModel setUncheckedImg:[UIImage imageNamed:@"login_agree2"]];
    [self.windowBindModel setPrivacyState:NO];//协议是否勾选
    /**隐私协议详情页面导航栏相关设置*/
    [self.windowBindModel setWebNavColor:[UIColor whiteColor]];
    [self.windowBindModel setWebNavTitleAttrs:@{NSForegroundColorAttributeName: TITLE_COLOR, NSFontAttributeName: TEXT_FONT_18}];
    [self.windowBindModel setWebNavReturnImg:[UIImage imageNamed:@"back"]];
    //****想登录按钮始终可点击 就用下面方法，可在未勾选隐私协议的时候进行二次弹窗，确认后继续登录
    /**忽略隐私条款check框状态，登陆按钮一直可点击 默认:NO(不忽略) */
    self.windowBindModel.ignorePrivacyState = YES;//始终允许点击一键登录按钮
    //当忽略隐私条款check框状态，登陆按钮一直可点击时，不需要抖动提示
    if (self.windowBindModel.ignorePrivacyState) {
        self.delegateVc.isChecked = NO;
        self.delegateVc.isPop = NO;
        [TXLoginOauthSDK setLoginDelegate:self.delegateVc];
    }
    /**底部协议相关设置*/
    NSString *pryStr = @"我已阅读并同意&&默认&&";
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    NSAttributedString *strappPrivacy = [[NSAttributedString alloc]initWithString:pryStr attributes:@{NSFontAttributeName:TEXT_FONT_12, NSForegroundColorAttributeName:TITLE_COLOR, NSParagraphStyleAttributeName:style}];
    [self.windowBindModel setAppPrivacyDemo:strappPrivacy];
    //隐私条款:数组对象
    self.windowBindModel.privacySymbol = YES;//隐私协议书名号，默认YES
    //隐私协议标签Y偏移量该控件底部（bottom）相对于屏幕（safeArea）底部（bottom）的距离
    self.windowBindModel.appPrivacyOriginLR = @[@(SCALES(36)),@(SCALES(21))];
    [self.windowBindModel setPresentAnimated:NO];//弹出是否动画
    [self.windowBindModel setPrivacyColor: MAIN_COLOR];
    /**设置登录页面y轴位置（全屏模式下）*/
    [self.windowBindModel setLogBtnOffsetY:SCALES(144)];//登录按钮Y偏移量
    self.windowBindModel.privacyLabelOffsetY = SCALES(46);//隐私协议标签Y偏移量该控件底部（bottom）相对于屏幕（safeArea）底部（bottom）的距离
    [self.windowBindModel setCheckboxOffsetY_B:@(SCALES(46))];//屏幕底部
    [self.windowBindModel setTxMobliNumberOffsetY:@(SCALES(210))];/**移动卡号码栏Y偏移量*/
    /**其他登录方式view*/
    [self.windowBindModel setIfCreateCustomView:YES];
    UIButton *closeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(SCALES(277), SCALES(10), SCALES(24), SCALES(24));
    closeBtn.adjustsImageWhenHighlighted = NO;
    [closeBtn setImage:[UIImage imageNamed:@"close2"] forState:UIControlStateNormal];
    [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [TXLoginOauthSDK dismissViewControllerAnimated:NO completion:^{
            close();
        }];
    }];
    UIImageView *top = [[UIImageView alloc] init];
    top.frame = CGRectMake(SCALES(311)/2 - SCALES(66), SCALES(16), SCALES(132), SCALES(92));
    top.image = [UIImage imageNamed:@"bind_top"];
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, SCALES(123), SCALES(311), SCALES(24));
    title.font = TEXT_MEDIUM(18);
    title.text = @"绑定手机号";
    title.textColor = TITLE_COLOR;
    title.textAlignment = NSTextAlignmentCenter;
    UILabel *hintText = [[UILabel alloc] init];
    hintText.frame = CGRectMake(SCALES(20), SCALES(157), SCALES(311) - SCALES(40), SCALES(72));
    hintText.font = TEXT_FONT_14;
    hintText.attributedText = [ASCommonFunc attributedWithString:@"根据国家政策及法律规定，为保障您的账号安全丢失及找回，建议您绑定手机号码，绑定后支持手机号快捷登录" lineSpacing:SCALES(4)];
    hintText.textColor = UIColorRGB(0x333333);
    hintText.numberOfLines = 0;
    hintText.textAlignment = NSTextAlignmentCenter;
    UILabel *bottomText = [[UILabel alloc] init];
    bottomText.frame = CGRectMake(0, SCALES(435), SCALES(311), SCALES(16));
    bottomText.font = TEXT_FONT_12;
    bottomText.text = @"*我们不会公开您的手机号，仅用于账号验证与通知";
    bottomText.textColor = TEXT_SIMPLE_COLOR;
    bottomText.textAlignment = NSTextAlignmentCenter;
    UIButton *phoneBtn = [self setPhoneBtnWithframe:CGRectMake(SCALES(311)/2 - SCALES(65), SCALES(332), SCALES(130), SCALES(20)) user:nil vc:vc isPopWindow:isPopWindow close:^{
        close();
    }];
    self.agreementHintIcon.frame = CGRectMake(SCALES(21), SCALES(375), SCALES(160), SCALES(24));
    [self.windowBindModel setCustomOtherLoginViews:@[top, title, hintText, self.agreementHintIcon, phoneBtn, bottomText, closeBtn]];
    return self.windowBindModel;
}

- (UIButton *)setWeChatLoginWithframe:(CGRect)frame {
    kWeakSelf(self);
    UIButton *button = [[UIButton alloc]init];
    button.frame = frame;
    [button setTitle:@" 微信登录" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"login_wechat"] forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_18;
    [button setBackgroundColor:UIColorRGB(0x24DB5A)];
    button.adjustsImageWhenHighlighted = NO;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = SCALES(25);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (wself.delegateVc.isChecked == YES) {
            [wself weChatLogin];
        } else {
            NSMutableAttributedString *attributedString = [ASTextAttributedManager userProtocolPopAgreement:^{
                ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];//用户协议
                vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_UserProtocol];
                ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = UIModalPresentationPageSheet;
                [[ASCommonFunc currentVc] presentViewController:nav animated:YES completion:nil];
            } privacyProtocol:^{
                ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];//隐私协议
                vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Privacy];
                ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = UIModalPresentationPageSheet;
                [[ASCommonFunc currentVc] presentViewController:nav animated:YES completion:nil];
            }];
            [ASAlertViewManager protocolPopTitle:@"用户协议和隐私政策"
                                      cancelText:@"不同意并退出"
                                      cancelFont:TEXT_FONT_15
                            dismissOnMaskTouched:NO
                                      attributed:attributedString
                                    affirmAction:^{
                wself.delegateVc.isChecked = YES;
                [wself weChatLogin];
            } cancelAction:^{
                ASLog(@"-----不同意协议---");
            }];
        }
    }];
    return button;
}

- (UIButton *)setServiceWithframe:(CGRect)frame {
    kWeakSelf(self);
    UIButton *button = [[UIButton alloc]init];
    button.frame = frame;
    [button setTitle:@" 在线客服" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"login_service"] forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_15;
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wself chatService];
    }];
    return button;
}

//如果user数据不为空表示的是登录的手机号绑定，为空表示设置页的手机号绑定
- (UIButton *)setPhoneBtnWithframe:(CGRect)frame user:(ASUserInfoModel *)user vc:(UIViewController *)vc isPopWindow:(BOOL)isPopWindow close:(VoidBlock)close{
    kWeakSelf(self);
    CustomButton *button = [[CustomButton alloc]init];
    button.frame = frame;
    [button setTitle:@"绑定其他手机号 " forState:UIControlStateNormal];
    if (kObjectIsEmpty(user)) {
        [button setImage:[UIImage imageNamed:@"cell_back"] forState:UIControlStateNormal];
        [button setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
    } else {
        [button setImage:[UIImage imageNamed:@"cell_back2"] forState:UIControlStateNormal];
        [button setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    }
    button.titleLabel.font = TEXT_FONT_15;
    button.adjustsImageWhenHighlighted = NO;
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (kObjectIsEmpty(user)) {
            [TXLoginOauthSDK dismissViewControllerAnimated:NO completion:^{
                ASLoginBindPhoneController *bindVc = [[ASLoginBindPhoneController alloc] init];//需要处理modal出来的页面无法跳转的问题
                [vc.navigationController pushViewController:bindVc animated:YES];
            }];
        } else {
            [wself TXLoginBindPhoneWithUser:user];
        }
    }];
    return button;
}
@end
