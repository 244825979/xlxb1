//
//  ASVipDetailsController.m
//  AS
//
//  Created by SA on 2025/5/21.
//

#import "ASVipDetailsController.h"
#import "ASFGIAPVerifyTransactionManager.h"
#import "ASVipDetailsModel.h"
#import "ASVipDetailsTopView.h"
#import "ASVipDetailsGoodsView.h"
#import "ASVipGradeListView.h"
#import "ASPayRequest.h"
#import "ASVipReceiveGiftView.h"
#import "ASPayTopUpModel.h"

@interface ASVipDetailsController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ASVipDetailsTopView *vipTopView;
@property (nonatomic, strong) ASVipDetailsGoodsView *goodsVipView;
@property (nonatomic, strong) ASVipReceiveGiftView *receiveGiftView;
@property (nonatomic, strong) ASVipGradeListView *gradeListView;
@property (nonatomic, strong) UIButton *openBtn;
/**数据**/
@property (nonatomic, strong) FGIAPProductsFilter *filter;
@property (nonatomic, strong) ASVipDetailsModel *detailsModel;
@property (nonatomic, strong) ASVipGoodsModel *selectOpenModel;//选择去开通的选中数据
@end

@implementation ASVipDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.view.backgroundColor = UIColorRGB(0x16100E);
    [self createUI];
    [self requestData];
    kWeakSelf(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"updateVipNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [wself requestData];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}

- (void)createUI {
    UIImageView *topBgImage = [[UIImageView alloc]init];
    topBgImage.image = [UIImage imageNamed:@"vip_top"];
    topBgImage.contentMode = UIViewContentModeScaleAspectFill;
    topBgImage.userInteractionEnabled = YES;
    [self.view addSubview:topBgImage];
    [topBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(SCALES(164)+ HEIGHT_NAVBAR);
    }];
    
    UIView *navigationView = [[UIView alloc] init];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(NAVIGATION_BAR_HEIGHT);
    }];
    UIButton *back = [[UIButton alloc] init];
    back.adjustsImageWhenHighlighted = NO;
    [back setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    kWeakSelf(self);
    [[back rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (wself.isRootPop) {
            [wself.navigationController popViewControllerAnimated:YES];
        } else {
            [wself.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    [navigationView addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(navigationView);
        make.left.mas_equalTo(12);
    }];
    UILabel *title = [[UILabel alloc] init];
    title.text = @"会员中心";
    title.font = TEXT_FONT_20;
    title.textColor = UIColor.whiteColor;
    title.textAlignment = NSTextAlignmentCenter;
    [navigationView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(navigationView);
    }];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
    [self.scrollView addSubview:self.vipTopView];
    [self.vipTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(10));
        make.left.mas_equalTo(SCALES(16));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(32));
        make.height.mas_equalTo(SCALES(130));
    }];
    [self.scrollView addSubview:self.goodsVipView];
    [self.goodsVipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vipTopView.mas_bottom).offset(SCALES(20));
        make.left.width.equalTo(self.view);
        make.height.mas_equalTo(SCALES(128));
    }];
    [self.scrollView addSubview:self.gradeListView];
    if (USER_INFO.gender == 1) {
        [self.scrollView addSubview:self.receiveGiftView];
        [self.receiveGiftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsVipView.mas_bottom).offset(SCALES(20));
            make.left.width.equalTo(self.vipTopView);
            make.height.mas_equalTo(SCALES(50));
        }];
        [self.gradeListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.receiveGiftView.mas_bottom).offset(SCALES(20));
            make.left.width.equalTo(self.vipTopView);
            make.bottom.equalTo(self.scrollView.mas_bottom).offset(SCALES(-20));
        }];
    } else {
        [self.gradeListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsVipView.mas_bottom).offset(SCALES(20));
            make.left.width.equalTo(self.vipTopView);
            make.bottom.equalTo(self.scrollView.mas_bottom).offset(SCALES(-20));
        }];
    }
    [self.view addSubview:self.openBtn];
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom).offset(SCALES(10));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCALES(319), SCALES(48)));
        make.bottom.equalTo(self.view.mas_bottom).offset(-(SCALES(10) + TAB_BAR_MAGIN20));
    }];
}

