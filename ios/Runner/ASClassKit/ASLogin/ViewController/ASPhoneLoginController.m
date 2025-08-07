//
//  ASPhoneLoginController.m
//  AS
//
//  Created by SA on 2025/4/14.
//

#import "ASPhoneLoginController.h"
#import "ASLoginTextFileView.h"
#import "ASRegisterUserController.h"
#import "ASLoginOtherView.h"
#import "ASLoginBgView.h"
#import "ASVoiceCodeView.h"

@interface ASPhoneLoginController ()
@property (nonatomic, strong) ASLoginTextFileView *phoneTextField;
@property (nonatomic, strong) ASLoginTextFileView *enterOTPTextField;
@property (nonatomic, strong) UIButton *agreementBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) ASVoiceCodeView *voiceCodeView;
/**数据**/
@property (nonatomic, copy) NSString *phoneText;
@property (nonatomic, copy) NSString *codeText;
@property (nonatomic, assign) NSInteger codeSendCount;//发送验证码次数。数字验证码
@property (nonatomic, assign) BOOL isInputCode;//是否输入验证码
@end

@implementation ASPhoneLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    self.isInputCode = NO;
    [self createUI];
    [self setData];
}

- (void)createUI {
    kWeakSelf(self);
    ASLoginBgView *bgView = [[ASLoginBgView alloc] init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    ASLoginOtherView *otherView = [[ASLoginOtherView alloc] init];
    otherView.type = kWeChatType;
    [self.view addSubview:otherView];
    [otherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-TAB_BAR_MAGIN);
        make.size.mas_equalTo(CGSizeMake(SCALES(240), SCALES(130)));
    }];
    otherView.actionBlock = ^(NSString * _Nonnull indexName) {
        if ([indexName isEqualToString:@"微信登录"]) {
            [wself loginActionWithPhoneLogin:NO];
            return;
        }
    };
    [self.view addSubview:self.phoneTextField];
    CGFloat topHeight = kISiPhoneX ? STATUS_BAR_HEIGHT + SCALES(300) : STATUS_BAR_HEIGHT + SCALES(250);
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(32));
        make.right.offset(SCALES(-32));
        make.top.mas_equalTo(topHeight);
        make.height.mas_equalTo(SCALES(50));
    }];
    [self.view addSubview:self.enterOTPTextField];
    [self.enterOTPTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.phoneTextField);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(SCALES(20));
    }];
    if (USER_INFO.systemIndexModel.sms_fail_voice_tips == 1) {
        [self.view addSubview:self.voiceCodeView];
        [self.voiceCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view).offset(SCALES(-3));
            make.top.equalTo(self.enterOTPTextField.mas_bottom).offset(SCALES(10));
            make.size.mas_equalTo(CGSizeMake(SCALES(255), SCALES(24)));
        }];
    }
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.phoneTextField);
        make.top.equalTo(self.enterOTPTextField.mas_bottom).offset(USER_INFO.systemIndexModel.sms_fail_voice_tips == 1 ? SCALES(53) : SCALES(23));
    }];
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wself loginActionWithPhoneLogin:YES];
    }];
    YYLabel *agreementView = [[YYLabel alloc] init];
    agreementView.numberOfLines = 0;
    agreementView.attributedText = [ASTextAttributedManager loginHomeAgreement:^{
        wself.agreementBtn.selected = !wself.agreementBtn.selected;
    } serviceProtocol:^{//用户协议
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_UserProtocol];
        ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationPageSheet;
        [[ASCommonFunc currentVc] presentViewController:nav animated:YES completion:nil];
    } privacyProtocol:^{//隐私协议
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Privacy];
        ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationPageSheet;
        [[ASCommonFunc currentVc] presentViewController:nav animated:YES completion:nil];
    }];
    [self.view addSubview:agreementView];
    [agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(SCALES(18));
        make.left.equalTo(self.phoneTextField).offset(SCALES(22));
    }];
    [self.view addSubview:self.agreementBtn];
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(agreementView.mas_left).offset(SCALES(7));
        make.size.mas_equalTo(CGSizeMake(SCALES(36), SCALES(36)));
        make.centerY.equalTo(agreementView);
    }];
}

