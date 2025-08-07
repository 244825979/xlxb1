//
//  ASSetTeenagerPwdController.h
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TeenagerPwdType){
    kTeenagerPwdFirstSet = 0,           //首次设置
    kTeenagerPwdAffirm = 1,             //再次确认设置
    kTeenagerPwdClose = 2,              //关闭未成年输入密码
};

@interface ASSetTeenagerPwdController : ASBaseViewController
@property (nonatomic, assign) TeenagerPwdType type;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, copy) BoolBlock backBlock;//是否关闭成功
@end

NS_ASSUME_NONNULL_END
