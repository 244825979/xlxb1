//
//  ASBindPhoneTextView.h
//  AS
//
//  Created by SA on 2025/7/17.
//

#import <UIKit/UIKit.h>
#import "CodeButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BindPhonTextViewType){
    kTextViewPhone = 0,
    kTextViewCode = 1
};

@interface ASBindPhoneTextView : UIView
@property (nonatomic, assign) BindPhonTextViewType viewType;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) CodeButton *sendOTP;
@property (nonatomic, copy) void (^inputBlock)(NSString *text);
@property (nonatomic, copy) void (^enterOTPkBlock)(CodeButton *button);//点击发送验证码回调
@end

NS_ASSUME_NONNULL_END
