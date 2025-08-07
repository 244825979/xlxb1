//
//  ASBaseWebViewController.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASBaseWebViewController.h"
#import <WebKit/WebKit.h>
#import <UMShare/UMShare.h>
#import "ASMineRequest.h"
#import "ASEditDataController.h"
#import "ASAuthHomeController.h"
#import "ASWithdrawChangeHomeController.h"
#import "ASWebJsBodyModel.h"
#import "ASSetBindViewController.h"

@interface ASBaseWebViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIView *noticeConsentView;//须知同意view
@end

@implementation ASBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.allowsInlineMediaPlayback = YES;
    configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeAll;
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    //cookies参数
    NSMutableDictionary* dicts = [NSMutableDictionary dictionary];
    [dicts setValue:STRING(USER_INFO.token) forKey:@"accessToken"];
    [dicts setValue:STRING(kAppVersion) forKey:@"appVersion"];
    [dicts setValue:kAppBundleID forKey:@"packageName"];
    [dicts setValue:@(kAppType) forKey:@"mtype"];//环境
    NSMutableString *cookie = [NSMutableString stringWithFormat:@""];
    for (NSString * key in dicts) {
        [cookie appendFormat:@"document.cookie = '%@=%@';\n",key, dicts[key]];
    }
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    [userContentController addScriptMessageHandler:self name:@"openMainActivity"];//js注入监听
    [userContentController addScriptMessageHandler:self name:@"openUserDetail"];
    [userContentController addScriptMessageHandler:self name:@"openActivity"];
    [userContentController addScriptMessageHandler:self name:@"showPosterDialog"];
    [userContentController addScriptMessageHandler:self name:@"showNewShareDialog"];
    [userContentController addScriptMessageHandler:self name:@"copyInviteCode"];
    [userContentController addScriptMessageHandler:self name:@"showShareAndPosterDialog"];//邀请好友事件
    configuration.userContentController = userContentController;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    self.webView.navigationDelegate = self;
    self.webView.opaque = NO;
    self.webView.multipleTouchEnabled = YES;
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:self.webView];
    self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.height - HEIGHT_NAVBAR);
    [self.view addSubview:self.progressView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)setWebUrl:(NSString *)webUrl {
    _webUrl = webUrl;
}

- (void)setNotifylogID:(NSString *)notifylogID {
    _notifylogID = notifylogID;
    if (!kStringIsEmpty(notifylogID) && notifylogID.integerValue != 0) {
        [self.view addSubview:self.noticeConsentView];
        [self.noticeConsentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(SCALES(84) + TAB_BAR_MAGIN);
        }];
    }
}

- (void)setShowNavigationTitle:(NSString *)showNavigationTitle {
    _showNavigationTitle = showNavigationTitle;
    if (!kStringIsEmpty(showNavigationTitle)) {
        self.progressView.hidden = YES;
        kWeakSelf(self);
        UIButton *back = [UIButton buttonWithType: UIButtonTypeCustom];
        [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [[back rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [wself.navigationController popViewControllerAnimated:YES];
        }];
        [self.view addSubview:back];
        back.frame = CGRectMake(12, STATUS_BAR_HEIGHT, 44, 44);
        UILabel *title = [[UILabel alloc]init];
        title.text = STRING(showNavigationTitle);
        title.textColor = TITLE_COLOR;
        title.font = TEXT_MEDIUM(18);
        title.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(back);
        }];
        self.webView.frame = CGRectMake(0, HEIGHT_NAVBAR, SCREEN_WIDTH, self.view.height - HEIGHT_NAVBAR);
    }
}

