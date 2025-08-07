//
//  ASDaySignInAlertView.m
//  AS
//
//  Created by SA on 2025/4/18.
//

#import "ASDaySignInAlertView.h"

@implementation ASDaySignInAlertView

//构造方法
- (instancetype)initWithDaySignInModel:(nullable ASSignInGiftModel *)model {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor clearColor];
        self.size = CGSizeMake(SCALES(307), SCALES(345));
        UIImageView *bgImage = [[UIImageView alloc] init];
        bgImage.image = [UIImage imageNamed:@"sign_bg"];
        bgImage.userInteractionEnabled = YES;
        [self addSubview:bgImage];
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UIView *giftBg = [[UIView alloc] init];
        giftBg.layer.cornerRadius = SCALES(12);
        giftBg.backgroundColor = UIColorRGB(0xF5F5F5);
        [self addSubview:giftBg];
        [giftBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(122));
            make.centerX.equalTo(bgImage);
            make.size.mas_equalTo(CGSizeMake(SCALES(127), SCALES(133)));
        }];
        
        UIImageView *giftIcon = [[UIImageView alloc]init];
        [giftIcon sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.img]]];
        giftIcon.contentMode = UIViewContentModeScaleAspectFill;
        [giftBg addSubview:giftIcon];
        [giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(24));
            make.centerX.equalTo(giftBg);
            make.height.width.mas_equalTo(SCALES(75));
        }];
        
        UIButton *acount = [[UIButton alloc]init];
        [acount setBackgroundImage:[UIImage imageNamed:@"sign_acount"] forState:UIControlStateNormal];
        [acount setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        acount.titleLabel.font = TEXT_FONT_12;
        [acount setTitle:[NSString stringWithFormat:@"x%zd",model.money] forState:UIControlStateNormal];
        [giftBg addSubview:acount];
        [acount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(giftBg);
            make.size.mas_equalTo(CGSizeMake(SCALES(36), SCALES(24)));
        }];
        
        UILabel *content = [[UILabel alloc]init];
        content.font = TEXT_FONT_14;
        content.text = [NSString stringWithFormat:@"第%zd天", model.number];
        content.textAlignment = NSTextAlignmentCenter;
        content.textColor = TITLE_COLOR;
        [giftBg addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(giftIcon.mas_bottom).offset(SCALES(6));
            make.centerX.equalTo(giftBg);
            make.height.mas_equalTo(SCALES(22));
        }];
        
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirm setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        confirm.adjustsImageWhenHighlighted = NO;
        confirm.layer.cornerRadius = SCALES(25);
        confirm.layer.masksToBounds = YES;
        [confirm setTitle:@"收下啦" forState:UIControlStateNormal];
        confirm.titleLabel.font = TEXT_FONT_18;
        [bgImage addSubview:confirm];
        [[confirm rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.affirmBlock) {
                wself.affirmBlock();
            }
        }];
        [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(SCALES(-16));
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCALES(227), SCALES(50)));
        }];
    }
    return self;
}

