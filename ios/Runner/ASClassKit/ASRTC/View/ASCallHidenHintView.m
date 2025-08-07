//
//  ASCallHidenHintView.m
//  AS
//
//  Created by SA on 2025/5/20.
//

#import "ASCallHidenHintView.h"

@implementation ASCallHidenHintView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorRGBA(0x000000, 0.5);
        self.layer.cornerRadius = SCALES(21);
        UILabel *text = [[UILabel alloc]init];
        text.textColor = UIColor.whiteColor;
        text.font = TEXT_FONT_14;
        text.text = @"点击接听将自动解除对Ta隐身";
        [self addSubview:text];
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(SCALES(15));
            make.centerY.equalTo(self);
        }];
        UIImageView *icon = [[UIImageView alloc]init];
        icon.image = [UIImage imageNamed:@"call_hiden"];
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(text.mas_left).offset(SCALES(-7));
            make.size.mas_equalTo(CGSizeMake(SCALES(24), SCALES(24)));
        }];
    }
    return self;
}
@end
