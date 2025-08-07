//
//  ASAuthOrSafetyItemView.m
//  AS
//
//  Created by SA on 2025/5/21.
//

#import "ASAuthOrSafetyItemView.h"

@interface ASAuthOrSafetyItemView ()
@property (nonatomic, strong) UIImageView *back;
@end

@implementation ASAuthOrSafetyItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon];
        [self addSubview:self.title];
        [self addSubview:self.state];
        [self addSubview:self.goAuth];
        [self addSubview:self.back];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.actionBlock) {
                wself.actionBlock();
            }
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(50), SCALES(50)));
    }];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.icon);
        make.left.equalTo(self.icon.mas_right).offset(SCALES(16));
    }];
    if (self.itemType == kAuthItemType) {
        [self.state mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.offset(SCALES(-16));
            make.size.mas_equalTo(CGSizeMake(SCALES(64), SCALES(64)));
        }];
        [self.goAuth mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.offset(SCALES(-16));
            make.size.mas_equalTo(CGSizeMake(SCALES(70), SCALES(32)));
        }];
    } else {
        [self.state mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.offset(SCALES(-40));
            make.size.mas_equalTo(CGSizeMake(SCALES(72), SCALES(32)));
        }];
        [self.back mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(SCALES(-14));
            make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
        }];
    }
}

- (void)setItemType:(AuthOrSafetyItemType)itemType {
    _itemType = itemType;
    switch (itemType) {
        case kAuthItemType:
        {
            self.back.hidden = YES;
        }
            break;
        case kSafetyItemType:
        {
            self.back.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)setStateValue:(NSInteger)stateValue {
    _stateValue = stateValue;
    switch (self.itemType) {
        case kAuthItemType:
        {
            if (self.stateValue == 1) {//认证通过
                self.state.hidden = NO;
                self.goAuth.hidden = YES;
                self.state.image = [UIImage imageNamed:@"auth_state"];
            } else if (self.stateValue == 2) {//认证审核中
                self.state.hidden = NO;
                self.goAuth.hidden = YES;
                self.state.image = [UIImage imageNamed:@"auth_state1"];
            } else {//未认证或者认证失败
                self.state.hidden = YES;
                self.goAuth.hidden = NO;
            }
        }
            break;
        case kSafetyItemType:
        {
            self.goAuth.hidden = YES;
            if (self.stateValue == 1) {//已展示
                self.state.hidden = NO;
                self.state.image = [UIImage imageNamed:@"anquan_state2"];
            } else if (self.stateValue == 2) {//已阅读
                self.state.hidden = NO;
                self.state.image = [UIImage imageNamed:@"anquan_state1"];
            } else if (self.stateValue == 3) {//已阅读并同意
                self.state.hidden = NO;
                self.state.image = [UIImage imageNamed:@"anquan_state3"];
            } else {
                self.state.hidden = YES;
            }
        }
            break;
        default:
            break;
    }
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = TITLE_COLOR;
        _title.font = TEXT_MEDIUM(16);
    }
    return _title;
}

- (UIImageView *)state {
    if (!_state) {
        _state = [[UIImageView alloc]init];
        _state.hidden = YES;
    }
    return _state;
}

- (UIImageView *)back {
    if (!_back) {
        _back = [[UIImageView alloc]init];
        _back.image = [UIImage imageNamed:@"cell_back"];
        _back.hidden = YES;
    }
    return _back;
}

- (UIButton *)goAuth {
    if (!_goAuth) {
        _goAuth = [[UIButton alloc]init];
        [_goAuth setBackgroundColor:GRDUAL_CHANGE_BG_COLOR(SCALES(70), SCALES(32))];
        _goAuth.adjustsImageWhenHighlighted = NO;
        _goAuth.titleLabel.font = TEXT_FONT_16;
        [_goAuth setTitle:@"去认证" forState:UIControlStateNormal];
        _goAuth.layer.masksToBounds = YES;
        _goAuth.layer.cornerRadius = SCALES(16);
        _goAuth.hidden = YES;
        kWeakSelf(self);
        [[_goAuth rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.actionBlock) {
                wself.actionBlock();
            }
        }];
    }
    return _goAuth;
}
@end
