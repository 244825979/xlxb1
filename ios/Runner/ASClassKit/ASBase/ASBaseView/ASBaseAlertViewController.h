//
//  ASBaseAlertViewController.h
//  AS
//
//  Created by SA on 2025/7/30.
//  弹窗的底部承载控制器，透明的状态，用于弹窗覆盖tabbar，一般用在tabbar上的几个主页控制器的多层级弹窗生命管理

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASBaseAlertViewController : UIViewController
- (void)homePopViewWithComplete:(VoidBlock)complete;
- (void)minePopViewWithComplete:(VoidBlock)complete;
- (void)IMListPopViewWithComplete:(VoidBlock)complete;
@end

NS_ASSUME_NONNULL_END
