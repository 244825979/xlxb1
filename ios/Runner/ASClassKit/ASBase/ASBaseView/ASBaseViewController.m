//
//  ASBaseViewController.m
//  AS
//
//  Created by SA on 2025/4/9.
//

#import "ASBaseViewController.h"
#import "ASScreenShieldView.h"

@interface ASBaseViewController ()
@property (nonatomic, assign) BOOL banScreenshot;
@end

@implementation ASBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController.childViewControllers.count > 1) {
        [self backBtn];
    }
    if (self.banScreenshot) {
        if (@available(iOS 13.2, *)) {
            self.view = [ASScreenShieldView creactWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        } else {
            [super loadView];
        }
    } else {
        [super loadView];
    }
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    if (!kStringIsEmpty(titleText)) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 200, 44)];
        titleLabel.font = TEXT_FONT_20;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = titleText;
        self.navigationItem.titleView = titleLabel;
    }
}

- (void)backBtn {
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btnLeft setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    btnLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnLeft addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}

- (void)popVC {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
