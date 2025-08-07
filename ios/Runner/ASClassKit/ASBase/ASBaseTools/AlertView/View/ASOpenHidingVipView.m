//
//  ASOpenHidingVipView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASOpenHidingVipView.h"

@implementation ASOpenHidingVipView

- (instancetype)initOpenHidingVipView {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        self.layer.cornerRadius = SCALES(12);
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"hiden_pop"];
        icon.userInteractionEnabled = YES;
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(20));
            make.centerX.equalTo(self);
            make.height.width.mas_equalTo(SCALES(75));
        }];
        UILabel *title = [[UILabel alloc]init];
        title.font = TEXT_MEDIUM(18);
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"对指定人隐身";
        title.textColor = TITLE_COLOR;
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(icon.mas_bottom).offset(SCALES(20));
            make.height.mas_equalTo(SCALES(28));
            make.centerX.equalTo(icon);
        }];
        UILabel *content = [[UILabel alloc]init];
        content.font = TEXT_FONT_14;
        content.textAlignment = NSTextAlignmentCenter;
        content.text = @"开通VIP会员，解锁对指定人隐身特权";
        content.textColor = TITLE_COLOR;
        [self addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(SCALES(20));
            make.height.mas_equalTo(SCALES(20));
            make.centerX.equalTo(icon);
        }];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:closeBtn];
        closeBtn.titleLabel.font = TEXT_FONT_18;
        [closeBtn setTitle:@"再想想" forState:UIControlStateNormal];
        closeBtn.layer.cornerRadius = SCALES(25);
        closeBtn.layer.masksToBounds = YES;
        [closeBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        [closeBtn setBackgroundColor:UIColorRGB(0xEEEEEE)];
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
        }];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(25));
            make.top.equalTo(content.mas_bottom).offset(SCALES(20));
            make.height.mas_equalTo(SCALES(50));
        }];
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:submitBtn];
        submitBtn.titleLabel.font = TEXT_FONT_18;
        [submitBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        submitBtn.layer.cornerRadius = SCALES(25);
        submitBtn.layer.masksToBounds = YES;
        [submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        submitBtn.adjustsImageWhenHighlighted = NO;
        [[submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.affirmBlock) {
                [wself removeView];
                wself.affirmBlock();
            }
        }];
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.width.equalTo(closeBtn);
            make.left.equalTo(closeBtn.mas_right).offset(SCALES(13));
            make.right.equalTo(self).offset(SCALES(-25));
        }];
        self.size = CGSizeMake(SCALES(307), SCALES(273));
    }
    return self;
}

- (void)removeView {
    [self removeFromSuperview];
}
@end
