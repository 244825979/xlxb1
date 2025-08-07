//
//  ASBalanceListCell.m
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASPayBalanceListCell.h"

@interface ASPayBalanceListCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *firstIcon;
@property (nonatomic, strong) UIImageView *moneyIcon;
@property (nonatomic, strong) UILabel *gold;
@property (nonatomic, strong) UILabel *give;
@property (nonatomic, strong) UIImageView *giveBg;
@property (nonatomic, strong) UILabel *money;
@end

@implementation ASPayBalanceListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.firstIcon];
        [self.contentView addSubview:self.giveBg];
        [self.contentView addSubview:self.give];
        [self.bgView addSubview:self.moneyIcon];
        [self.bgView addSubview:self.gold];
        [self.bgView addSubview:self.money];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.firstIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(72), SCALES(24)));
    }];
    [self.gold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView).offset(SCALES(14));
        make.top.mas_equalTo(SCALES(27));
        make.height.mas_equalTo(SCALES(34));
    }];
    [self.moneyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.gold.mas_left).offset(SCALES(-6));
        make.centerY.equalTo(self.gold);
        make.width.height.mas_equalTo(SCALES(22));
    }];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-SCALES(18));
        make.height.mas_equalTo(SCALES(20));
    }];
    [self.give mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.height.mas_equalTo(SCALES(22));
        make.width.mas_lessThanOrEqualTo(self.bgView.mas_width);//最大宽度限制
    }];
    [self.giveBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.give);
    }];
}

- (void)setModel:(ASGoodsListModel *)model {
    _model = model;
    if (model.btn_text.count > 0) {
        NSString *text = model.btn_text[0];
        self.give.hidden = kStringIsEmpty(text) ? YES : NO;
        self.giveBg.hidden = kStringIsEmpty(text) ? YES : NO;
        self.give.text = [NSString stringWithFormat:@"   %@   ", STRING(text)];
    } else {
        self.giveBg.hidden = YES;
        self.give.hidden = YES;
    }
    self.money.text = [NSString stringWithFormat:@"￥%zd", model.price];
    self.gold.text = [NSString stringWithFormat:@"%zd",model.amount];
    self.firstIcon.hidden = kStringIsEmpty(model.first_recharge) ? YES : NO;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = SCALES(12);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderColor = UIColorRGB(0xF5F5F5).CGColor;
        _bgView.layer.borderWidth = SCALES(2);
        _bgView.backgroundColor = UIColorRGB(0xF5F5F5);
    }
    return _bgView;
}

- (UIImageView *)moneyIcon {
    if (!_moneyIcon) {
        _moneyIcon = [[UIImageView alloc]init];
        _moneyIcon.image = [UIImage imageNamed:@"money"];
    }
    return _moneyIcon;
}

- (UIImageView *)firstIcon {
    if (!_firstIcon) {
        _firstIcon = [[UIImageView alloc]init];
        _firstIcon.image = [UIImage imageNamed:@"pay_first"];
    }
    return _firstIcon;
}

- (UILabel *)money {
    if (!_money) {
        _money = [[UILabel alloc]init];
        _money.text = @"￥0";
        _money.textColor = TEXT_COLOR;
        _money.font = TEXT_FONT_15;
        _money.textAlignment = NSTextAlignmentCenter;
    }
    return _money;
}

- (UILabel *)gold {
    if (!_gold) {
        _gold = [[UILabel alloc]init];
        _gold.text = @"0";
        _gold.textColor = TITLE_COLOR;
        _gold.font = TEXT_MEDIUM(22);
    }
    return _gold;
}

- (UILabel *)give {
    if (!_give) {
        _give = [[UILabel alloc]init];
        _give.text = @"赠送金币";
        _give.textColor = UIColorRGB(0x66340F);
        _give.font = TEXT_MEDIUM(11);
        _give.textAlignment = NSTextAlignmentCenter;
    }
    return _give;
}

- (UIImageView *)giveBg {
    if (!_giveBg) {
        _giveBg = [[UIImageView alloc]init];
        _giveBg.image = [UIImage imageNamed:@"pay_give"];
        _giveBg.hidden = YES;
    }
    return _giveBg;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.bgView.backgroundColor = UIColorRGB(0xFFF1F1);
        self.bgView.layer.borderColor = UIColorRGB(0xFD6E6A).CGColor;
        self.gold.textColor = UIColorRGB(0xFD6E6A);
    } else {
        self.bgView.backgroundColor = UIColorRGB(0xF5F5F5);
        self.bgView.layer.borderColor = UIColorRGB(0xF5F5F5).CGColor;
        self.gold.textColor = TITLE_COLOR;
    }
}
@end
