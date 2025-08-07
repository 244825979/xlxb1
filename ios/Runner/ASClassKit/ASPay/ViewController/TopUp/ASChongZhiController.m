//
//  ASChongZhiController.m
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASChongZhiController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "ASFGIAPVerifyTransactionManager.h"
#import "ASPayBalanceBottomView.h"
#import "ASPayBalanceListCell.h"
#import "ASMineRequest.h"
#import "ASPayRequest.h"
#import "ASRechargeBeforeModel.h"
#import "ASIncomeRecordHomeController.h"
#import "ASPayTopUpModel.h"

#import "ASIMRollScrollView.h"

@interface ASChongZhiController ()<SDCycleScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UILabel *coinBalance;//金币余额
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) NSArray *bannerDatas;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, strong) ASGoodsListModel *selectModel;
@property (nonatomic, assign) NSInteger isYidun;
@property (nonatomic, strong) FGIAPProductsFilter *filter;
@property (nonatomic, strong) ASIMRollScrollPageView *rollScrollView;//顶部滚动提示
@end

@implementation ASChongZhiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    [self createUI];
    [self requestBanner];
    [self requestGoodsList];
    kWeakSelf(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"updateBalanceNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [wself requestGoodsList];
    }];
    //获取是否首次弹出未成年弹窗提示，未弹出就弹出提示
    NSString *isPopUnderAgePop = [ASUserDefaults valueForKey:[NSString stringWithFormat:@"%@_%@", STRING(USER_INFO.user_id), kIsPopUnderAgePopView]];
    if (isPopUnderAgePop.integerValue == 0 || kStringIsEmpty(isPopUnderAgePop)) {
        [self requestPayPop];
    }
}

