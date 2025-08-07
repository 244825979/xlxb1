//
//  ASCallTopView.m
//  AS
//
//  Created by SA on 2025/5/19.
//

#import "ASCallTopView.h"
#import "ASIMRollScrollView.h"

@interface ASCallTopView ()
@property (nonatomic, strong) UIView *horScrollBg;
@property (nonatomic, strong) UIImageView *horScrollIcon;
@property (nonatomic, strong) ASIMRollScrollPageView *rollScrollView;
@end

@implementation ASCallTopView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.horScrollBg];
        [self.horScrollBg addSubview:self.horScrollIcon];
        [self.horScrollBg addSubview:self.rollScrollView];
        [self addSubview:self.jubaoBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.horScrollBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.offset(-52);
        make.height.mas_equalTo(32);
        make.centerY.equalTo(self);
    }];
    [self.horScrollIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.height.width.mas_equalTo(20);
        make.centerY.equalTo(self.horScrollBg);
    }];
    [self.rollScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.horScrollIcon.mas_right).offset(8);
        make.centerY.equalTo(self.horScrollBg);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.horScrollBg);
    }];
    [self.jubaoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(24);
        make.right.equalTo(self).offset(-14);
    }];
}

- (void)invTimer {
    [self.rollScrollView invTimer];
}

- (UIView *)horScrollBg {
    if (!_horScrollBg) {
        _horScrollBg = [[UIView alloc]init];
        _horScrollBg.backgroundColor = UIColorRGBA(0x00000, 0.5);
        _horScrollBg.layer.cornerRadius = 16;
        _horScrollBg.layer.masksToBounds = YES;
    }
    return _horScrollBg;
}

- (UIImageView *)horScrollIcon {
    if (!_horScrollIcon) {
        _horScrollIcon = [[UIImageView alloc]init];
        _horScrollIcon.image = [UIImage imageNamed:@"rtc_notify"];
    }
    return _horScrollIcon;
}

- (ASIMRollScrollPageView *)rollScrollView {
    if (!_rollScrollView) {
        _rollScrollView = [[ASIMRollScrollPageView alloc]init];
        _rollScrollView.textColor = UIColor.whiteColor;
        _rollScrollView.textArr = [NSMutableArray arrayWithArray:@[@"请文明聊天，严禁低俗、涉黄、涉政等违规行为，如有问题请举报或反馈，平台核实后将警告、封禁，或追究法律责任。"]];
        _rollScrollView.backgroundColor = UIColor.clearColor;
    }
    return _rollScrollView;
}

- (UIButton *)jubaoBtn {
    if (!_jubaoBtn) {
        _jubaoBtn = [[UIButton alloc]init];
        [_jubaoBtn setBackgroundImage:[UIImage imageNamed:@"rtc_jubao"] forState:UIControlStateNormal];
        _jubaoBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_jubaoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.jubaoBlock) {
                wself.jubaoBlock();
            }
        }];
    }
    return _jubaoBtn;
}

@end
