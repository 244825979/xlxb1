//
//  ASBaseAlertViewController.m
//  AS
//
//  Created by SA on 2025/7/30.
//

#import "ASBaseAlertViewController.h"

@interface ASBaseAlertViewController ()
@property (nonatomic, assign) BOOL isFirstPop;
@end

@implementation ASBaseAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    self.isFirstPop = YES;
    self.view.backgroundColor = UIColor.clearColor;
    kWeakSelf(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:tap];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        if (wself.view.subviews.count == 0) {//发现当前页面没有了弹窗，但是没有关闭当前页面，用户点击就进行关闭
            [wself dismissViewControllerAnimated:NO completion:^{
                
            }];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    ASLog(@"-------当前view上面是否有浮窗的数量： %zd",self.view.subviews.count);
    if (self.view.subviews.count == 0 && self.isFirstPop == NO) {//如果当前页面没有了浮窗，就关闭当前页
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }
}

- (void)homePopViewWithComplete:(VoidBlock)complete {
    kWeakSelf(self);
    [[ASPopViewManager shared] requestAppVersionPopViewWithVc:wself complete:^{//版本更新弹窗
        wself.isFirstPop = NO;
        [[ASPopViewManager shared] isOpenTeenagerPopWithVc:wself complete:^{//青少年模式弹窗关闭
            [[ASPopViewManager shared] requestNewUserGiftWithVc:wself complete:^{//新人礼包
                [[ASPopViewManager shared] requestRecommendUserWithVc:wself complete:^{//今日缘分弹窗
                    complete();//回调刷新缘分状态
                    [[ASPopViewManager shared] activityPopWithPlacement:1 vc:wself isPopWindow:NO affirmAction:^{//活动配置弹窗
                        
                    } cancelBlock:^{
                        if ([wself isSelfVc]) {//最后一步判断当前顶层控制器来决定是否关闭弹窗流程
                            [wself dismissViewControllerAnimated:NO completion:^{
                                
                            }];
                        }
                    }];
                }];
            }];
        }];
    }];
}

- (void)minePopViewWithComplete:(VoidBlock)complete {
    kWeakSelf(self);
    [[ASPopViewManager shared] requestPopBindWithVc:wself complete:^{//绑定弹窗
        wself.isFirstPop = NO;
        [[ASPopViewManager shared] requestXuzhiPopWithVc:wself complete:^{//须知弹窗
            [[ASPopViewManager shared] requestVideoShowRemindWithVc:wself complete:^{//视频秀引导
                [[ASPopViewManager shared] headerPopRemindWithVc:wself complete:^{//头像引导
                    [[ASPopViewManager shared] activityPopWithPlacement:4 vc:wself isPopWindow:NO affirmAction:^{//活动配置弹窗
                        
                    } cancelBlock:^{
                        if ([wself isSelfVc]) {//最后一步判断当前顶层控制器来决定是否关闭弹窗流程
                            [wself dismissViewControllerAnimated:NO completion:^{
                                
                            }];
                        }
                        
                    }];
                }];
            }];
        }];
    }];
}

//判断是否顶层控制器，避免跳转其他控制器的情况下关闭了当前流程
- (BOOL)isSelfVc {
    if ([ASCommonFunc currentVc] == self) {
        return YES;
    }
    return NO;
}

@end
