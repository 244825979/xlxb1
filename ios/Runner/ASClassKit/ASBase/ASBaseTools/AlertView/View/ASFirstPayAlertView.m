//
//  ASFirstPayAlertView.m
//  AS
//
//  Created by SA on 2025/6/11.
//

#import "ASFirstPayAlertView.h"
#import <FGIAPService/FGIAPManager.h>
#import <FGIAPService/FGIAPProductsFilter.h>
#import "CustomButton.h"
#import "ASFGIAPVerifyTransactionManager.h"
#import "ASPayTopUpModel.h"

@interface ASFirstPayAlertView()
@property (nonatomic, strong) UIView *giftsBg;//礼物背景
@property (nonatomic, strong) FGIAPProductsFilter *filter;
@end

@implementation ASFirstPayAlertView
//构造方法
- (instancetype)initFirstPayViewWithModel:(ASFirstPayDataModel *)model {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];        
        self.size = CGSizeMake(SCALES(319), SCALES(485));
        ASFirstPayListModel *listModel = model.list[0];
        kWeakSelf(self);
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"first_pop"];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(SCALES(-40));
            make.left.right.top.equalTo(self);
        }];
        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"close4"] forState:UIControlStateNormal];
        closeBtn.adjustsImageWhenHighlighted = NO;
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self);
            make.height.width.mas_equalTo(SCALES(24));
        }];
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
                [wself removeView];
            }
        }];
        UILabel *title = [[UILabel alloc] init];
        title.text = @"礼包特惠仅可享受1次";
        title.textColor = MAIN_COLOR;
        title.font = TEXT_FONT_18;
        [bgView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(114));
            make.centerX.equalTo(bgView);
            make.height.mas_equalTo(SCALES(24));
        }];
        [bgView addSubview:self.giftsBg];
        [self.giftsBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(154));
            make.centerX.equalTo(bgView);
            make.width.mas_equalTo(SCALES(287));
            make.height.mas_equalTo(SCALES(175));
        }];
        UIImageView *moneyBg = [[UIImageView alloc]init];
        moneyBg.image = [UIImage imageNamed:@"frist_pay_money"];
        moneyBg.userInteractionEnabled = YES;
        [bgView addSubview:moneyBg];
        [moneyBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.giftsBg);
            make.height.mas_equalTo(SCALES(48));
        }];
        UILabel *moneyLabel = [[UILabel alloc]init];
        moneyLabel.font = TEXT_MEDIUM(22);
        NSString *moneyStr = [NSString stringWithFormat:@"￥%zd | %zd金币", listModel.price, listModel.amount];
        moneyLabel.text = moneyStr;
        moneyLabel.textColor = UIColorRGB(0x742B08);
        [moneyBg addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(15));
            make.centerY.equalTo(moneyBg);
        }];
        CustomButton *morePayBtn = [[CustomButton alloc] init];
        [morePayBtn setImage:[UIImage imageNamed:@"cell_back1"] forState:UIControlStateNormal];
        [morePayBtn setTitle:@"更多充值" forState:UIControlStateNormal];
        morePayBtn.titleLabel.font = TEXT_MEDIUM(13.5);
        morePayBtn.adjustsImageWhenHighlighted = NO;
        [morePayBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [moneyBg addSubview:morePayBtn];
        [morePayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(SCALES(-4));
            make.centerY.height.right.equalTo(moneyBg);
        }];
        [[morePayBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
            [ASMyAppCommonFunc balanceDeficiencyPopViewWithPayScene:Pay_Scene_FirstPay cancel:^{
                
            }];
        }];
        UIButton *payBtn = [[UIButton alloc] init];
        [payBtn setBackgroundImage:[UIImage imageNamed:@"frist_pay_btn"] forState:UIControlStateNormal];
        payBtn.adjustsImageWhenHighlighted = NO;
        [payBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [bgView addSubview:payBtn];
        [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.giftsBg.mas_bottom).offset(SCALES(16));
            make.centerX.equalTo(bgView);
            make.width.mas_equalTo(SCALES(199));
            make.height.mas_equalTo(SCALES(50));
        }];
        [[payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASMsgTool showLoading:@"购买正在进行中，完成前请不要离开"];
            [ASMyAppCommonFunc applePayRequestWithScene:Pay_Scene_FirstPay
                                           rechargeType:@"1"
                                              productID:listModel.ios_product_id
                                                 isOpen:model.is_yidun
                                               toUserID:@""
                                                success:^(ASPayTopUpModel * model) {
                [ASFGIAPVerifyTransactionManager goPayWithFilter:wself.filter productID:listModel.ios_product_id orderNo:model.order_no];
            } errorBack:^(NSInteger code) {
                if (wself.cancelBlock) {
                    wself.cancelBlock();
                    [wself removeView];
                }
            }];
        }];
        YYLabel *agreementView = [[YYLabel alloc]init];
        agreementView.numberOfLines = 0;
        agreementView.attributedText = [ASTextAttributedManager firstPayProtectAgreement:^{
            if (wself.cancelBlock) {
                wself.cancelBlock();
                [wself removeView];
            }
            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
            vc.webUrl = USER_INFO.configModel.webUrl.recharge;
            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
        }];
        [bgView addSubview:agreementView];
        [agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(payBtn.mas_bottom).offset(SCALES(12));
            make.centerX.equalTo(bgView);
            make.height.mas_equalTo(SCALES(22));
        }];
        for (int i = 0; i < listModel.reward_gift.count; i++) {
            if (i < 3) {
                ASFirstPayGiftView *giftView = [[ASFirstPayGiftView alloc] init];
                giftView.giftModel = listModel.reward_gift[i];
                giftView.frame = CGRectMake(SCALES(11) + i*(SCALES(85)+SCALES(5)), SCALES(64), SCALES(85), SCALES(95));
                giftView.layer.masksToBounds = YES;
                giftView.layer.cornerRadius = SCALES(10);
                giftView.layer.borderColor = UIColorRGB(0xFFD391).CGColor;
                giftView.layer.borderWidth = SCALES(1);
                [self.giftsBg addSubview:giftView];
            }
        }
        ///关闭充值弹窗
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"updateBalanceNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
        }];
    }
    return self;
}

