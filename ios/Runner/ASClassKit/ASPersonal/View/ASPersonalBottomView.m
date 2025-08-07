//
//  ASPersonalBottomView.m
//  AS
//
//  Created by SA on 2025/5/6.
//

#import "ASPersonalBottomView.h"

@interface ASPersonalBottomView ()
@property (nonatomic, strong) UIStackView *stackView;//容器
@property (nonatomic, strong) UIButton *callBtn;//打电话
@property (nonatomic, strong) UIButton *siliaoBtn;//私聊
@property (nonatomic, strong) UIButton *siliaoLongBtn;//私聊长按钮
@property (nonatomic, strong) UIButton *followBtn;//关注
@property (nonatomic, strong) UIButton *dazhaohuBtn;//打招呼
@property (nonatomic, strong) UIButton *editBtn;//编辑
@end

@implementation ASPersonalBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.stackView];
        [self.stackView addArrangedSubview:self.dazhaohuBtn];
        [self.stackView addArrangedSubview:self.siliaoLongBtn];
        [self.stackView addArrangedSubview:self.siliaoBtn];
        [self.stackView addArrangedSubview:self.followBtn];
        [self.stackView addArrangedSubview:self.callBtn];
        [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(8));
            make.left.offset(SCALES(16));
            make.right.equalTo(self.mas_right).offset(SCALES(-16));
            make.height.mas_equalTo(SCALES(48));
        }];
        [self addSubview:self.editBtn];
        [self.editBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(8));
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCALES(319), SCALES(50)));
        }];
    }
    return self;
}

- (void)setUserID:(NSString *)userID {
    _userID = userID;
    if (![USER_INFO.user_id isEqualToString:self.userID]) {
        self.stackView.hidden = NO;
        self.editBtn.hidden = YES;
    } else {
        self.stackView.hidden = YES;
        self.editBtn.hidden = NO;
    }
}

- (void)setModel:(ASUserInfoModel *)model {
    _model = model;
    if (model.is_beckon == YES) {
        self.dazhaohuBtn.hidden = YES;
        self.siliaoBtn.hidden = YES;
        self.siliaoLongBtn.hidden = NO;
    } else {
        self.dazhaohuBtn.hidden = NO;
        if (kAppType == 1) {
            self.siliaoBtn.hidden = YES;
            self.siliaoLongBtn.hidden = YES;
        } else {
            self.siliaoLongBtn.hidden = YES;
            self.siliaoBtn.hidden = NO;
        }
    }
    self.isFollow = model.is_follow;
}

- (void)setIsFollow:(NSInteger)isFollow {
    _isFollow = isFollow;
    if (isFollow == YES) {
        [self.followBtn setBackgroundImage:[UIImage imageNamed:@"personal_guanzhu1"] forState:UIControlStateNormal];
    } else {
        [self.followBtn setBackgroundImage:[UIImage imageNamed:@"personal_guanzhu"] forState:UIControlStateNormal];
    }
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc]init];
        _stackView.hidden = YES;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.spacing = SCALES(12);
    }
    return _stackView;
}

- (UIButton *)callBtn {
    if (!_callBtn) {
        _callBtn = [[UIButton alloc] init];
        [_callBtn setBackgroundImage:[UIImage imageNamed:@"personal_call"] forState:UIControlStateNormal];
        [_callBtn setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];//拉伸权级
        _callBtn.adjustsImageWhenHighlighted = NO;
        if (kAppType == 1) {
            _callBtn.hidden = YES;
        }
        kWeakSelf(self);
        [[_callBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASMyAppCommonFunc callPopViewWithUserID:wself.model.userid scene:Call_Scene_PersonInfo back:^(BOOL isSucceed) {
                
            }];
        }];
    }
    return _callBtn;
}

