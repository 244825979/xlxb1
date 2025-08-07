//
//  ASSetTeenagerHomeController.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASSetTeenagerHomeController.h"
#import "ASSetTeenagerPwdController.h"

@interface ASSetTeenagerHomeController ()

@end

@implementation ASSetTeenagerHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"青少年模式";
    [self createUI];
}

- (void)createUI {
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:@"teenager"];
    [self.view addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCALES(160), SCALES(160)));
        make.top.mas_equalTo(SCALES(100));
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"青少年模式已关闭";
    title.font = TEXT_FONT_18;
    title.textColor = TITLE_COLOR;
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(SCALES(25));
        make.top.equalTo(icon.mas_bottom).offset(SCALES(18));
    }];
    
    UIButton *nextButton=[[UIButton alloc]init];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    nextButton.adjustsImageWhenHighlighted = NO;
    nextButton.titleLabel.font = TEXT_FONT_18;
    nextButton.layer.masksToBounds = YES;
    nextButton.layer.cornerRadius = SCALES(25);
    [nextButton setTitle:@"开启青少年模式" forState:UIControlStateNormal];
    kWeakSelf(self);
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ASSetTeenagerPwdController *vc = [[ASSetTeenagerPwdController alloc] init];
        vc.type = kTeenagerPwdFirstSet;
        [wself.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCALES(319), SCALES(50)));
        make.bottom.equalTo(self.view.mas_bottom).offset(-(SCALES(14) + TAB_BAR_MAGIN));
    }];
}
@end
