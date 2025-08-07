//
//  ASBaseNavigationController.m
//  AS
//
//  Created by SA on 2025/4/9.
//

#import "ASBaseNavigationController.h"
#import "UIViewController+NavigationControllerHidden.h"

@interface ASBaseNavigationController ()<UINavigationControllerDelegate>
@property (nonatomic, weak) id popDelegate;
@end

@implementation ASBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tabbar的主题颜色
    self.navigationBar.backgroundColor = UIColor.whiteColor;
    //设置导航栏的颜色
    [self.navigationBar setBarTintColor:UIColor.whiteColor];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.navigationBar.translucent = NO;
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    self.delegate = self;
    self.navigationBar.prefersLargeTitles = YES;
    self.topViewController.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName: TEXT_FONT_20,
                                               NSForegroundColorAttributeName:TITLE_COLOR};
    if (@available(iOS 15.0, *)) { //15系统push导航栏灰色处理
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance setShadowImage:[[UIImage alloc] init]];
        [appearance setBackgroundColor:[UIColor whiteColor]];
        [appearance setBackgroundImage:[ASCommonFunc createImageWithColor:[UIColor whiteColor]]];
        [appearance setShadowImage:[ASCommonFunc createImageWithColor:[UIColor whiteColor]]];
        [[UINavigationBar appearance] setScrollEdgeAppearance: appearance];
    }
}

//统一返回样式
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    [super pushViewController:viewController animated:animated];
    // 修改tabBra的frame
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}

- (void)setBarBackgroundColor:(UIColor *)barBackgroundColor{
    self.navigationBar.backgroundColor = barBackgroundColor;
    [self.navigationBar setBarTintColor:barBackgroundColor];
}

- (void)setTitleBackgroundColor:(UIColor *)titleBackgroundColor {
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:titleBackgroundColor}];
}

//解决手势失效问题
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    } else {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

//显示时候调用
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController.shouldNavigationBarHidden != self.navigationBarHidden) {
        [self setNavigationBarHidden:viewController.shouldNavigationBarHidden animated:animated];
    }
}

//设置状态栏样式样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

//返回方法
- (void)backBarButtonItemAction {
    [self.navigationItem setHidesBackButton:NO];
    [self popViewControllerAnimated:YES];
}

@end
