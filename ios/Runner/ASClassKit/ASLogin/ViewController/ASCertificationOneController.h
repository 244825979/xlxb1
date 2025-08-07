//
//  ASCertificationOneController.h
//  AS
//
//  Created by SA on 2025/5/23.
//

#import "ASBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASCertificationOneController : ASBaseViewController
@property (nonatomic, assign) BOOL showNavigation;//进入认证页H5是否显示导航
@property (nonatomic, strong) ASUserInfoModel *userModel;
@property (nonatomic, copy) NSString *userAvatar;
@property (nonatomic, copy) VoidBlock backBlock;
@end

NS_ASSUME_NONNULL_END
