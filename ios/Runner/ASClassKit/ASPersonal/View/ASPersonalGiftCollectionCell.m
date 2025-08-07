//
//  ASPersonalGiftCollectionCell.m
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASPersonalGiftCollectionCell.h"

@interface ASPersonalGiftCollectionCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *acount;
@end

@implementation ASPersonalGiftCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = UIColorRGB(0xf5f5f5);
        self.contentView.layer.cornerRadius = SCALES(8);
        self.contentView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.acount];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(6));
        make.centerX.equalTo(self.contentView);
        make.height.width.mas_equalTo(SCALES(60));
    }];
    
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.icon.mas_bottom).offset(SCALES(6));
        make.height.mas_equalTo(SCALES(16));
    }];
    
    [self.acount mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.title.mas_bottom).offset(SCALES(2));
        make.height.mas_equalTo(SCALES(12));
    }];
}

- (void)setModel:(ASGiftListModel *)model {
    _model = model;
    self.title.text = STRING(model.name);
    self.acount.text = [NSString stringWithFormat:@"x%zd", model.total];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.img]]];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _icon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = TEXT_FONT_13;
        _title.textColor = TITLE_COLOR;
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (UILabel *)acount {
    if (!_acount) {
        _acount = [[UILabel alloc]init];
        _acount.font = TEXT_FONT_11;
        _acount.textColor = TITLE_COLOR;
        _acount.textAlignment = NSTextAlignmentCenter;
    }
    return _acount;
}
@end
