//
//  ASEarningsListCell.m
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASEarningsListCell.h"

@interface ASEarningsListCell ()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *acount;
@property (nonatomic, strong) UILabel *monthTime;
@property (nonatomic, strong) UILabel *dayIncome;
@property (nonatomic, strong) UIImageView *backIcon;
@end

@implementation ASEarningsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.header];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.acount];
        [self.contentView addSubview:self.monthTime];
        [self.contentView addSubview:self.dayIncome];
        [self.contentView addSubview:self.backIcon];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(50), SCALES(50)));
    }];
    
    [self.name mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.header.mas_right).offset(SCALES(8));
        make.top.equalTo(self.header.mas_top).offset(SCALES(2));
        make.height.mas_equalTo(SCALES(20));
        make.width.mas_equalTo(SCALES(125));
    }];
    
    [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.header.mas_bottom).offset(SCALES(-2));
        make.left.equalTo(self.name.mas_left);
        make.height.mas_equalTo(SCALES(16));
        make.width.mas_equalTo(SCALES(140));
    }];
    
    [self.monthTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(SCALES(14));
    }];
    
    [self.dayIncome mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.offset(SCALES(-14));
    }];
    
    if (self.model.is_detail || self.earningsModel.is_detail) {
        [self.backIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.offset(SCALES(-12));
            make.width.height.mas_equalTo(SCALES(14));
        }];
        
        [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.name.mas_right).offset(SCALES(5));
            make.right.equalTo(self.backIcon.mas_left).offset(SCALES(-8));
            make.centerY.equalTo(self.name);
            make.height.mas_equalTo(SCALES(20));
        }];

        [self.acount mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.time.mas_right).offset(SCALES(5));
            make.right.equalTo(self.title);
            make.bottom.equalTo(self.header);
            make.height.mas_equalTo(SCALES(22));
        }];
    } else {
        [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.name.mas_right).offset(SCALES(5));
            make.right.equalTo(self.contentView.mas_right).offset(SCALES(-14));
            make.centerY.equalTo(self.name);
            make.height.mas_equalTo(SCALES(20));
        }];

        [self.acount mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.time.mas_right).offset(SCALES(5));
            make.right.equalTo(self.title);
            make.bottom.equalTo(self.header);
            make.height.mas_equalTo(SCALES(22));
        }];
    }
}

- (void)setIsTimeCell:(BOOL)isTimeCell {
    _isTimeCell = isTimeCell;
    if (isTimeCell == YES) {
        self.monthTime.hidden = NO;
        self.contentView.backgroundColor = UIColorRGB(0xF5F5F5);
        self.dayIncome.hidden = NO;
        self.header.hidden = YES;
        self.name.hidden = YES;
        self.title.hidden = YES;
        self.time.hidden = YES;
        self.acount.hidden = YES;
    } else {
        self.monthTime.hidden = YES;
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.dayIncome.hidden = YES;
        self.header.hidden = NO;
        self.name.hidden = NO;
        self.title.hidden = NO;
        self.time.hidden = NO;
        self.acount.hidden = NO;
    }
}

- (void)setDayTimeOrIncomeStr:(NSString *)dayTimeOrIncomeStr {
    _dayTimeOrIncomeStr = dayTimeOrIncomeStr;
    NSArray *strs = [dayTimeOrIncomeStr componentsSeparatedByString:@","];
    if (strs.count > 0) {
        self.monthTime.text = STRING(strs[0]);
        self.dayIncome.hidden = YES;
    }
     
    if (strs.count > 1) {
        //如果是收支记录需要隐藏
        self.dayIncome.hidden = NO;
        //富文本设置
        NSString *dayIncomeStr = [NSString stringWithFormat:@"%@元",STRING(strs[1])];
        NSMutableAttributedString *dayIncomeAtt = [[NSMutableAttributedString alloc] initWithString:dayIncomeStr];
        //设置部分字体颜色
        [dayIncomeAtt addAttribute:NSForegroundColorAttributeName
                                  value:TITLE_COLOR
                          range:NSMakeRange(dayIncomeStr.length - 1, 1)];
        [dayIncomeAtt addAttribute:NSFontAttributeName
                          value:TEXT_FONT_13
                          range:NSMakeRange(dayIncomeStr.length - 1, 1)];
        [self.dayIncome setAttributedText:dayIncomeAtt];
    }
}

