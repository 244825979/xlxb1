//
//  ASWithdrawBalanceTopView.m
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASWithdrawBalanceTopView.h"

@interface ASWithdrawBalanceTopView ()
@property (nonatomic, strong) UIImageView *acountBgView;//余额背景
@property (nonatomic, strong) UILabel *acountTitle;//可提现余额标题
@property (nonatomic, strong) UILabel *acount;//可提现金额
@property (nonatomic, strong) UILabel *freeze;//冻结余额
@property (nonatomic, strong) UILabel *dayEarning;//今日收益
@property (nonatomic, strong) UILabel *sevenDayEarning;//近7日收益
@property (nonatomic, strong) UIButton *withdrawBtn;//提现
@property (nonatomic, strong) UIButton *conversionBtn;//兑换
@property (nonatomic, strong) UIImageView *indicateView;
@end

@implementation ASWithdrawBalanceTopView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.acountBgView];
        [self.acountBgView addSubview:self.acountTitle];
        [self.acountBgView addSubview:self.acount];
        [self.acountBgView addSubview:self.freeze];
        [self.acountBgView addSubview:self.dayEarning];
        [self.acountBgView addSubview:self.sevenDayEarning];
        [self addSubview:self.withdrawBtn];
        [self addSubview:self.conversionBtn];
        [self addSubview:self.indicateView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.acountBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(SCALES(14));
        make.right.equalTo(self).offset(SCALES(-16));
        make.height.mas_equalTo(SCALES(124));
    }];
    [self.acountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(SCALES(16));
        make.height.mas_equalTo(SCALES(18));
    }];
    [self.acount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.acountTitle);
        make.top.equalTo(self.acountTitle.mas_bottom).offset(SCALES(6));
        make.height.mas_equalTo(SCALES(45));
    }];
    [self.freeze mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acount.mas_right).offset(SCALES(5));
        make.bottom.equalTo(self.acount);
        make.height.mas_equalTo(SCALES(18));
    }];
    [self.dayEarning mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.mas_equalTo(SCALES(90));
        make.height.mas_equalTo(SCALES(18));
    }];
    [self.sevenDayEarning mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(169));
        make.centerY.equalTo(self.dayEarning);
        make.height.mas_equalTo(SCALES(18));
    }];
    [self.withdrawBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acountBgView.mas_bottom).offset(SCALES(14));
        make.centerX.equalTo(self.acountBgView).offset(SCALES(-50));
        make.height.mas_equalTo(SCALES(22));
        make.width.mas_equalTo(SCALES(100));
    }];
    [self.conversionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.withdrawBtn);
        make.centerX.equalTo(self.acountBgView).offset(SCALES(50));
        make.height.mas_equalTo(SCALES(22));
        make.width.mas_equalTo(SCALES(100));
    }];
    if (self.withdrawBtn.selected == YES) {
        [self.indicateView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.acountBgView.mas_bottom).offset(SCALES(37));
            make.centerX.equalTo(self.withdrawBtn);
            make.size.mas_equalTo(CGSizeMake(SCALES(24), SCALES(8)));
        }];
    }
    if (self.conversionBtn.selected == YES) {
        [self.indicateView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.acountBgView.mas_bottom).offset(SCALES(37));
            make.centerX.equalTo(self.conversionBtn);
            make.size.mas_equalTo(CGSizeMake(SCALES(24), SCALES(8)));
        }];
    }
}

- (void)setModel:(ASAccountMoneyModel *)model {
    _model = model;
    self.dayEarning.text = [NSString stringWithFormat:@"今日收益：%@",model.today_income];
    self.sevenDayEarning.text = [NSString stringWithFormat:@"近7日收益：%@",model.hebdo_income];
    if (model.freeze_money.floatValue > 0) {
        self.freeze.hidden = NO;
        self.freeze.text = [NSString stringWithFormat:@"【冻结余额：%@元】",model.freeze_money];
    } else {
        self.freeze.hidden = YES;
    }
    NSString *amountStr = [NSString stringWithFormat:@"¥ %@",model.income_coin_money];
    NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:amountStr];
    [amountAtt addAttribute:NSFontAttributeName
                      value:TEXT_FONT_16
                      range:NSMakeRange(0, 2)];
    [self.acount setAttributedText:amountAtt];
    self.dayEarning.hidden = USER_INFO.gender == 2 ? YES : NO;
    self.sevenDayEarning.hidden = USER_INFO.gender == 2 ? YES : NO;
}

- (UIImageView *)acountBgView {
    if (!_acountBgView) {
        _acountBgView = [[UIImageView alloc]init];
        _acountBgView.image = [UIImage imageNamed:@"withdraw_top1"];
    }
    return _acountBgView;
}

