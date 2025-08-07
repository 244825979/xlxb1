//
//  ASCallUserView.m
//  AS
//
//  Created by SA on 2025/5/19.
//

#import "ASCallUserView.h"

@interface ASCallUserView()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UIImageView *zhenren;
@property (nonatomic, strong) UIImageView *shiming;
@property (nonatomic, strong) UILabel *content;
@end

@implementation ASCallUserView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.header];
        [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCALES(106), SCALES(106)));
        }];
        [self addSubview:self.stackView];
        [self.stackView addArrangedSubview:self.nickName];
        [self.stackView addArrangedSubview:self.zhenren];
        [self.stackView addArrangedSubview:self.shiming];
        [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.header.mas_bottom).offset(SCALES(14));
        }];
        [self.zhenren mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCALES(40), SCALES(16)));
        }];
        [self.shiming mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCALES(40), SCALES(16)));
        }];
        [self addSubview:self.content];
        [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.stackView.mas_bottom).offset(SCALES(10));
            make.height.mas_equalTo(SCALES(22));
        }];
    }
    return self;
}
- (void)setIsCaller:(BOOL)isCaller {
    _isCaller = isCaller;
}

- (void)setModel:(ASCallRtcDataModel *)model {
    _model = model;
    if (self.isCaller) {
        [self.header sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.from_avatar]]];
        self.nickName.text = model.from_nickname;
        NSString *text;
        if (!kStringIsEmpty(model.from_age_text)) {
            text = model.from_age_text;
        }
        if (!kStringIsEmpty(model.from_height)) {
            text = [NSString stringWithFormat:@"%@ | %@", text, model.from_height];
        }
        if (!kStringIsEmpty(model.from_occupation)) {
            text = [NSString stringWithFormat:@"%@ | %@", text, model.from_occupation];
        }
        if (!kStringIsEmpty(text)) {
            self.content.text = text;
            self.content.hidden = NO;
        }
    } else {
        [self.header sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.to_avatar]]];
        self.nickName.text = model.to_nickname;
        NSString *text;
        if (!kStringIsEmpty(model.to_age_text)) {
            text = model.to_age_text;
        }
        if (!kStringIsEmpty(model.to_height)) {
            text = [NSString stringWithFormat:@"%@ | %@", text, model.to_height];
        }
        if (!kStringIsEmpty(model.to_occupation)) {
            text = [NSString stringWithFormat:@"%@ | %@", text, model.to_occupation];
        }
        if (!kStringIsEmpty(text)) {
            self.content.text = text;
            self.content.hidden = NO;
        }
    }
}

- (void)setUserInfo:(ASUserInfoModel *)userInfo {
    _userInfo = userInfo;
    self.zhenren.hidden = NO;
    self.shiming.hidden = NO;
    [self.header sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, userInfo.avatar]]];
    self.nickName.text = userInfo.nickname;
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.layer.cornerRadius = SCALES(53);
        _header.layer.masksToBounds = YES;
        _header.layer.borderColor = UIColor.whiteColor.CGColor;
        _header.layer.borderWidth = SCALES(1);
        _header.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _header;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc]init];
        _nickName.textColor = UIColor.whiteColor;
        _nickName.font = TEXT_FONT_16;
    }
    return _nickName;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc]init];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.spacing = SCALES(6);
    }
    return _stackView;
}

- (UIImageView *)zhenren {
    if (!_zhenren) {
        _zhenren = [[UIImageView alloc]init];
        _zhenren.image = [UIImage imageNamed:@"personal_zhenren"];
        _zhenren.contentMode = UIViewContentModeScaleAspectFill;
        _zhenren.hidden = YES;
        [_zhenren setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _zhenren;
}

- (UIImageView *)shiming {
    if (!_shiming) {
        _shiming = [[UIImageView alloc]init];
        _shiming.image = [UIImage imageNamed:@"personal_shiming"];
        _shiming.contentMode = UIViewContentModeScaleAspectFill;
        _shiming.hidden = YES;
        [_shiming setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _shiming;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.textColor = UIColor.whiteColor;
        _content.font = TEXT_FONT_16;
        _content.hidden = YES;
    }
    return _content;
}
@end
