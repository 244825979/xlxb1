//
//  ASNewUserPopView.m
//  AS
//
//  Created by AS on 2025/3/7.
//

#import "ASNewUserPopView.h"

@interface ASNewUserPopView ()

@end

@implementation ASNewUserPopView

- (instancetype)initNewUserGiftViewWithModel:(ASNewUserGiftModel *)model {
    if (self = [super init]) {
        kWeakSelf(self);
        self.size = CGSizeMake(SCALES(295), SCALES(375));
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"new_gift_bg"];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        ASNewUserGiftView *oneGift = [[ASNewUserGiftView alloc] init];
        oneGift.backgroundColor = UIColor.whiteColor;
        oneGift.layer.masksToBounds = YES;
        oneGift.layer.cornerRadius = SCALES(10);
        oneGift.layer.borderColor = UIColorRGB(0xFF5266).CGColor;
        oneGift.layer.borderWidth = SCALES(1);
        [self addSubview:oneGift];
        if (model.list.count > 1) {
            oneGift.model = model.list[0];
            [oneGift mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(SCALES(155));
                make.left.mas_equalTo(SCALES(46));
                make.size.mas_equalTo(CGSizeMake(SCALES(92), SCALES(98)));
            }];
            ASNewUserGiftView *twoGift = [[ASNewUserGiftView alloc] init];
            twoGift.model = model.list[1];
            twoGift.backgroundColor = UIColor.whiteColor;
            twoGift.layer.masksToBounds = YES;
            twoGift.layer.cornerRadius = SCALES(10);
            twoGift.layer.borderColor = UIColorRGB(0xFF5266).CGColor;
            twoGift.layer.borderWidth = SCALES(1);
            [self addSubview:twoGift];
            [twoGift mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.width.height.equalTo(oneGift);
                make.right.equalTo(self).offset(SCALES(-46));
            }];
        } else {
            oneGift.model = model.list[0];
            [oneGift mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(SCALES(155));
                make.centerX.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(SCALES(92), SCALES(98)));
            }];
        }
        UIButton *getBtn = [[UIButton alloc] init];
        [getBtn setBackgroundImage:[UIImage imageNamed:@"new_gift_btn"] forState:UIControlStateNormal];
        getBtn.adjustsImageWhenHighlighted = NO;
        [self addSubview:getBtn];
        [getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(277));
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCALES(167), SCALES(46)));
        }];
        [[getBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.closeBlock) {
                [wself removeView];
                wself.closeBlock();
            }
        }];
        UILabel *hintText = [[UILabel alloc] init];
        hintText.text = @"可前往【私信】-【礼物】-【背包】中查看";
        hintText.textColor = TEXT_SIMPLE_COLOR;
        hintText.font = TEXT_FONT_13;
        [self addSubview:hintText];
        [hintText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(getBtn.mas_bottom).offset(SCALES(16));
            make.centerX.equalTo(self);
            make.height.mas_equalTo(SCALES(20));
        }];
    }
    return self;
}

- (void)removeView {
    [self removeFromSuperview];
}
@end

@interface ASNewUserGiftView ()
@property (nonatomic, strong) UILabel *bottomTitle;
@property (nonatomic, strong) UIImageView *giftIcon;
@property (nonatomic, copy) UILabel *acount;
@end

@implementation ASNewUserGiftView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.bottomTitle];
    [self addSubview:self.giftIcon];
    [self addSubview:self.acount];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bottomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(SCALES(31));
    }];
    [self.giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(11));
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(SCALES(55));
    }];
    self.acount.frame = CGRectMake(self.width - SCALES(32), 0, SCALES(32), SCALES(18));
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.acount.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(SCALES(9), SCALES(9))];
     CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.acount.bounds;
    maskLayer.path = maskPath.CGPath;
    self.acount.layer.mask = maskLayer;
}

- (void)setModel:(ASNewUserGiftListModel *)model {
    _model = model;
    self.bottomTitle.text = STRING(model.name);
    [self.giftIcon sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, STRING(model.img)]]];
    self.acount.text = [NSString stringWithFormat:@"x%zd", model.num];
}

- (UILabel *)bottomTitle {
    if (!_bottomTitle) {
        _bottomTitle = [[UILabel alloc]init];
        _bottomTitle.textColor = MAIN_COLOR;
        _bottomTitle.font = TEXT_MEDIUM(14);
        _bottomTitle.backgroundColor = UIColorRGB(0xFFE6E9);
        _bottomTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomTitle;
}

- (UIImageView *)giftIcon {
    if (!_giftIcon) {
        _giftIcon = [[UIImageView alloc]init];
        _giftIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _giftIcon;
}

- (UILabel *)acount {
    if (!_acount) {
        _acount = [[UILabel alloc]init];
        _acount.textColor = UIColorRGB(0x66340F);
        _acount.backgroundColor = UIColorRGB(0xFFD80D);
        _acount.font = TEXT_FONT_12;
        _acount.textAlignment = NSTextAlignmentCenter;
    }
    return _acount;
}
@end
