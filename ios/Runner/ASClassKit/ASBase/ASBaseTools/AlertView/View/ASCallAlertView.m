//
//  ASCallAlertView.m
//  AS
//
//  Created by SA on 2025/5/19.
//

#import "ASCallAlertView.h"

@implementation ASCallAlertView
- (instancetype)initCallViewWithModel:(ASRtcAnchorPriceModel *)model {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor whiteColor];
        self.size = CGSizeMake(SCREEN_WIDTH, SCALES(174) + TAB_BAR_MAGIN);
        ASCallCellView *videoView = [[ASCallCellView alloc]init];
        videoView.type = kCallTypeVideo;
        videoView.model = model;
        videoView.cliledBlock = ^{
            [wself removeView];
            wself.affirmBlock(kCallTypeVideo);
        };
        [self addSubview:videoView];
        [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(14));
            make.left.right.equalTo(self);
            make.height.mas_equalTo(SCALES(50));
        }];
        ASCallCellView *voiceView = [[ASCallCellView alloc]init];
        voiceView.type = kCallTypeVoice;
        voiceView.model = model;
        voiceView.cliledBlock = ^{
            [wself removeView];
            wself.affirmBlock(kCallTypeVoice);
        };
        [self addSubview:voiceView];
        [voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(videoView.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(SCALES(50));
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = BACKGROUNDCOLOR;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(voiceView.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(SCALES(10));
        }];
        UIButton *closeBtn = [[UIButton alloc] init];
        closeBtn.titleLabel.font = TEXT_FONT_18;
        [closeBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
        }];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(SCALES(50));
        }];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(SCALES(14), SCALES(14))];
         CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
    return self;
}

- (void)removeView {
    [self removeFromSuperview];
}
@end


@interface ASCallCellView()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *discount;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *vipContent;
@end

@implementation ASCallCellView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.icon];
        [self addSubview:self.title];
        [self addSubview:self.discount];
        kWeakSelf(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (USER_INFO.gender == 1) {
                if (wself.model.is_lock == YES) {
                    return;
                }
            }
            if (wself.cliledBlock) {
                wself.cliledBlock();
            }
        }];
    }
    return self;
}

- (void)setModel:(ASRtcAnchorPriceModel *)model {
    _model = model;
    if (USER_INFO.gender == 1) {
        if (model.is_lock == YES) {
            self.icon.image = [UIImage imageNamed:@"lock_cell"];
            self.discount.hidden = NO;
            self.discount.text = [NSString stringWithFormat:@"  %@  ", STRING(model.lock_tips)];
        } else {
            self.discount.hidden = YES;
        }
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self).offset(SCALES(12));
        }];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.title.mas_left).offset(-SCALES(4));
            make.centerY.equalTo(self.title);
            make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
        }];
    } else {
        [self addSubview:self.content];
        [self addSubview:self.vipContent];
        if (self.type == kCallTypeVideo) {
            if (!kStringIsEmpty(model.video_price)) {
                self.content.hidden = NO;
                self.content.text = STRING(model.video_price);
            } else {
                self.content.hidden = YES;
            }
            if (kStringIsEmpty(model.video_free)) {
                self.vipContent.hidden = YES;
            } else {
                self.vipContent.hidden = NO;
                self.vipContent.text = STRING(model.video_free);
            }
            if (kStringIsEmpty(model.video_vip_txt)) {
                self.discount.hidden = YES;
            } else {
                self.discount.hidden = NO;
                self.discount.text = [NSString stringWithFormat:@"  %@  ", STRING(model.video_vip_txt)];
            }
        } else {
            if (!kStringIsEmpty(model.voice_price)) {
                self.content.hidden = NO;
                self.content.text = STRING(model.voice_price);
            } else {
                self.content.hidden = YES;
            }
            if (kStringIsEmpty(model.voice_free)) {
                self.vipContent.hidden = YES;
            } else {
                self.vipContent.hidden = NO;
                self.vipContent.text = STRING(model.voice_free);
            }
            if (kStringIsEmpty(model.voice_vip_txt)) {
                self.discount.hidden = YES;
            } else {
                self.discount.hidden = NO;
                self.discount.text = [NSString stringWithFormat:@"  %@  ", STRING(model.voice_vip_txt)];
            }
        }
        if ((self.type == kCallTypeVideo && kStringIsEmpty(self.model.video_price) && kStringIsEmpty(self.model.video_free)) ||
            (self.type == kCallTypeVoice && kStringIsEmpty(self.model.voice_price) && kStringIsEmpty(self.model.voice_free))) {
            [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.centerX.equalTo(self).offset(SCALES(12));
            }];
        } else {
            [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(SCALES(7));
                make.centerX.equalTo(self).offset(SCALES(-10));
                make.height.mas_equalTo(SCALES(16));
            }];
        }
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.title.mas_left).offset(-SCALES(8));
            make.centerY.equalTo(self.title);
            make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
        }];
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title).offset(SCALES(10));
            make.top.equalTo(self.title.mas_bottom).offset(SCALES(4));
            make.height.mas_equalTo(SCALES(16));
        }];
        if (self.content.hidden == NO) {
            [self.vipContent mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.content.mas_right).offset(SCALES(4));
                make.centerY.equalTo(self.content);
            }];
        } else {
            [self.vipContent mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.title.mas_right);
                make.top.equalTo(self.title.mas_bottom).offset(SCALES(4));
                make.height.mas_equalTo(SCALES(16));
            }];
        }
    }
    if (self.discount.hidden == false) {
        [self.discount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_right).offset(SCALES(4));
            make.centerY.equalTo(self.title);
            make.height.mas_equalTo(SCALES(16));
        }];
    }
}

- (void)setType:(ASCallType)type {
    _type = type;
    if (type == kCallTypeVideo) {
        self.title.text = @"视频通话";
        self.icon.image = [UIImage imageNamed:@"video_cell"];
    } else {
        self.title.text = @"语音通话";
        self.icon.image = [UIImage imageNamed:@"phone_cell"];
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
        _title = [[UILabel alloc]init];
        _title.textColor = TITLE_COLOR;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = TEXT_FONT_16;
    }
    return _title;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.textColor = TEXT_SIMPLE_COLOR;
        _content.font = TEXT_FONT_12;
        _content.hidden = YES;
    }
    return _content;
}

- (UILabel *)vipContent {
    if (!_vipContent) {
        _vipContent = [[UILabel alloc]init];
        _vipContent.textColor = RED_COLOR;
        _vipContent.font = TEXT_FONT_12;
        _vipContent.hidden = YES;
    }
    return _vipContent;
}

- (UILabel *)discount {
    if (!_discount) {
        _discount = [[UILabel alloc]init];
        _discount.font = TEXT_FONT_10;
        _discount.textColor = UIColorRGB(0x624F26);
        _discount.backgroundColor = UIColorRGB(0xFED546);
        _discount.hidden = YES;
        _discount.layer.masksToBounds = YES;
        _discount.layer.cornerRadius = SCALES(5);
    }
    return _discount;
}
@end
