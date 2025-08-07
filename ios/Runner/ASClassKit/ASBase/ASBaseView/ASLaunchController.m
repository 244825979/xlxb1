//
//  ViewController.m
//  AS
//
//  Created by SA on 2025/4/8.
//

#import "ASLaunchController.h"

@interface ASLaunchController ()

@end

@implementation ASLaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"login_bg"];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image = [UIImage imageNamed:@"app_logo"];
    [bgView addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.width.mas_equalTo(60);
        make.bottom.equalTo(self.view).offset(-TAB_BAR_MAGIN-70);
    }];
    
    UILabel *appName = [[UILabel alloc] init];
    appName.text = kAppName;
    appName.textColor = UIColor.whiteColor;
    appName.font = TEXT_FONT_15;
    [bgView addSubview:appName];
    [appName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(logo.mas_bottom).offset(5);
        make.height.mas_equalTo(26);
    }];
}


@end
