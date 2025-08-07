//
//  ASBindPhoneTextView.m
//  AS
//
//  Created by SA on 2025/7/17.
//

#import "ASBindPhoneTextView.h"

@interface ASBindPhoneTextView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *lineView;
@end

@implementation ASBindPhoneTextView
- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.textField];
        [self addSubview:self.sendOTP];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.centerY.height.equalTo(self);
        make.right.offset(SCALES(-110));
    }];
    [self.sendOTP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self);
        make.right.offset(SCALES(-16));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(SCALES(0.5));
    }];
}

- (void)setViewType:(BindPhonTextViewType)viewType {
    _viewType = viewType;
    
    switch (viewType) {
        case kTextViewPhone:
        {
            self.textField.placeholder = @"请输入手机号";
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.sendOTP.hidden = NO;
        }
            break;
        case kTextViewCode:
        {
            self.textField.placeholder = @"请输入验证码";
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.sendOTP.hidden = YES;
        }
            break;
        default:
            break;
    }
}

//按钮输入监听
- (void)textFieldDidChange:(UITextField *)textField {
    if (self.inputBlock) {
        self.inputBlock(textField.text);
    }
}

//发送验证码
- (void)sendOTPClicked:(CodeButton *)button {
    if (self.enterOTPkBlock) {
        self.enterOTPkBlock(button);
    }
}

#pragma mark textField Delegate
//文本框输入时处理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //昵称不超过10 超过禁止输入
    if (self.viewType == kTextViewPhone) {
        [self.textField insertWhitSpaceInsertPosition:@[@(3), @(7)] replacementString:string textlength:12];
        return NO;
    }
    //邀请人不超过10位 超过禁止输入
    if (self.viewType == kTextViewCode) {
        if (textField.text.length > 5 && ![string isEqualToString:@""]){
            return NO;
        }
    }
    return YES;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = LINE_COLOR;
    }
    return _lineView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
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
        [_sendOTP setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendOTP.titleLabel.font = TEXT_FONT_16;
        [_sendOTP setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [_sendOTP addTarget:self action:@selector(sendOTPClicked:) forControlEvents:UIControlEventTouchUpInside];
        _sendOTP.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _sendOTP;
}

@end
