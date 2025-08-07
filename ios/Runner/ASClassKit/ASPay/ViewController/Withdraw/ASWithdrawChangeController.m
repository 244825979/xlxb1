//
//  ASMyEarningsBalanceController.m
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASWithdrawChangeController.h"
#import "ASCommonRequest.h"
#import "ASWithdrawBalanceTopView.h"
#import "ASWithdrawBalanceSubView.h"
#import "ASWithdrawExchangeView.h"
#import "ASMineRequest.h"
#import "ASPayRequest.h"
#import "ASCenterNotifyModel.h"
#import "ASWithdrawRequestModel.h"
#import "ASWithdrawRecordController.h"
#import "ASWithdrawBindController.h"
#import "ASWithdrawBindListController.h"

@interface ASWithdrawChangeController ()
@property (nonatomic, strong) ASWithdrawBalanceTopView *topView;
@property (nonatomic, strong) ASWithdrawBalanceSubView *withdrawView;
@property (nonatomic, strong) ASWithdrawExchangeView *exchangeView;
@property (nonatomic, strong) ASWithdrawModel *withdrawModel;//提现数据
@property (nonatomic, strong) NSNumber *money;
@end

@implementation ASWithdrawChangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"账户余额";
    [self createUI];
    [self requestWallet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)createUI {
    kWeakSelf(self);
    UIButton *incomeList = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 66, 44)];
    [incomeList setTitle:@"收益记录" forState:UIControlStateNormal];
    [incomeList setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    incomeList.titleLabel.font = TEXT_FONT_16;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:incomeList];
    [[incomeList rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wself.view endEditing:YES];
        ASWithdrawRecordController *vc = [[ASWithdrawRecordController alloc] init];
        [wself.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:self.topView];
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(SCALES(198));
    }];
    self.topView.clikedBlock = ^(NSString *clikedName) {
        if ([clikedName isEqualToString:@"积分兑现"]) {
            [wself.view endEditing:YES];
                wself.withdrawView.hidden = NO;
                wself.exchangeView.hidden = YES;
            return;
        }
        if ([clikedName isEqualToString:@"兑换金币"]) {
            [wself.view endEditing:YES];
                wself.withdrawView.hidden = YES;
                wself.exchangeView.hidden = NO;
            return;
        }
    };
    [self.view addSubview:self.withdrawView];
    [self.withdrawView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.view addSubview:self.exchangeView];
    [self.exchangeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)requestWallet {
    kWeakSelf(self);
    [ASMineRequest requestWalletIndexSuccess:^(id  _Nullable data) {
        wself.topView.model = data;
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)requestData {
    kWeakSelf(self);
    [ASPayRequest requestWithdrawSuccess:^(id  _Nullable data) {
        wself.withdrawModel = data;
        wself.withdrawView.model = data;
        wself.exchangeView.model = data;
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (ASWithdrawBalanceTopView *)topView {
    if (!_topView) {
        _topView = [[ASWithdrawBalanceTopView alloc]init];
        _topView.backgroundColor = UIColor.whiteColor;
    }
    return _topView;
}

- (ASWithdrawBalanceSubView *)withdrawView {
    if (!_withdrawView) {
        _withdrawView = [[ASWithdrawBalanceSubView alloc]init];
        _withdrawView.backgroundColor = UIColor.whiteColor;
        _withdrawView.hidden = NO;
        kWeakSelf(self);
        _withdrawView.selectMoneyBlock = ^(NSNumber * _Nonnull money) {
            wself.money = money;
        };
        _withdrawView.clikedBlock = ^(NSString *clikedName) {
            if ([clikedName isEqualToString:@"合作协议"]) {
                ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Partnership];;
                [wself.navigationController pushViewController:vc animated:YES];
                return;
            }
            if ([clikedName isEqualToString:@"立即提现"]) {
                [ASPayRequest requestWalletIsNoticeWithSuccess:^(id  _Nonnull response) {
                    ASCenterNotifyModel *model = response;
                    if (model.isPop == 1) {
                        [ASAlertViewManager centerPopNoticeViewWithModel:model vc:wself cancelBlock:^{
                            
                        }];
                    } else {
                        [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthPopBindAccount succeed:^{
                            if (kStringIsEmpty(wself.withdrawModel.alipay_account)) {
                                kShowToast(@"请先绑定提现账号~");
                                return;
                            }
                            if (kObjectIsEmpty(wself.money)) {
                                kShowToast(@"可提现余额不足20");
                                return;
                            }
                            [ASPayRequest requestWithdrawPriceDataWithMoney:wself.money success:^(id  _Nullable data) {
                                ASWithdrawRequestModel *model = data;
                                NSString *text = [NSString stringWithFormat:@"提现%@元，实际到账%@元 提现方式：%@（%@）", STRING(model.withdraw_money), STRING(model.receive_money), STRING(model.account), STRING(model.account_name)];
                                [ASAlertViewManager popWithdrawHintViewWithContent:text isProtocol:model.isPopProtocol indexAction:^(NSString * _Nonnull indexName) {
                                    if ([indexName isEqualToString:@"提现"]) {
                                        //提现成功，提示toast,刷新当前页面
                                        [ASPayRequest requestUserWithdrawNewWithMoney:model.withdraw_money success:^(id  _Nullable data) {
                                            kShowToast(@"提现申请成功！");
                                            [wself requestWallet];
                                        } errorBack:^(NSInteger code, NSString *msg) {

                                        }];
                                        return;
                                    }
                                    if ([indexName isEqualToString:@"查看协议"]) {
                                        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                                        vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Partnership];;
                                        [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                                        return;
                                    }
                                }];
                                
                            } errorBack:^(NSInteger code, NSString *msg) {

                            }];
                        }];
                    }
                } errorBack:^(NSInteger code, NSString * _Nonnull message) {
                    
                }];
                return;
            }
            
            if ([clikedName isEqualToString:@"账号绑定"]) {
                [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthPopBindAccount succeed:^{
                    if (kStringIsEmpty(wself.withdrawModel.alipay_account)) {
                        ASWithdrawBindController *vc = [[ASWithdrawBindController alloc] init];
                        [wself.navigationController pushViewController:vc animated:YES];
                    } else {
                        ASWithdrawBindListController *vc = [[ASWithdrawBindListController alloc] init];
                        [wself.navigationController pushViewController:vc animated:YES];
                    }
                }];
                return;
            }
        };
    }
    return _withdrawView;
}

- (ASWithdrawExchangeView *)exchangeView {
    if (!_exchangeView) {
        _exchangeView = [[ASWithdrawExchangeView alloc]init];
        _exchangeView.backgroundColor = UIColor.whiteColor;
        _exchangeView.hidden = YES;
        kWeakSelf(self);
        _exchangeView.backBlock = ^{
            [wself requestWallet];
        };
    }
    return _exchangeView;
}
@end
