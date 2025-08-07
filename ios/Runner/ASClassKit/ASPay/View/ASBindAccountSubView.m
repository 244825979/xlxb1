//
//  ASBindAccountSubView.m
//  AS
//
//  Created by SA on 2025/6/27.
//

#import "ASBindAccountSubView.h"

@implementation ASBindAccountSubView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.leftTitle];
        [self addSubview:self.content];
        [self addSubview:self.icon];
        [self addSubview:self.accountTextField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(SCALES(16));
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(SCALES(130));
    }];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content.mas_right).offset(SCALES(4));
        make.centerY.equalTo(self.content);
        make.size.mas_equalTo(CGSizeMake(SCALES(20), SCALES(20)));
    }];
    [self.accountTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(SCALES(130));
        make.width.mas_equalTo(SCALES(180));
    }];
}

- (void)setType:(ASBindAccountViewType)type {
    _type = type;
    switch (type) {
        case kBindAccountViewDefault:
            self.icon.hidden = YES;
            self.accountTextField.hidden = YES;
            self.content.hidden = NO;
            break;
        case kBindAccountViewAcount:
            self.icon.hidden = NO;
            self.accountTextField.hidden = YES;
            self.content.hidden = NO;
            break;
        case kBindAccountViewTextField:
            self.icon.hidden = YES;
            self.accountTextField.hidden = NO;
            self.content.hidden = YES;
            break;
        default:
            break;
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.inputClickBlock) {
        self.inputClickBlock(textField.text);
    }
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.hidden = YES;
    }
    return _icon;
}

- (UILabel *)leftTitle {
    if (!_leftTitle) {
        _leftTitle = [[UILabel alloc]init];
        _leftTitle.textColor = TITLE_COLOR;
        _leftTitle.font = TEXT_FONT_16;
    }
    return _leftTitle;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.textColor = TITLE_COLOR;
        _content.font = TEXT_FONT_15;
        _content.hidden = YES;
    }
    return _content;
}

- (UITextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc]init];
        _accountTextField.text = @"";
        _accountTextField.textColor = TITLE_COLOR;
        _accountTextField.font = TEXT_FONT_15;
        _accountTextField.hidden = YES;
        _accountTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"请输入%@账号", STRING(USER_INFO.configModel.config.baozhifu_text)]  attributes:@{NSFontAttributeName:TEXT_FONT_15,NSForegroundColorAttributeName: PLACEHOLDER_COLOR}];
        [_accountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _accountTextField;
}

@end
