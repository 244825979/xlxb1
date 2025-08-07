//
//  ASAddUsefulLanCell.m
//  AS
//
//  Created by SA on 2025/5/16.
//

#import "ASAddUsefulLanCell.h"

@interface ASAddUsefulLanCell()
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIImageView *state;
@property (nonatomic, strong) UIImageView *back;
@end

@implementation ASAddUsefulLanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.state];
        [self.contentView addSubview:self.back];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat textMaxLayoutWidth = SCREEN_WIDTH - SCALES(110);
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.centerY.equalTo(self.contentView);
        make.width.mas_lessThanOrEqualTo(textMaxLayoutWidth);
    }];
    [self.state mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content.mas_right).offset(SCALES(8));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(42), SCALES(18)));
    }];
    [self.back mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
        make.right.equalTo(self.contentView.mas_right).offset(SCALES(-14));
    }];
}

- (void)setModel:(ASAddUsefulLanModel *)model {
    _model = model;
    self.content.attributedText = [ASCommonFunc attributedWithString:STRING(model.word) lineSpacing:SCALES(3)];
    if (model.status == 0) {
        self.state.hidden = NO;
        self.state.image = [UIImage imageNamed:@"useful_state"];
    } else if (model.status == 1) {
        if (model.is_system == 0) {
            self.state.hidden = NO;
            self.state.image = [UIImage imageNamed:@"useful_state1"];
        } else {
            self.state.hidden = YES;
        }
    } else {
        self.state.hidden = YES;
    }
}

- (UIImageView *)back {
    if (!_back) {
        _back = [[UIImageView alloc]init];
        _back.image = [UIImage imageNamed:@"cell_back"];
    }
    return _back;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = TITLE_COLOR;
        _content.font = TEXT_FONT_15;
        _content.text = @"内容";
        _content.numberOfLines = 0;
    }
    return _content;
}

- (UIImageView *)state {
    if (!_state) {
        _state = [[UIImageView alloc]init];
        _state.hidden = YES;
    }
    return _state;
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
