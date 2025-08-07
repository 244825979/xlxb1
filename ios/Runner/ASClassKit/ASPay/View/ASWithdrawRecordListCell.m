//
//  ASWithdrawRecordListCell.m
//  AS
//
//  Created by SA on 2025/6/27.
//

#import "ASWithdrawRecordListCell.h"

@interface ASWithdrawRecordListCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *money;
@property (nonatomic, strong) UILabel *realCashMoney;
@property (nonatomic, strong) UILabel *cardAccount;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *orderNo;
@property (nonatomic, strong) UILabel *status;
@property (nonatomic, strong) UIView *line;
@end

@implementation ASWithdrawRecordListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.money];
        [self.bgView addSubview:self.realCashMoney];
        [self.bgView addSubview:self.cardAccount];
        [self.bgView addSubview:self.time];
        [self.bgView addSubview:self.orderNo];
        [self.bgView addSubview:self.status];
        [self.bgView addSubview:self.line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(SCALES(184));
    }];
    [self.status mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(14));
        make.width.mas_equalTo(SCALES(75));
        make.right.equalTo(self.bgView.mas_right).offset(SCALES(-14));
    }];
    [self.money mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.top.mas_equalTo(SCALES(14));
        make.height.mas_equalTo(SCALES(20));
    }];
    [self.realCashMoney mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.money);
        make.top.equalTo(self.money.mas_bottom).offset(SCALES(14));
    }];
    [self.cardAccount mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.money);
        make.top.equalTo(self.realCashMoney.mas_bottom).offset(SCALES(14));
    }];
    [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.money);
        make.top.equalTo(self.cardAccount.mas_bottom).offset(SCALES(14));
    }];
    [self.orderNo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.money);
        make.top.equalTo(self.time.mas_bottom).offset(SCALES(14));
    }];
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.right.equalTo(self.bgView).offset(SCALES(-14));
        make.bottom.equalTo(self.bgView);
        make.height.mas_equalTo(SCALES(0.5));
    }];
}

- (void)setModel:(ASCashoutRecordModel *)model {
    _model = model;
    self.money.text = [NSString stringWithFormat:@"提现金额：%@元",model.cash_money];
    self.realCashMoney.text = [NSString stringWithFormat:@"实际到账：%@元",model.real_cash_money];
    self.cardAccount.text = [NSString stringWithFormat:@"提现账号：%@(%@)", model.bank, model.card_account];
    self.time.text = [NSString stringWithFormat:@"提现时间：%@",model.create_time_text];
    self.orderNo.text = [NSString stringWithFormat:@"提现单号：%@",model.order_no];
    self.status.text = STRING(model.status_text);
    self.status.textColor = [ASCommonFunc changeColor:model.status_color];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UILabel *)money {
    if (!_money) {
        _money = [[UILabel alloc]init];
        _money.textColor = TITLE_COLOR;
        _money.font = TEXT_FONT_14;
        _money.text = @"提现金额：";
    }
    return _money;
}

- (UILabel *)realCashMoney {
    if (!_realCashMoney) {
        _realCashMoney = [[UILabel alloc]init];
        _realCashMoney.textColor = TITLE_COLOR;
        _realCashMoney.font = TEXT_FONT_14;
        _realCashMoney.text = @"实际到账：";
    }
    return _realCashMoney;
}

- (UILabel *)cardAccount {
    if (!_cardAccount) {
        _cardAccount = [[UILabel alloc]init];
        _cardAccount.textColor = TITLE_COLOR;
        _cardAccount.font = TEXT_FONT_14;
        _cardAccount.text = @"提现账号：";
    }
    return _cardAccount;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.textColor = TITLE_COLOR;
        _time.font = TEXT_FONT_14;
        _time.text = @"提现时间：";
    }
    return _time;
}

- (UILabel *)orderNo {
    if (!_orderNo) {
        _orderNo = [[UILabel alloc]init];
        _orderNo.textColor = TITLE_COLOR;
        _orderNo.font = TEXT_FONT_14;
        _orderNo.text = @"提现单号：";
    }
    return _orderNo;
}

- (UILabel *)status {
    if (!_status) {
        _status = [[UILabel alloc]init];
        _status.textColor = TITLE_COLOR;
        _status.font = TEXT_FONT_14;
        _status.textAlignment = NSTextAlignmentRight;
    }
    return _status;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}

@end
