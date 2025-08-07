//
//  ASBaseNavigationView.m
//  AS
//
//  Created by SA on 2025/4/23.
//

#import "ASBaseNavigationView.h"

@interface ASBaseNavigationView ()

@end

@implementation ASBaseNavigationView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.title];
        [self addSubview:self.backBtn];
        [self addSubview:self.moreBtn];
        [self addSubview:self.silenceBtn];
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(SCREEN_WIDTH - 100);
    }];
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(44);
    }];
    [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(44);
    }];
    [self.silenceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreBtn.mas_left);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(44);
    }];
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.textColor = UIColor.whiteColor;
        _title.font = TEXT_FONT_20;
        _title.hidden = YES;
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.adjustsImageWhenHighlighted = NO;
        [_backBtn setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.clikedBlock) {
                wself.clikedBlock(wself.backBtn, @"返回");
            }
        }];
    }
    return _backBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.adjustsImageWhenHighlighted = NO;
        [_moreBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.clikedBlock) {
                wself.clikedBlock(wself.moreBtn, @"更多");
            }
        }];
    }
    return _moreBtn;
}

- (UIButton *)silenceBtn {
    if (!_silenceBtn) {
        _silenceBtn = [[UIButton alloc]init];
        _silenceBtn.hidden = YES;
        _silenceBtn.adjustsImageWhenHighlighted = NO;
        [_silenceBtn setImage:[UIImage imageNamed:@"personal_silence1"] forState:UIControlStateNormal];
        [_silenceBtn setImage:[UIImage imageNamed:@"personal_silence"] forState:UIControlStateSelected];
        kWeakSelf(self);
        [[_silenceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.clikedBlock) {
                wself.clikedBlock(wself.silenceBtn, @"铃音");
            }
        }];
    }
    return _silenceBtn;
}
@end