- (void)createUI {
    UIImageView *topView = [[UIImageView alloc] init];
    topView.image = [UIImage imageNamed:@"chongzhi_top"];
    topView.userInteractionEnabled = YES;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(STATUS_BAR_HEIGHT > 20 ? 0 : -24);
        make.height.mas_equalTo(SCALES(190)+HEIGHT_NAVBAR);
    }];
    UIButton *back = [[UIButton alloc] init];
    back.adjustsImageWhenHighlighted = NO;
    [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    kWeakSelf(self);
    [[back rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wself.navigationController popToRootViewControllerAnimated:YES];
    }];
    [topView addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(44);
        make.height.width.mas_equalTo(44);
    }];
    UILabel *title = [[UILabel alloc] init];
    title.text = @"账户余额";
    title.font = TEXT_FONT_20;
    title.textColor = TITLE_COLOR;
    title.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.top.equalTo(back);
        make.height.mas_equalTo(44);
    }];
    UIButton *incomeBtn = [[UIButton alloc]init];
    [incomeBtn setTitle:@"收支记录" forState:UIControlStateNormal];
    [incomeBtn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    incomeBtn.titleLabel.font = TEXT_FONT_16;
    [[incomeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ASIncomeRecordHomeController *vc = [[ASIncomeRecordHomeController alloc] init];
        [wself.navigationController pushViewController:vc animated:YES];
    }];
    [topView addSubview:incomeBtn];
    [incomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(-14);
        make.centerY.equalTo(title);
        make.height.mas_equalTo(44);
    }];
    [topView addSubview:self.rollScrollView];
    [self.rollScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back.mas_bottom).offset(SCALES(1));
        make.centerX.equalTo(topView);
        make.height.mas_equalTo(SCALES(20));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(46));
    }];
    UILabel *balanceTitle = [[UILabel alloc] init];
    balanceTitle.text = @"金币余额";
    balanceTitle.font = TEXT_FONT_16;
    balanceTitle.textColor = TITLE_COLOR;
    [topView addSubview:balanceTitle];
    [balanceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rollScrollView.mas_bottom).offset(SCALES(19));
        make.left.mas_equalTo(SCALES(34));
        make.height.mas_equalTo(SCALES(22));
    }];
    self.coinBalance = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = TEXT_MEDIUM(30);
        label.textColor = UIColorRGB(0xFD6E6A);
        label.text = STRING(self.accountModel.coin);
        [topView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(balanceTitle.mas_bottom).offset(SCALES(3));
            make.left.equalTo(balanceTitle);
            make.height.mas_equalTo(SCALES(36));
        }];
        label;
    });
    self.bannerView = ({
        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(SCALES(16),
                                                                                               HEIGHT_NAVBAR + SCALES(112),
                                                                                               floorf(SCREEN_WIDTH - SCALES(32)),
                                                                                               SCALES(76))
                                                                           delegate:self
                                                                   placeholderImage:[UIImage imageNamed:@""]];
        bannerView.hidden = YES;
        bannerView.backgroundColor = UIColor.clearColor;
        bannerView.autoScrollTimeInterval = 3.0f;
        bannerView.layer.masksToBounds = YES;
        bannerView.layer.cornerRadius = SCALES(8);
        bannerView.showPageControl = NO;
        [self.view addSubview:bannerView];
        bannerView;
    });
    UIImageView *topButtomView = [[UIImageView alloc] init];
    topButtomView.image = [UIImage imageNamed:@"chongzhi_top1"];
    [self.view addSubview:topButtomView];
    [topButtomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(HEIGHT_NAVBAR + SCALES(156));
        make.height.mas_equalTo(SCALES(40));
    }];
    UILabel *tableTitle = [[UILabel alloc] init];
    tableTitle.text = @"请选择充值金币";
    tableTitle.font = TEXT_MEDIUM(16);
    tableTitle.textColor = TITLE_COLOR;
    [self.view addSubview:tableTitle];
    [tableTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topButtomView.mas_bottom).offset(SCALES(2));
        make.left.mas_equalTo(SCALES(16));
        make.height.mas_equalTo(SCALES(22));
    }];
    CGFloat itemW = floorf((SCREEN_WIDTH - SCALES(32) - SCALES(14)) /2);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemW, SCALES(100));
    layout.sectionInset = UIEdgeInsetsMake(0, 0, SCALES(20), 0);
    layout.minimumInteritemSpacing = SCALES(2);
    layout.minimumLineSpacing = SCALES(14);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableTitle.mas_bottom).offset(SCALES(12));
        make.left.mas_equalTo(SCALES(16));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(32));
    }];
    [self.collectionView registerClass:[ASPayBalanceListCell class] forCellWithReuseIdentifier:@"payBalanceListCell"];
    ASPayBalanceBottomView *bottom = [[ASPayBalanceBottomView alloc] init];
    bottom.backgroundColor = UIColor.whiteColor;
    bottom.layer.shadowColor = [UIColor grayColor].CGColor;
    bottom.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    bottom.payBlock = ^{
        [wself requestPayTopUpRechargeWithComplete:^{
            [ASMsgTool showLoading:@"购买正在进行中，完成前请不要离开"];
            [ASMyAppCommonFunc applePayRequestWithScene:Pay_Scene_PayCenter
                                           rechargeType:@"1"
                                              productID:wself.selectModel.ios_product_id
                                                 isOpen:wself.isYidun
                                               toUserID:@""
                                                success:^(ASPayTopUpModel * model) {
                [ASFGIAPVerifyTransactionManager goPayWithFilter:wself.filter productID:wself.selectModel.ios_product_id orderNo:model.order_no];
            } errorBack:^(NSInteger code) {
                
            }];
        }];
    };
    [self.view addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(TAB_BAR_MAGIN20 + SCALES(108));
    }];
}