- (UIView *)giftsBg {
    if (!_giftsBg) {
        _giftsBg = [[UIView alloc]init];
        _giftsBg.backgroundColor = UIColorRGB(0xFFF1F4);
        _giftsBg.layer.cornerRadius = SCALES(12);
    }
    return _giftsBg;
}

- (void)removeView {
    [self removeFromSuperview];
}

- (FGIAPProductsFilter *)filter {
    if (!_filter) {
        _filter = [[FGIAPProductsFilter alloc]init];
    }
    return _filter;
}
@end

@interface ASFirstPayGiftView ()
@property (nonatomic, strong) UILabel *bottomTitle;
@property (nonatomic, strong) UIImageView *giftIcon;
@property (nonatomic, copy) UILabel *acount;
@end

@implementation ASFirstPayGiftView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.bottomTitle];
    [self addSubview:self.giftIcon];
    [self addSubview:self.acount];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bottomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(SCALES(28));
    }];
    [self.giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(16));
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(SCALES(45));
    }];
    self.acount.frame = CGRectMake(self.width - SCALES(32), 0, SCALES(32), SCALES(18));
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.acount.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(SCALES(9), SCALES(9))];
     CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.acount.bounds;
    maskLayer.path = maskPath.CGPath;
    self.acount.layer.mask = maskLayer;
}

- (void)setGiftModel:(ASFirstGiftModel *)giftModel {
    _giftModel = giftModel;
    self.bottomTitle.text = STRING(giftModel.name);
    [self.giftIcon sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, STRING(giftModel.img)]]];
    self.acount.text = [NSString stringWithFormat:@"x%zd", giftModel.number];
}

- (UILabel *)bottomTitle {
    if (!_bottomTitle) {
        _bottomTitle = [[UILabel alloc]init];
        _bottomTitle.textColor = MAIN_COLOR;
        _bottomTitle.font = TEXT_MEDIUM(14);
        _bottomTitle.backgroundColor = UIColorRGB(0xFFDFE6);
        _bottomTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomTitle;
}

- (UIImageView *)giftIcon {
    if (!_giftIcon) {
        _giftIcon = [[UIImageView alloc]init];
        _giftIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _giftIcon;
}

- (UILabel *)acount {
    if (!_acount) {
        _acount = [[UILabel alloc]init];
        _acount.textColor = UIColorRGB(0x66340F);
        _acount.backgroundColor = UIColorRGB(0xFFDD2F);
        _acount.font = TEXT_FONT_11;
        _acount.textAlignment = NSTextAlignmentCenter;
    }
    return _acount;
}

@end
