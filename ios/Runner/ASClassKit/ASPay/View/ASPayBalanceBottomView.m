//
//  ASPayBalanceBottomView.m
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASPayBalanceBottomView.h"

@interface ASPayBalanceBottomView ()
@property (nonatomic, strong) UIButton *goPay;
@property (nonatomic, strong) YYLabel *agreementView;
@end

@implementation ASPayBalanceBottomView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.goPay];
        [self addSubview:self.agreementView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.goPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(SCALES(8));
        make.size.mas_equalTo(CGSizeMake(SCALES(311), SCALES(48)));
    }];
    [self.agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goPay.mas_bottom).offset(SCALES(8));
        make.centerX.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(60));
        make.height.mas_equalTo(SCALES(40));
    }];
}

- (UIButton *)goPay {
    if (!_goPay) {
        _goPay = [[UIButton alloc]init];
        [_goPay setTitle:@"立即充值" forState:UIControlStateNormal];
        _goPay.titleLabel.font = TEXT_FONT_18;
        _goPay.adjustsImageWhenHighlighted = NO;
        _goPay.layer.cornerRadius = SCALES(24);
        _goPay.layer.masksToBounds = YES;
        [_goPay setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_goPay rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.payBlock) {
                wself.payBlock();
            }
        }];
    }
    return _goPay;
}

- (YYLabel *)agreementView {
    if (!_agreementView) {
        _agreementView = [[YYLabel alloc]init];
        _agreementView.attributedText = [ASTextAttributedManager goPayProtectAgreement:^{
            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
            vc.webUrl = USER_INFO.configModel.webUrl.recharge;
            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
        } teenagerAction:^{
            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
            vc.webUrl = USER_INFO.configModel.webUrl.teenagerProtocol;
            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
        }];
        _agreementView.numberOfLines = 0;
    }
    return _agreementView;
}
@end
