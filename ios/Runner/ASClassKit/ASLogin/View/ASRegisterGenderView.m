//
//  ASRegisterGenderView.m
//  AS
//
//  Created by SA on 2025/4/15.
//

#import "ASRegisterGenderView.h"

@interface ASRegisterGenderView ()
@property (nonatomic, strong) UIImageView *genderIcon;
@property (nonatomic, strong) UILabel *genderText;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation ASRegisterGenderView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.genderIcon];
        [self addSubview:self.genderText];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(SCALES(1));
    }];
    
    [self.genderIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(SCALES(-24));
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(SCALES(16));
    }];
    
    [self.genderText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.genderIcon.mas_right).offset(SCALES(16));
    }];
}

- (void)setIsMan:(BOOL)isMan {
    _isMan = isMan;
    if (self.isMan) {
        self.genderText.text = @"男";
    } else {
        self.genderText.text = @"女";
    }
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    if (isSelect) {
        if (self.isMan) {
            self.genderIcon.image = [UIImage imageNamed:@"man2"];
            self.genderText.textColor = UIColorRGB(0x3AB2F9);
            self.lineView.backgroundColor = UIColorRGB(0x3AB2F9);
        } else {
            self.genderIcon.image = [UIImage imageNamed:@"woman2"];
            self.genderText.textColor = UIColorRGB(0xFF66BE);
            self.lineView.backgroundColor = UIColorRGB(0xFF66BE);
        }
    } else {
        if (self.isMan) {
            self.genderIcon.image = [UIImage imageNamed:@"man1"];
        } else {
            self.genderIcon.image = [UIImage imageNamed:@"woman1"];
        }
        self.genderText.textColor = TEXT_SIMPLE_COLOR;
        self.lineView.backgroundColor = LINE_COLOR;
    }
}

- (UIImageView *)genderIcon {
    if (!_genderIcon) {
        _genderIcon = [[UIImageView alloc]init];
        _genderIcon.image = [UIImage imageNamed:@"man2"];
        _genderIcon.userInteractionEnabled = YES;
    }
    return _genderIcon;
}

- (UILabel *)genderText {
    if (!_genderText) {
        _genderText = [[UILabel alloc]init];
        _genderText.font = TEXT_FONT_16;
        _genderText.textColor = TEXT_SIMPLE_COLOR;
    }
    return _genderText;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = LINE_COLOR;
    }
    return _lineView;
}
@end
