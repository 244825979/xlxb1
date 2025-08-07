//
//  ASPersonalSignTextCell.m
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASPersonalSignTextCell.h"

@interface ASPersonalSignTextCell ()
@property (nonatomic, strong) UIView *signView;
@property (nonatomic, strong) UILabel *signature;
@end

@implementation ASPersonalSignTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.signView];
        [self.signView addSubview:self.signature];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.signView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.mas_equalTo(SCALES(16));
        make.right.offset(SCALES(-16));
        make.height.mas_equalTo(self.model.signTextHeight);
    }];
    
    [self.signature mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.right.offset(SCALES(-10));
        make.top.mas_equalTo(SCALES(12));
    }];
}

- (void)setModel:(ASUserInfoModel *)model {
    _model = model;
    if ([model.sign containsString:@"这个人很懒，什么都没有留下"]) {//字符串包含
        self.signature.text = model.sign;
    } else {
        self.signature.attributedText = [ASCommonFunc attributedWithString:model.sign lineSpacing:SCALES(3.0)];
    }
}

- (UIView *)signView {
    if (!_signView) {
        _signView = [[UIView alloc]init];
        _signView.layer.cornerRadius = SCALES(8);
        _signView.layer.masksToBounds = YES;
        _signView.backgroundColor = UIColorRGB(0xF5F5F5);
    }
    return _signView;
}

- (UILabel *)signature {
    if (!_signature) {
        _signature = [[UILabel alloc]init];
        _signature.font = TEXT_FONT_14;
        _signature.textColor = TITLE_COLOR;
        _signature.text = @"这个人很懒，什么都没有留下";
        _signature.numberOfLines = 0;
        _signature.preferredMaxLayoutWidth = SCREEN_WIDTH - SCALES(56);//设置最大宽度
    }
    return _signature;
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
