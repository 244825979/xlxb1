//
//  ASLoginOtherView.m
//  AS
//
//  Created by SA on 2025/5/22.
//

#import "ASLoginOtherView.h"

@interface ASLoginOtherView ()
@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UIButton *weChatBtn;
@property (nonatomic, strong) UIImageView *leftIcon;
@property (nonatomic, strong) UIImageView *rightIcon;
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, strong) UILabel *hintLabel;
@end

@implementation ASLoginOtherView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.leftIcon];
        [self addSubview:self.text];
        [self addSubview:self.rightIcon];
        [self addSubview:self.phoneBtn];
        [self addSubview:self.weChatBtn];
        [self addSubview:self.hintLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.text mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.width.mas_equalTo(SCALES(91));
        make.height.mas_equalTo(SCALES(16));
    }];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self.text);
        make.size.mas_equalTo(CGSizeMake(SCALES(60), SCALES(2)));
    }];
    [self.rightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self.text);
        make.size.mas_equalTo(CGSizeMake(SCALES(60), SCALES(2)));
    }];
    [self.hintLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.text.mas_bottom).offset(SCALES(92));
        make.height.mas_equalTo(SCALES(18));
    }];
    [self.weChatBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(SCALES(37));
        make.width.height.mas_equalTo(SCALES(50));
    }];
    [self.phoneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(SCALES(37));
        make.width.height.mas_equalTo(SCALES(50));
    }];
}

- (void)setType:(OtherLoginViewType)type {
    _type = type;
    switch (type) {
        case kWeChatType:
        {
            self.phoneBtn.hidden = YES;
            self.weChatBtn.hidden = NO;
            self.text.hidden = NO;
            self.leftIcon.hidden = NO;
            self.rightIcon.hidden = NO;
        }
            break;
        case kPhoneType:
        {
            self.weChatBtn.hidden = YES;
            if (USER_INFO.systemIndexModel.mobile_login_status == 1) {//是否开启手机号码登录
                self.phoneBtn.hidden = NO;
                self.text.hidden = NO;
                self.leftIcon.hidden = NO;
                self.rightIcon.hidden = NO;
            } else {
                self.text.hidden = YES;
                self.leftIcon.hidden = YES;
                self.rightIcon.hidden = YES;
                self.phoneBtn.hidden = YES;
            }
        }
            break;
        default:
            break;
    }
}

- (UILabel *)text {
    if (!_text) {
        _text = [[UILabel alloc]init];
        _text.text = @"其他登录方式";
        _text.font = TEXT_FONT_14;
        _text.textColor = UIColor.whiteColor;
        _text.textAlignment = NSTextAlignmentCenter;
        _text.hidden = YES;
    }
    return _text;
}

- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc]init];
        _leftIcon.image = [UIImage imageNamed:@"login_other_left"];
        _leftIcon.hidden = YES;
    }
    return _leftIcon;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc]init];
        _rightIcon.image = [UIImage imageNamed:@"login_other_right"];
        _rightIcon.hidden = YES;
    }
    return _rightIcon;
}

- (UIButton *)phoneBtn {
    if (!_phoneBtn) {
        _phoneBtn = [[UIButton alloc]init];
        [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"login_phone"] forState:UIControlStateNormal];
        _phoneBtn.adjustsImageWhenHighlighted = NO;
        _phoneBtn.hidden = YES;
        kWeakSelf(self);
        [[_phoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.actionBlock) {
                wself.actionBlock(@"手机号登录");
            }
        }];
    }
    return _phoneBtn;
}

- (UIButton *)weChatBtn {
    if (!_weChatBtn) {
        _weChatBtn = [[UIButton alloc]init];
        [_weChatBtn setBackgroundImage:[UIImage imageNamed:@"login_wechat1"] forState:UIControlStateNormal];
        _weChatBtn.adjustsImageWhenHighlighted = NO;
        _weChatBtn.hidden = YES;
        kWeakSelf(self);
        [[_weChatBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.actionBlock) {
                wself.actionBlock(@"微信登录");
            }
        }];
    }
    return _weChatBtn;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc]init];
        _hintLabel.font = TEXT_FONT_13;
        _hintLabel.text = @"除青少年模式外，未满18岁不得使用本APP";
        _hintLabel.textColor = UIColor.whiteColor;
        _hintLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hintLabel;
}
@end