#pragma mark - WKNavigationDelegate method
// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:^(BOOL success) {
            
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    ASLog(@"-------------message.body = %@ name = %@",message.body, message.name);
    if ([message.name caseInsensitiveCompare:@"openMainActivity"] == NSOrderedSame) {
        NSDictionary *body = message.body;
        NSString *type = body[@"type"];
        if ([type isEqualToString:@"main"]) {//跳转到首页
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:NO];
            return;
        }
        if ([type isEqualToString:@"dynamic"]) {//跳转到动态列表
            self.tabBarController.selectedIndex = 1;
            [self.navigationController popToRootViewControllerAnimated:NO];
            return;
        }
        if ([type isEqualToString:@"videoshow"]) {//跳转视频秀主页
            self.tabBarController.selectedIndex = 2;
            [self.navigationController popToRootViewControllerAnimated:NO];
            return;
        }
        if ([type isEqualToString:@"message"]) {//跳转消息主页
            self.tabBarController.selectedIndex = 3;
            [self.navigationController popToRootViewControllerAnimated:NO];
            return;
        }
        if ([type isEqualToString:@"my"]) {//跳转我的主页
            self.tabBarController.selectedIndex = 4;
            [self.navigationController popToRootViewControllerAnimated:NO];
            return;
        }
    } else if ([message.name caseInsensitiveCompare:@"openActivity"] == NSOrderedSame) {
        NSDictionary *body = message.body;
        NSString *linkType = body[@"linkType"];
        NSString *linkUrl = body[@"linkUrl"];
        if (linkType.integerValue == 2) {
            if ([linkUrl isEqualToString:@"infoEdit"]) {//完善资料
                ASEditDataController *vc = [[ASEditDataController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            if ([linkUrl isEqualToString:@"auth"]) {//认证页面
                ASAuthHomeController *vc = [[ASAuthHomeController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            if ([linkUrl isEqualToString:@"main"]) {//退出关闭当前页面
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            if ([linkUrl isEqualToString:@"accountVerify"]) {
                BOOL isInclude = NO;
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[ASWithdrawChangeHomeController class]]) {
                        isInclude = YES;
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
                if (isInclude == NO) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                return;
            }
            if ([linkUrl isEqualToString:@"authSuccess"]) {//实名认证成功
                USER_INFO.is_auth = 2;
                [ASUserDefaults setValue:@2 forKey:@"userinfo_is_auth"];
                BOOL isInclude = NO;
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[ASAuthHomeController class]]) {
                        isInclude = YES;
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
                if (isInclude == NO) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                return;
            }
            if ([linkUrl isEqualToString:@"authFail"]) {//实名认证失败
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            if ([linkUrl isEqualToString:@"verifySuccess"]) {//真人认证成功
                USER_INFO.is_rp_auth = 2;
                [ASUserDefaults setValue:@2 forKey:@"userinfo_is_rp_auth"];
                BOOL isInclude = NO;
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[ASAuthHomeController class]]) {
                        isInclude = YES;
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
                if (isInclude == NO) {
                    //首次进行真人认证，去首页
                    if (self.backBlock) {
                        self.backBlock();
                    }
                }
                return;
            }
            if ([linkUrl isEqualToString:@"verifyFail"]) {//真人认证失败
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            if ([linkUrl isEqualToString:@"matchSuccess"]) {//真人比对成功
                [self.navigationController popViewControllerAnimated:YES];
                //真人比对成功
                if (self.backBlock) {
                    self.backBlock();
                }
                return;
            }
            if ([linkUrl isEqualToString:@"matchFail"]) {//真人比对失败
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            if ([linkUrl isEqualToString:@"withdraw"]) {//提现页
                BOOL isInclude = NO;
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[ASWithdrawChangeHomeController class]]) {
                        isInclude = YES;
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
                if (isInclude == NO) {
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    ASWithdrawChangeHomeController *vc = [[ASWithdrawChangeHomeController alloc] init];
                    [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                }
                return;
            }
            if ([linkUrl isEqualToString:@"accountBind"]) {
                ASSetBindViewController *vc = [[ASSetBindViewController alloc] init];
                [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                return;
            }
        }
    } else if ([message.name caseInsensitiveCompare:@"openUserDetail"] == NSOrderedSame) {//根据id进入个人主页
        NSDictionary *body = message.body;
        NSNumber *userId = body[@"userId"];
        NSNumber *type = body[@"type"];
        if (type.integerValue == 1) {
            [ASMyAppCommonFunc goPersonalHomeWithUserID:[NSString stringWithFormat:@"%@",userId] viewController:self action:^(id  _Nonnull data) {
            }];
        }
    } else if ([message.name caseInsensitiveCompare:@"showShareAndPosterDialog"] == NSOrderedSame) {//邀请好友分享
        ASWebJsBodyModel *bodyModel = [ASWebJsBodyModel mj_objectWithKeyValues:message.body];
        [ASAlertViewManager popUMShareViewWithBody:bodyModel action:^(UMSocialPlatformType platformType, id  _Nonnull value) {
            if (platformType == UMSocialPlatformType_UserDefine_Begin) {//点击海报
                [ASAlertViewManager popInvitePosterViewWithBody:bodyModel affirmAction:^{
                    
                }];
                return;
            }
            if (![[UMSocialManager defaultManager] isInstall:platformType]) {
                if (platformType == UMSocialPlatformType_WechatSession || platformType == UMSocialPlatformType_WechatTimeLine) {
                    kShowToast(@"请先安装微信");
                    return;
                }
            }
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                //异步下载
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:STRING(bodyModel.shareData.thumbUrl)]];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    //创建网页内容对象
                    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:STRING(bodyModel.shareData.title) descr:STRING(bodyModel.shareData.des) thumImage:imageData];
                    //设置网页地址
                    shareObject.webpageUrl = STRING(bodyModel.shareData.linkUrl);
                    //分享消息对象设置分享内容对象
                    messageObject.shareObject = shareObject;
                    //调用分享接口
                    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                        if (error) {
                            ASLog(@"************分享失败 %@*********",error);
                        } else {
                            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                                UMSocialShareResponse *resp = data;
                                //分享结果消息
                                ASLog(@"************分享成功 %@*********",resp.message);
                            } else {
                                ASLog(@"response data is %@",data);
                            }
                        }
                    }];
                });
            });
        }];
    } else if ([message.name caseInsensitiveCompare:@"copyInviteCode"] == NSOrderedSame) {//分享海报
        NSDictionary *body = message.body;
        NSString *inviteCode = body[@"inviteCode"];
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        pab.string = STRING(inviteCode);
        if (pab == nil) {
            kShowToast(@"复制失败");
        } else {
            kShowToast(@"复制成功");
        }
    }
}

