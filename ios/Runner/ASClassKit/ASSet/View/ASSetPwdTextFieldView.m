//
//  ASSetPwdTextFieldView.m
//  AS
//
//  Created by SA on 2025/4/23.
//

#import "ASSetPwdTextFieldView.h"
#import "CodeButton.h"

@interface ASSetPwdTextFieldView()<UITextFieldDelegate>
@property (nonatomic, strong) CodeButton *sendOTP;
@end

@implementation ASSetPwdTextFieldView

- (instancetype)init {
    if (self = [super init]) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = SCALES(25);
        self.backgroundColor = UIColorRGB(0xF5F5F5);
        [self addSubview:self.textField];
        [self addSubview:self.sendOTP];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(24));
        make.centerY.height.equalTo(self);
        make.right.offset(SCALES(-120));
    }];
    
    [self.sendOTP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self);
        make.right.offset(SCALES(-24));
    }];
}

- (void)setTextFieldType:(SetTextFieldType)textFieldType {
    _textFieldType = textFieldType;
    switch (textFieldType) {
        case kTextFieldPhone:
        {
            self.textField.placeholder = @"请输入手机号";
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.sendOTP.hidden = YES;
        }
            break;
        case kTextFieldEnterOTP:
        {
            self.textField.placeholder = @"请输入验证码";
            self.sendOTP.hidden = NO;
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case kTextFieldSetPwd:
        {
            self.textField.placeholder = @"请输入密码";
            self.sendOTP.hidden = YES;
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.textField.secureTextEntry = YES;
        }
            break;
        default:
            break;
    }
}

- (void)sendOTPClicked:(CodeButton *)button {
    if (self.enterOTPkBlock) {
        self.enterOTPkBlock(button);
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.inputBlock) {
        self.inputBlock(textField.text);
    }
}

#pragma mark textField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.textFieldType == kTextFieldPhone) {
        [self.textField insertWhitSpaceInsertPosition:@[@(3), @(7)] replacementString:string textlength:12];
        return NO;
    }
    if (self.textFieldType == kTextFieldEnterOTP) {
        if (textField.text.length > 5 && ![string isEqualToString:@""]){
            return NO;
        }
    }
    if (self.textFieldType == kTextFieldSetPwd) {
        if (textField.text.length > 3 && ![string isEqualToString:@""]){
            return NO;
        }
    }
    return YES;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField=[[UITextField alloc]init];
        _textField.textColor = TITLE_COLOR;
        _textField.font = TEXT_FONT_16;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (CodeButton *)sendOTP {
    if (!_sendOTP) {
        _sendOTP = [[CodeButton alloc]init];
        [_sendOTP setTitle:@"获取验证码" forState:UIControlStateNormal];
        _sendOTP.titleLabel.font = TEXT_FONT_16;
        [_sendOTP setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        [_sendOTP addTarget:self action:@selector(sendOTPClicked:) forControlEvents:UIControlEventTouchUpInside];
        _sendOTP.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _sendOTP;
}
@end
