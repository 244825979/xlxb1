//
//  ASVideoShowMyListCell.m
//  AS
//
//  Created by SA on 2025/5/13.
//

#import "ASVideoShowMyListCell.h"

@interface ASVideoShowMyListCell ()
@property (nonatomic, strong) UIImageView *coverImage;
@property (nonatomic, strong) UILabel *coverText;
@property (nonatomic, strong) UIImageView *playIcon;
@property (nonatomic, strong) UILabel *playAcont;
@property (nonatomic, strong) UIImageView *lockIcon;
@property (nonatomic, strong) UILabel *status;
@end

@implementation ASVideoShowMyListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.coverImage];
        [self.coverImage addSubview:self.coverText];
        [self.coverImage addSubview:self.playIcon];
        [self.coverImage addSubview:self.playAcont];
        [self.coverImage addSubview:self.lockIcon];
        [self.coverImage addSubview:self.status];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.coverText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(5));
        make.top.mas_equalTo(SCALES(5));
        make.size.mas_equalTo(CGSizeMake(SCALES(28), SCALES(16)));
    }];
    [self.playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(6));
        make.bottom.equalTo(self.coverImage).offset(SCALES(-7));
        make.size.mas_equalTo(CGSizeMake(SCALES(14), SCALES(14)));
    }];
    [self.playAcont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playIcon.mas_right).offset(SCALES(2));
        make.centerY.equalTo(self.playIcon);
        make.right.equalTo(self.coverImage).offset(SCALES(-12));
    }];
    [self.lockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.coverImage);
        make.top.mas_equalTo(SCALES(5));
        make.size.mas_equalTo(CGSizeMake(SCALES(26), SCALES(22)));
    }];
    [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.coverImage).offset(SCALES(-5));
        make.top.mas_equalTo(SCALES(5));
        make.size.mas_equalTo(CGSizeMake(SCALES(36), SCALES(16)));
    }];
}

- (void)setModel:(ASVideoShowDataModel *)model {
    _model = model;
    if (model.is_cover.integerValue == 1) {
        self.coverText.hidden = NO;
    } else {
        self.coverText.hidden = YES;
    }
    if (model.show_status.integerValue == 1) {
        self.lockIcon.hidden = YES;
    } else {
        self.lockIcon.hidden = NO;
    }
    if (model.audit_status.integerValue == 0) {
        self.status.hidden = NO;
        self.playAcont.hidden = YES;
        self.playIcon.hidden = YES;
    } else {
        self.status.hidden = YES;
        self.playAcont.hidden = NO;
        self.playIcon.hidden = NO;
    }
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString: STRING(model.cover_img_url)]];
    self.playAcont.text = [ASCommonFunc changeNumberAcount: model.play_num];
}

- (UIImageView *)coverImage {
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc]init];
        _coverImage.contentMode = UIViewContentModeScaleAspectFill;
        _coverImage.layer.cornerRadius = SCALES(6);
        _coverImage.layer.masksToBounds = YES;
    }
    return _coverImage;
}

- (UILabel *)coverText {
    if (!_coverText) {
        _coverText = [[UILabel alloc]init];
        _coverText.text = @"封面";
        _coverText.backgroundColor = MAIN_COLOR;
        _coverText.textColor = UIColor.whiteColor;
        _coverText.font = TEXT_FONT_10;
        _coverText.textAlignment = NSTextAlignmentCenter;
        _coverText.layer.cornerRadius = SCALES(4);
        _coverText.layer.masksToBounds = YES;
        _coverText.hidden = YES;
    }
    return _coverText;
}

- (UIImageView *)playIcon {
    if (!_playIcon) {
        _playIcon = [[UIImageView alloc]init];
        _playIcon.image = [UIImage imageNamed:@"video_play1"];
        _playIcon.hidden = YES;
    }
    return _playIcon;
}

- (UILabel *)playAcont {
    if (!_playAcont) {
        _playAcont = [[UILabel alloc]init];
        _playAcont.text = @"0";
        _playAcont.textColor = UIColor.whiteColor;
        _playAcont.font = TEXT_FONT_12;
        _playAcont.hidden = YES;
    }
    return _playAcont;
}

- (UIImageView *)lockIcon {
    if (!_lockIcon) {
        _lockIcon = [[UIImageView alloc]init];
        _lockIcon.image = [UIImage imageNamed:@"video_lock2"];
        _lockIcon.hidden = YES;
    }
    return _lockIcon;
}

- (UILabel *)status {
    if (!_status) {
        _status = [[UILabel alloc]init];
        _status.text = @"审核中";
        _status.backgroundColor = UIColorRGB(0xFAAC16);
        _status.textColor = UIColor.whiteColor;
        _status.font = TEXT_FONT_10;
        _status.textAlignment = NSTextAlignmentCenter;
        _status.layer.cornerRadius = SCALES(4);
        _status.layer.masksToBounds = YES;
        _status.hidden = YES;
    }
    return _status;
}
@end