- (void)loginActionWithPhoneLogin:(BOOL)isPhoneLogin {
    kWeakSelf(self);
    [self.view endEditing:YES];
    //协议富文本
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
    if (self.agreementBtn.isSelected == YES) {
        if (isPhoneLogin == YES) {
            [self login];
        } else {
            [[ASLoginManager shared] weChatLogin];
        }
    } else {
        [ASAlertViewManager protocolPopTitle:@"用户协议和隐私政策"
                                  cancelText:@"不同意并退出"
                                  cancelFont:TEXT_FONT_15
                        dismissOnMaskTouched:NO
                                  attributed:attributedString
                                affirmAction:^{
            wself.agreementBtn.selected = YES;
            if (isPhoneLogin == YES) {
                [wself login];
            } else {
                [[ASLoginManager shared] weChatLogin];
            }
        } cancelAction:^{
            ASLog(@"-----不同意协议---");
        }];
    }
}

- (void)setData {
    NSString *inputPhone = [ASUserDefaults objectForKey:kLoginPhoneText];
    if (!kStringIsEmpty(inputPhone) && inputPhone.length == 11) {
        [self.phoneTextField.textField insertWhitSpaceInsertPosition:@[@(3), @(7)] replacementString:inputPhone textlength:12];
    }
#ifdef DEBUG
    self.phoneText = [ASCommonFunc removeCharWithString:inputPhone chars:@[@" "]];
    self.codeText = @"7777";
    self.enterOTPTextField.textField.text = @"7777";
    [self verifyButton];
#else
    
#endif
}

- (void)login {
    [self.view endEditing:YES];
    [ASUserDefaults setValue:STRING(self.phoneText) forKey:kLoginPhoneText];
    [ASMsgTool showLoading];
    kWeakSelf(self);
    [ASLoginRequest requestPhoneLoginWithPhone:self.phoneText code:self.codeText success:^(id  _Nullable data) {
        NSString *number = data;
        if (number.integerValue == 1) {
            ASRegisterUserController *vc = [[ASRegisterUserController alloc] init];
            vc.backBlock = ^{
                [[ASLoginManager shared] TX_LoginPushFailDispose:NO actionBlock:^{ }];
            };
            [wself.navigationController pushViewController:vc animated:YES];
        } else {
            [[ASLoginManager shared] loginSuccess];
        }
        [ASMsgTool hideMsg];
    } errorBack:^(NSInteger code, NSString *msg) {
        [ASMsgTool hideMsg];
    }];
}

- (void)verifyButton {
    if (self.phoneText.length != 11 || self.codeText.length < 4) {
        self.loginBtn.userInteractionEnabled = NO;
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"button_bg2"] forState:UIControlStateNormal];
    } else {
        self.loginBtn.userInteractionEnabled = YES;
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    }
}

- (ASLoginTextFileView *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField=[[ASLoginTextFileView alloc]init];
        _phoneTextField.textFieldType = kTextFieldPhone;
        kWeakSelf(self);
        _phoneTextField.inputBlock = ^(NSString * _Nonnull text) {
            wself.phoneText = [ASCommonFunc removeCharWithString:text chars:@[@" "]];
            [wself verifyButton];
        };
    }
    return _phoneTextField;
}

- (ASLoginTextFileView *)enterOTPTextField {
    if (!_enterOTPTextField) {
        _enterOTPTextField=[[ASLoginTextFileView alloc]init];
        _enterOTPTextField.textFieldType = kTextFieldEnterOTP;
        kWeakSelf(self);
        _enterOTPTextField.inputBlock = ^(NSString * _Nonnull text) {
            wself.codeText = text;
            wself.isInputCode = YES;
            [wself verifyButton];
        };
        _enterOTPTextField.enterOTPkBlock = ^(CodeButton * _Nonnull button) {
            if (wself.phoneText.length != 11) {
                kShowToast(@"请输入正确的手机号");
                return;
            }
            [ASLoginRequest requestSmsCodeWithPhone:wself.phoneText type:@"login" isVoice:NO success:^(id  _Nullable data) {
                wself.codeSendCount++;
                wself.enterOTPTextField.textField.placeholder = @"请输入验证码";
                button.enabled = NO;
                [button startCountDownWithSecond:60];
                [button countDownChanging:^NSString *(CodeButton *countDownButton, NSUInteger second) {
                    NSString *title = [NSString stringWithFormat:@"%lus",(unsigned long)second];
                    NSInteger timing = 60 - second;
                    //开启语音验证码功能，且发送验证码的次数已经达到了数量。进行计时，到时间弹出语音验证码发送提示
                    if (USER_INFO.systemIndexModel.sms_fail_voice_tips == 1 &&
                        wself.codeSendCount == USER_INFO.systemIndexModel.sms_fail_voice_retry_time &&
                        wself.isInputCode == NO &&
                        (timing == USER_INFO.systemIndexModel.sms_fail_voice_alert_seconds || (USER_INFO.systemIndexModel.sms_fail_voice_alert_seconds > 60 && timing == 60))) {
                        wself.voiceCodeView.hidden = NO;
                    }
                    //开启微信登录浮窗提醒功能，且发送验证码的次数已经达到了数量。进行计时，到时间弹出微信登录浮窗提示
                    if (USER_INFO.systemIndexModel.sms_fail_wechat_tips == 1 &&
                        wself.codeSendCount == USER_INFO.systemIndexModel.sms_fail_wechat_retry_time &&
                        wself.isInputCode == NO &&
                        (timing == USER_INFO.systemIndexModel.sms_fail_wechat_alert_seconds || (USER_INFO.systemIndexModel.sms_fail_wechat_alert_seconds > 60 && timing == 60))) {
                        //进行微信登录
                        [UIAlertController wechatLoginWithView:wself.view affirmAction:^{
                            [wself loginActionWithPhoneLogin:NO];
                        }];
                    }
                    return title;
                }];
                [button countDownFinished:^NSString *(CodeButton *countDownButton, NSUInteger second) {
                    button.enabled = YES;
                    return @"重新获取";
                }];
            } errorBack:^(NSInteger code, NSString *msg) {

            }];
        };
    }
    return _enterOTPTextField;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc]init];
        _loginBtn.adjustsImageWhenHighlighted = NO;
        _loginBtn.userInteractionEnabled = NO;
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"button_bg2"] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = TEXT_MEDIUM(18);
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = SCALES(25);
        [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    }
    return _loginBtn;
}

