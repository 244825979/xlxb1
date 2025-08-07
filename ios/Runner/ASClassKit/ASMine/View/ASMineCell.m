//
//  ASMineCell.m
//  AS
//
//  Created by SA on 2025/4/18.
//

#import "ASMineCell.h"

@interface ASMineCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *titleIcon;
@property (nonatomic, strong) UIImageView *rightIcon;
@property (nonatomic, strong) UIImageView *backIcon;
@end

@implementation ASMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:self.bgView];
        self.bgView.frame = CGRectMake(SCALES(16), 0, SCREEN_WIDTH - SCALES(32), SCALES(54));
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.titleIcon];
        [self.bgView addSubview:self.rightLabel];
        [self.bgView addSubview:self.rightIcon];
        [self.bgView addSubview:self.backIcon];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(12));
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(SCALES(24));
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleIcon.mas_right).offset(SCALES(8));
        make.centerY.equalTo(self.titleIcon);
    }];
    
    [self.backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
        make.right.equalTo(self.bgView).offset(SCALES(-12));
    }];
    if (self.type != kMineCellDefault) {
        if (self.type == kMineCellService || self.type == kMineCellConvenient || self.type == kMineCellMoney) {
            [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.backIcon.mas_left).offset(SCALES(-8));
                make.centerY.equalTo(self.contentView);
            }];
        } else {
            [self.rightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.backIcon.mas_left).offset(SCALES(-8));
                make.centerY.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(SCALES(20), SCALES(20)));
            }];
            [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.rightIcon.mas_left).offset(SCALES(-8));
                make.centerY.equalTo(self.contentView);
            }];
        }
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = STRING(title);
}

- (void)setIcon:(NSString *)icon {
    _icon = icon;
    self.titleIcon.image = [UIImage imageNamed:STRING(icon)];
}

- (void)setType:(ASMineCellType)type {
    _type = type;
    switch (type) {
        case kMineCellInvite:
        {
            self.rightLabel.hidden = NO;
            self.rightIcon.hidden = NO;
            self.rightLabel.text = @"最多奖励8888金币";
            self.rightIcon.image = [UIImage imageNamed:@"hongbao"];
        }
            break;
        case kMineCellTask:
        {
            self.rightLabel.hidden = NO;
            self.rightIcon.hidden = NO;
            self.rightLabel.text = @"做任务，免费赚金币";
            self.rightIcon.image = [UIImage imageNamed:@"money"];
        }
            break;
        case kMineCellService:
        {
            self.rightLabel.hidden = NO;
            self.rightIcon.hidden = YES;
            self.rightLabel.text = [NSString stringWithFormat:@"值班时间：%@",USER_INFO.systemIndexModel.customerOnline];
        }
            break;
        case kMineCellConvenient:
        {
            self.rightLabel.hidden = NO;
            self.rightIcon.hidden = YES;
            self.rightLabel.text = @"设置更多优质内容，流量越多";
        }
            break;
        case kMineCellMoney:
        {
            self.rightLabel.hidden = NO;
            self.rightIcon.hidden = YES;
            self.rightLabel.text = @"金币：0";
        }
            break;
        default:
            self.rightLabel.hidden = YES;
            self.rightIcon.hidden = YES;
            break;
    }
}

- (void)setIsFirstCell:(BOOL)isFirstCell {
    _isFirstCell = isFirstCell;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(SCALES(8), SCALES(8))];
     CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;
}

- (void)setIsLastCell:(BOOL)isLastCell {
    _isLastCell = isLastCell;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(SCALES(8), SCALES(8))];
     CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TITLE_COLOR;
        _titleLabel.font = TEXT_FONT_15;
    }
    return _titleLabel;
}

- (UIImageView *)titleIcon {
    if (!_titleIcon) {
        _titleIcon = [[UIImageView alloc] init];
    }
    return _titleIcon;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = TEXT_FONT_13;
        _rightLabel.textColor = TEXT_SIMPLE_COLOR;
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
    }
    return _rightIcon;
}

- (UIImageView *)backIcon {
    if (!_backIcon) {
        _backIcon = [[UIImageView alloc] init];
        _backIcon.image = [UIImage imageNamed:@"cell_back"];
    }
    return _backIcon;
}

@end
