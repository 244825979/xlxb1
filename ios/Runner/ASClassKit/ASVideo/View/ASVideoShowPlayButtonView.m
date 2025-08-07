//
//  ASVideoShowPlayButtonView.m
//  AS
//
//  Created by SA on 2025/5/12.
//

#import "ASVideoShowPlayButtonView.h"

@interface ASVideoShowPlayButtonView()
@property (nonatomic, strong) UILabel *text;
@end

@implementation ASVideoShowPlayButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon];
        [self addSubview:self.text];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.clikedBlock) {
                wself.clikedBlock();
            }
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
    }];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(SCALES(2));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(SCALES(18));
    }];
}

- (void)setNormalIcon:(NSString *)normalIcon {
    _normalIcon = normalIcon;
}

- (void)setSelectIcon:(NSString *)selectIcon {
    _selectIcon = selectIcon;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    if (isSelect) {
        self.icon.image = [UIImage imageNamed:STRING(self.selectIcon)];
    } else {
        self.icon.image = [UIImage imageNamed:STRING(self.normalIcon)];
    }
}

- (void)setTextStr:(NSString *)textStr {
    _textStr = textStr;
    _text.text = STRING(textStr);
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}

- (UILabel *)text {
    if (!_text) {
        _text = [[UILabel alloc]init];
        _text.font = TEXT_FONT_14;
        _text.textAlignment = NSTextAlignmentCenter;
        _text.textColor = UIColor.whiteColor;
    }
    return _text;
}

@end
