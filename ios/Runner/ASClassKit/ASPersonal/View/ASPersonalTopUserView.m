//
//  ASPersonalTopUserView.m
//  AS
//
//  Created by SA on 2025/5/6.
//

#import "ASPersonalTopUserView.h"

@interface ASPersonalTopUserView ()
@property (nonatomic, strong) UIStackView *oneStackView;//第一行容器
@property (nonatomic, strong) UIStackView *twoStackView;//第二行容器
@property (nonatomic, strong) UIStackView *threeStackView;//第三行容器

@property (nonatomic, strong) UILabel *nickName;//昵称
@property (nonatomic, strong) UILabel *userCode;//用户号
@property (nonatomic, strong) UIButton *codeCopy;//复制按钮
@property (nonatomic, strong) UIView *stateView;//在线状态
@property (nonatomic, strong) UIImageView *genderView;//性别
@property (nonatomic, strong) UIImageView *vip;
@property (nonatomic, strong) UIImageView *auth;//实名认证
@property (nonatomic, strong) UIImageView *rpAuth;//真人认证
@property (nonatomic, strong) UILabel *userRemark;//备注名
@end

@implementation ASPersonalTopUserView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.oneStackView];
        [self.oneStackView addArrangedSubview:self.nickName];
        [self.oneStackView addArrangedSubview:self.userRemark];
        [self.oneStackView addArrangedSubview:[UIView new]];//添加可拉伸的view
        [self addSubview:self.twoStackView];
        [self.twoStackView addArrangedSubview:self.userCode];
        [self.twoStackView addArrangedSubview:self.codeCopy];
        [self.twoStackView addArrangedSubview:self.stateView];
        [self.twoStackView addArrangedSubview:[UIView new]];//添加可拉伸的view
        [self addSubview:self.threeStackView];
        [self.threeStackView addArrangedSubview:self.genderView];
        [self.threeStackView addArrangedSubview:self.rpAuth];
        [self.threeStackView addArrangedSubview:self.auth];
        [self.threeStackView addArrangedSubview:self.vip];
        [self.threeStackView addArrangedSubview:[UIView new]];//添加可拉伸的view
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.oneStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.mas_equalTo(SCALES(16));
        make.height.mas_equalTo(SCALES(28));
        make.right.offset(SCALES(-16));
    }];
    [self.twoStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.oneStackView);
        make.top.equalTo(self.oneStackView.mas_bottom).offset(SCALES(8));
        make.height.mas_equalTo(SCALES(20));
    }];
    [self.threeStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.oneStackView);
        make.top.equalTo(self.twoStackView.mas_bottom).offset(SCALES(8));
        make.height.mas_equalTo(SCALES(16));
    }];
}

- (void)setUserRemarkStr:(NSString *)userRemarkStr {
    _userRemarkStr = userRemarkStr;
    if (!kStringIsEmpty(userRemarkStr)) {
        self.userRemark.hidden = NO;
        self.userRemark.text = [NSString stringWithFormat:@"备注：%@",userRemarkStr];
    } else {
        self.userRemark.hidden = YES;
    }
}

- (void)setModel:(ASUserInfoModel *)model {
    _model = model;
    self.nickName.text = STRING(model.nickname);
    self.userCode.text = [NSString stringWithFormat:@"ID：%@", model.usercode];
    if (model.online.status) {
        self.stateView.hidden = NO;
    } else {
        self.stateView.hidden = YES;
    }
    if (model.gender == 2) {
        self.genderView.image = [UIImage imageNamed:@"man2"];
    } else {
        self.genderView.image = [UIImage imageNamed:@"woman2"];
    }
    if (model.vip == 1) {
        self.vip.hidden = NO;
        self.nickName.textColor = MAIN_COLOR;
    } else {
        self.vip.hidden = YES;
        self.nickName.textColor = TITLE_COLOR;
    }
    if (model.is_auth == 1) {
        self.auth.hidden = NO;
    } else {
        self.auth.hidden = YES;
    }
    if (model.is_rp_auth == 1) {
        self.rpAuth.hidden = NO;
    } else {
        self.rpAuth.hidden = YES;
    }
    self.userRemarkStr = model.user_remark;
}