- (UILabel *)acountTitle {
    if (!_acountTitle) {
        _acountTitle = [[UILabel alloc]init];
        _acountTitle.text = @"可提现余额";
        _acountTitle.textColor = UIColor.whiteColor;
        _acountTitle.font = TEXT_FONT_13;
    }
    return _acountTitle;
}

- (UILabel *)acount {
    if (!_acount) {
        _acount = [[UILabel alloc]init];
        _acount.text = @"¥0";
        _acount.textColor = UIColor.whiteColor;
        _acount.font = TEXT_MEDIUM(32);
    }
    return _acount;
}

- (UILabel *)freeze {
    if (!_freeze) {
        _freeze = [[UILabel alloc]init];
        _freeze.text = @"(冻结余额：0.0元)";
        _freeze.textColor = UIColor.whiteColor;
        _freeze.font = TEXT_FONT_13;
        _freeze.hidden = YES;
    }
    return _freeze;
}

- (UILabel *)dayEarning {
    if (!_dayEarning) {
        _dayEarning = [[UILabel alloc]init];
        _dayEarning.text = @"今日收益：";
        _dayEarning.textColor = UIColor.whiteColor;
        _dayEarning.font = TEXT_FONT_13;
    }
    return _dayEarning;
}

- (UILabel *)sevenDayEarning {
    if (!_sevenDayEarning) {
        _sevenDayEarning = [[UILabel alloc]init];
        _sevenDayEarning.text = @"近7日收益：";
        _sevenDayEarning.textColor = UIColor.whiteColor;
        _sevenDayEarning.font = TEXT_FONT_13;
    }
    return _sevenDayEarning;
}

- (UIButton *)withdrawBtn {
    if (!_withdrawBtn) {
        _withdrawBtn = [[UIButton alloc]init];
        [_withdrawBtn setTitle:@"积分兑现" forState:UIControlStateNormal];
        [_withdrawBtn setBackgroundColor:UIColor.whiteColor];
        _withdrawBtn.titleLabel.font = TEXT_MEDIUM(20);
        [_withdrawBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        [_withdrawBtn setTitleColor:TITLE_COLOR forState:UIControlStateSelected];
        _withdrawBtn.selected = YES;
        kWeakSelf(self);
        [[_withdrawBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.withdrawBtn.selected == YES) {
                return;
            }
            [wself.indicateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.acountBgView.mas_bottom).offset(SCALES(37));
                make.centerX.equalTo(wself.withdrawBtn);
                make.size.mas_equalTo(CGSizeMake(SCALES(24), SCALES(8)));
            }];
            if (wself.clikedBlock) {
                wself.withdrawBtn.selected = YES;
                wself.withdrawBtn.titleLabel.font = TEXT_MEDIUM(20);
                wself.conversionBtn.selected = NO;
                wself.conversionBtn.titleLabel.font = TEXT_FONT_16;
                wself.clikedBlock(@"积分兑现");
            }
        }];
    }
    return _withdrawBtn;
}

- (UIButton *)conversionBtn {
    if (!_conversionBtn) {
        _conversionBtn = [[UIButton alloc]init];
        [_conversionBtn setTitle:@"兑换金币" forState:UIControlStateNormal];
        [_conversionBtn setBackgroundColor:UIColor.clearColor];
        _conversionBtn.titleLabel.font = TEXT_FONT_16;
        [_conversionBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        [_conversionBtn setTitleColor:TITLE_COLOR forState:UIControlStateSelected];
        kWeakSelf(self);
        [[_conversionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.conversionBtn.selected == YES) {
                return;
            }
            [wself.indicateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.acountBgView.mas_bottom).offset(SCALES(37));
                make.centerX.equalTo(wself.conversionBtn);
                make.size.mas_equalTo(CGSizeMake(SCALES(24), SCALES(8)));
            }];
            if (wself.clikedBlock) {
                wself.withdrawBtn.selected = NO;
                wself.withdrawBtn.titleLabel.font = TEXT_FONT_16;
                wself.conversionBtn.selected = YES;
                wself.conversionBtn.titleLabel.font = TEXT_MEDIUM(20);
                wself.clikedBlock(@"兑换金币");
            }
        }];
    }
    return _conversionBtn;
}

- (UIImageView *)indicateView {
    if (!_indicateView) {
        _indicateView = [[UIImageView alloc]init];
        _indicateView.image = [UIImage imageNamed:@"bottom_icon"];
    }
    return _indicateView;
}
@end
