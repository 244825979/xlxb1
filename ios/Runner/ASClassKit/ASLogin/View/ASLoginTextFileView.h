//
//  ASLoginTextFileView.h
//  AS
//
//  Created by SA on 2025/4/14.
//

#import <UIKit/UIKit.h>
#import "CodeButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LoginTextFieldType){
    kTextFieldPhone = 0,                //手机号码输入框
    kTextFieldEnterOTP = 1,             //验证码输入框
};

@interface ASLoginTextFileView : UIView
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) LoginTextFieldType textFieldType;
@property (nonatomic, strong) CodeButton *sendOTP;
@property (nonatomic, copy) void (^inputBlock)(NSString *text);//输入文本回调
@property (nonatomic, copy) void (^enterOTPkBlock)(CodeButton *button);//点击发送验证码回调
@end

NS_ASSUME_NONNULL_END