//构造方法 签到列表弹窗
- (instancetype)initWithSignInListModel:(nullable ASSignInModel *)model {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor clearColor];
        self.size = CGSizeMake(SCALES(307), SCALES(407));
        UIImageView *bgImage = [[UIImageView alloc] init];
        bgImage.image = [UIImage imageNamed:@"sign_bg1"];
        bgImage.userInteractionEnabled = YES;
        [self addSubview:bgImage];
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        UILabel *content = [[UILabel alloc]init];
        content.font = TEXT_FONT_14;
        content.textColor = TITLE_COLOR;
        NSString *todayCount = [NSString stringWithFormat:@"%zd",model.today_count];
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已连续签到 %@ 天，立即签到领取奖励", todayCount]];
        [attributed addAttribute:NSForegroundColorAttributeName
                           value:MAIN_COLOR
                           range:NSMakeRange(6, todayCount.length)];
        [attributed addAttribute:NSFontAttributeName
                           value:TEXT_MEDIUM(24)
                           range:NSMakeRange(6, todayCount.length)];
        [content setAttributedText:attributed];
        [self addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(110));
            make.left.mas_equalTo(SCALES(20));
            make.height.mas_equalTo(SCALES(24));
        }];
        UIView *contentBgView = [[UIView alloc]init];
        [self addSubview:contentBgView];
        [contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(150));
            make.left.mas_equalTo(SCALES(15));
            make.right.offset(SCALES(-15));
            make.height.mas_equalTo(SCALES(175));
        }];
        CGFloat viewH = SCALES(84);
        CGFloat viewW = SCALES(64);
        for (int i = 0; i < model.today.count; i++) {
            ASSignInListModel *listModel = model.today[i];
            UIView *contentView = [[UIView alloc] init];
            contentView.layer.cornerRadius = SCALES(8);
            contentView.layer.masksToBounds = YES;
            [contentBgView addSubview:contentView];
            if (i < 6) {
                contentView.frame = CGRectMake((i%4) * (viewW + SCALES(7)), (i/4) * (viewH + SCALES(7)), viewW, viewH);
            } else {
                contentView.frame = CGRectMake(SCALES(142), viewH + SCALES(7), SCALES(135), viewH);
            }
            UILabel *state = [[UILabel alloc]init];
            state.textColor = TITLE_COLOR;
            state.font = TEXT_FONT_12;
            state.textAlignment = NSTextAlignmentCenter;
            [contentView addSubview:state];
            [state mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(SCALES(8));
                make.centerX.equalTo(contentView);
                make.height.mas_equalTo(SCALES(12));
            }];
            UIImageView *goldIcon = [[UIImageView alloc]init];
            goldIcon.contentMode = UIViewContentModeScaleAspectFit;
            [contentView addSubview:goldIcon];
            [goldIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(SCALES(27));
                make.centerX.equalTo(contentView);
                make.height.mas_equalTo(SCALES(30));
            }];
            UILabel *acount = [[UILabel alloc]init];
            acount.textColor = TEXT_SIMPLE_COLOR;
            acount.font = TEXT_FONT_12;
            acount.textAlignment = NSTextAlignmentCenter;
            acount.adjustsFontSizeToFitWidth = YES;//字体自适应属性
            acount.minimumScaleFactor = 0.5f;//自适应最小字体缩放比例
            [contentView addSubview:acount];
            [acount mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(goldIcon.mas_bottom).offset(SCALES(3));
                make.left.right.equalTo(contentView);
                make.height.mas_equalTo(SCALES(12));
            }];
            if (listModel.list.count > 0) {
                ASSignInGiftModel *giftModel = listModel.list[0];
                acount.text = STRING(giftModel.title);
                [goldIcon sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, giftModel.img]]];
            }
            if (listModel.now_day && !listModel.status) {//当天未签到
                contentView.backgroundColor = UIColorRGB(0xFFF1F3);
                state.text = @"今天";
                state.textColor = MAIN_COLOR;
                acount.textColor = MAIN_COLOR;
            } else if (i >= model.today_count){//大于今天
                contentView.backgroundColor = UIColorRGB(0xF5F5F5);
                state.text = [NSString stringWithFormat:@"第%d天", i + 1];
                state.textColor = TEXT_SIMPLE_COLOR;
                acount.textColor = TEXT_SIMPLE_COLOR;
            } else {//已经签到
                contentView.backgroundColor = UIColorRGB(0xF5F5F5);
                state.text = @"已签";
                state.textColor = MAIN_COLOR;
                acount.textColor = MAIN_COLOR;
            }
        }
        
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        confirm.adjustsImageWhenHighlighted = NO;
        if (model.today_status == NO) {
            [confirm setTitle:@"签到" forState:UIControlStateNormal];
            [confirm setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            [confirm setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        } else {
            [confirm setTitle:@"已签到" forState:UIControlStateNormal];
            [confirm setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
            [confirm setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
        }
        confirm.titleLabel.font = TEXT_FONT_18;
        confirm.layer.cornerRadius = SCALES(25);
        confirm.layer.masksToBounds = YES;
        [self addSubview:confirm];
        [[confirm rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.affirmBlock) {
                wself.affirmBlock();
                [wself removeView];
            }
        }];
        [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentBgView.mas_bottom).offset(SCALES(16));
            make.centerX.equalTo(bgImage);
            make.size.mas_equalTo(CGSizeMake(SCALES(227), SCALES(50)));
        }];
    }
    return self;
}

- (void)removeView {
    [self removeFromSuperview];
}
@end
