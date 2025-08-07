//
//  ASSetPwdTextFieldView.h
//  AS
//
//  Created by SA on 2025/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SetTextFieldType){
    kTextFieldSetPwd = 0,                   //密码输入
    kTextFieldEnterOTP = 1,                 //验证码输入框
    kTextFieldPhone = 2,                    //手机号码输入框
};

@interface ASSetPwdTextFieldView : UIView
@property (nonatomic, assign) SetTextFieldType textFieldType;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) TextBlock inputBlock;
@property (nonatomic, copy) ActionBlock enterOTPkBlock;
@end

NS_ASSUME_NONNULL_END
