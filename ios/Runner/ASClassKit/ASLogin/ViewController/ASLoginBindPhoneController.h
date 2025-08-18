//
//  ASLoginBindPhoneController.h
//  AS
//
//  Created by SA on 2025/7/17.
//  绑定手机号 女用户必须绑定才可完成注册，男用户可跳过

#import "ASBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLoginBindPhoneController : ASBaseViewController
@property (nonatomic, strong) ASUserInfoModel *userModel;
@property (nonatomic, assign) BOOL isWeChatFirst;
@end

NS_ASSUME_NONNULL_END
