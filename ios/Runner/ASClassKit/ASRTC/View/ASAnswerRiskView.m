//
//  ASAnswerRiskView.m
//  AS
//
//  Created by SA on 2025/5/19.
//

#import "ASAnswerRiskView.h"

@interface ASAnswerRiskView ()
@property (nonatomic, strong) UIImageView *lessenIcon;//缩小切换
@property (nonatomic, strong) UIView *textBg;
@property (nonatomic, strong) UILabel *text;
/**数据**/
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) NSInteger index;
@end

@implementation ASAnswerRiskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        [self addSubview:self.lessenIcon];
        [self addSubview:self.textBg];
        [self.textBg addSubview:self.text];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.lessenIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.height.mas_equalTo(SCALES(32));
    }];
    [self.textBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lessenIcon.mas_right).offset(SCALES(12));
        make.top.right.bottom.equalTo(self);
    }];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(SCALES(8));
        make.right.bottom.offset(SCALES(-8));
    }];
}

- (void)setModel:(ASCallAnswerRiskModel *)model {
    _model = model;
    self.isOpen = YES;
    if (model.labelList.count > 0) {
        self.index = 0;
        self.textBg.hidden = NO;
        [self textHintWithText:model.labelList[self.index]];
    }
}

- (void)textHintWithText:(NSString *)text {
    kWeakSelf(self);
    self.text.attributedText = [ASCommonFunc attributedWithString:text lineSpacing:SCALES(3)];
    [[RACScheduler mainThreadScheduler] afterDelay:self.model.showTime schedule:^{
        wself.textBg.hidden = YES;
        wself.index++;
        if (wself.index == wself.model.labelList.count) {
            wself.index = 0;
        }
        [[RACScheduler mainThreadScheduler] afterDelay:self.model.waitTime schedule:^{
            if (wself.isOpen == YES) {
                wself.textBg.hidden = NO;
                [wself textHintWithText:wself.model.labelList[wself.index]];
            }
        }];
    }];
}

- (UIImageView *)lessenIcon {
    if (!_lessenIcon) {
        _lessenIcon = [[UIImageView alloc]init];
        _lessenIcon.image = [UIImage imageNamed:@"risk_text"];
        _lessenIcon.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_lessenIcon addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.isOpen) {
                wself.lessenIcon.image = [UIImage imageNamed:@"risk_text1"];
                wself.isOpen = NO;
                wself.textBg.hidden = YES;
            } else {
                wself.lessenIcon.image = [UIImage imageNamed:@"risk_text"];
                wself.isOpen = YES;
                wself.textBg.hidden = NO;
                wself.index = 0;
                [wself textHintWithText:wself.model.labelList[wself.index]];
            }
        }];
    }
    return _lessenIcon;
}

- (UIView *)textBg {
    if (!_textBg) {
        _textBg = [[UIView alloc]init];
        _textBg.backgroundColor = UIColorRGBA(0x000000, 0.5);
        _textBg.layer.cornerRadius = SCALES(8);
    }
    return _textBg;
}

- (UILabel *)text {
    if (!_text) {
        _text = [[UILabel alloc]init];
        _text.textColor = UIColor.whiteColor;
        _text.font = TEXT_FONT_13;
        _text.numberOfLines = 0;
    }
    return _text;
}
@end
