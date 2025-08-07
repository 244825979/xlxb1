//
//  ASVipDetailsTopView.m
//  AS
//
//  Created by SA on 2025/6/27.
//

#import "ASVipDetailsTopView.h"

@interface ASVipDetailsTopView()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *text;
@end

@implementation ASVipDetailsTopView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.bgView];
        [self addSubview:self.icon];
        [self.bgView addSubview:self.nickName];
        [self.bgView addSubview:self.text];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(6));
        make.left.mas_equalTo(SCALES(19));
        make.height.mas_equalTo(SCALES(60));
        make.width.mas_equalTo(SCALES(175));
    }];
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(65));
        make.left.mas_equalTo(SCALES(19));
        make.height.mas_equalTo(SCALES(25));
    }];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickName.mas_bottom).offset(SCALES(6));
        make.left.equalTo(self.nickName);
        make.height.mas_equalTo(SCALES(20));
    }];
}

- (void)setModel:(ASVipUserInfoModel *)model {
    _model = model;
    self.nickName.text = STRING(model.nickname);
    if (model.vip_id == 1) {
        self.text.text = STRING(model.expire_time);
    } else {
        self.text.text = @"您还未开通会员哦~";
    }
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
        _bgView.userInteractionEnabled = YES;
        _bgView.image = [UIImage imageNamed:@"vip_user"];
    }
    return _bgView;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.image = [UIImage imageNamed:@"vip_tequan"];
    }
    return _icon;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc] init];
        _nickName.textColor = UIColorRGB(0x4F0000);
        _nickName.font = TEXT_MEDIUM(18);
        _nickName.text = @"用户昵称";
    }
    return _nickName;
}

- (UILabel *)text {
    if (!_text) {
        _text = [[UILabel alloc] init];
        _text.textColor = UIColorRGB(0x4F0000);
        _text.font = TEXT_FONT_15;
        if (USER_INFO.vip == 1) {
            _text.text = @"会员到期时间：00-00-00";
        } else {
            _text.text = @"您还未开通会员哦~";
        }
    }
    return _text;
}

@end
