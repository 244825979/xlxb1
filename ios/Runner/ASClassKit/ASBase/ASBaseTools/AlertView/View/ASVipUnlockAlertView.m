//
//  ASVipUnlockAlertView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASVipUnlockAlertView.h"

@implementation ASVipUnlockAlertView

- (instancetype)initVipUnlock {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = SCALES(12);
        self.size = CGSizeMake(SCALES(311), SCALES(314));
        UIImageView *bgImage = [[UIImageView alloc] init];
        bgImage.image = [UIImage imageNamed:@"unlock_bg"];
        bgImage.userInteractionEnabled = YES;
        [self addSubview:bgImage];
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = TEXT_MEDIUM(18);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"解锁访客记录";
        titleLabel.textColor = TITLE_COLOR;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(148));
            make.height.mas_equalTo(SCALES(28));
            make.centerX.equalTo(self);
        }];
        UILabel *contentLabel = [[UILabel alloc]init];
        contentLabel.font = TEXT_FONT_14;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.text = @"开通VIP会员，不错过每一段缘分";
        contentLabel.textColor = UIColorRGB(0x333333);
        [self addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(SCALES(16));
            make.height.mas_equalTo(SCALES(24));
            make.centerX.equalTo(self);
        }];
        UIButton *openBtn = [[UIButton alloc]init];
        [openBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        openBtn.titleLabel.font = TEXT_FONT_18;
        [openBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        openBtn.adjustsImageWhenHighlighted = NO;
        openBtn.layer.cornerRadius = SCALES(25);
        openBtn.layer.masksToBounds = YES;
        [[openBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.affirmBlock) {
                wself.affirmBlock();
                [wself removeView];
            }
        }];
        [self addSubview:openBtn];
        [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).offset(SCALES(24));
            make.size.mas_equalTo(CGSizeMake(SCALES(227), SCALES(50)));
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (void)removeView {
    [self removeFromSuperview];
}
@end
