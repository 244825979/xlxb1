//
//  ASSetTeenagerForgetPwdController.m
//  AS
//
//  Created by SA on 2025/4/23.
//

#import "ASSetTeenagerForgetPwdController.h"
#import "ASSetPwdTextFieldView.h"
#import "ASSetRequest.h"
#import "CodeButton.h"

@interface ASSetTeenagerForgetPwdController ()
@property (nonatomic, strong) ASSetPwdTextFieldView *mobileTextField;
@property (nonatomic, strong) ASSetPwdTextFieldView *enterOTPTextField;
/**数据**/
@property (nonatomic, copy) NSString *phoneText;
@property (nonatomic, copy) NSString *codeText;
@property (nonatomic, strong) UIButton *nextBtn;
@end

@implementation ASSetTeenagerForgetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"关闭青少年模式";
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}

- (void)createUI {
    kWeakSelf(self);
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:24];
    title.text = @"忘记密码";
    title.textColor = TITLE_COLOR;
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(28));
        make.top.mas_equalTo(SCALES(28));
        make.height.mas_equalTo(SCALES(34));
    }];
    
    [self.view addSubview:self.mobileTextField];
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(28));
        make.right.offset(SCALES(-28));
        make.top.equalTo(title.mas_bottom).offset(SCALES(16));
        make.height.mas_equalTo(SCALES(50));
    }];
    
    [self.view addSubview:self.enterOTPTextField];
    [self.enterOTPTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.mobileTextField);
        make.top.equalTo(self.mobileTextField.mas_bottom).offset(SCALES(14));
    }];
    
    self.nextBtn = ({
        UIButton *button = [[UIButton alloc]init];
        [button setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateSelected];
        [button setTitle:@"关闭青少年模式" forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;
        button.userInteractionEnabled = NO;
        button.titleLabel.font = TEXT_FONT_18;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = SCALES(25);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASSetRequest requestForgetPwdTeenagerWithPhone:wself.phoneText code:wself.codeText success:^(id  _Nullable data) {
                if (wself.closeBlock) {
                    [wself.view endEditing:YES];
                    [wself.navigationController popViewControllerAnimated:YES];
                    wself.closeBlock(YES);
                }
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        }];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCALES(319), SCALES(50)));
            make.bottom.equalTo(self.view).offset(-(SCALES(14) + TAB_BAR_MAGIN));
        }];
        button;
    });
}

- (void)popVC {
    [self.view endEditing:YES];
    if (self.closeBlock) {
        self.closeBlock(NO);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)verifyButton {
    if (self.phoneText.length != 11 || self.codeText.length < 4) {
        self.nextBtn.userInteractionEnabled = NO;
        self.nextBtn.selected = NO;
    } else {
        self.nextBtn.userInteractionEnabled = YES;
        self.nextBtn.selected = YES;
    }
}

- (ASSetPwdTextFieldView *)mobileTextField {
    if (!_mobileTextField) {
        _mobileTextField = [[ASSetPwdTextFieldView alloc]init];
        _mobileTextField.textFieldType = kTextFieldPhone;
        kWeakSelf(self);
        _mobileTextField.inputBlock = ^(NSString * _Nonnull text) {
            wself.phoneText = [ASCommonFunc removeCharWithString:text chars:@[@" "]];
            [wself verifyButton];
        };
    }
    return _mobileTextField;
}

- (ASSetPwdTextFieldView *)enterOTPTextField {
    if (!_enterOTPTextField) {
        _enterOTPTextField = [[ASSetPwdTextFieldView alloc]init];
        _enterOTPTextField.textFieldType = kTextFieldEnterOTP;
        kWeakSelf(self);
        _enterOTPTextField.inputBlock = ^(NSString * _Nonnull text) {
            wself.codeText = text;
            [wself verifyButton];
        };
        _enterOTPTextField.enterOTPkBlock = ^(CodeButton * _Nonnull button) {
            if (wself.phoneText.length != 11) {
                kShowToast(@"请输入正确的手机号");
                return;
            }
            [ASLoginRequest requestSmsCodeWithPhone:wself.phoneText type:@"findadpwd" isVoice:NO success:^(id  _Nullable data) {
                button.enabled = NO;
                [button startCountDownWithSecond:60];
                [button countDownChanging:^NSString *(CodeButton *countDownButton, NSUInteger second) {
                    NSString *title = [NSString stringWithFormat:@"%lus",(unsigned long)second];
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
@end
