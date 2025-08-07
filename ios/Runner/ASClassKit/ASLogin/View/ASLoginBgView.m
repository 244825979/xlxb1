//
//  ASLoginBgView.m
//  AS
//
//  Created by SA on 2025/5/22.
//

#import "ASLoginBgView.h"

@interface ASLoginBgView ()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIButton *serviceBtn;
@property (nonatomic, strong) UIImageView *appLogo;
@property (nonatomic, strong) UILabel *appName;
@end

@implementation ASLoginBgView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.bgView];
        [self addSubview:self.serviceBtn];
        [self addSubview:self.appLogo];
        [self addSubview:self.appName];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(SCALES(-20));
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(SCALES(100), 44));
    }];
    CGFloat topHeight = kISiPhoneX ? SCALES(116) + STATUS_BAR_HEIGHT : SCALES(96) + STATUS_BAR_HEIGHT;
    [self.appLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topHeight);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(78), SCALES(78)));
    }];
    [self.appName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.appLogo.mas_bottom).offset(SCALES(16));
        make.height.mas_equalTo(SCALES(25));
    }];
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
        _bgView.image = [UIImage imageNamed:@"login_bg"];
        _bgView.userInteractionEnabled = YES;
        _bgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgView;
}

- (UIButton *)serviceBtn {
    if (!_serviceBtn) {
        _serviceBtn = [[UIButton alloc]init];
        [_serviceBtn setTitle:@" 在线客服" forState:UIControlStateNormal];
        [_serviceBtn setImage:[UIImage imageNamed:@"login_service"] forState:UIControlStateNormal];
        _serviceBtn.adjustsImageWhenHighlighted = NO;
        [_serviceBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = TEXT_FONT_15;
        [[_serviceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
            vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Customer];
            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
        }];
    }
    return _serviceBtn;
}

- (UIImageView *)appLogo {
    if (!_appLogo) {
        _appLogo = [[UIImageView alloc]init];
        _appLogo.image = [UIImage imageNamed:@"app_logo"];
    }
    return _appLogo;
}

- (UILabel *)appName {
    if (!_appName) {
        _appName = [[UILabel alloc]init];
        _appName.font = TEXT_MEDIUM(18);
        _appName.text = @"心 聊 想 伴";
        _appName.textColor = UIColor.whiteColor;
    }
    return _appName;
}
@end
