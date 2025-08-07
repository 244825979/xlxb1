//
//  ASSendVipPopView.m
//  AS
//
//  Created by SA on 2025/5/20.
//

#import "ASSendVipPopView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "ASPageControl.h"
#import "ASFGIAPVerifyTransactionManager.h"
#import "ASPayTopUpModel.h"

@interface ASSendVipPopView ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *selectBgView;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) YYLabel *agreementView;
@property (nonatomic, strong) ASSendVipOpenItemView *selectItem;
@property (nonatomic, strong) ASPageControl *pageControl;
@property (nonatomic, strong) ASSendVipGoodListModel *selectModel;
@property (nonatomic, strong) FGIAPProductsFilter *filter;
@end

@implementation ASSendVipPopView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = UIColor.whiteColor;
        self.size = CGSizeMake(SCREEN_WIDTH, SCALES(487) + TAB_BAR_MAGIN);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(SCALES(12), SCALES(12))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(SCREEN_WIDTH/2 - SCALES(231)/2,
                                                                             SCALES(24),
                                                                             floorf(SCALES(231)),
                                                                             SCALES(149)) delegate:self placeholderImage:nil];
    self.bannerView.backgroundColor = UIColor.whiteColor;
    self.bannerView.autoScrollTimeInterval = 3.0f;
    self.bannerView.showPageControl = NO;//显示分页控制器
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.bannerView];
    [self addSubview:self.pageControl];
    [self addSubview:self.closeBtn];
    [self addSubview:self.selectBgView];
    [self addSubview:self.sendBtn];
    [self addSubview:self.agreementView];
    self.pageControl.frame = CGRectMake(self.bannerView.left, SCALES(173), self.bannerView.width, SCALES(34));
    kWeakSelf(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"updateVipNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        if (wself.cancelBlock) {
            [wself removeView];
            wself.cancelBlock();
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(16));
        make.right.offset(SCALES(-16));
        make.height.width.mas_equalTo(SCALES(24));
    }];
    [self.selectBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.right.offset(SCALES(-16));
        make.top.mas_equalTo(SCALES(214));
        make.height.mas_equalTo(SCALES(130));
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectBgView.mas_bottom).offset(SCALES(28));
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(300), SCALES(50)));
    }];
    [self.agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendBtn.mas_bottom).offset(SCALES(12));
        make.centerX.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(60));
        make.height.mas_equalTo(SCALES(40));
    }];
}

- (void)setSendVipModel:(ASSendVipModel *)sendVipModel {
    _sendVipModel = sendVipModel;
    CGFloat viewH = SCALES(130);
    CGFloat viewW = (SCREEN_WIDTH - SCALES(32) - SCALES(20))/3;
    kWeakSelf(self);
    for (int i = 0; i < sendVipModel.goodList.count; i++) {
        ASSendVipGoodListModel *model = sendVipModel.goodList[i];
        ASSendVipOpenItemView *view = [[ASSendVipOpenItemView alloc] init];
        view.model = model;
        view.frame = CGRectMake((viewW + SCALES(10)) * i, 0, viewW, viewH);
        [self.selectBgView addSubview:view];
        if (model.is_checked == 1) {
            view.isSelect = YES;
            self.selectItem = view;
            self.selectModel = model;
        }
        view.itemClikedBlock = ^(ASSendVipOpenItemView * _Nonnull backView) {
            backView.isSelect = YES;
            wself.selectItem.isSelect = NO;
            wself.selectItem = backView;
            wself.selectModel = backView.model;
        };
    }
    NSMutableArray *urls = [NSMutableArray array];
    for (ASSendVipPrivilegeList *model in sendVipModel.privilegeList) {
        [urls addObject:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL,model.banner]];
    }
    self.pageControl.numberOfPages = urls.count;
    wself.bannerView.imageURLStringsGroup = urls;
}

#pragma mark - SDCycleScrollViewDelegate
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    self.pageControl.currentPage = index;
}