- (void)requestData {
    kWeakSelf(self)
    [ASPayRequest requestVipNobleRechargeSuccess:^(id  _Nullable data) {
        wself.detailsModel = data;
        if (wself.detailsModel.info.vip_id == 1) {
            USER_INFO.vip = 1;
            [ASUserDefaults setValue:@(1) forKey:@"userinfo_vip"];
        }
        wself.vipTopView.model = wself.detailsModel.info;
        wself.goodsVipView.list = wself.detailsModel.list;
        wself.receiveGiftView.model = wself.detailsModel.info.gift;
        wself.gradeListView.lists = wself.detailsModel.privilege;
        if (wself.detailsModel.info.vip_id == 1) {
            [wself.openBtn setTitle:@"续费VIP" forState:UIControlStateNormal];
        } else {
            [wself.openBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        }
        //默认选择的推荐套餐
        for (int i = 0; i < wself.detailsModel.list.count; i++) {
            ASVipGoodsModel *model = wself.detailsModel.list[i];
            if (model.vip_suggest == 1) {//默认选择套餐
                wself.selectOpenModel = model;
                return;
            }
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

//去开通
- (void)openVip {
    kWeakSelf(self);
    [ASMsgTool showLoading:@"购买正在进行中，完成前请不要离开"];
    [ASMyAppCommonFunc applePayRequestWithScene:Pay_Scene_Vip
                                   rechargeType:@"2"
                                      productID:self.selectOpenModel.start_ios_product_id
                                         isOpen:self.detailsModel.is_yidun
                                       toUserID:@""
                                        success:^(ASPayTopUpModel * model) {
        [ASFGIAPVerifyTransactionManager goPayWithFilter:wself.filter productID:wself.selectOpenModel.start_ios_product_id orderNo:model.order_no];
    } errorBack:^(NSInteger code) {
        
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = false;
    }
    return _scrollView;
}

- (ASVipDetailsTopView *)vipTopView {
    if (!_vipTopView) {
        _vipTopView = [[ASVipDetailsTopView alloc]init];
    }
    return _vipTopView;
}

- (ASVipDetailsGoodsView *)goodsVipView {
    if (!_goodsVipView) {
        _goodsVipView = [[ASVipDetailsGoodsView alloc]init];
        kWeakSelf(self);
        _goodsVipView.itemBlock = ^(ASVipGoodsModel * _Nonnull model) {
            wself.selectOpenModel = model;
        };
    }
    return _goodsVipView;
}

- (ASVipGradeListView *)gradeListView {
    if (!_gradeListView) {
        _gradeListView = [[ASVipGradeListView alloc]init];
    }
    return _gradeListView;
}

- (UIButton *)openBtn {
    if (!_openBtn) {
        _openBtn = [[UIButton alloc] init];
        _openBtn.titleLabel.font = TEXT_MEDIUM(18);
        _openBtn.layer.cornerRadius = SCALES(24);
        _openBtn.layer.masksToBounds = YES;
        _openBtn.backgroundColor = CHANGE_BG_COLOR(UIColorRGB(0xFECBB0), UIColorRGB(0xFEE1D4), SCALES(319), SCALES(48));
        [_openBtn setTitleColor:UIColorRGB(0x571D03) forState:UIControlStateNormal];
        if (USER_INFO.vip == 1) {
            [_openBtn setTitle:@"续费VIP" forState:UIControlStateNormal];
        } else {
            [_openBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        }
        kWeakSelf(self);
        [[_openBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [wself openVip];
        }];
    }
    return _openBtn;
}

- (ASVipReceiveGiftView *)receiveGiftView {
    if (!_receiveGiftView) {
        _receiveGiftView = [[ASVipReceiveGiftView alloc]init];
        kWeakSelf(self);
        _receiveGiftView.clikedBlock = ^{
            [ASAlertViewManager vipReceiveGiftPopWithModel:wself.detailsModel.info.gift affirmAction:^{
                [ASPayRequest requestReceiveAwardGiftSuccess:^(id  _Nullable data) {
                    [wself requestData];
                    kShowToast(@"领取成功~");
                } errorBack:^(NSInteger code, NSString *msg) {
                    
                }];
            }];
        };
    }
    return _receiveGiftView;
}

- (FGIAPProductsFilter *)filter {
    if (!_filter) {
        _filter = [[FGIAPProductsFilter alloc]init];
    }
    return _filter;
}
@end
