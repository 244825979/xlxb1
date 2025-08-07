//
//  FUHeadButtonView.m
//  huanliao
//
//  Created by quxing on 2023/9/4.
//

#import "FUHeadButtonView.h"

@implementation FUHeadButtonView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubView];
        [self addLayoutConstraint];
        self.shouldRender = NO;
    }
    return self;
}

- (void)setupSubView{
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.adjustsImageWhenHighlighted = NO;
    [_backButton setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backButton];
    _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _switchButton.adjustsImageWhenHighlighted = NO;
    [_switchButton setBackgroundImage:[UIImage imageNamed:@"meiyan_open"] forState:UIControlStateNormal];
    [_switchButton setBackgroundImage:[UIImage imageNamed:@"meiyan_close"] forState:UIControlStateSelected];
    [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_switchButton];
    NSNumber *isOpenFU = [ASUserDefaults valueForKey:@"isOpenFaceUnity"];
    if (kObjectIsEmpty(isOpenFU)) {//默认没有调整过美颜状态，就正常开启美颜
        _switchButton.selected = NO;
    } else {
        _switchButton.selected = !isOpenFU.boolValue;
    }
    _defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_defaultButton setTitle:@"恢复默认" forState:UIControlStateNormal];
    [_defaultButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_defaultButton setBackgroundColor:UIColorRGBA(0x000000, 0.3)];
    _defaultButton.titleLabel.font = TEXT_FONT_14;
    _defaultButton.layer.cornerRadius = 15;
    _defaultButton.layer.masksToBounds = YES;
    [_defaultButton addTarget:self action:@selector(defaultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_defaultButton];
}

- (BOOL)shouldRender {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL should = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        should = self.switchButton.selected;
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return should;
}

- (void)addLayoutConstraint {
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self).offset(16);
        make.height.width.mas_equalTo(44);
    
    }];
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.trailing.equalTo(self.mas_trailing).offset(-16);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
    [_defaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchButton.mas_bottom).offset(12);
        make.centerX.equalTo(self.switchButton);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
}

#pragma  mark -  UI 交互
- (void)backAction:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(headButtonViewBackAction:)]) {
        [_delegate headButtonViewBackAction:btn];
    }
}

- (void)defaultAction:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(headButtonViewDefaultAction:)]) {
        [_delegate headButtonViewDefaultAction:btn];
    }
}

- (void)switchAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.shouldRender = btn.selected;
    if ([_delegate respondsToSelector:@selector(headButtonViewSwitchAction:)]) {
        [_delegate headButtonViewSwitchAction:btn];
    }
}

@end
