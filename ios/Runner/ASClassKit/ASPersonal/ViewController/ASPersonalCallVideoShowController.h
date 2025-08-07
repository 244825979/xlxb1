//
//  ASPersonalCallVideoShowController.h
//  AS
//
//  Created by SA on 2025/7/2.
//

#import "ASBaseViewController.h"
#import "ASVideoShowDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASPersonalCallVideoShowController : ASBaseViewController
@property (nonatomic, strong) ASUserInfoModel *userModel;
@property (nonatomic, strong) ASVideoShowDataModel *videoShowModel;
@end

NS_ASSUME_NONNULL_END
