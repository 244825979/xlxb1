//
//  ASWeChatLoginController.m
//  AS
//
//  Created by SA on 2025/5/22.
//

#import "ASWeChatLoginController.h"
#import "ASLoginBgView.h"
#import "ASLoginOtherView.h"

@interface ASWeChatLoginController ()
@property (nonatomic, strong) UIButton *agreementBtn;
@end

@implementation ASWeChatLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    [self createUI];
}

- (void)createUI {
    kWeakSelf(self);
    ASLoginBgView *bgView = [[ASLoginBgView alloc] init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    ASLoginOtherView *otherView = [[ASLoginOtherView alloc] init];
    otherView.type = kPhoneType;
    [self.view addSubview:otherView];
    [otherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-TAB_BAR_MAGIN);
        make.size.mas_equalTo(CGSizeMake(SCALES(240), SCALES(130)));
    }];
    otherView.actionBlock = ^(NSString * _Nonnull indexName) {
        if ([indexName isEqualToString:@"手机号登录"]) {
            [[ASLoginManager shared] phoneLoginVc];
            return;
        }
    };
    NSMutableAttributedString *attributedString = [ASTextAttributedManager userProtocolPopAgreement:^{
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];//用户协议
        vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_UserProtocol];
        ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationPageSheet;
        [[ASCommonFunc currentVc] presentViewController:nav animated:YES completion:nil];
    } privacyProtocol:^{
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];//隐私协议
        vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Privacy];
        ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationPageSheet;
        [[ASCommonFunc currentVc] presentViewController:nav animated:YES completion:nil];
    }];
    UIButton *weChatBtn = [[UIButton alloc]init];
    [weChatBtn setTitle:@" 微信登录" forState:UIControlStateNormal];
    [weChatBtn setImage:[UIImage imageNamed:@"login_wechat"] forState:UIControlStateNormal];
    [weChatBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    weChatBtn.titleLabel.font = TEXT_FONT_18;
    [weChatBtn setBackgroundColor:UIColorRGB(0x24DB5A)];
    weChatBtn.adjustsImageWhenHighlighted = NO;
    weChatBtn.layer.masksToBounds = YES;
    weChatBtn.layer.cornerRadius = SCALES(25);
    [[weChatBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (wself.agreementBtn.isSelected == YES) {
            [[ASLoginManager shared] weChatLogin];
        } else {
            [ASAlertViewManager protocolPopTitle:@"用户协议和隐私政策"
                                      cancelText:@"不同意并退出"
                                      cancelFont:TEXT_FONT_15
                            dismissOnMaskTouched:NO
                                      attributed:attributedString
                                    affirmAction:^{
                wself.agreementBtn.selected = YES;
                [[ASLoginManager shared] weChatLogin];
            } cancelAction:^{
                ASLog(@"-----不同意协议---");
            }];
        }
    }];
    [self.view addSubview:weChatBtn];
    [weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(32));
        make.right.offset(SCALES(-32));
        make.top.mas_equalTo(STATUS_BAR_HEIGHT + SCALES(344));
        make.height.mas_equalTo(SCALES(50));
    }];
    UIButton *txOneLoginBtn = [[UIButton alloc]init];
    [txOneLoginBtn setTitle:@"本机号码一键登录" forState:UIControlStateNormal];
    [txOneLoginBtn setBackgroundImage:[UIImage imageNamed:@"button_login_bg"] forState:UIControlStateNormal];
    [txOneLoginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    txOneLoginBtn.titleLabel.font = TEXT_FONT_18;
    txOneLoginBtn.adjustsImageWhenHighlighted = NO;
    [[txOneLoginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[ASLoginManager shared] TX_LoginPushFailDispose:YES actionBlock:^{
            if (USER_INFO.systemIndexModel.mobile_login_status == 1) {//是否开启手机号码登录
                [[ASLoginManager shared] phoneLoginVc];
            } else {
                [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"登录失败，请优先使用微信登录方式" left:@"确定" right:@"" affirmAction:^{
                    
                } cancelAction:^{
                    
                }];
            }
        }];
    }];
    [self.view addSubview:txOneLoginBtn];
    [txOneLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(32));
        make.right.offset(SCALES(-32));
        make.top.equalTo(weChatBtn.mas_bottom).offset(SCALES(16));
        make.height.mas_equalTo(SCALES(50));
    }];
    YYLabel *agreementView = [[YYLabel alloc] init];
    agreementView.numberOfLines = 0;
    agreementView.attributedText = [ASTextAttributedManager loginHomeAgreement:^{
        wself.agreementBtn.selected = !wself.agreementBtn.selected;
    } serviceProtocol:^{//用户协议
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_UserProtocol];
        ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationPageSheet;
        [[ASCommonFunc currentVc] presentViewController:nav animated:YES completion:nil];
    } privacyProtocol:^{//隐私协议
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Privacy];
        ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationPageSheet;
        [[ASCommonFunc currentVc] presentViewController:nav animated:YES completion:nil];
    }];
    [self.view addSubview:agreementView];
    [agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(txOneLoginBtn.mas_bottom).offset(SCALES(18));
        make.left.equalTo(txOneLoginBtn).offset(SCALES(22));
    }];
    [self.view addSubview:self.agreementBtn];
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(agreementView.mas_left).offset(SCALES(7));
        make.size.mas_equalTo(CGSizeMake(SCALES(36), SCALES(36)));
        make.centerY.equalTo(agreementView);
    }];
}

- (UIButton *)agreementBtn {
    if (!_agreementBtn) {
        _agreementBtn = [[UIButton alloc]init];
        [_agreementBtn setImage:[UIImage imageNamed:@"login_agree1"] forState:UIControlStateNormal];
        [_agreementBtn setImage:[UIImage imageNamed:@"login_agree"] forState:UIControlStateSelected];
        _agreementBtn.adjustsImageWhenHighlighted = NO;
        _agreementBtn.selected = NO;
        kWeakSelf(self);
        [[_agreementBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [wself.view endEditing:YES];
            wself.agreementBtn.selected = !wself.agreementBtn.selected;
        }];
    }
    return _agreementBtn;
}
@end
