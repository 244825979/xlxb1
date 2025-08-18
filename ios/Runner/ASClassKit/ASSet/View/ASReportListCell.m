//
//  ASReportListCell.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASReportListCell.h"
#import "ASSetRequest.h"

@interface ASReportListCell ()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *beReported;
@property (nonatomic, strong) UILabel *reportedTime;
@property (nonatomic, strong) UILabel *state;
@property (nonatomic, strong) UIButton *nolleProsequi;
@property (nonatomic, strong) UIImageView *back;
@end

@implementation ASReportListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.header];
        [self.contentView addSubview:self.beReported];
        [self.contentView addSubview:self.reportedTime];
        [self.contentView addSubview:self.state];
        [self.contentView addSubview:self.nolleProsequi];
        [self.contentView addSubview:self.back];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(SCALES(16));
        make.height.width.mas_equalTo(SCALES(50));
    }];
    [self.beReported mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header).offset(SCALES(4));
        make.left.equalTo(self.header.mas_right).offset(SCALES(8));
        make.height.mas_equalTo(SCALES(16));
    }];
    [self.reportedTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.header.mas_bottom).offset(SCALES(-4));
        make.left.equalTo(self.beReported);
    }];
    if (self.model.status == 0 || self.model.status == 4 || self.model.status == 5) {
        [self.state mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(SCALES(-42));
            make.centerY.equalTo(self.beReported);
        }];
        [self.nolleProsequi mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(SCALES(-42));
            make.centerY.equalTo(self.reportedTime);
            make.size.mas_equalTo(CGSizeMake(SCALES(42), SCALES(20)));
        }];
    } else {
        [self.state mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(SCALES(-42));
            make.centerY.equalTo(self.contentView);
        }];
    }
    [self.back mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(SCALES(-16));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
    }];
}

- (void)setModel:(ASReportListModel *)model {
    _model = model;
    [self.header sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar]]];
    self.beReported.text = STRING(model.nickname);
    self.reportedTime.text = STRING(model.ctime);
    switch (model.status) {
        case 0://受理中
        case 5://补充材料审核中
        {
            self.state.text = @"受理中";
            self.state.textColor = UIColorRGB(0xFAAC16);
            self.nolleProsequi.hidden = NO;
            [self.state mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(SCALES(-42));
                make.centerY.equalTo(self.beReported);
            }];
            [self.nolleProsequi mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(SCALES(-42));
                make.centerY.equalTo(self.reportedTime);
                make.size.mas_equalTo(CGSizeMake(SCALES(42), SCALES(20)));
            }];
        }
            break;
        case 1://审核失败。已完成
        case 2://审核成功。已完成
        {
            self.state.text = @"已完成";
            self.state.textColor = TEXT_SIMPLE_COLOR;
            self.nolleProsequi.hidden = YES;
        }
            break;
        case 3://撤销。已撤回
        {
            self.state.text = @"已撤回";
            self.state.textColor = TEXT_SIMPLE_COLOR;
            self.nolleProsequi.hidden = YES;
            [self.state mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(SCALES(-42));
                make.centerY.equalTo(self.contentView);
            }];
        }
            break;
        case 4://补充材料。待补充
        {
            self.state.text = @"待补充";
            self.state.textColor = UIColorRGB(0xF55F4E);
            self.nolleProsequi.hidden = NO;
            [self.state mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(SCALES(-42));
                make.centerY.equalTo(self.beReported);
            }];
            [self.nolleProsequi mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(SCALES(-42));
                make.centerY.equalTo(self.reportedTime);
                make.size.mas_equalTo(CGSizeMake(SCALES(42), SCALES(20)));
            }];
        }
            break;
        default:
            break;
    }
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.layer.masksToBounds = YES;
        _header.layer.cornerRadius = SCALES(8);
    }
    return _header;
}

- (UILabel *)beReported {
    if (!_beReported) {
        _beReported = [[UILabel alloc] init];
        _beReported.textColor = TITLE_COLOR;
        _beReported.font = TEXT_FONT_14;
    }
    return _beReported;
}

- (UILabel *)reportedTime {
    if (!_reportedTime) {
        _reportedTime = [[UILabel alloc] init];
        _reportedTime.textColor = TEXT_SIMPLE_COLOR;
        _reportedTime.font = TEXT_FONT_12;
    }
    return _reportedTime;
}

- (UILabel *)state {
    if (!_state) {
        _state = [[UILabel alloc] init];
        _state.textColor = TEXT_SIMPLE_COLOR;
        _state.font = TEXT_FONT_14;
    }
    return _state;
}

- (UIButton *)nolleProsequi {
    if (!_nolleProsequi) {
        _nolleProsequi = [[UIButton alloc]init];
        [_nolleProsequi setTitle:@"撤回" forState:UIControlStateNormal];
        [_nolleProsequi setBackgroundColor:MAIN_COLOR];
        _nolleProsequi.adjustsImageWhenHighlighted = NO;
        _nolleProsequi.titleLabel.font = TEXT_FONT_12;
        _nolleProsequi.layer.cornerRadius = SCALES(10);
        _nolleProsequi.layer.masksToBounds = YES;
        _nolleProsequi.hidden = YES;
        kWeakSelf(self);
        [[_nolleProsequi rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASAlertViewManager defaultPopTitle:@"提示" content:@"您确定要撤销投诉吗？" left:@"确认" right:@"取消" isTouched:YES affirmAction:^{
                [ASSetRequest requestReportDrawWithID:wself.model.ID success:^(id  _Nullable data) {
                    wself.model.status = 3;
                    wself.state.text = @"已撤回";
                    wself.state.textColor = TEXT_SIMPLE_COLOR;
                    wself.nolleProsequi.hidden = YES;
                    [wself.state mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(wself.contentView.mas_right).offset(SCALES(-42));
                        make.centerY.equalTo(wself.contentView);
                    }];
                } errorBack:^(NSInteger code, NSString *msg) {
                    
                }];
            } cancelAction:^{
                
            }];
        }];
    }
    return _nolleProsequi;
}

- (UIImageView *)back {
    if (!_back) {
        _back = [[UIImageView alloc]init];
        _back.image = [UIImage imageNamed:@"cell_back"];
    }
    return _back;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
