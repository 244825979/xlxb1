//
//  ASLoginTextFileView.m
//  AS
//
//  Created by SA on 2025/4/14.
//

#import "ASLoginTextFileView.h"

@interface ASLoginTextFileView()<UITextFieldDelegate>

@end

@implementation ASLoginTextFileView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = SCALES(25);
        self.layer.masksToBounds = YES;
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
        make.right.offset(SCALES(-110));
    }];
    [self.sendOTP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self);
        make.right.offset(SCALES(-20));
    }];
}

- (void)setTextFieldType:(LoginTextFieldType)textFieldType {
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
        default:
            break;
    }
}

//发送验证码
- (void)sendOTPClicked:(CodeButton *)button {
    if (self.enterOTPkBlock) {
        self.enterOTPkBlock(button);
    }
}

//按钮输入监听
- (void)textFieldDidChange:(UITextField *)textField {
    if (self.inputBlock) {
        self.inputBlock(textField.text);
    }
}

#pragma mark textField Delegate
//文本框输入时处理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //手机号码加空格
    if (self.textFieldType == kTextFieldPhone) {
        [self.textField insertWhitSpaceInsertPosition:@[@(3), @(7)] replacementString:string textlength:12];
        return NO;
    }
    //验证码不超过6位 超过禁止输入
    if (self.textFieldType == kTextFieldEnterOTP) {
        if (textField.text.length > 5 && ![string isEqualToString:@""]){
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
        [_sendOTP setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [_sendOTP addTarget:self action:@selector(sendOTPClicked:) forControlEvents:UIControlEventTouchUpInside];
        _sendOTP.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _sendOTP;
}
@end
