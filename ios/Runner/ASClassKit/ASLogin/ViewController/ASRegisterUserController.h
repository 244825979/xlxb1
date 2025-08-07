//
//  ASRegisterUserController.h
//  AS
//
//  Created by SA on 2025/4/14.
//

#import "ASBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASRegisterUserController : ASBaseViewController
@property (nonatomic, assign) BOOL showNavigation;//进入认证页H5是否显示导航
@property (nonatomic, copy) NSString *iconurl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) void (^backBlock)(void);
@end

NS_ASSUME_NONNULL_END
