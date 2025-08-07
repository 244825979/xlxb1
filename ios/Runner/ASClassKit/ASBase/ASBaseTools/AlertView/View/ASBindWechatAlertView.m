//
//  ASBindWechatAlertView.m
//  AS
//
//  Created by SA on 2025/7/24.
//

#import "ASBindWechatAlertView.h"

@interface ASBindWechatAlertView ()
@property (nonatomic, strong) UIImageView *topIcon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *hintText;
@property (nonatomic, strong) UILabel *hintBottom;
@property (nonatomic, strong) UIButton *submit;
@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation ASBindWechatAlertView

- (instancetype)init {
    if (self = [super init]) {
        self.size = CGSizeMake(SCALES(311), SCALES(380));
        self.layer.cornerRadius = SCALES(16);
        self.layer.masksToBounds = YES;
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.topIcon];
        [self addSubview:self.title];
        [self addSubview:self.hintText];
        [self addSubview:self.submit];
        [self addSubview:self.hintBottom];
        [self addSubview:self.closeBtn];
        [self.topIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(22));
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCALES(78), SCALES(78)));
        }];
        [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(16));
            make.right.equalTo(self).offset(SCALES(-10));
            make.size.mas_equalTo(CGSizeMake(SCALES(24), SCALES(24)));
        }];
        [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topIcon.mas_bottom).offset(SCALES(22));
            make.centerX.equalTo(self);
            make.height.mas_equalTo(SCALES(24));
        }];
        [self.hintText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).offset(SCALES(10));
            make.left.mas_equalTo(SCALES(20));
            make.right.equalTo(self.mas_right).offset(SCALES(-20));
        }];
        [self.submit mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(258));
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCALES(247), SCALES(48)));
        }];
        [self.hintBottom mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-SCALES(19));
        }];
    }
    return self;
}

- (UIImageView *)topIcon {
    if (!_topIcon) {
        _topIcon = [[UIImageView alloc]init];
        _topIcon.image = [UIImage imageNamed:@"set_bind_wx"];
    }
    return _topIcon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.textColor = TITLE_COLOR;
        _title.font = TEXT_MEDIUM(18);
        _title.text = @"微信一键绑定";
    }
    return _title;
}

- (UILabel *)hintText {
    if (!_hintText) {
        _hintText = [[UILabel alloc]init];
        _hintText.textColor = UIColorRGB(0x333333);
        _hintText.font = TEXT_FONT_15;
        _hintText.attributedText = [ASCommonFunc attributedWithString:@"根据国家政策及法律规定，为保障您的账号安全丢失及找回，建议您绑定微信账号，绑定后支持微信快捷登录" lineSpacing:SCALES(4)];
        _hintText.numberOfLines = 0;
    }
    return _hintText;
}

- (UILabel *)hintBottom {
    if (!_hintBottom) {
        _hintBottom = [[UILabel alloc]init];
        _hintBottom.textColor = TEXT_SIMPLE_COLOR;
        _hintBottom.font = TEXT_FONT_12;
        _hintBottom.text = @"*我们不会公开您的微信号，仅用于账号验证与通知";
    }
    return _hintBottom;
}

- (UIButton *)submit {
    if (!_submit) {
        _submit = [[UIButton alloc]init];
        [_submit setTitle:@"立即绑定" forState:UIControlStateNormal];
        [_submit setBackgroundImage:[UIImage imageNamed:@"set_bind_btn_wx"] forState:UIControlStateNormal];
        _submit.adjustsImageWhenHighlighted = NO;
        _submit.titleLabel.font = TEXT_MEDIUM(18);
        _submit.layer.cornerRadius = SCALES(24);
        _submit.layer.masksToBounds = YES;
        kWeakSelf(self);
        [[_submit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.affirmBlock) {
                wself.affirmBlock();
                [wself removeFromSuperview];
            }
        }];
    }
    return _submit;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setImage:[UIImage imageNamed:@"close2"] forState:UIControlStateNormal];
        _closeBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.closeBlock) {
                wself.closeBlock();
                [wself removeFromSuperview];
            }
        }];
    }
    return _closeBtn;
}
@end
