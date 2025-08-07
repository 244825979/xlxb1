//
//  ASMineAccountView.m
//  AS
//
//  Created by SA on 2025/4/18.
//

#import "ASMineAccountView.h"

@interface ASMineAccountView()
@property (nonatomic, strong) ASMineAccountItemView *moneyView;//充值金币
@property (nonatomic, strong) ASMineAccountItemView *earnings;//我的收益
@property (nonatomic, strong) UIView *lineView;
@end

@implementation ASMineAccountView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.moneyView];
        [self addSubview:self.earnings];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.moneyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
    }];
    [self.earnings mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.left.equalTo(self.moneyView.mas_right);
        make.width.equalTo(self.moneyView);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(1), SCALES(30)));
    }];
}

- (void)setModel:(ASAccountMoneyModel *)model {
    _model = model;
    self.moneyView.acount = model.coin;
    self.earnings.acount = model.income_coin_money;
}

- (ASMineAccountItemView *)moneyView {
    if (!_moneyView) {
        _moneyView = [[ASMineAccountItemView alloc]init];
        _moneyView.title.text = @"充值金币";
        _moneyView.icon.image = [UIImage imageNamed:@"mine_pay"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_moneyView addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.indexNameBlock) {
                wself.indexNameBlock(@"充值金币");
            }
        }];
    }
    return _moneyView;
}

- (ASMineAccountItemView *)earnings {
    if (!_earnings) {
        _earnings = [[ASMineAccountItemView alloc]init];
        _earnings.title.text = @"我的收益";
        _earnings.icon.image = [UIImage imageNamed:@"mine_shouyi"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_earnings addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.indexNameBlock) {
                wself.indexNameBlock(@"我的收益");
            }
        }];
    }
    return _earnings;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = LINE_COLOR;
    }
    return _lineView;
}
@end


@implementation ASMineAccountItemView
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.icon];
        [self addSubview:self.title];
        [self addSubview:self.content];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.offset(SCALES(8));
        make.size.mas_equalTo(CGSizeMake(SCALES(70), SCALES(70)));
    }];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(SCALES(5));
        make.top.mas_equalTo(SCALES(15));
        make.height.mas_equalTo(SCALES(16));
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.title);
        make.top.mas_equalTo(SCALES(34));
        make.height.mas_equalTo(SCALES(20));
    }];
}

- (void)setAcount:(NSString *)acount {
    _acount = acount;
    self.content.text = STRING(acount);
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.textColor = TITLE_COLOR;
        _title.font = TEXT_FONT_13;
    }
    return _title;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.text = @"0";
        _content.textColor = MAIN_COLOR;
        _content.font = TEXT_MEDIUM(17);
        _content.adjustsFontSizeToFitWidth = YES;//字体自适应属性
        _content.minimumScaleFactor = 0.5f;//自适应最小字体缩放比例
    }
    return _content;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}
@end
