//
//  ASVoiceCodeView.m
//  AS
//
//  Created by SA on 2025/7/18.
//

#import "ASVoiceCodeView.h"

@interface ASVoiceCodeView ()

@end

@implementation ASVoiceCodeView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.textLabel];
        [self addSubview:self.voiceBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(90), SCALES(24)));
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.voiceBtn.mas_left).offset(SCALES(-10));
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.textColor = TEXT_SIMPLE_COLOR;
        _textLabel.font = TEXT_FONT_12;
        _textLabel.text = @"没收到验证码？请尝试使用";
    }
    return _textLabel;
}

- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc]init];
        [_voiceBtn setTitle:@"语音验证码" forState:UIControlStateNormal];
        _voiceBtn.adjustsImageWhenHighlighted = NO;
        _voiceBtn.layer.cornerRadius = SCALES(12);
        _voiceBtn.layer.masksToBounds = YES;
        _voiceBtn.titleLabel.font = TEXT_FONT_12;
        [_voiceBtn setImage:[UIImage imageNamed:@"login_voice1"] forState:UIControlStateNormal];
        [_voiceBtn setBackgroundColor:MAIN_COLOR];
        kWeakSelf(self);
        [[_voiceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.actionBlock) {
                wself.actionBlock();
            }
        }];
    }
    return _voiceBtn;
}
@end
