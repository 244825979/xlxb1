//
//  ASVipDetailsGoodsView.m
//  AS
//
//  Created by SA on 2025/6/27.
//

#import "ASVipDetailsGoodsView.h"

@interface ASVipDetailsGoodsView()
@property (nonatomic, strong) UIView *itemBg;
@property (nonatomic, strong) ASVipGoodsItemView *selectItem;
@end

@implementation ASVipDetailsGoodsView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.itemBg];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.itemBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(32));
        make.top.equalTo(self);
        make.height.mas_equalTo(SCALES(128));
    }];
}

- (void)setList:(NSArray<ASVipGoodsModel *> *)list {
    _list = list;
    CGFloat viewH = SCALES(128);
    CGFloat viewW = (SCREEN_WIDTH - SCALES(32) - SCALES(20))/3;
    kWeakSelf(self);
    for (int i = 0; i < list.count; i++) {
        ASVipGoodsModel *model = list[i];
        ASVipGoodsItemView *view = [[ASVipGoodsItemView alloc] init];
        view.model = model;
        view.frame = CGRectMake((viewW + SCALES(10)) * i, 0, viewW, viewH);
        [self.itemBg addSubview:view];
        if (model.vip_suggest == 1) {
            view.isSelect = YES;
            self.selectItem = view;
        }
        view.itemBlock = ^(ASVipGoodsItemView * _Nonnull backView) {
            if (wself.selectItem == backView) {
                return;
            }
            backView.isSelect = YES;
            wself.selectItem.isSelect = NO;
            wself.selectItem = backView;
            if (wself.itemBlock) {
                wself.itemBlock(backView.model);
            }
        };
    }
}

- (UIView *)itemBg {
    if (!_itemBg) {
        _itemBg = [[UIView alloc] init];
    }
    return _itemBg;
}

@end

@interface ASVipGoodsItemView ()
@property (nonatomic, strong) UIImageView *recommendIcon;//推荐提示
@property (nonatomic, strong) UIImageView *bgImageView;//内容背景
@property (nonatomic, strong) UILabel *time;//时间
@property (nonatomic, strong) UILabel *acount;//实际金额
@property (nonatomic, strong) UILabel *originalCost;//原价
@property (nonatomic, strong) UILabel *economize;//节省
@end

@implementation ASVipGoodsItemView
- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.bgImageView];
        [self addSubview:self.recommendIcon];
        [self.bgImageView addSubview:self.time];
        [self.bgImageView addSubview:self.acount];
        [self.bgImageView addSubview:self.originalCost];
        [self.bgImageView addSubview:self.economize];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.itemBlock) {
                wself.itemBlock(wself);
            }
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.mas_equalTo(SCALES(8));
    }];
    [self.recommendIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.height.mas_equalTo(SCALES(20));
        make.width.mas_equalTo(SCALES(62));
    }];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView);
        make.top.mas_equalTo(SCALES(17));
        make.height.mas_equalTo(SCALES(14));
        make.width.equalTo(self.bgImageView);
    }];
    [self.acount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView).offset(SCALES(-2));
        make.top.mas_equalTo(SCALES(41));
        make.height.mas_equalTo(SCALES(20));
        make.width.equalTo(self.bgImageView.mas_width).offset(SCALES(-2));
    }];
    [self.economize mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView);
        make.top.mas_equalTo(SCALES(73));
        make.height.mas_equalTo(SCALES(20));
        make.width.mas_equalTo(SCALES(63));
    }];
    [self.originalCost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView);
        make.top.mas_equalTo(SCALES(97));
        make.height.mas_equalTo(SCALES(14));
    }];
}

- (void)setModel:(ASVipGoodsModel *)model {
    _model = model;
    self.time.text = STRING(model.vip_duration);
    self.economize.text = STRING(model.province);
    NSString *amountStr = [NSString stringWithFormat:@"￥ %zd", model.price];
    NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:amountStr];
    [amountAtt addAttribute:NSFontAttributeName
                      value:TEXT_FONT_12
                      range:NSMakeRange(0, 2)];
    [self.acount setAttributedText:amountAtt];
    NSMutableAttributedString *marketPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价%zd元", model.old_price]];
    [marketPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, marketPrice.length)];
    self.originalCost.attributedText = marketPrice;
    if (model.vip_suggest == 1) {
        self.recommendIcon.hidden = NO;
    } else {
        self.recommendIcon.hidden = YES;
    }
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    if (isSelect) {
        self.bgImageView.image = [UIImage imageNamed:@"vip_sel"];
        self.time.textColor = UIColorRGB(0x571D03);
        self.acount.textColor = UIColorRGB(0xFD6A00);
        self.economize.textColor = UIColor.whiteColor;
        self.economize.backgroundColor = UIColorRGB(0x711402);
        self.originalCost.textColor = UIColorRGB(0x8F4242);
    } else {
        self.bgImageView.image = [UIImage imageNamed:@"vip_sel1"];
        self.time.textColor = UIColorRGB(0xFDE6E6);
        self.acount.textColor = UIColorRGB(0xFDE6E6);
        self.economize.textColor = UIColorRGB(0x181826);
        self.economize.backgroundColor = UIColorRGB(0xFDE6E6);
        self.originalCost.textColor = UIColorRGB(0xCBB6AB);
    }
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"vip_sel1"];
    }
    return _bgImageView;
}

- (UIImageView *)recommendIcon {
    if (!_recommendIcon) {
        _recommendIcon = [[UIImageView alloc]init];
        _recommendIcon.image = [UIImage imageNamed:@"vip_xingjiabi"];
    }
    return _recommendIcon;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.text = @"1个月";
        _time.textColor = UIColorRGB(0xFDE6E6);
        _time.font = TEXT_FONT_12;
        _time.textAlignment = NSTextAlignmentCenter;
    }
    return _time;
}

- (UILabel *)acount {
    if (!_acount) {
        _acount = [[UILabel alloc]init];
        _acount.text = @"￥0";
        _acount.textColor = UIColorRGB(0xFDE6E6);
        _acount.font = TEXT_MEDIUM(22);
        _acount.textAlignment = NSTextAlignmentCenter;
    }
    return _acount;
}

- (UILabel *)economize {
    if (!_economize) {
        _economize = [[UILabel alloc]init];
        _economize.text = @"立省0元";
        _economize.textColor = UIColorRGB(0x181826);
        _economize.backgroundColor = UIColorRGB(0xFDE6E6);
        _economize.font = TEXT_FONT_10;
        _economize.textAlignment = NSTextAlignmentCenter;
        _economize.layer.cornerRadius = SCALES(10);
        _economize.layer.masksToBounds = YES;
    }
    return _economize;
}

- (UILabel *)originalCost {
    if (!_originalCost) {
        _originalCost = [[UILabel alloc]init];
        _originalCost.text = @"原价0.0";
        _originalCost.textColor = UIColorRGB(0xCBB6AB);
        _originalCost.font = TEXT_FONT_10;
        _originalCost.textAlignment = NSTextAlignmentCenter;
    }
    return _originalCost;
}
@end
