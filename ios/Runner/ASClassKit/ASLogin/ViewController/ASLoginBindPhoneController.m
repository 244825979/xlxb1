//
//  ASLoginBindPhoneController.m
//  AS
//
//  Created by SA on 2025/7/17.
//

#import "ASLoginBindPhoneController.h"
#import "ASBindPhoneTextView.h"
#import "ASVoiceCodeView.h"

@interface ASLoginBindPhoneController ()
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) ASBindPhoneTextView *phoneView;
@property (nonatomic, strong) ASBindPhoneTextView *codeView;
@property (nonatomic, strong) ASVoiceCodeView *voiceCodeView;
/**数据**/
@property (nonatomic, copy) NSString *phoneText;
@property (nonatomic, copy) NSString *codeText;
@property (nonatomic, assign) NSInteger codeSendCount;//发送验证码次数。数字验证码
@property (nonatomic, assign) BOOL isInputCode;//是否输入验证码
@end

@implementation ASLoginBindPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    self.isInputCode = NO;
    [self createUI];
}

- (void)createUI {
    kWeakSelf(self);
    UIButton *backBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.hidden = (self.userModel.gender == 1 || kObjectIsEmpty(self.userModel)) ? NO : YES;//男用户的绑定或者无用户数据传入的设置手机号绑定
    [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wself.view endEditing:YES];
        if (kObjectIsEmpty(wself.userModel)) {
            [wself.navigationController popViewControllerAnimated:YES];
        } else {
            [[ASLoginManager shared] TX_LoginPushFailDispose:NO actionBlock:^{ }];
        }
    }];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    UIButton *skipBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    skipBtn.titleLabel.font = TEXT_MEDIUM(15);
    [skipBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    skipBtn.hidden = self.userModel.gender == 2 ? NO : YES;
    [[skipBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wself.view endEditing:YES];
        [[ASLoginManager shared] loginSuccess];
    }];
    [self.view addSubview:skipBtn];
    [skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backBtn);
        make.right.offset(-12);
        make.size.mas_equalTo(CGSizeMake(50, 44));
    }];
    UILabel *title = [[UILabel alloc]init];
    title.text = @"绑定手机号";
    title.textColor = TITLE_COLOR;
    title.font = TEXT_MEDIUM(20);
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(HEIGHT_NAVBAR + SCALES(60));
        make.centerX.equalTo(self.view);
    }];
    UILabel *titleText = [[UILabel alloc]init];
    titleText.text = @"根据国家政策及法律规定，发言等功能需绑定手机号";
    titleText.textColor = TITLE_COLOR;
    titleText.font = TEXT_FONT_13;
    titleText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleText];
    [titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(SCALES(10));
        make.centerX.equalTo(self.view);
    }];
    [self.view addSubview:self.phoneView];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(32));
        make.right.offset(SCALES(-32));
        make.top.equalTo(titleText.mas_bottom).offset(SCALES(50));
        make.height.mas_equalTo(SCALES(54));
    }];
    [self.view addSubview:self.codeView];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.phoneView);
        make.top.equalTo(self.phoneView.mas_bottom).offset(SCALES(16));
    }];
    if (USER_INFO.systemIndexModel.sms_fail_voice_tips_bind == 1) {
        [self.view addSubview:self.voiceCodeView];
        [self.voiceCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view).offset(SCALES(-3));
            make.top.equalTo(self.codeView.mas_bottom).offset(SCALES(10));
            make.size.mas_equalTo(CGSizeMake(SCALES(255), SCALES(24)));
        }];
    }
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.codeView.mas_bottom).offset(SCALES(65));
        make.size.mas_equalTo(CGSizeMake(SCALES(247), SCALES(48)));
    }];
    [[self.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wself.view endEditing:YES];
        if (!kObjectIsEmpty(wself.userModel)) {
            [ASLoginRequest requestPhoneBindMobileWithMobile:wself.phoneText code:wself.codeText isRegister:YES success:^(id  _Nonnull response) {
                //绑定成功，进入到首页
                [[ASLoginManager shared] loginSuccess];
            } errorBack:^(NSInteger code, NSString * _Nonnull message) {
                
            }];
        } else {
            [ASLoginRequest requestPhoneBindMobileWithMobile:wself.phoneText code:wself.codeText isRegister:NO success:^(id  _Nonnull response) {
                //绑定成功，更新一下样式
                [wself.navigationController popViewControllerAnimated:YES];
                kShowToast(@"绑定成功，可直接用手机号码登录此账号");
            } errorBack:^(NSInteger code, NSString * _Nonnull message) {
                
            }];
        }
    }];
    UILabel *hintText = [[UILabel alloc] init];
    hintText.text = @"*绑定后支持手机号快捷登录，找回账号更方便";
    hintText.textColor = TEXT_SIMPLE_COLOR;
    hintText.font = TEXT_FONT_13;
    [self.view addSubview:hintText];
    [hintText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.submitBtn.mas_bottom).offset(SCALES(10));
        make.height.mas_equalTo(SCALES(16));
    }];
}

