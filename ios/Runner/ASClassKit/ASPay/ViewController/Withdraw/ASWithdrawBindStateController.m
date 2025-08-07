//
//  ASWithdrawBindStateController.m
//  AS
//
//  Created by SA on 2025/6/27.
//

#import "ASWithdrawBindStateController.h"
#import "ASWithdrawChangeController.h"

@interface ASWithdrawBindStateController ()

@end

@implementation ASWithdrawBindStateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"绑定提现账号";
    [self createUI];
}

- (void)createUI {
    kWeakSelf(self);
    UIImageView *stateIcon = [[UIImageView alloc] init];
    stateIcon.image = [UIImage imageNamed:self.isSucceed == YES ? @"bind_state" : @"bind_state1"];
    [self.view addSubview:stateIcon];
    [stateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(SCALES(-66));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(SCALES(166));
    }];
    UILabel *title = [[UILabel alloc] init];
    title.font = TEXT_FONT_20;
    title.text = self.isSucceed == YES ? @"提交成功" : @"提交失败";
    title.textColor = self.isSucceed == YES ? MAIN_COLOR : TEXT_SIMPLE_COLOR;
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(stateIcon.mas_bottom).offset(SCALES(14));
        make.height.mas_equalTo(SCALES(28));
    }];
    UILabel *content = [[UILabel alloc] init];
    content.font = TEXT_FONT_15;
    content.text = STRING(self.hintText);
    content.textColor = TEXT_SIMPLE_COLOR;
    content.numberOfLines = 0;
    content.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(stateIcon);
        make.top.equalTo(title.mas_bottom).offset(SCALES(14));
        make.width.mas_equalTo(SCALES(260));
    }];
    UIButton *nextBtn = [[UIButton alloc] init];
    [nextBtn setTitle:@"返回" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = TEXT_FONT_16;
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = SCALES(20);
    nextBtn.layer.borderWidth = SCALES(1);
    nextBtn.layer.borderColor = (self.isSucceed == YES ? MAIN_COLOR : TEXT_SIMPLE_COLOR).CGColor;
    [nextBtn setTitleColor:self.isSucceed == YES ? MAIN_COLOR : TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(stateIcon);
        make.top.equalTo(content.mas_bottom).offset(SCALES(14));
        make.height.mas_equalTo(SCALES(40));
        make.width.mas_equalTo(SCALES(125));
    }];
    [[nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (wself.isSucceed) {
            BOOL isInclude = NO;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[ASWithdrawChangeController class]]) {
                    isInclude = YES;
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            if (isInclude == NO) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } else {
            [wself.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)popVC {
    [self.view endEditing:YES];
    if (self.isSucceed) {
        BOOL isInclude = NO;
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[ASWithdrawChangeController class]]) {
                isInclude = YES;
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        if (isInclude == NO) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