- (UIStackView *)oneStackView {
    if (!_oneStackView) {
        _oneStackView = [[UIStackView alloc]init];
        _oneStackView.axis = UILayoutConstraintAxisHorizontal;
        _oneStackView.distribution = UIStackViewDistributionFill;
        _oneStackView.spacing = SCALES(8);
    }
    return _oneStackView;
}

- (UIStackView *)twoStackView {
    if (!_twoStackView) {
        _twoStackView = [[UIStackView alloc]init];
        _twoStackView.axis = UILayoutConstraintAxisHorizontal;
        _twoStackView.distribution = UIStackViewDistributionFill;
        _twoStackView.spacing = SCALES(8);
    }
    return _twoStackView;
}

- (UIStackView *)threeStackView {
    if (!_threeStackView) {
        _threeStackView = [[UIStackView alloc]init];
        _threeStackView.axis = UILayoutConstraintAxisHorizontal;
        _threeStackView.distribution = UIStackViewDistributionFill;
        _threeStackView.spacing = SCALES(4);
    }
    return _threeStackView;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc]init];
        _nickName.textColor = TITLE_COLOR;
        _nickName.font = TEXT_FONT_20;
        _nickName.text = @"昵称";
        [_nickName setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];//拉伸权级
    }
    return _nickName;
}

- (UILabel *)userCode {
    if (!_userCode) {
        _userCode = [[UILabel alloc]init];
        _userCode.textColor = TEXT_SIMPLE_COLOR;
        _userCode.font = TEXT_FONT_14;
        _userCode.text = @"ID：";
        [_userCode setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _userCode;
}

- (UIButton *)codeCopy {
    if (!_codeCopy) {
        _codeCopy = [[UIButton alloc]init];
        [_codeCopy setImage:[UIImage imageNamed:@"copy1"] forState:UIControlStateNormal];
        [_codeCopy setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        kWeakSelf(self);
        [[_codeCopy rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            pab.string = STRING(wself.model.usercode);
            if (pab == nil) {
                kShowToast(@"复制失败");
            } else {
                kShowToast(@"复制成功");
            }
        }];
    }
    return _codeCopy;
}

- (UIView *)stateView {
    if (!_stateView) {
        _stateView = [[UIView alloc]init];
        [_stateView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        UIView *state = [[UIView alloc] init];
        state.backgroundColor = UIColorRGB(0x63E170);
        state.layer.masksToBounds = YES;
        state.layer.cornerRadius = SCALES(4);
        [_stateView addSubview:state];
        [state mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(_stateView);
            make.height.width.mas_equalTo(SCALES(8));
        }];
            
        UILabel *stateText = [[UILabel alloc]init];
        stateText.textColor = UIColorRGB(0x63E170);;
        stateText.font = TEXT_FONT_14;
        stateText.text = @"在线";
        [_stateView addSubview:stateText];
        [stateText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_stateView);
            make.left.equalTo(state.mas_right).offset(SCALES(4));
        }];
    }
    return _stateView;
}

- (UILabel *)userRemark {
    if (!_userRemark) {
        _userRemark = [[UILabel alloc]init];
        _userRemark.textColor = TEXT_SIMPLE_COLOR;
        _userRemark.font = TEXT_FONT_14;
        _userRemark.adjustsFontSizeToFitWidth = YES;
        _userRemark.minimumScaleFactor = 0.5;
        _userRemark.hidden = YES;
        [_userRemark setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _userRemark;
}

- (UIImageView *)genderView {
    if (!_genderView) {
        _genderView = [[UIImageView alloc]init];
        [_genderView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _genderView;
}

- (UIImageView *)vip {
    if (!_vip) {
        _vip = [[UIImageView alloc]init];
        _vip.image = [UIImage imageNamed:@"personal_vip"];
        [_vip setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _vip.hidden = YES;
    }
    return _vip;
}

- (UIImageView *)auth {
    if (!_auth) {
        _auth = [[UIImageView alloc]init];
        _auth.image = [UIImage imageNamed:@"personal_shiming"];
        [_auth setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _auth.hidden = YES;
    }
    return _auth;
}

- (UIImageView *)rpAuth {
    if (!_rpAuth) {
        _rpAuth = [[UIImageView alloc]init];
        _rpAuth.image = [UIImage imageNamed:@"personal_zhenren"];
        [_rpAuth setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _rpAuth.hidden = YES;
    }
    return _rpAuth;
}
@end
