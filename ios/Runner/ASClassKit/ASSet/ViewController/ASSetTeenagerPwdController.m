//
//  ASSetTeenagerPwdController.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASSetTeenagerPwdController.h"
#import "ASSetPwdTextFieldView.h"
#import "ASSetRequest.h"

@interface ASSetTeenagerPwdController ()
@property (nonatomic, copy) NSString *pwdText;
@property (nonatomic, strong) UIButton *nextBtn;
@end

@implementation ASSetTeenagerPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"青少年模式";
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.type == kTeenagerPwdClose) {
        id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
        [self.view addGestureRecognizer:pan];
    }
}

- (void)createUI {
    kWeakSelf(self);
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:24];
    if (self.type == kTeenagerPwdFirstSet) {
        title.text = @"设置密码";
    } else if (self.type == kTeenagerPwdAffirm) {
        title.text = @"确认密码";
    } else if (self.type == kTeenagerPwdClose) {
        title.text = @"输入密码";
    }
    title.textColor = TITLE_COLOR;
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(28));
        make.top.mas_equalTo(SCALES(40));
        make.height.mas_equalTo(SCALES(38));
    }];
    
    ASSetPwdTextFieldView *inputPwdView = [[ASSetPwdTextFieldView alloc] init];
    inputPwdView.textFieldType = kTextFieldSetPwd;
    inputPwdView.inputBlock = ^(NSString * _Nonnull text) {
        wself.pwdText = text;
        [wself verifyButton];
    };
    [self.view addSubview:inputPwdView];
    [inputPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(SCALES(16));
        make.left.equalTo(title);
        make.right.equalTo(self.view).offset(SCALES(-28));
        make.height.mas_equalTo(SCALES(50));
    }];
    
    self.nextBtn = ({
        UIButton *button = [[UIButton alloc]init];
        [button setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
        [button setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;//去掉点击效果
        button.titleLabel.font = TEXT_FONT_18;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = SCALES(25);
        button.selected = NO;
        if (self.type == kTeenagerPwdClose) {
            [button setTitle:@"关闭青少年模式" forState:UIControlStateNormal];
        } else {
            [button setTitle:@"开启青少年模式" forState:UIControlStateNormal];
        }
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.type == kTeenagerPwdFirstSet) {
                if (wself.pwdText.length != 4) {
                    kShowToast(@"请输入4位数密码");
                    return;
                }
                ASSetTeenagerPwdController *vc = [[ASSetTeenagerPwdController alloc] init];
                vc.pwd = wself.pwdText;
                vc.type = kTeenagerPwdAffirm;
                [wself.navigationController pushViewController:vc animated:YES];
            } else if (wself.type == kTeenagerPwdAffirm) {
                if (![wself.pwdText isEqualToString:wself.pwd]) {
                    kShowToast(@"密码不正确");
                    return;
                }
                [ASSetRequest requestOpenTeenagerWithPwd:wself.pwd success:^(id  _Nullable data) {
                    [wself.navigationController popToRootViewControllerAnimated:YES];
                    [[ASPopViewManager shared] closeTeenagerPop];
                } errorBack:^(NSInteger code, NSString *msg) {
                    
                }];
                
            } else if (wself.type == kTeenagerPwdClose) {
                if (wself.pwdText.length != 4) {
                    kShowToast(@"密码错误");
                    return;
                }
                [ASSetRequest requestCloseTeenagerWithPwd:wself.pwdText success:^(id  _Nullable data) {
                    [wself.navigationController popViewControllerAnimated:YES];
                    if (wself.backBlock) {
                        wself.backBlock(YES);
                    }
                } errorBack:^(NSInteger code, NSString *msg) {
                    
                }];
            }
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
    if (self.backBlock) {
        self.backBlock(NO);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)verifyButton {
    if (self.pwdText.length == 4) {
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [self.nextBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    } else {
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
        [self.nextBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
    }
}

@end