- (UIButton *)agreementBtn {
    if (!_agreementBtn) {
        _agreementBtn = [[UIButton alloc]init];
        [_agreementBtn setImage:[UIImage imageNamed:@"login_agree1"] forState:UIControlStateNormal];
        [_agreementBtn setImage:[UIImage imageNamed:@"login_agree"] forState:UIControlStateSelected];
        _agreementBtn.adjustsImageWhenHighlighted = NO;
        _agreementBtn.selected = NO;
        kWeakSelf(self);
        [[_agreementBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [wself.view endEditing:YES];
            wself.agreementBtn.selected = !wself.agreementBtn.selected;
        }];
    }
    return _agreementBtn;
}

- (ASVoiceCodeView *)voiceCodeView {
    if (!_voiceCodeView) {
        _voiceCodeView = [[ASVoiceCodeView alloc]init];
        _voiceCodeView.textLabel.textColor = UIColor.whiteColor;
        [_voiceCodeView.voiceBtn setImage:[UIImage imageNamed:@"login_voice1"] forState:UIControlStateNormal];
        [_voiceCodeView.voiceBtn setBackgroundColor:UIColorRGB(0xFD6E6A)];
        [_voiceCodeView.voiceBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _voiceCodeView.hidden = YES;
        kWeakSelf(self);
        _voiceCodeView.actionBlock = ^{
            if (wself.phoneText.length != 11) {
                kShowToast(@"请输入正确的手机号");
                return;
            }
            [ASLoginRequest requestSmsCodeWithPhone:wself.phoneText type:@"login" isVoice:YES success:^(id  _Nullable data) {
                [wself.voiceCodeView.voiceBtn setBackgroundColor:TEXT_SIMPLE_COLOR];
                wself.voiceCodeView.voiceBtn.userInteractionEnabled = NO;
                wself.enterOTPTextField.textField.placeholder = @"请输入语音验证码";
                wself.enterOTPTextField.sendOTP.enabled = NO;
                [wself.enterOTPTextField.sendOTP stopCountDown];//停止之前的倒计时
                [wself.enterOTPTextField.sendOTP startCountDownWithSecond:60];//重新倒计时60s
                [wself.enterOTPTextField.sendOTP countDownChanging:^NSString *(CodeButton *countDownButton, NSUInteger second) {
                    NSString *title = [NSString stringWithFormat:@"%lus",(unsigned long)second];
                    return title;
                }];
                [wself.enterOTPTextField.sendOTP countDownFinished:^NSString *(CodeButton *countDownButton, NSUInteger second) {
                    wself.enterOTPTextField.sendOTP.enabled = YES;
                    return @"重新获取";
                }];
                //弹窗提示
                [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"我们将以电话的方式告诉您验证码\n请注意接听" left:@"知道了" right:@"" affirmAction:^{
                    
                } cancelAction:^{
                    
                }];
            } errorBack:^(NSInteger code, NSString *msg) {

            }];
        };
    }
    return _voiceCodeView;
}
@end
