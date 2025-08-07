//
//  ASReportDetailsHeadView.m
//  AS
//
//  Created by SA on 2025/6/30.
//

#import "ASReportDetailsHeadView.h"

@interface ASReportDetailsHeadView ()
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIImageView *stateIcon;
@property (nonatomic, strong) UIView *progressStateView;
@property (nonatomic, strong) UILabel *stateLable1;
@property (nonatomic, strong) UILabel *stateLable2;
@property (nonatomic, strong) UILabel *stateLable3;
@end

@implementation ASReportDetailsHeadView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.progressView];
        [self.progressView addSubview:self.progressStateView];
        [self addSubview:self.stateIcon];
        [self addSubview:self.stateLable1];
        [self addSubview:self.stateLable2];
        [self addSubview:self.stateLable3];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(20));
        make.centerX.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(32));
        make.height.mas_equalTo(SCALES(8));
    }];
    [self.stateLable1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressView);
        make.top.mas_equalTo(SCALES(36));
    }];
    [self.stateLable2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.progressView);
        make.top.equalTo(self.stateLable1);
    }];
    [self.stateLable3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.progressView);
        make.top.equalTo(self.stateLable1);
    }];
}

- (void)setModel:(ASReportListModel *)model {
    _model = model;
    switch (model.status) {
        case 0://受理中
        {
            self.stateLable1.textColor = MAIN_COLOR;
            self.stateLable2.hidden = YES;
            self.progressStateView.backgroundColor = MAIN_COLOR;
            self.stateIcon.image = [UIImage imageNamed:@"jubao_state1"];
            [self.progressStateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.progressView);
                make.width.mas_equalTo((SCREEN_WIDTH - SCALES(32))/2);
            }];
            [self.stateIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.equalTo(self.progressView);
                make.width.height.mas_equalTo(SCALES(16));
            }];
        }
            break;
        case 1://审核失败。已完成
        case 2://审核成功。已完成
        {
            self.stateLable1.textColor = MAIN_COLOR;
            self.stateLable2.hidden = YES;
            self.progressStateView.backgroundColor = MAIN_COLOR;
            self.stateIcon.image = [UIImage imageNamed:@"jubao_state1"];
            [self.progressStateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.progressView);
                make.width.mas_equalTo(SCREEN_WIDTH - SCALES(32));
            }];
            [self.stateIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.right.equalTo(self.progressView);
                make.width.height.mas_equalTo(SCALES(16));
            }];
        }
            break;
        case 3://撤销。已撤回
        {
            self.stateLable1.textColor = TEXT_SIMPLE_COLOR;
            self.stateLable2.hidden = YES;
            self.stateLable3.text = @"已撤回";
            self.progressStateView.backgroundColor = UIColorRGB(0xCCCCCC);
            self.stateIcon.image = [UIImage imageNamed:@"jubao_state2"];
            [self.progressStateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.progressView);
                make.width.mas_equalTo(SCREEN_WIDTH - SCALES(32));
            }];
            [self.stateIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.centerY.equalTo(self.progressView);
                make.width.height.mas_equalTo(SCALES(16));
            }];
        }
            break;
        case 4://补充材料。待补充
        {
            self.stateLable1.textColor = MAIN_COLOR;
            self.stateLable2.hidden = NO;
            self.stateLable2.text = @"待补充";
            self.stateLable2.textColor = TEXT_SIMPLE_COLOR;
            self.progressStateView.backgroundColor = MAIN_COLOR;
            self.stateIcon.image = [UIImage imageNamed:@"jubao_state2"];
            [self.progressStateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.progressView);
                make.width.mas_equalTo((SCREEN_WIDTH - SCALES(32))/2);
            }];
            [self.stateIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.equalTo(self.progressView);
                make.width.height.mas_equalTo(SCALES(16));
            }];
        }
            break;
        case 5://补充材料审核中
        {
            self.stateLable1.textColor = MAIN_COLOR;
            self.stateLable2.hidden = NO;
            self.stateLable2.text = @"待补充";
            self.stateLable2.textColor = MAIN_COLOR;
            self.progressStateView.backgroundColor = MAIN_COLOR;
            self.stateIcon.image = [UIImage imageNamed:@"jubao_state1"];
            [self.progressStateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.progressView);
                make.width.mas_equalTo((SCREEN_WIDTH - SCALES(32))/2);
            }];
            [self.stateIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.equalTo(self.progressView);
                make.width.height.mas_equalTo(SCALES(16));
            }];
        }
            break;
        default:
            break;
    }
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc]init];
        _progressView.layer.masksToBounds = YES;
        _progressView.layer.cornerRadius = SCALES(4);
        _progressView.backgroundColor = UIColorRGB(0xF5F5F5);
    }
    return _progressView;
}

- (UIView *)progressStateView {
    if (!_progressStateView) {
        _progressStateView = [[UIView alloc]init];
    }
    return _progressStateView;
}

- (UIImageView *)stateIcon {
    if (!_stateIcon) {
        _stateIcon = [[UIImageView alloc]init];
    }
    return _stateIcon;
}

- (UILabel *)stateLable1 {
    if (!_stateLable1) {
        _stateLable1 = [[UILabel alloc]init];
        _stateLable1.text = @"受理中";
        _stateLable1.font = TEXT_FONT_12;
        _stateLable1.textColor = MAIN_COLOR;
    }
    return _stateLable1;
}

- (UILabel *)stateLable2 {
    if (!_stateLable2) {
        _stateLable2 = [[UILabel alloc]init];
        _stateLable2.text = @"待补充";
        _stateLable2.font = TEXT_FONT_12;
        _stateLable2.hidden = YES;
    }
    return _stateLable2;
}

- (UILabel *)stateLable3 {
    if (!_stateLable3) {
        _stateLable3 = [[UILabel alloc]init];
        _stateLable3.text = @"已完成";
        _stateLable3.font = TEXT_FONT_12;
        _stateLable3.textColor = TEXT_SIMPLE_COLOR;
    }
    return _stateLable3;
}
@end
