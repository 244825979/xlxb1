//
//  ASBalanceDeficiencyAlertView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASBalanceDeficiencyAlertView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <FGIAPService/FGIAPManager.h>
#import <FGIAPService/FGIAPProductsFilter.h>
#import "ASFGIAPVerifyTransactionManager.h"
#import "ASMineRequest.h"
#import "ASPayTopUpModel.h"

@interface ASBalanceDeficiencyAlertView ()<SDCycleScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) NSArray *bannerDatas;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, strong) FGIAPProductsFilter *filter;
@property (nonatomic, strong) ASGoodsListModel *selectGood;
@property (nonatomic, strong) UIView *headBannerBgView;
@end

@implementation ASBalanceDeficiencyAlertView

- (FGIAPProductsFilter *)filter {
    if (!_filter) {
        _filter = [[FGIAPProductsFilter alloc]init];
    }
    return _filter;
}

- (instancetype)initBalanceDeficiencyViewWithModel:(ASPayGoodsDataModel *)model
                                             scene:(NSString *)scene {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor clearColor];
        self.size = CGSizeMake(SCREEN_WIDTH, SCALES(359) + TAB_BAR_MAGIN + SCALES(95));
        self.headBannerBgView = ({
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(95));
            [self addSubview:view];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [view addGestureRecognizer:tap];
            [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                if (wself.cancelBlock) {
                    wself.cancelBlock();
                }
            }];
            view;
        });
        self.bannerView = ({
            SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(SCALES(16),
                                                                                                   0,
                                                                                                   floorf(SCREEN_WIDTH - SCALES(32)),
                                                                                                   SCALES(80))
                                                                               delegate:self
                                                                       placeholderImage:[UIImage imageNamed:@""]];
            bannerView.hidden = YES;
            bannerView.backgroundColor = UIColor.clearColor;
            bannerView.autoScrollTimeInterval = 3.0f;
            bannerView.layer.masksToBounds = YES;
            bannerView.layer.cornerRadius = SCALES(8);
            bannerView.showPageControl = NO;
            [self addSubview:bannerView];
            bannerView;
        });
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = UIColor.whiteColor;
        [self addSubview:bgView];
        bgView.frame = CGRectMake(0, SCALES(95), SCREEN_WIDTH, SCALES(359) + TAB_BAR_MAGIN);
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = TEXT_MEDIUM(16);
        titleLabel.text = @"请选择充值金额";
        titleLabel.textColor = TITLE_COLOR;
        [bgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(16));
            make.top.mas_equalTo(SCALES(20));
            make.height.mas_equalTo(SCALES(20));
        }];
        UIImageView *moneyIcon = [[UIImageView alloc] init];
        moneyIcon.image = [UIImage imageNamed:@"money1"];
        [bgView addSubview:moneyIcon];
        [moneyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView.mas_right).offset(SCALES(-16));
            make.top.mas_equalTo(SCALES(22));
            make.height.width.mas_equalTo(SCALES(18));
        }];
        UILabel *moneyLabel = [[UILabel alloc]init];
        moneyLabel.font = TEXT_MEDIUM(14);
        moneyLabel.textColor = RED_COLOR;
        NSString *text = [NSString stringWithFormat:@"余额：%@",model.coin];
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:text];
        [attributed addAttribute:NSForegroundColorAttributeName
                           value:TEXT_COLOR
                           range:NSMakeRange(0, 3)];
        [moneyLabel setAttributedText:attributed];
        [bgView addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(moneyIcon.mas_left).offset(SCALES(-5));
            make.centerY.equalTo(moneyIcon);
            make.height.mas_equalTo(SCALES(20));
            make.width.mas_lessThanOrEqualTo(SCALES(200));//最大宽度限制
        }];
        CGFloat itemW = floorf((SCREEN_WIDTH - SCALES(32) - SCALES(16)) /3);//图片宽度
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemW, SCALES(100));
        layout.minimumInteritemSpacing = SCALES(8);
        layout.minimumLineSpacing = SCALES(8);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCALES(16), SCALES(57), SCREEN_WIDTH - SCALES(32), SCALES(210)) collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        [bgView addSubview:self.collectionView];
        self.collectionView.backgroundColor = UIColor.whiteColor;
        [self.collectionView registerClass:[ASBalanceListCell class] forCellWithReuseIdentifier:@"balanceListCell"];
        UIButton* payBtn = [[UIButton alloc] init];
        payBtn.adjustsImageWhenHighlighted = NO;
        [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [payBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        payBtn.titleLabel.font = TEXT_FONT_18;
        payBtn.layer.masksToBounds = YES;
        payBtn.layer.cornerRadius = SCALES(25);
        [[payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASMsgTool showLoading:@"购买正在进行中，完成前请不要离开"];
            [ASMyAppCommonFunc applePayRequestWithScene:scene
                                           rechargeType:@"1"
                                              productID:wself.selectGood.ios_product_id
                                                 isOpen:model.is_yidun
                                               toUserID:@""
                                                success:^(ASPayTopUpModel * model) {
                [ASFGIAPVerifyTransactionManager goPayWithFilter:wself.filter productID:wself.selectGood.ios_product_id orderNo:model.order_no];
            } errorBack:^(NSInteger code) { }];
        }];
        [bgView addSubview:payBtn];
        [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bgView).offset(-TAB_BAR_MAGIN - SCALES(15));
            make.centerX.equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(SCALES(319), SCALES(50)));
        }];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(SCALES(10), SCALES(10))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = bgView.bounds;
        maskLayer.path = maskPath.CGPath;
        bgView.layer.mask = maskLayer;
        [self requestBanner];
        self.listArray = model.list;
        [self.collectionView reloadData];
        if (model.list.count > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            self.selectGood = self.listArray[0];
        }
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"updateBalanceNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
        }];
    }
    return self;
}

