//
//  ASDynamicNotifyListCell.m
//  AS
//
//  Created by SA on 2025/5/16.
//

#import "ASDynamicNotifyListCell.h"

@interface ASDynamicNotifyListCell ()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *createTime;
@property (nonatomic, strong) YYLabel *content;
@end

@implementation ASDynamicNotifyListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.header];
        [self.contentView addSubview:self.createTime];
        [self.contentView addSubview:self.content];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.top.mas_equalTo(SCALES(10));
        make.width.height.mas_equalTo(SCALES(40));
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.header.mas_right).offset(SCALES(10));
        make.top.equalTo(self.header.mas_top);
        make.width.mas_equalTo(floorf(SCREEN_WIDTH - SCALES(78)));
        make.height.mas_greaterThanOrEqualTo(SCALES(16));
    }];
    [self.createTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(SCALES(-10));
    }];
}

- (void)setModel:(ASDynamicNotifyListModel *)model {
    _model = model;
    [self.header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.from_user_avatar]]];
    self.createTime.text = STRING(model.create_time);
    self.content.attributedText = model.textAgreement;
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.layer.cornerRadius = 9;
        _header.layer.masksToBounds = YES;
        _header.contentMode = UIViewContentModeScaleAspectFill;
        _header.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_header addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            [ASMyAppCommonFunc goPersonalHomeWithUserID:wself.model.from_user_id viewController:[ASCommonFunc currentVc] action:^(id  _Nonnull data) {
            }];
        }];
    }
    return _header;
}

- (UILabel *)createTime {
    if (!_createTime) {
        _createTime = [[UILabel alloc]init];
        _createTime.textColor = TEXT_SIMPLE_COLOR;
        _createTime.font = TEXT_FONT_14;
    }
    return _createTime;
}

- (YYLabel *)content {
    if (!_content) {
        _content = [[YYLabel alloc]init];
        _content.font = TEXT_FONT_14;
        _content.textColor = TITLE_COLOR;
        _content.numberOfLines = 0;
        _content.preferredMaxLayoutWidth = floorf(SCREEN_WIDTH - SCALES(78));
    }
    return _content;
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
