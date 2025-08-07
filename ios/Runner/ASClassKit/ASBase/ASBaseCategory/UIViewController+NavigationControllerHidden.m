//
//  UIViewController+NavigationControllerHidden.m
//  AS
//
//  Created by SA on 2025/4/10.
//

#import "UIViewController+NavigationControllerHidden.h"
#import <objc/runtime.h>

@implementation UIViewController (NavigationControllerHidden)

- (BOOL)shouldNavigationBarHidden{
    return [objc_getAssociatedObject(self, @selector(shouldNavigationBarHidden)) boolValue];
}

- (void)setShouldNavigationBarHidden:(BOOL)shouldNavigationBarHidden{
    objc_setAssociatedObject(self, @selector(shouldNavigationBarHidden), @(shouldNavigationBarHidden), OBJC_ASSOCIATION_ASSIGN);
}

@end
