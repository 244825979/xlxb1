//
//  ASCallItemView.m
//  AS
//
//  Created by SA on 2025/5/19.
//

#import "ASCallItemView.h"

@implementation ASCallItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.actionBlock) {
                wself.actionBlock();
            }
        }];
        [self addSubview:self.icon];
        [self addSubview:self.title];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(self.mas_width);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(SCALES(8));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(SCALES(20));
    }];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.textColor = UIColor.whiteColor;
        _title.font = TEXT_FONT_13;
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}
@end
