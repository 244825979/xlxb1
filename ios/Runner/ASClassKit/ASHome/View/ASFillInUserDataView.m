//
//  ASFillInUserDataView.m
//  AS
//
//  Created by SA on 2025/4/17.
//  补充资料的悬浮view

#import "ASFillInUserDataView.h"

@interface ASFillInUserDataView ()
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, strong) UIImageView *goIcon;
@property (nonatomic, strong) UIButton *close;
@end

@implementation ASFillInUserDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorRGB(0xFFF1F1);
        [self addSubview:self.text];
        [self addSubview:self.goIcon];
        [self addSubview:self.close];
        kWeakSelf(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
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
    [self.text mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.centerY.equalTo(self);
    }];
    
    [self.close mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(SCALES(-16));
        make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
        make.centerY.equalTo(self);
    }];
    
    [self.goIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.close.mas_left).offset(SCALES(-8));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(68), SCALES(26)));
    }];
}

- (UILabel *)text {
    if (!_text) {
        _text = [[UILabel alloc]init];
        _text.font = TEXT_FONT_14;
        _text.textColor = UIColorRGB(0xFD6E6A);
        _text.text = @"完成资料领福利，你有金币待领取";
    }
    return _text;
}

- (UIImageView *)goIcon {
    if (!_goIcon) {
        _goIcon = [[UIImageView alloc]init];
        _goIcon.image = [UIImage imageNamed:@"go_user_data"];
    }
    return _goIcon;
}

- (UIButton *)close {
    if (!_close) {
        _close = [[UIButton alloc] init];
        _close.adjustsImageWhenHighlighted = NO;
        [_close setImage:[UIImage imageNamed:@"close1"] forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_close rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [UIView animateWithDuration:0.25 animations:^{
                wself.alpha = 0.0;
            } completion:^(BOOL finished) {
                [wself removeFromSuperview];
            }];
        }];
    }
    return _close;
}
@end