- (void)removeView {
    [self removeFromSuperview];
}

- (void)requestBanner {
    kWeakSelf(self);
    [ASMineRequest requestBannerWithType:@"11" success:^(NSArray * _Nullable banner) {
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
        wself.headBannerBgView.userInteractionEnabled = YES;
    }];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    ASBannerModel *model = self.bannerDatas[index];
    if (self.cancelBlock) {
        self.cancelBlock();
        [self removeView];
    }
    [ASMyAppCommonFunc bannerClikedWithBannerModel:model viewController:[ASCommonFunc currentVc] action:^(id  _Nonnull data) {
        
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASBalanceListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"balanceListCell" forIndexPath:indexPath];
    cell.model = self.listArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectGood = self.listArray[indexPath.row];
}

@end

@interface ASBalanceListCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *firstIcon;
@property (nonatomic, strong) UIImageView *moneyIcon;
@property (nonatomic, strong) UILabel *gold;
@property (nonatomic, strong) UILabel *give;
@property (nonatomic, strong) UIImageView *giveBg;
@property (nonatomic, strong) UILabel *money;
@end

@implementation ASBalanceListCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.firstIcon];
        [self.contentView addSubview:self.giveBg];
        [self.contentView addSubview:self.give];
        [self.bgView addSubview:self.moneyIcon];
        [self.bgView addSubview:self.gold];
        [self.bgView addSubview:self.money];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.firstIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(60), SCALES(22)));
    }];
    [self.give mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(SCALES(22));
        make.width.mas_lessThanOrEqualTo(self.bgView.mas_width);//最大宽度限制
    }];
    [self.giveBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.give);
    }];
    [self.gold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView).offset(SCALES(12));
        make.top.mas_equalTo(SCALES(38));
        make.height.mas_equalTo(SCALES(22));
    }];
    [self.moneyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.gold.mas_left).offset(SCALES(-6));
        make.centerY.equalTo(self.gold);
        make.width.height.mas_equalTo(SCALES(18));
    }];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-SCALES(15));
        make.height.mas_equalTo(SCALES(17));
    }];
}

- (void)setModel:(ASGoodsListModel *)model {
    _model = model;
    if (model.btn_text.count > 0) {
        NSString *text = model.btn_text[0];
        self.give.hidden = kStringIsEmpty(text) ? YES : NO;
        self.giveBg.hidden = kStringIsEmpty(text) ? YES : NO;
        self.give.text = [NSString stringWithFormat:@"   %@   ", STRING(text)];
    } else {
        self.giveBg.hidden = YES;
        self.give.hidden = YES;
    }
    self.money.text = [NSString stringWithFormat:@"￥%zd", model.price];
    self.gold.text = [NSString stringWithFormat:@"%zd",model.amount];
    self.firstIcon.hidden = kStringIsEmpty(model.first_recharge) ? YES : NO;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = SCALES(12);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderColor = UIColorRGB(0xF7F7F9).CGColor;
        _bgView.layer.borderWidth = SCALES(2);
        _bgView.backgroundColor = UIColorRGB(0xF7F7F9);
    }
    return _bgView;
}

- (UIImageView *)moneyIcon {
    if (!_moneyIcon) {
        _moneyIcon = [[UIImageView alloc]init];
        _moneyIcon.image = [UIImage imageNamed:@"money1"];
    }
    return _moneyIcon;
}

- (UIImageView *)firstIcon {
    if (!_firstIcon) {
        _firstIcon = [[UIImageView alloc]init];
        _firstIcon.image = [UIImage imageNamed:@"pay_first"];
    }
    return _firstIcon;
}

- (UILabel *)money {
    if (!_money) {
        _money = [[UILabel alloc]init];
        _money.text = @"￥0";
        _money.textColor = TEXT_COLOR;
        _money.font = TEXT_FONT_12;
        _money.textAlignment = NSTextAlignmentCenter;
    }
    return _money;
}

- (UILabel *)gold {
    if (!_gold) {
        _gold = [[UILabel alloc]init];
        _gold.text = @"0";
        _gold.textColor = TITLE_COLOR;
        _gold.font = TEXT_MEDIUM(20);
    }
    return _gold;
}

- (UILabel *)give {
    if (!_give) {
        _give = [[UILabel alloc]init];
        _give.text = @"赠送金币";
        _give.textColor = UIColorRGB(0x66340F);
        _give.font = TEXT_MEDIUM(11);
        _give.textAlignment = NSTextAlignmentCenter;
    }
    return _give;
}

- (UIImageView *)giveBg {
    if (!_giveBg) {
        _giveBg = [[UIImageView alloc]init];
        _giveBg.image = [UIImage imageNamed:@"pay_give"];
        _giveBg.hidden = YES;
    }
    return _giveBg;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.bgView.backgroundColor = UIColorRGBA(0xFF1832, 0.06);
        self.bgView.layer.borderColor = MAIN_COLOR.CGColor;
        self.gold.textColor = MAIN_COLOR;
    } else {
        self.bgView.backgroundColor = UIColorRGB(0xF7F7F9);
        self.bgView.layer.borderColor = UIColorRGB(0xF7F7F9).CGColor;
        self.gold.textColor = TITLE_COLOR;
    }
}
@end
