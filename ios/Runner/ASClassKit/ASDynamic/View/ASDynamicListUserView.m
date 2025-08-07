//
//  ASDynamicListUserView.m
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASDynamicListUserView.h"

@interface ASDynamicListUserView()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UIView *isOnline;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UIImageView *genderIcon;
@property (nonatomic, strong) UIImageView *realName;
@property (nonatomic, strong) UIImageView *realPerson;
@property (nonatomic, strong) UIImageView *vip;
@property (nonatomic, strong) UIButton *zhaohuBtn;
@property (nonatomic, assign) BOOL isBeckon;
@end

@implementation ASDynamicListUserView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.header];
        [self addSubview:self.nickName];
        [self addSubview:self.genderIcon];
        [self addSubview:self.realName];
        [self addSubview:self.realPerson];
        [self addSubview:self.vip];
        [self addSubview:self.zhaohuBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(50);
    }];
    
    [self.zhaohuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(SCALES(-16));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(51), SCALES(20)));
    }];
    
    if (self.model.is_auth || self.model.is_rp_auth || self.model.is_vip) {
        [self.nickName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.header.mas_right).offset(SCALES(10));
            make.top.equalTo(self.header.mas_top).offset(SCALES(3));
            make.height.mas_equalTo(SCALES(20));
        }];
    } else {
        [self.nickName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.header.mas_right).offset(SCALES(10));
            make.centerY.equalTo(self);
            make.height.mas_equalTo(SCALES(20));
        }];
    }
    [self.genderIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickName.mas_right).offset(SCALES(8));
        make.centerY.equalTo(self.nickName);
        make.height.width.mas_equalTo(SCALES(16));
    }];
    
    if (self.model.is_auth) {
        [self.realName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nickName);
            make.top.equalTo(self.nickName.mas_bottom).offset(SCALES(7));
            make.size.mas_equalTo(CGSizeMake(SCALES(40), SCALES(16)));
        }];
        if (self.model.is_rp_auth) {
            [self.realPerson mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.realName.mas_right).offset(SCALES(4));
                make.centerY.equalTo(self.realName);
                make.size.mas_equalTo(CGSizeMake(SCALES(40), SCALES(16)));
            }];
            [self.vip mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.realPerson.mas_right).offset(SCALES(4));
                make.centerY.equalTo(self.realName);
                make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
            }];
        } else {
            [self.vip mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.realName.mas_right).offset(SCALES(4));
                make.centerY.equalTo(self.realName);
                make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
            }];
        }
    } else {
        if (self.model.is_rp_auth) {
            [self.realPerson mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nickName);
                make.top.equalTo(self.nickName.mas_bottom).offset(SCALES(7));
                make.size.mas_equalTo(CGSizeMake(SCALES(40), SCALES(16)));
            }];
            [self.vip mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.realPerson.mas_right).offset(SCALES(4));
                make.centerY.equalTo(self.realPerson);
                make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
            }];
        } else {
            [self.vip mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nickName);
                make.top.equalTo(self.nickName.mas_bottom).offset(SCALES(7));
                make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
            }];
        }
    }
}

- (void)setModel:(ASDynamicListModel *)model {
    _model = model;
    [self.header setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar]] placeholder:nil];
    self.nickName.text = STRING(model.nickname);
    self.isBeckon = model.is_beckon;
    if (model.gender == 2) {
        self.genderIcon.image = [UIImage imageNamed:@"man2"];
    } else {
        self.genderIcon.image = [UIImage imageNamed:@"woman2"];
    }
    if (kAppType == 0) {
        self.zhaohuBtn.hidden = [model.user_id isEqualToString:USER_INFO.user_id] ? YES : NO;
    } else {
        self.zhaohuBtn.hidden = YES;
    }
    if (model.vip == 1) {
        self.nickName.textColor = RED_COLOR;
        self.vip.hidden = NO;
    } else {
        self.nickName.textColor = TITLE_COLOR;
        self.vip.hidden = YES;
    }
    self.realName.hidden = !model.is_auth;
    self.realPerson.hidden = !model.is_rp_auth;
}

- (void)setIsBeckon:(BOOL)isBeckon {
    _isBeckon = isBeckon;
    if (isBeckon == 1) {
        [self.zhaohuBtn setBackgroundImage:[UIImage imageNamed:@"sixin_icon"] forState:UIControlStateNormal];
    } else {
        [self.zhaohuBtn setBackgroundImage:[UIImage imageNamed:@"dashan_icon"] forState:UIControlStateNormal];
    }
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.layer.cornerRadius = SCALES(8);
        _header.layer.masksToBounds = YES;
        _header.contentMode = UIViewContentModeScaleAspectFill;
        _header.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_header addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            [ASMyAppCommonFunc goPersonalHomeWithUserID:wself.model.user_id viewController:[ASCommonFunc currentVc] action:^(id  _Nonnull data) {
                NSString *str = data;
                if ([str isEqualToString:@"beckon"]) {
                    wself.model.is_beckon = 1;
                    wself.isBeckon = 1;
                }
            }];
        }];
    }
    return _header;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc]init];
        _nickName.font = TEXT_MEDIUM(16);
        _nickName.textColor = TITLE_COLOR;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_nickName addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            [ASMyAppCommonFunc goPersonalHomeWithUserID:wself.model.user_id viewController:[ASCommonFunc currentVc] action:^(id  _Nonnull data) {
                NSString *str = data;
                if ([str isEqualToString:@"beckon"]) {
                    wself.model.is_beckon = 1;
                    wself.isBeckon = 1;
                }
            }];
        }];
    }
    return _nickName;
}

- (UIImageView *)genderIcon {
    if (!_genderIcon) {
        _genderIcon = [[UIImageView alloc]init];
    }
    return _genderIcon;
}

- (UIImageView *)realName {
    if (!_realName) {
        _realName = [[UIImageView alloc]init];
        _realName.image = [UIImage imageNamed:@"personal_shiming"];
        _realName.hidden = YES;
    }
    return _realName;
}

- (UIImageView *)realPerson {
    if (!_realPerson) {
        _realPerson = [[UIImageView alloc]init];
        _realPerson.image = [UIImage imageNamed:@"personal_zhenren"];
        _realPerson.hidden = YES;
    }
    return _realPerson;
}

- (UIButton *)zhaohuBtn {
    if (!_zhaohuBtn) {
        _zhaohuBtn = [[UIButton alloc]init];
        _zhaohuBtn.hidden = YES;
        _zhaohuBtn.adjustsImageWhenHighlighted = NO;
        if (kAppType == 0) {
            _zhaohuBtn.hidden = NO;
        } else {
            _zhaohuBtn.hidden = YES;
        }
        kWeakSelf(self);
        [[_zhaohuBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.model.is_beckon == 0) {
                [ASMyAppCommonFunc greetWithUserID:wself.model.user_id action:^(id  _Nonnull data) {
                    wself.model.is_beckon = 1;
                    [wself.zhaohuBtn setBackgroundImage:[UIImage imageNamed:@"sixin_icon"] forState:UIControlStateNormal];
                    wself.isBeckon = 1;
                }];
            } else {
                [ASMyAppCommonFunc chatWithUserID:wself.model.user_id nickName:wself.model.nickname action:^(id  _Nonnull data) {
                    
                }];
            }
        }];
    }
    return _zhaohuBtn;
}
- (UIImageView *)vip {
    if (!_vip) {
        _vip = [[UIImageView alloc]init];
        _vip.image = [UIImage imageNamed:@"vip"];
        _vip.hidden = YES;
    }
    return _vip;
}
@end