#pragma mark - event response
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.progressView.alpha = 1.0f;
        [self.progressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                self.progressView.alpha = 0.0f;
            }
                             completion:^(BOOL finished) {
                [self.progressView setProgress:0 animated:NO];
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {//部分页面进行自定义title处理
        if (object == self.webView) {
            if ([self.webUrl containsString:USER_INFO.systemIndexModel.faceAuth]) {
                self.titleText = @"实名认证";
                return;
            }
            if ([self.webUrl containsString:USER_INFO.systemIndexModel.verifyAuth]) {
                self.titleText = @"真人认证";
                return;
            }
            if ([self.webUrl containsString:USER_INFO.systemIndexModel.matchAuth]) {
                self.titleText = @"真人核验";
                return;
            }
            self.titleText = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - getter and setter
- (UIProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (UIView *)noticeConsentView {
    if (!_noticeConsentView) {
        _noticeConsentView = [[UIView alloc]init];
        _noticeConsentView.backgroundColor = UIColor.whiteColor;
        UIButton *affirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noticeConsentView addSubview:affirmBtn];
        kWeakSelf(self);
        affirmBtn.titleLabel.font = TEXT_MEDIUM(18);
        [affirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        affirmBtn.adjustsImageWhenHighlighted = NO;//去掉点击效果
        [affirmBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
        [affirmBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateSelected];
        [affirmBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        [affirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        affirmBtn.layer.masksToBounds = YES;
        affirmBtn.selected = NO;
        affirmBtn.layer.cornerRadius = SCALES(24.5);
        UIButton *agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [agreementButton setImage:[UIImage imageNamed:@"potocol1"] forState:UIControlStateNormal];
        [agreementButton setImage:[UIImage imageNamed:@"potocol"] forState:UIControlStateSelected];
        agreementButton.adjustsImageWhenHighlighted = NO;
        agreementButton.selected = NO;
        [[agreementButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            agreementButton.selected = !agreementButton.selected;
            affirmBtn.selected = !affirmBtn.selected;
        }];
        [_noticeConsentView addSubview:agreementButton];
        UILabel *agreementView = [[UILabel alloc] init];
        agreementView.text = @"已阅读并同意以上内容";
        agreementView.numberOfLines = 0;
        agreementView.font = TEXT_FONT_13;
        agreementView.textColor = TEXT_SIMPLE_COLOR;
        [_noticeConsentView addSubview:agreementView];
        [agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_noticeConsentView).offset(SCALES(-6) - TAB_BAR_MAGIN);
            make.centerX.equalTo(_noticeConsentView).offset(SCALES(10));
        }];
        [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(agreementView.mas_left).offset(SCALES(2));
            make.size.mas_equalTo(CGSizeMake(SCALES(36), SCALES(36)));
            make.centerY.equalTo(agreementView);
        }];
        [[affirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (!agreementButton.isSelected) {
                kShowToast(@"请勾选协议");
                return;
            }
            [ASMineRequest requestNoticeAgreeWithID:wself.notifylogID success:^(id  _Nonnull response) {
                [wself.navigationController popToRootViewControllerAnimated:YES];
            } errorBack:^(NSInteger code, NSString * _Nonnull message) {
                
            }];
        }];
        [affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noticeConsentView);
            make.bottom.equalTo(agreementView.mas_top).offset(SCALES(-10));
            make.size.mas_equalTo(CGSizeMake(SCALES(235), SCALES(45)));
        }];
    }
    return _noticeConsentView;
}

// 记得取消监听
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end