- (UIView *)selectBgView {
    if (!_selectBgView) {
        _selectBgView = [[UIView alloc]init];
    }
    return _selectBgView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setImage:[UIImage imageNamed:@"close2"] forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
        }];
    }
    return _closeBtn;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitle:@"立即赠送" forState:UIControlStateNormal];
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        _sendBtn.adjustsImageWhenHighlighted = NO;
        _sendBtn.titleLabel.font = TEXT_MEDIUM(18);
        _sendBtn.layer.cornerRadius = SCALES(25);
        _sendBtn.layer.masksToBounds = YES;
        kWeakSelf(self);
        [[_sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (kObjectIsEmpty(wself.selectItem)) {
                kShowToast(@"请选择赠送的套餐");
                return;
            }
            [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"当前操作为赠送对方VIP，而非为自己开通VIP，确认赠送吗？" left:@"确认" right:@"取消" affirmAction:^{
                [ASMsgTool showLoading:@"赠送购买进行中，完成前请不要离开"];
                [ASMyAppCommonFunc applePayRequestWithScene:Pay_Scene_Vip
                                               rechargeType:@"2"
                                                  productID:wself.selectModel.start_ios_product_id
                                                     isOpen:wself.sendVipModel.is_yidun
                                                   toUserID:wself.toUserID
                                                    success:^(ASPayTopUpModel * model) {
                    [ASFGIAPVerifyTransactionManager goPayWithFilter:wself.filter productID:wself.selectModel.start_ios_product_id orderNo:model.order_no];
                } errorBack:^(NSInteger code) {
                    
                }];
            } cancelAction:^{
                
            }];
        }];
    }
    return _sendBtn;
}

- (YYLabel *)agreementView {
    if (!_agreementView) {
        _agreementView = [[YYLabel alloc]init];
        kWeakSelf(self);
        _agreementView.attributedText = [ASTextAttributedManager goPayProtectAgreement:^{
            if (wself.cancelBlock) {
                [wself removeView];
                wself.cancelBlock();
            }
            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
            vc.webUrl = USER_INFO.configModel.webUrl.recharge;
            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
        } teenagerAction:^{
            if (wself.cancelBlock) {
                [wself removeView];
                wself.cancelBlock();
            }
            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
            vc.webUrl = USER_INFO.configModel.webUrl.teenagerProtocol;
            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
        }];
        _agreementView.numberOfLines = 0;
    }
    return _agreementView;
}

- (ASPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[ASPageControl alloc]init];
        _pageControl.currentPointSize = CGSizeMake(SCALES(6), SCALES(6));
        _pageControl.otherPointSize = CGSizeMake(SCALES(6), SCALES(6));
        _pageControl.currentColor = UIColorRGB(0x7C5220);
        _pageControl.otherColor = UIColorRGB(0xE7E7E7);
        _pageControl.controlSpacing = SCALES(9);
        _pageControl.pointCornerRadius = SCALES(3);
    }
    return _pageControl;
}

- (FGIAPProductsFilter *)filter {
    if (!_filter) {
        _filter = [[FGIAPProductsFilter alloc]init];
    }
    return _filter;
}

- (void)removeView {
    [self removeFromSuperview];
}
@end


@interface ASSendVipOpenItemView ()
@property (nonatomic, strong) UILabel *recommendText;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *acount;
@property (nonatomic, strong) UILabel *originalCost;
@property (nonatomic, strong) UILabel *economize;
@end

@implementation ASSendVipOpenItemView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.bgView];
        [self addSubview:self.recommendText];
        [self.bgView addSubview:self.time];
        [self.bgView addSubview:self.acount];
        [self.bgView addSubview:self.originalCost];
        [self.bgView addSubview:self.economize];
        self.recommendText.frame = CGRectMake(0, 0, SCALES(65), SCALES(20));
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.recommendText.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(SCALES(10), SCALES(10))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.recommendText.bounds;
        maskLayer.path = maskPath.CGPath;
        self.recommendText.layer.mask = maskLayer;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.itemClikedBlock) {
                wself.itemClikedBlock(wself);
            }
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.mas_equalTo(SCALES(10));
    }];
    if (kAppType == 1) {
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.top.mas_equalTo(SCALES(25));
            make.height.mas_equalTo(SCALES(15));
            make.width.equalTo(self.bgView);
        }];
        [self.acount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView).offset(SCALES(-3));
            make.top.mas_equalTo(SCALES(50));
            make.height.mas_equalTo(SCALES(31));
            make.width.equalTo(self.bgView.mas_width).offset(SCALES(-3));
        }];
    } else {
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.top.mas_equalTo(SCALES(15));
            make.height.mas_equalTo(SCALES(15));
            make.width.equalTo(self.bgView);
        }];
        [self.acount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView).offset(SCALES(-2));
            make.top.mas_equalTo(SCALES(36));
            make.height.mas_equalTo(SCALES(20));
            make.width.equalTo(self.bgView.mas_width).offset(SCALES(-2));
        }];
    }
    [self.originalCost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.mas_equalTo(SCALES(64));
        make.height.mas_equalTo(SCALES(14));
        make.width.equalTo(self.bgView);
    }];
    [self.economize mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.mas_equalTo(SCALES(85));
        make.height.mas_equalTo(SCALES(20));
        make.width.mas_equalTo(SCALES(63));
    }];
}

