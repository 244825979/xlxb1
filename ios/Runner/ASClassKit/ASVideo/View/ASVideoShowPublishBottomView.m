//
//  ASVideoShowPublishBottomView.m
//  AS
//
//  Created by SA on 2025/5/13.
//

#import "ASVideoShowPublishBottomView.h"

@interface ASVideoShowPublishBottomView ()
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *hintBtn;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIButton *publishBtn;
@end

@implementation ASVideoShowPublishBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.hintBtn];
        [self addSubview:self.openBtn];
        [self addSubview:self.closeBtn];
        [self addSubview:self.line];
        [self addSubview:self.line1];
        [self addSubview:self.publishBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.mas_equalTo(SCALES(16));
        make.right.equalTo(self).offset(SCALES(-16));
        make.height.mas_equalTo(SCALES(0.5));
    }];
    [self.hintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line);
        make.top.equalTo(self.line.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCALES(100), SCALES(48)));
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line);
        make.height.mas_equalTo(SCALES(48));
        make.centerY.equalTo(self.hintBtn);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.closeBtn.mas_left).offset(SCALES(-16));
        make.width.mas_equalTo(SCALES(1));
        make.height.mas_equalTo(SCALES(14));
        make.centerY.equalTo(self.hintBtn);
    }];
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line1.mas_left).offset(SCALES(-16));
        make.height.mas_equalTo(SCALES(48));
        make.centerY.equalTo(self.hintBtn);
    }];
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(58));
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(311), SCALES(50)));
    }];
}


- (UIButton *)hintBtn {
    if (!_hintBtn) {
        _hintBtn = [[UIButton alloc]init];
        [_hintBtn setTitle:@" 所有人可见" forState:UIControlStateNormal];
        [_hintBtn setImage:[UIImage imageNamed:@"video_lock1"] forState:UIControlStateNormal];
        _hintBtn.titleLabel.font = TEXT_FONT_15;
        [_hintBtn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    }
    return _hintBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setTitle:@"私密" forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = TEXT_FONT_15;
        [_closeBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [wself.hintBtn setTitle:@" 仅自己可见" forState:UIControlStateNormal];
            [wself.hintBtn setImage:[UIImage imageNamed:@"video_lock"] forState:UIControlStateNormal];
            [wself.closeBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            [wself.openBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
            if (wself.indexBlock) {
                wself.indexBlock(@"私密");
            }
        }];
    }
    return _closeBtn;
}

- (UIButton *)openBtn {
    if (!_openBtn) {
        _openBtn = [[UIButton alloc]init];
        [_openBtn setTitle:@"公开" forState:UIControlStateNormal];
        _openBtn.titleLabel.font = TEXT_FONT_15;
        [_openBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_openBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [wself.hintBtn setTitle:@" 所有人可见" forState:UIControlStateNormal];
            [wself.hintBtn setImage:[UIImage imageNamed:@"video_lock1"] forState:UIControlStateNormal];
            [wself.openBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            [wself.closeBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
            if (wself.indexBlock) {
                wself.indexBlock(@"公开");
            }
        }];
    }
    return _openBtn;
}

- (UIButton *)publishBtn {
    if (!_publishBtn) {
        _publishBtn = [[UIButton alloc]init];
        [_publishBtn setTitle:@"立即发布" forState:UIControlStateNormal];
        [_publishBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        _publishBtn.adjustsImageWhenHighlighted = NO;
        _publishBtn.titleLabel.font = TEXT_FONT_18;
        _publishBtn.layer.masksToBounds = YES;
        _publishBtn.layer.cornerRadius = SCALES(25);
        kWeakSelf(self);
        [[_publishBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.indexBlock) {
                wself.indexBlock(@"发布");
            }
        }];
    }
    return _publishBtn;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc]init];
        _line1.backgroundColor = LINE_COLOR;
    }
    return _line1;
}
@end
