//
//  ASHomeUserListCell.m
//  AS
//
//  Created by SA on 2025/4/16.
//

#import "ASHomeUserListCell.h"

@interface ASHomeUserListCell ()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UIImageView *onlineView;
@property (nonatomic, strong) UIImageView *shadowImage;//阴影
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UIButton *dashanBtn;
@property (nonatomic, strong) UILabel *userIntroduction;//用户简介
@end

@implementation ASHomeUserListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.cover];
        [self.cover addSubview:self.onlineView];
        [self.cover addSubview:self.shadowImage];
        [self.shadowImage addSubview:self.userName];
        [self.shadowImage addSubview:self.dashanBtn];
        [self.shadowImage addSubview:self.userIntroduction];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.cover mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(SCALES(-9));
    }];
    [self.onlineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(SCALES(8));
        make.size.mas_equalTo(CGSizeMake(SCALES(38), SCALES(16)));
    }];
    [self.shadowImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.cover);
        make.height.mas_equalTo(SCALES(56));
    }];
    if (self.isCall == NO) {
        [self.dashanBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(8));
            make.right.offset(SCALES(-6));
            make.height.mas_equalTo(SCALES(20));
            make.width.mas_equalTo(SCALES(51));
        }];
    } else {
        [self.dashanBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(8));
            make.right.offset(SCALES(-6));
            make.height.mas_equalTo(SCALES(32));
            make.width.mas_equalTo(SCALES(32));
        }];
    }
    [self.userName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dashanBtn);
        make.left.mas_equalTo(SCALES(6));
        make.right.equalTo(self.dashanBtn.mas_left).offset(SCALES(-6));
    }];
    [self.userIntroduction mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName);
        make.bottom.equalTo(self.shadowImage).offset(SCALES(-8));
        make.right.offset(self.isCall == YES ? SCALES(-30) : SCALES(-8));
    }];
}

- (void)setIsBeckon:(NSInteger)isBeckon {
    _isBeckon = isBeckon;
    if (self.isCall == NO) {
        if (isBeckon == 0) {
            [self.dashanBtn setBackgroundImage:[UIImage imageNamed:@"dashan_icon"] forState:UIControlStateNormal];
        } else {
            [self.dashanBtn setBackgroundImage:[UIImage imageNamed:@"sixin_icon"] forState:UIControlStateNormal];
        }
    }
}

- (void)setIsCall:(BOOL)isCall {
    _isCall = isCall;
    if (isCall) {
        [self.dashanBtn setBackgroundImage:[UIImage imageNamed:@"home_call"] forState:UIControlStateNormal];
    }
}

- (void)setModel:(ASHomeUserListModel *)model {
    _model = model;
    [self.cover setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar]] placeholder:nil];
    self.userName.text = STRING(model.nickname);
    self.userIntroduction.text = [NSString stringWithFormat:@"%zd岁", model.age];
    if (model.isHeight == YES && kStringIsEmpty(model.occupation)) {
        self.userIntroduction.text = [NSString stringWithFormat:@"%zd岁 | %@", model.age, model.height];
    } else if (model.isHeight == YES && !kStringIsEmpty(model.occupation)) {
        self.userIntroduction.text = [NSString stringWithFormat:@"%zd岁 | %@ | %@", model.age, model.height, model.occupation];
    } else if (model.isHeight == NO && !kStringIsEmpty(model.occupation)) {
        self.userIntroduction.text = [NSString stringWithFormat:@"%zd岁 | %@", model.age, model.occupation];
    }
    if (model.is_online == 1) {
        self.onlineView.hidden = NO;
    } else {
        self.onlineView.hidden = YES;
    }
    self.isBeckon = model.is_beckon;
//    self.userName.textColor = model.is_vip == YES ? RED_COLOR : UIColor.whiteColor;
}

- (UIImageView *)cover {
    if (!_cover) {
        _cover = [[UIImageView alloc]init];
        _cover.layer.cornerRadius = SCALES(8);
        _cover.clipsToBounds = YES;
        _cover.contentMode = UIViewContentModeScaleAspectFill;
        _cover.userInteractionEnabled = YES;
    }
    return _cover;
}

- (UIImageView *)shadowImage {
    if (!_shadowImage) {
        _shadowImage = [[UIImageView alloc]init];
        _shadowImage.image = [UIImage imageNamed:@"shadow"];
        _shadowImage.userInteractionEnabled = YES;
    }
    return _shadowImage;
}

- (UIImageView *)onlineView {
    if (!_onlineView) {
        _onlineView = [[UIImageView alloc]init];
        _onlineView.hidden = YES;
        _onlineView.image = [UIImage imageNamed:@"online"];
        _onlineView.userInteractionEnabled = YES;
    }
    return _onlineView;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc]init];
        _userName.textColor = UIColor.whiteColor;
        _userName.font = TEXT_MEDIUM(16);
    }
    return _userName;
}

- (UILabel *)userIntroduction {
    if (!_userIntroduction) {
        _userIntroduction = [[UILabel alloc]init];
        _userIntroduction.textColor = UIColor.whiteColor;
        _userIntroduction.font = TEXT_FONT_13;
    }
    return _userIntroduction;
}

- (UIButton *)dashanBtn {
    if (!_dashanBtn) {
        _dashanBtn = [[UIButton alloc]init];
        _dashanBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_dashanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.isCall) {
                [ASMyAppCommonFunc callWithUserID:wself.model.ID
                                         callType:kCallTypeVideo
                                            scene:Call_Scene_QuickCall
                                             back:^(BOOL isSucceed) {
                    
                }];
            } else {
                if (wself.model.is_beckon == 0) {
                    [ASMyAppCommonFunc greetWithUserID:wself.model.ID action:^(id  _Nonnull data) {
                        wself.model.is_beckon = 1;
                        wself.isBeckon = 1;
                        [wself.dashanBtn setBackgroundImage:[UIImage imageNamed:@"sixin_icon"] forState:UIControlStateNormal];
                    }];
                } else {
                    [ASMyAppCommonFunc chatWithUserID:wself.model.ID nickName:wself.model.nickname action:^(id  _Nonnull data) {
                        
                    }];
                }
            }
        }];
    }
    return _dashanBtn;
}

@end
