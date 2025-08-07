//
//  UIViewController+NavigationControllerHidden.h
//  AS
//
//  Created by SA on 2025/4/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (NavigationControllerHidden)
//是否隐藏导航栏。默认NO。
@property (nonatomic , assign) BOOL shouldNavigationBarHidden;
@end

NS_ASSUME_NONNULL_END
