//
//  ASBaseCommonCell.m
//  AS
//
//  Created by SA on 2025/4/21.
//

#import "ASBaseCommonCell.h"

@interface ASBaseCommonCell ()
@property (nonatomic, strong) UIImageView *titleRearImage;
@property (nonatomic, strong) UIImageView *backIcon;
@property (nonatomic, strong) UIView *line;
@end

@implementation ASBaseCommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.titleRearImage];
        [self.contentView addSubview:self.rightLabel];
        [self.contentView addSubview:self.setSwitch];
        [self.contentView addSubview:self.backIcon];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.redView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.centerY.equalTo(self.contentView);
    }];
    [self.redView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(SCALES(10));
        make.centerY.equalTo(self.titleLabel);
        make.width.height.mas_equalTo(SCALES(8));
    }];
    [self.titleRearImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(SCALES(8));
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(SCALES(-38));
        make.width.mas_lessThanOrEqualTo(SCALES(200));//最大宽度
    }];
    [self.setSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(42), SCALES(26)));
        make.right.equalTo(self.contentView).offset(SCALES(-20));
    }];
    [self.backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
        make.right.equalTo(self.contentView).offset(SCALES(-14));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.mas_equalTo(SCALES(14));
        make.right.equalTo(self.contentView).offset(SCALES(-14));
        make.height.mas_equalTo(SCALES(0.5));
    }];
}

- (void)setModel:(ASSetCellModel *)model {
    _model = model;
    if (!kObjectIsEmpty(model.leftTitleFont)) {
        self.titleLabel.font = model.leftTitleFont;
    } else {
        self.titleLabel.font = TEXT_FONT_15;
    }
    self.titleLabel.text = STRING(model.leftTitle);
    if (!kObjectIsEmpty(model.leftTitleColor)) {
        self.titleLabel.textColor = model.leftTitleColor;
    } else {
        self.titleLabel.textColor = TITLE_COLOR;
    }
    if (!kStringIsEmpty(model.titleRearImage)) {
        self.titleRearImage.image = [UIImage imageNamed:model.titleRearImage];
        self.titleRearImage.hidden = NO;
    } else {
        self.titleRearImage.hidden = YES;
    }
    if (!kObjectIsEmpty(model.rightTextFont)) {
        self.rightLabel.font = model.rightTextFont;
    } else {
        self.rightLabel.font = TEXT_FONT_13;
    }
    if (!kObjectIsEmpty(model.rightTextColor)) {
        self.rightLabel.textColor = model.rightTextColor;
    } else {
        self.rightLabel.textColor = TEXT_SIMPLE_COLOR;
    }
    self.rightLabel.text = STRING(model.rightText);
    switch (model.cellType) {
        case kSetCommonCellDefault:
        {
            self.rightLabel.hidden = YES;
            self.setSwitch.hidden = YES;
            if (model.isSkip) {
                self.backIcon.hidden = YES;
            } else {
                self.backIcon.hidden = NO;
            }
        }
            break;
        case kSetCommonCellText:
        {
            self.rightLabel.hidden = NO;
            self.setSwitch.hidden = YES;

            if (!kStringIsEmpty(model.rightText)) {
                self.rightLabel.text = model.rightText;
            } else {
                self.rightLabel.text = @"";
            }
            
            if (model.isSkip) {
                self.backIcon.hidden = YES;
            } else {
                self.backIcon.hidden = NO;
            }
        }
            break;
        case kSetCommonCellSwitch:
        {
            self.rightLabel.hidden = YES;
            self.setSwitch.hidden = NO;
            [self.setSwitch setOn:model.isSwitch];
            self.backIcon.hidden = YES;
        }
            break;
        default:
            break;
    }
    self.line.hidden = !model.isShowLine;
    self.redView.hidden = !model.isRed;
}

- (void)switchClick:(UISwitch *)switchs {
    if (self.model.valueDidBlock) {
        self.model.valueDidBlock(switchs);
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TITLE_COLOR;
        _titleLabel.font = TEXT_MEDIUM(15);
    }
    return _titleLabel;
}

- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc]init];
        _redView.backgroundColor = RED_COLOR;
        _redView.layer.cornerRadius = SCALES(4);
        _redView.layer.masksToBounds = YES;
        _redView.hidden = YES;
    }
    return _redView;
}

- (UIImageView *)titleRearImage {
    if (!_titleRearImage) {
        _titleRearImage = [[UIImageView alloc]init];
        _titleRearImage.hidden = YES;
    }
    return _titleRearImage;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.font = TEXT_FONT_13;
        _rightLabel.textColor = TEXT_SIMPLE_COLOR;
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}

- (UISwitch *)setSwitch {
    if (!_setSwitch) {
        _setSwitch = [[UISwitch alloc]init];
        _setSwitch.tintColor = BACKGROUNDCOLOR;
        _setSwitch.onTintColor = MAIN_COLOR;
        [_setSwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setSwitch;
}

- (UIImageView *)backIcon {
    if (!_backIcon) {
        _backIcon = [[UIImageView alloc]init];
        _backIcon.image = [UIImage imageNamed:@"cell_back"];
    }
    return _backIcon;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = LINE_COLOR;
        _line.hidden = YES;
    }
    return _line;
}
@end
