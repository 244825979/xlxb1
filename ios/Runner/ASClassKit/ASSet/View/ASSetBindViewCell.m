//
//  ASSetBindViewCell.m
//  AS
//
//  Created by SA on 2025/7/23.
//

#import "ASSetBindViewCell.h"

@interface ASSetBindViewCell ()
@property (nonatomic, strong) UIImageView *titleIcon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *rightText;
@property (nonatomic, strong) UIImageView *backIcon;
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UIButton *goBind;
@end

@implementation ASSetBindViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleIcon];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.rightText];
        [self.contentView addSubview:self.backIcon];
        [self.contentView addSubview:self.header];
        [self.contentView addSubview:self.goBind];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.type == kBindTypePhone) {
        [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(16));
            make.centerY.equalTo(self.contentView);
        }];
        [self.backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(SCALES(20), SCALES(20)));
            make.right.equalTo(self.contentView).offset(SCALES(-12));
        }];
        [self.rightText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.backIcon.mas_left).offset(SCALES(-6));
        }];
    } else {
        [self.titleIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(16));
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(SCALES(28), SCALES(26)));
        }];
        [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleIcon.mas_right).offset(SCALES(4));
            make.centerY.equalTo(self.titleIcon);
        }];
        [self.rightText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(SCALES(-20));
        }];
        [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.rightText.mas_left).offset(SCALES(-8));
            make.size.mas_equalTo(CGSizeMake(SCALES(30), SCALES(30)));
        }];
        [self.goBind mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(SCALES(-16));
            make.size.mas_equalTo(CGSizeMake(SCALES(70), SCALES(30)));
        }];
    }
}

- (void)setType:(ASBindCellType)type {
    _type = type;
    switch (type) {
        case kBindTypePhone:
            self.titleIcon.hidden = YES;
            self.title.text = @"手机号";
            self.backIcon.hidden = NO;
            self.rightText.hidden = NO;
            if (kStringIsEmpty(self.model.mobile)) {
                self.backIcon.image = [UIImage imageNamed:@"cell_back3"];
                self.rightText.text = @"去绑定";
                self.rightText.textColor = RED_COLOR;
            } else {
                self.backIcon.image = [UIImage imageNamed:@"cell_back2"];
                self.rightText.text = self.model.mobile;
                self.rightText.textColor = TITLE_COLOR;
            }
            break;
        case kBindTypeWX:
            self.titleIcon.hidden = NO;
            self.titleIcon.image = [UIImage imageNamed:@"bind_wx"];
            self.title.text = @"微信";
            self.backIcon.hidden = YES;
            if (kStringIsEmpty(self.model.wechat)) {
                self.header.hidden = YES;
                self.rightText.hidden = YES;
                self.goBind.hidden = NO;
            } else {
                self.header.hidden = NO;
                self.rightText.hidden = NO;
                self.goBind.hidden = YES;
                self.rightText.text = self.model.wechat.length > 10 ? [self.model.wechat substringToIndex:10] : STRING(self.model.wechat);
                [self.header sd_setImageWithURL:[NSURL URLWithString:self.model.avatar]];
            }
            break;
        default:
            break;
    }
}

- (void)setModel:(ASSetBindStateModel *)model {
    _model = model;
}

- (UIImageView *)titleIcon {
    if (!_titleIcon) {
        _titleIcon = [[UIImageView alloc] init];
        _titleIcon.hidden = YES;
    }
    return _titleIcon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = TEXT_FONT_15;
        _title.textColor = TITLE_COLOR;
    }
    return _title;
}

- (UILabel *)rightText {
    if (!_rightText) {
        _rightText = [[UILabel alloc]init];
        _rightText.font = TEXT_FONT_14;
        _rightText.textColor = TITLE_COLOR;
        _rightText.textAlignment = NSTextAlignmentRight;
        _rightText.hidden = YES;
    }
    return _rightText;
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.contentMode = UIViewContentModeScaleAspectFill;
        _header.hidden = YES;
        _header.layer.cornerRadius = SCALES(15);
        _header.layer.masksToBounds = YES;
    }
    return _header;
}

- (UIImageView *)backIcon {
    if (!_backIcon) {
        _backIcon = [[UIImageView alloc]init];
        _backIcon.image = [UIImage imageNamed:@"cell_back3"];
        _backIcon.hidden = YES;
    }
    return _backIcon;
}

- (UIButton *)goBind {
    if (!_goBind) {
        _goBind = [[UIButton alloc]init];
        [_goBind setTitle:@"去绑定" forState:UIControlStateNormal];
        [_goBind setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        _goBind.adjustsImageWhenHighlighted = NO;
        _goBind.titleLabel.font = TEXT_FONT_14;
        _goBind.layer.cornerRadius = SCALES(15);
        _goBind.layer.masksToBounds = YES;
        _goBind.hidden = YES;
        kWeakSelf(self);
        [[_goBind rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (kStringIsEmpty(wself.model.wechat)) {
                [[ASLoginManager shared] weChatBindWithSuccess:^(id  _Nonnull response) {
                    NSString *nickname = STRING(response[@"nickname"]);
                    NSString *headimgurl = STRING(response[@"headimgurl"]);
                    wself.header.hidden = NO;
                    wself.rightText.hidden = NO;
                    wself.goBind.hidden = YES;
                    wself.model.wechat = nickname;
                    wself.model.avatar = headimgurl;
                    wself.rightText.text = wself.model.wechat.length > 10 ? [wself.model.wechat substringToIndex:10] : STRING(wself.model.wechat);
                    [wself.header sd_setImageWithURL:[NSURL URLWithString:wself.model.avatar]];
                }];
            }
        }];
    }
    return _goBind;
}


@end
