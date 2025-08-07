//
//  ASReceiveGiftPopView.m
//  AS
//
//  Created by AS on 2025/5/11.
//

#import "ASReceiveGiftPopView.h"

@implementation ASReceiveGiftPopView

- (instancetype)initReceiveGiftPopViewWithModel:(ASGiftListModel *)model {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor clearColor];
        self.size = CGSizeMake(SCALES(307), SCALES(341));
        UIImageView *bgImageView = [[UIImageView alloc] init];
        bgImageView.image = [UIImage imageNamed:@"vip_receive"];
        bgImageView.userInteractionEnabled = YES;
        [self addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        UIView *giftBg = [[UIView alloc] init];
        giftBg.layer.cornerRadius = SCALES(15);
        giftBg.backgroundColor = UIColor.whiteColor;
        [bgImageView addSubview:giftBg];
        [giftBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(66));
            make.centerX.equalTo(bgImageView);
            make.size.mas_equalTo(CGSizeMake(SCALES(127), SCALES(133)));
        }];
        UIImageView *giftIcon = [[UIImageView alloc]init];
        [giftIcon sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.img]]];
        giftIcon.contentMode = UIViewContentModeScaleAspectFill;
        [giftBg addSubview:giftIcon];
        [giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(giftBg);
            make.height.width.mas_equalTo(SCALES(85));
        }];
        UIButton *acount = [[UIButton alloc]init];
        [acount setBackgroundImage:[UIImage imageNamed:@"vip_number"] forState:UIControlStateNormal];
        [acount setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        acount.titleLabel.font = TEXT_FONT_12;
        [acount setTitle:[NSString stringWithFormat:@"x%zd",model.num] forState:UIControlStateNormal];
        [giftBg addSubview:acount];
        [acount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(giftBg);
            make.size.mas_equalTo(CGSizeMake(SCALES(40), SCALES(22)));
        }];
        UILabel *content = [[UILabel alloc]init];
        content.font = TEXT_FONT_14;
        content.text = [NSString stringWithFormat:@"%@", model.name];
        content.textAlignment = NSTextAlignmentCenter;
        content.textColor = TITLE_COLOR;
        [self addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(giftBg.mas_bottom).offset(SCALES(7));
            make.centerX.equalTo(giftBg);
            make.height.mas_equalTo(SCALES(22));
        }];
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirm setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        confirm.adjustsImageWhenHighlighted = NO;
        confirm.layer.cornerRadius = SCALES(25);
        confirm.layer.masksToBounds = YES;
        [confirm setTitle:@"立即领取" forState:UIControlStateNormal];
        confirm.titleLabel.font = TEXT_FONT_18;
        [bgImageView addSubview:confirm];
        [[confirm rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.affirmBlock) {
                wself.affirmBlock();
            }
        }];
        [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(SCALES(-44));
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCALES(227), SCALES(50)));
        }];
        UILabel *hint = [[UILabel alloc]init];
        hint.font = TEXT_FONT_14;
        hint.textAlignment = NSTextAlignmentCenter;
        hint.text = @"礼物领取后在【礼物】-【背包】中查看";
        hint.textColor = TEXT_SIMPLE_COLOR;
        [bgImageView addSubview:hint];
        [hint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(confirm.mas_bottom);
            make.centerX.bottom.equalTo(bgImageView);
        }];
    }
    return self;
}

@end
