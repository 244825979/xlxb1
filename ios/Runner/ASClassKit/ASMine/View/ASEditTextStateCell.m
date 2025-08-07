//
//  ASEditTextStateCell.m
//  AS
//
//  Created by SA on 2025/4/21.
//

#import "ASEditTextStateCell.h"

@interface ASEditTextStateCell ()
@property (nonatomic,strong) UIImageView *stateIcon;
@property (nonatomic,strong) UIImageView *backIcon;
@property (nonatomic,strong) UIView *line;
@end

@implementation ASEditTextStateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.stateIcon];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.backIcon];
    [self.contentView addSubview:self.line];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(SCALES(-38));
        make.width.mas_lessThanOrEqualTo(SCALES(200));//最大宽度
    }];
    
    [self.stateIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightLabel.mas_left).offset(SCALES(-8));
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(SCALES(42), SCALES(18)));
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
    self.line.hidden = !model.isShowLine;
    
    if (model.stateHiden == 1) {
        self.stateIcon.hidden = YES;
    } else {
        self.stateIcon.hidden = NO;
    }
}

- (UIImageView *)stateIcon {
    if (!_stateIcon) {
        _stateIcon = [[UIImageView alloc]init];
        _stateIcon.image = [UIImage imageNamed:@"state_review"];
        _stateIcon.hidden = YES;
    }
    return _stateIcon;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TITLE_COLOR;
        _titleLabel.font = TEXT_MEDIUM(15);
    }
    return _titleLabel;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