- (void)requestBanner {
    kWeakSelf(self);
    [ASMineRequest requestBannerWithType:@"6" success:^(NSArray * _Nullable banner) {
        wself.bannerDatas = banner;
        NSMutableArray *urls = [NSMutableArray array];
        for (ASBannerModel *model in wself.bannerDatas) {
            [urls addObject:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.image]];
        }
        if (urls.count == 0) {
            wself.bannerView.hidden = YES;
        } else {
            wself.bannerView.hidden = NO;
        }
        wself.bannerView.imageURLStringsGroup = urls;
        [wself.bannerView adjustWhenControllerViewWillAppera];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)requestGoodsList {
    kWeakSelf(self);
    [ASCommonRequest requestGoodsListWithScene:Pay_Scene_PayCenter showHUD:NO success:^(ASPayGoodsDataModel *  _Nullable model) {
        wself.listArray = [NSMutableArray arrayWithArray:model.list];
        wself.coinBalance.text = STRING(model.coin);
        wself.isYidun = model.is_yidun;
        [wself.collectionView reloadData];
        if (wself.listArray.count > 0) {
            wself.selectModel = model.list[0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [wself.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

//首次进入是否弹出未成年弹窗提示
- (void)requestPayPop {
    kWeakSelf(self);
    NSMutableAttributedString *attributedString = [ASTextAttributedManager payPopProtectAgreement:^{
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = USER_INFO.configModel.webUrl.teenagerProtocol;
        ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationPageSheet;
        [wself presentViewController:nav animated:YES completion:nil];
    }];
    
    [ASPayRequest requestIsPopAgreeWithSuccess:^(id  _Nonnull response) {
        NSNumber *isPop = response[@"isAgree"];
        if (isPop.boolValue == NO) {
            //保存已经首次弹出未成年弹窗状态
            [ASUserDefaults setValue:@"1" forKey:[NSString stringWithFormat:@"%@_%@", STRING(USER_INFO.user_id), kIsPopUnderAgePopView]];
            [ASAlertViewManager protocolPopTitle:@"温馨提示"
                                      cancelText:@"取消"
                                      cancelFont:TEXT_FONT_15
                            dismissOnMaskTouched:YES
                                      attributed:attributedString
                                    affirmAction:^{
                [ASPayRequest requestAgreeUnderageWithSuccess:^(id  _Nonnull response) {
                    
                } errorBack:^(NSInteger code, NSString * _Nonnull message) {
                    
                }];
            } cancelAction:^{
                
            }];
        }
    } errorBack:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}

//点击充值按钮校验
- (void)requestPayTopUpRechargeWithComplete:(VoidBlock)complete {
    kWeakSelf(self);
    NSMutableAttributedString *attributedString = [ASTextAttributedManager payPopProtectAgreement:^{
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = USER_INFO.configModel.webUrl.teenagerProtocol;
        ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationPageSheet;
        [wself presentViewController:nav animated:YES completion:nil];
    }];
    [ASPayRequest requestWalletRechargeBeforeWithSuccess:^(id  _Nonnull response) {
        ASRechargeBeforeModel *model = response;
        if (model.isPopTeen == 1) {
            [ASAlertViewManager protocolPopTitle:@"温馨提示"
                                      cancelText:@"取消"
                                      cancelFont:TEXT_FONT_15
                            dismissOnMaskTouched:YES
                                      attributed:attributedString
                                    affirmAction:^{
                //同意
                [ASPayRequest requestAgreeUnderageWithSuccess:^(id  _Nonnull response) {
                    complete();
                } errorBack:^(NSInteger code, NSString * _Nonnull message) {
                    
                }];
            } cancelAction:^{
                
            }];
            return;
        }
        if (model.isPopGreen == 1) {
            [ASAlertViewManager defaultPopTitle:@"温馨提示"
                                        content:STRING(model.greenText)
                                           left:@"确定并充值"
                                          right:@""
                                   affirmAction:^{
                complete();
            } cancelAction:^{
                
            }];
            return;
        }
        if (model.isPopRechargeMax == 1) {
            [ASAlertViewManager defaultPopTitle:@"温馨提示"
                                        content:STRING(model.rechargeMaxText)
                                           left:@"确定并充值"
                                          right:@""
                                   affirmAction:^{
                complete();
            } cancelAction:^{
                
            }];
            return;
        }
        complete();
    } errorBack:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASPayBalanceListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"payBalanceListCell" forIndexPath:indexPath];
    cell.model = self.listArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ASLog(@"cell点击");
    self.selectModel = self.listArray[indexPath.row];
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    ASBannerModel *model = self.bannerDatas[index];
    [ASMyAppCommonFunc bannerClikedWithBannerModel:model viewController:self action:^(id  _Nonnull data) {
        
    }];
}

- (FGIAPProductsFilter *)filter {
    if (!_filter) {
        _filter = [[FGIAPProductsFilter alloc]init];
    }
    return _filter;
}

- (ASIMRollScrollPageView *)rollScrollView {
    if (!_rollScrollView) {
        _rollScrollView = [[ASIMRollScrollPageView alloc]init];
        _rollScrollView.bgHeight = SCALES(20);
        _rollScrollView.backgroundColor = UIColorRGBA(0xffffff, 0.5);
        _rollScrollView.textColor = UIColorRGB(0xFD6E6A);
        _rollScrollView.layer.cornerRadius = SCALES(10);
        _rollScrollView.layer.masksToBounds = YES;
        if (kObjectIsEmpty(USER_INFO.textRiskModel.rechargeLabelList) || USER_INFO.textRiskModel.rechargeLabelList.count == 0) {
            _rollScrollView.textArr = [NSMutableArray arrayWithArray:@[@"请勿轻信各类刷单、退款、低价充值金币等信息，以免上当受骗！未成年人禁止充值消费"]];
        } else {
            _rollScrollView.textArr = [NSMutableArray arrayWithArray:USER_INFO.textRiskModel.rechargeLabelList];
        }
        _rollScrollView.userInteractionEnabled = NO;
    }
    return _rollScrollView;
}
@end