- (UIButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [[UIButton alloc] init];
        [_followBtn setBackgroundImage:[UIImage imageNamed:@"personal_guanzhu"] forState:UIControlStateNormal];
        [_followBtn setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];//拉伸权级
        _followBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_followBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASMyAppCommonFunc followWithUserID:wself.model.userid action:^(id  _Nonnull data) {
                NSString *isFollow = data;
                if ([isFollow isEqualToString:@"add"]) {
                    wself.isFollow = 1;
                    wself.model.is_follow = 1;
                    if (wself.nameBlock) {
                        wself.nameBlock(@"已关注");
                    }
                } else if ([isFollow isEqualToString:@"delete"]) {
                    wself.isFollow = 0;
                    wself.model.is_follow = 0;
                    if (wself.nameBlock) {
                        wself.nameBlock(@"取消关注");
                    }
                }
            }];
        }];
    }
    return _followBtn;
}

- (UIButton *)siliaoBtn {
    if (!_siliaoBtn) {
        _siliaoBtn = [[UIButton alloc] init];
        [_siliaoBtn setBackgroundImage:[UIImage imageNamed:@"personal_chat"] forState:UIControlStateNormal];
        [_siliaoBtn setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];//拉伸权级
        _siliaoBtn.adjustsImageWhenHighlighted = NO;
        _siliaoBtn.hidden = YES;
        kWeakSelf(self);
        [[_siliaoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASMyAppCommonFunc chatWithUserID:wself.model.userid nickName:wself.model.nickname action:^(id  _Nonnull data) {
                
            }];
        }];
    }
    return _siliaoBtn;
}

- (UIButton *)siliaoLongBtn {
    if (!_siliaoLongBtn) {
        _siliaoLongBtn = [[UIButton alloc] init];
        [_siliaoLongBtn setBackgroundImage:[UIImage imageNamed:@"personal_siliao"] forState:UIControlStateNormal];
        _siliaoLongBtn.adjustsImageWhenHighlighted = NO;
        _siliaoLongBtn.hidden = YES;
        kWeakSelf(self);
        [[_siliaoLongBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASMyAppCommonFunc chatWithUserID:wself.model.userid nickName:wself.model.nickname action:^(id  _Nonnull data) {
                
            }];
        }];
    }
    return _siliaoLongBtn;
}

- (UIButton *)dazhaohuBtn {
    if (!_dazhaohuBtn) {
        _dazhaohuBtn = [[UIButton alloc]init];
        [_dazhaohuBtn setBackgroundImage:[UIImage imageNamed:@"personal_zhaohu"] forState:UIControlStateNormal];
        _dazhaohuBtn.adjustsImageWhenHighlighted = NO;
        _dazhaohuBtn.hidden = YES;
        kWeakSelf(self);
        [[_dazhaohuBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.model.is_beckon == NO && kAppType == 0) {
                [ASMyAppCommonFunc greetWithUserID:wself.model.userid action:^(id  _Nonnull data) {
                    wself.dazhaohuBtn.hidden = YES;
                    wself.siliaoBtn.hidden = YES;
                    wself.siliaoLongBtn.hidden = NO;
                    wself.model.is_beckon = YES;
                    if (wself.nameBlock) {
                        wself.nameBlock(@"打招呼");
                    }
                }];
            } else {
                [ASMyAppCommonFunc chatWithUserID:wself.model.userid nickName:wself.model.nickname action:^(id  _Nonnull data) {
                    
                }];
            }
        }];
    }
    return _dazhaohuBtn;
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [[UIButton alloc]init];
        _editBtn.hidden = YES;
        [_editBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
        [_editBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        _editBtn.adjustsImageWhenHighlighted = NO;
        _editBtn.titleLabel.font = TEXT_FONT_18;
        _editBtn.layer.cornerRadius = SCALES(25);
        _editBtn.layer.masksToBounds = YES;
        kWeakSelf(self);
        [[_editBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.nameBlock) {
                wself.nameBlock(@"编辑资料");
            }
        }];
    }
    return _editBtn;
}
@end