- (void)verifyButton {
    if (!kStringIsEmpty(self.phoneText) &&
        !kStringIsEmpty(self.codeText)) {
        self.submitBtn.userInteractionEnabled = YES;
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    } else {
        self.submitBtn.userInteractionEnabled = NO;
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"button_bg2"] forState:UIControlStateNormal];
    }
}

- (ASBindPhoneTextView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[ASBindPhoneTextView alloc]init];
        _phoneView.viewType = kTextViewPhone;
        kWeakSelf(self);
        _phoneView.inputBlock = ^(NSString * _Nonnull text) {
            wself.phoneText = [ASCommonFunc removeCharWithString:text chars:@[@" "]];
            [wself verifyButton];
        };
        _phoneView.enterOTPkBlock = ^(CodeButton * _Nonnull button) {
            if (wself.phoneText.length != 11) {
                kShowToast(@"请输入正确的手机号");
                return;
            }
            [ASLoginRequest requestSmsCodeWithPhone:wself.phoneText type:@"bind" isVoice:NO success:^(id  _Nullable data) {
                wself.codeSendCount++;
                button.enabled = NO;
                wself.codeView.textField.placeholder = @"请输入验证码";
                [button startCountDownWithSecond:60];
                [button countDownChanging:^NSString *(CodeButton *countDownButton, NSUInteger second) {
                    NSString *title = [NSString stringWithFormat:@"%lus",(unsigned long)second];
                    NSInteger timing = 60 - second;
                    //开启语音验证码功能，且发送验证码的次数已经达到了数量。进行计时，到时间弹出语音验证码发送提示
                    if (wself.codeSendCount == USER_INFO.systemIndexModel.sms_fail_voice_retry_time &&
                        USER_INFO.systemIndexModel.sms_fail_voice_tips_bind == 1 &&
                        wself.isInputCode == NO &&
                        (timing == USER_INFO.systemIndexModel.sms_fail_voice_alert_seconds || (USER_INFO.systemIndexModel.sms_fail_voice_alert_seconds > 60 && timing == 60))) {
                        wself.voiceCodeView.hidden = NO;
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
    return _phoneView;
}

- (ASBindPhoneTextView *)codeView {
    if (!_codeView) {
        _codeView = [[ASBindPhoneTextView alloc]init];
        _codeView.viewType = kTextViewCode;
        kWeakSelf(self);
        _codeView.inputBlock = ^(NSString * _Nonnull text) {
            wself.codeText = text;
            wself.isInputCode = YES;
            [wself verifyButton];
        };
    }
    return _codeView;
}

- (ASVoiceCodeView *)voiceCodeView {
    if (!_voiceCodeView) {
        _voiceCodeView = [[ASVoiceCodeView alloc]init];
        _voiceCodeView.textLabel.textColor = TEXT_SIMPLE_COLOR;
        [_voiceCodeView.voiceBtn setImage:[UIImage imageNamed:@"login_voice"] forState:UIControlStateNormal];
        [_voiceCodeView.voiceBtn setBackgroundColor:UIColorRGBA(0xFD6E6A, 0.1)];
        [_voiceCodeView.voiceBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        _voiceCodeView.hidden = YES;
        kWeakSelf(self);
        _voiceCodeView.actionBlock = ^{
            if (wself.phoneText.length != 11) {
                kShowToast(@"请输入正确的手机号");
                return;
            }
            [ASLoginRequest requestSmsCodeWithPhone:wself.phoneText type:@"bind" isVoice:YES success:^(id  _Nullable data) {
                [wself.voiceCodeView.voiceBtn setImage:[UIImage imageNamed:@"login_voice2"] forState:UIControlStateNormal];
                [wself.voiceCodeView.voiceBtn setBackgroundColor:UIColorRGBA(0x999999, 0.1)];
                [wself.voiceCodeView.voiceBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
                wself.voiceCodeView.voiceBtn.userInteractionEnabled = NO;
                wself.codeView.textField.placeholder = @"请输入语音验证码";
                wself.codeView.sendOTP.enabled = NO;
                [wself.codeView.sendOTP stopCountDown];//停止之前的倒计时
                [wself.codeView.sendOTP startCountDownWithSecond:60];//重新倒计时60s
                [wself.codeView.sendOTP countDownChanging:^NSString *(CodeButton *countDownButton, NSUInteger second) {
                    NSString *title = [NSString stringWithFormat:@"%lus",(unsigned long)second];
                    return title;
                }];
                [wself.codeView.sendOTP countDownFinished:^NSString *(CodeButton *countDownButton, NSUInteger second) {
                    wself.codeView.sendOTP.enabled = YES;
                    return @"重新获取";
                }];
                //弹窗提示
                [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"我们将以电话的方式告诉您验证码\n请注意接听" left:@"知道了" right:@"" isTouched:YES affirmAction:^{
                    
                } cancelAction:^{
                    
                }];
            } errorBack:^(NSInteger code, NSString *msg) {

            }];
        };
    }
    return _voiceCodeView;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.adjustsImageWhenHighlighted = NO;
        _submitBtn.userInteractionEnabled = NO;
        [_submitBtn setBackgroundImage:[UIImage imageNamed:@"button_bg2"] forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = TEXT_MEDIUM(18);
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = SCALES(25);
        [_submitBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
    }
    return _submitBtn;
}
@end