- (void)setModel:(ASSendVipGoodListModel *)model {
    _model = model;
    self.time.text = STRING(model.expire);
    self.economize.text = [NSString stringWithFormat:@"立省%@元",STRING(model.diff)];
    NSString *amountStr = [NSString stringWithFormat:@"￥%@", model.price];
    NSMutableAttributedString * amountAtt = [[NSMutableAttributedString alloc] initWithString:amountStr];
    [amountAtt addAttribute:NSFontAttributeName
                      value:TEXT_FONT_11
                      range:NSMakeRange(0, 1)];
    [self.acount setAttributedText:amountAtt];
    NSMutableAttributedString *marketPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价%@元", model.old_price]];
    [marketPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, marketPrice.length)];
    self.originalCost.attributedText = marketPrice;
    if (model.is_checked == 1) {
        self.recommendText.hidden = NO;
    } else {
        self.recommendText.hidden = YES;
    }
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    if (isSelect) {
        self.time.textColor = UIColorRGB(0x7C5220);
        self.acount.textColor = UIColorRGB(0x7C5220);
        self.bgView.layer.borderColor = UIColorRGB(0x7C5220).CGColor;
        self.bgView.backgroundColor = UIColorRGB(0xFBF6EC);
    } else {
        self.time.textColor = TITLE_COLOR;
        self.acount.textColor = TITLE_COLOR;
        self.bgView.layer.borderColor = UIColor.clearColor.CGColor;
        self.bgView.backgroundColor = UIColorRGB(0xF5F5F5);
    }
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = SCALES(8);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderWidth = SCALES(2);
        _bgView.layer.borderColor = UIColor.clearColor.CGColor;
        _bgView.backgroundColor = UIColorRGB(0xF5F5F5);
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UILabel *)recommendText {
    if (!_recommendText) {
        _recommendText = [[UILabel alloc]init];
        _recommendText.textAlignment = NSTextAlignmentCenter;
        _recommendText.text = @"性价比推荐";
        _recommendText.backgroundColor = GRDUAL_CHANGE_BG_COLOR(SCALES(65), SCALES(20));
        _recommendText.textColor = UIColor.whiteColor;
        _recommendText.font = TEXT_FONT_10;
        _recommendText.hidden = YES;
    }
    return _recommendText;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.text = @"1个月";
        _time.textColor = TITLE_COLOR;
        _time.font = TEXT_FONT_12;
        _time.textAlignment = NSTextAlignmentCenter;
    }
    return _time;
}

- (UILabel *)acount {
    if (!_acount) {
        _acount = [[UILabel alloc]init];
        _acount.text = @"￥0";
        _acount.textColor = TITLE_COLOR;
        _acount.font = TEXT_MEDIUM(20);
        _acount.textAlignment = NSTextAlignmentCenter;
    }
    return _acount;
}

- (UILabel *)originalCost {
    if (!_originalCost) {
        _originalCost = [[UILabel alloc]init];
        _originalCost.text = @"原价0.0";
        _originalCost.textColor = TEXT_SIMPLE_COLOR;
        _originalCost.font = TEXT_FONT_10;
        _originalCost.textAlignment = NSTextAlignmentCenter;
        if (kAppType == 1) {
            _originalCost.hidden = YES;
        }
    }
    return _originalCost;
}

- (UILabel *)economize {
    if (!_economize) {
        _economize = [[UILabel alloc]init];
        _economize.text = @"立省0元";
        _economize.textColor = UIColor.whiteColor;
        _economize.backgroundColor = UIColorRGB(0x7C5220);
        _economize.font = TEXT_FONT_10;
        _economize.textAlignment = NSTextAlignmentCenter;
        _economize.layer.cornerRadius = SCALES(10);
        _economize.layer.masksToBounds = YES;
        if (kAppType == 1) {
            _economize.hidden = YES;
        }
    }
    return _economize;
}
@end
