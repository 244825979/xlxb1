//
//  ASEarningsDetailCell.m
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASEarningsDetailCell.h"
#import "ASSendBackDetailModel.h"

@interface ASEarningsDetailCell ()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@end

@implementation ASEarningsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.content];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(25));
        make.centerY.equalTo(self.contentView);
    }];

    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(170));
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setModel:(ASSendBackDetailListModel *)model {
    _model = model;
    self.title.text = [NSString stringWithFormat:@"%@：",STRING(model.label)];
    self.content.text = STRING(model.value);
}

- (void)setIsLast:(BOOL)isLast {
    _isLast = isLast;
    if (isLast == YES) {
        if (self.type == 0) {//退还详情
            self.content.textColor = MAIN_COLOR;
            if (self.model.value.length > 0) {
                NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:STRING(self.model.value)];
                [attributed addAttribute:NSForegroundColorAttributeName
                                        value:TITLE_COLOR
                                        range:NSMakeRange(self.model.value.length - 1, 1)];
                [self.content setAttributedText:attributed];
            }
        } else {//退回详情
            self.content.font = TEXT_MEDIUM(18);
            self.content.textColor = MAIN_COLOR;
        }
    }
}

- (void)setType:(NSInteger)type {
    _type = type;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = TEXT_FONT_14;
        _title.textColor = TEXT_SIMPLE_COLOR;
    }
    return _title;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.font = TEXT_FONT_14;
        _content.textColor = TITLE_COLOR;
    }
    return _content;
}

@end