- (void)setModel:(ASEarningsListModel *)model {
    _model = model;
    [self.header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.icon]]];
    self.name.text = STRING(model.from_username);
    self.time.text = STRING(model.create_time);
    
    //富文本设置
    NSString *amountStr = [NSString stringWithFormat:@"%@金币",model.change_value];
    NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:amountStr];
    //设置部分字体颜色
    [amountAtt addAttribute:NSForegroundColorAttributeName
                              value:TITLE_COLOR
                      range:NSMakeRange(amountStr.length - 2, 2)];
    [amountAtt addAttribute:NSFontAttributeName
                      value:TEXT_FONT_13
                      range:NSMakeRange(amountStr.length - 2, 2)];
    [self.acount setAttributedText:amountAtt];
    
    if (!kStringIsEmpty(model.system_str_tips)) {
        self.title.attributedText = [ASCommonFunc attributeString:STRING(model.system_str) highlightText:STRING(model.system_str_tips) highlightColor:MAIN_COLOR highlightFont:TEXT_FONT_12];
    } else {
        self.title.textColor = TITLE_COLOR;
        self.title.text = STRING(model.system_str);
    }
    
    if (model.is_detail == 1) {
        self.backIcon.hidden = NO;
    } else {
        self.backIcon.hidden = YES;
    }
}

- (void)setEarningsModel:(ASEarningsListModel *)earningsModel {
    _earningsModel = earningsModel;
    [self.header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, earningsModel.icon]]];
    self.name.text = STRING(earningsModel.from_username);
    self.time.text = STRING(earningsModel.create_time);
    //富文本设置
    NSString *amountStr = [NSString stringWithFormat:@"%@元",earningsModel.change_value_new];
    NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:amountStr];
    //设置部分字体颜色
    [amountAtt addAttribute:NSForegroundColorAttributeName
                              value:TITLE_COLOR
                      range:NSMakeRange(amountStr.length - 1, 1)];
    [amountAtt addAttribute:NSFontAttributeName
                      value:TEXT_FONT_13
                      range:NSMakeRange(amountStr.length - 1, 1)];
    [self.acount setAttributedText:amountAtt];
    
    if (!kStringIsEmpty(earningsModel.system_str_tips)) {
        self.title.attributedText = [ASCommonFunc attributeString:STRING(earningsModel.system_str) highlightText:STRING(earningsModel.system_str_tips) highlightColor:MAIN_COLOR highlightFont:TEXT_FONT_12];
    } else {
        self.title.textColor = TITLE_COLOR;
        self.title.text = STRING(earningsModel.system_str);
    }
    if (earningsModel.is_detail == 1) {
        self.backIcon.hidden = NO;
    } else {
        self.backIcon.hidden = YES;
    }
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.layer.cornerRadius = SCALES(8);
        _header.layer.masksToBounds = YES;
        _header.hidden = YES;
        _header.userInteractionEnabled = YES;
        _header.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_header addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            [ASMyAppCommonFunc goPersonalHomeWithUserID:!kStringIsEmpty(wself.model.track_user_id) ? wself.model.track_user_id : wself.earningsModel.track_user_id
                                         viewController:[ASCommonFunc currentVc]
                                                 action:^(id  _Nonnull data) {
                
            }];
        }];
    }
    return _header;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.textColor = TITLE_COLOR;
        _name.font = TEXT_FONT_16;
        _name.text = @"昵称";
        _name.hidden = YES;
    }
    return _name;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = TEXT_FONT_12;
        _title.textColor = TITLE_COLOR;
        _title.textAlignment = NSTextAlignmentRight;
        _title.hidden = YES;
    }
    return _title;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.font = TEXT_FONT_12;
        _time.textColor = TITLE_COLOR;
        _time.hidden = YES;
    }
    return _time;
}

- (UILabel *)acount {
    if (!_acount) {
        _acount = [[UILabel alloc]init];
        _acount.font = TEXT_MEDIUM(16);
        _acount.textColor = MAIN_COLOR;
        _acount.textAlignment = NSTextAlignmentRight;
        _acount.hidden = YES;
    }
    return _acount;
}

- (UILabel *)monthTime {
    if (!_monthTime) {
        _monthTime = [[UILabel alloc]init];
        _monthTime.font = TEXT_FONT_14;
        _monthTime.textColor = TEXT_SIMPLE_COLOR;
        _monthTime.hidden = YES;
    }
    return _monthTime;
}

- (UILabel *)dayIncome {
    if (!_dayIncome) {
        _dayIncome = [[UILabel alloc]init];
        _dayIncome.font = TEXT_MEDIUM(16);
        _dayIncome.textColor = MAIN_COLOR;
        _dayIncome.hidden = YES;
        _dayIncome.text = @"0.0元";
    }
    return _dayIncome;
}

- (UIImageView *)backIcon {
    if (!_backIcon) {
        _backIcon = [[UIImageView alloc]init];
        _backIcon.image = [UIImage imageNamed:@"cell_back"];
        _backIcon.hidden = YES;
    }
    return _backIcon;
}

@end
