//
//  ASCallGoPayView.m
//  AS
//
//  Created by SA on 2025/5/19.
//

#import "ASCallGoPayView.h"

@interface ASCallGoPayView ()
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, strong) UIButton *payBtn;
@end

@implementation ASCallGoPayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.text];
        [self addSubview:self.payBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(8));
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(SCALES(-75));
    }];
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(SCALES(-8));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(59), SCALES(28)));
    }];
}

- (void)setType:(ASCallType)type {
    _type = type;
}

- (UIButton *)payBtn {
    if (!_payBtn) {
        _payBtn = [[UIButton alloc]init];
        _payBtn.adjustsImageWhenHighlighted = NO;
        [_payBtn setTitle:@"去充值" forState:UIControlStateNormal];
        _payBtn.layer.cornerRadius = SCALES(14);
        _payBtn.layer.masksToBounds = YES;
        _payBtn.titleLabel.font = TEXT_MEDIUM(12);
        [_payBtn setBackgroundColor:GRDUAL_CHANGE_BG_COLOR(SCALES(59), SCALES(28))];
        kWeakSelf(self);
        [[_payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASMyAppCommonFunc balanceDeficiencyPopViewWithPayScene:wself.type == kCallTypeVideo ? Pay_Scene_VideoCalling : Pay_Scene_VoiceCalling  cancel:^{
                
            }];
        }];
    }
    return _payBtn;
}

- (UILabel *)text {
    if (!_text) {
        _text = [[UILabel alloc]init];
        _text.textColor = UIColor.whiteColor;
        _text.font = TEXT_FONT_12;
        _text.attributedText = [ASCommonFunc attributedWithString:@"您的金币余额不足，本次通话将自动挂断，请尽快充值" lineSpacing:SCALES(2)];
        _text.numberOfLines = 2;
    }
    return _text;
}
@end
