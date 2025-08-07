//
//  ASVipReceiveGiftView.m
//  AS
//
//  Created by SA on 2025/6/27.
//

#import "ASVipReceiveGiftView.h"

@interface ASVipReceiveGiftView ()
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIButton *receiveBtn;
@end

@implementation ASVipReceiveGiftView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.bgImage];
        [self.bgImage addSubview:self.icon];
        [self.bgImage addSubview:self.title];
        [self.bgImage addSubview:self.receiveBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(SCALES(14));
        make.width.mas_equalTo(SCALES(35));
        make.height.mas_equalTo(SCALES(30));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.icon.mas_right).offset(SCALES(16));
    }];
    [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(SCALES(-14));
        make.width.mas_equalTo(SCALES(60));
        make.height.mas_equalTo(SCALES(28));
    }];
}

- (void)setModel:(ASGiftListModel *)model {
    _model = model;
    if (model.is_reward == 1) {
        [self.receiveBtn setTitle:@"已领取" forState:UIControlStateNormal];
        self.receiveBtn.userInteractionEnabled = NO;
        [self.receiveBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        [self.receiveBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
    } else {
        [self.receiveBtn setTitle:@"领取" forState:UIControlStateNormal];
        self.receiveBtn.userInteractionEnabled = YES;
        [self.receiveBtn setTitleColor:UIColorRGB(0x571D03) forState:UIControlStateNormal];
        [self.receiveBtn setBackgroundImage:[UIImage imageNamed:@"vip_btn"] forState:UIControlStateNormal];
    }
}

- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]init];
        _bgImage.image = [UIImage imageNamed:@"vip_gift_bg"];
        _bgImage.userInteractionEnabled = YES;
    }
    return _bgImage;
}

- (UIButton *)receiveBtn {
    if (!_receiveBtn) {
        _receiveBtn = [[UIButton alloc] init];
        _receiveBtn.titleLabel.font = TEXT_FONT_14;
        [_receiveBtn setTitleColor:UIColorRGB(0x571D03) forState:UIControlStateNormal];
        _receiveBtn.layer.masksToBounds = YES;
        _receiveBtn.layer.cornerRadius = SCALES(14);
        _receiveBtn.adjustsImageWhenHighlighted = NO;
        [_receiveBtn setBackgroundImage:[UIImage imageNamed:@"vip_btn"] forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_receiveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.clikedBlock) {
                wself.clikedBlock();
            }
        }];
    }
    return _receiveBtn;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.image = [UIImage imageNamed:@"vip_gift1"];
    }
    return _icon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.textColor = UIColor.whiteColor;
        _title.font = TEXT_MEDIUM(16);
        _title.text = @"会员每日礼物";
    }
    return _title;
}
@end
