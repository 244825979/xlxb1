//
//  ASWithdrawChangeHomeController.m
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASWithdrawChangeHomeController.h"
#import "ASWithdrawChangeController.h"
#import "ASWithdrawRecordController.h"

@interface ASWithdrawChangeHomeController ()
@property (nonatomic, strong) UILabel *balanceMoney;
@property (nonatomic, strong) UILabel *notMoney;//不可用
@property (nonatomic, strong) UILabel *settleMoney;//待结算
@property (nonatomic, strong) UILabel *settleTitle;//待结算标题
@end

@implementation ASWithdrawChangeHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDCOLOR;
    self.shouldNavigationBarHidden = YES;
    [self createUI];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)createUI {
    UIImageView *topView = [[UIImageView alloc] init];
    topView.image = [UIImage imageNamed:@"withdraw_top"];
    topView.userInteractionEnabled = YES;
    [self.view addSubview:topView];
    topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_NAVBAR + SCALES(272));
    UIButton *back = [[UIButton alloc] init];
    back.adjustsImageWhenHighlighted = NO;
    [back setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    kWeakSelf(self);
    [[back rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wself.navigationController popToRootViewControllerAnimated:YES];
    }];
    back.frame = CGRectMake(10, STATUS_BAR_HEIGHT, 44, 44);
    [topView addSubview:back];
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(100, STATUS_BAR_HEIGHT, SCREEN_WIDTH - 200, 44);
    title.text = @"我的收益";
    title.font = TEXT_FONT_20;
    title.textColor = UIColor.whiteColor;
    title.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:title];
    UILabel *balanceTitle = [[UILabel alloc] init];
    balanceTitle.text = @"可提现余额";
    balanceTitle.font = TEXT_FONT_15;
    balanceTitle.textColor = UIColor.whiteColor;
    [topView addSubview:balanceTitle];
    [balanceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(SCALES(14));
        make.centerX.equalTo(topView).offset(SCALES(-13));
        make.height.mas_equalTo(SCALES(21));
    }];
    UIImageView *balanceIcon = [[UIImageView alloc] init];
    balanceIcon.image = [UIImage imageNamed:@"money1"];
    [topView addSubview:balanceIcon];
    [balanceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(balanceTitle.mas_right).offset(SCALES(10));
        make.centerY.equalTo(balanceTitle);
        make.height.width.mas_equalTo(SCALES(16));
    }];
    self.balanceMoney = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = TEXT_MEDIUM(36);
        label.textColor = UIColor.whiteColor;
        NSString *amountStr = [NSString stringWithFormat:@"%@元", self.model.income_coin_money];
        NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:amountStr];
        [amountAtt addAttribute:NSFontAttributeName
                          value:TEXT_FONT_13
                          range:NSMakeRange(amountStr.length - 1, 1)];
        [label setAttributedText:amountAtt];
        [topView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(balanceTitle.mas_bottom).offset(SCALES(20));
            make.centerX.equalTo(topView);
            make.height.mas_equalTo(SCALES(42));
        }];
        label;
    });
    if (self.model.freeze_money.floatValue > 0) {
        UILabel *notMoneyTitle = [[UILabel alloc] init];
        notMoneyTitle.font = TEXT_FONT_13;
        notMoneyTitle.text = @"不可用余额";
        notMoneyTitle.textAlignment = NSTextAlignmentCenter;
        notMoneyTitle.textColor = UIColor.whiteColor;
        [topView addSubview:notMoneyTitle];
        [notMoneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.balanceMoney.mas_bottom).offset(SCALES(25));
            make.left.mas_equalTo(SCALES(20));
            make.width.mas_equalTo(SCREEN_WIDTH/2 - SCALES(10));
            make.height.mas_equalTo(SCALES(18));
        }];
        self.notMoney = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = TEXT_MEDIUM(16);
            label.textColor = UIColor.whiteColor;
            NSString *amountStr = [NSString stringWithFormat:@"%@元", self.model.freeze_money];
            NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:amountStr];
            [amountAtt addAttribute:NSFontAttributeName
                              value:TEXT_FONT_13
                              range:NSMakeRange(amountStr.length - 1, 1)];
            [label setAttributedText:amountAtt];
            [topView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(notMoneyTitle.mas_bottom);
                make.centerX.equalTo(notMoneyTitle);
                make.height.mas_equalTo(SCALES(22));
            }];
            label;
        });
    }
    if (self.model.wait_coin_show == 1) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColorRGBA(0xffffff, 0.3);
        [topView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.balanceMoney.mas_bottom).offset(SCALES(29));
            make.centerX.equalTo(topView);
            make.height.mas_equalTo(SCALES(30));
            make.width.mas_equalTo(SCALES(1));
        }];
        self.settleTitle = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = TEXT_FONT_13;
            label.textColor = UIColor.whiteColor;
            label.text = STRING(self.model.wait_coin_name);
            label.textAlignment = NSTextAlignmentCenter;
            [topView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.balanceMoney.mas_bottom).offset(SCALES(25));
                make.right.equalTo(topView).offset(SCALES(-20));
                make.width.mas_equalTo(SCREEN_WIDTH/2 - SCALES(10));
                make.height.mas_equalTo(SCALES(18));
            }];
            label;
        });
        self.settleMoney = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = TEXT_MEDIUM(16);
            label.textColor = UIColor.whiteColor;
            NSString *amountStr = [NSString stringWithFormat:@"%@元", self.model.wait_settle_coin];
            NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:amountStr];
            [amountAtt addAttribute:NSFontAttributeName
                              value:TEXT_FONT_13
                              range:NSMakeRange(amountStr.length - 1, 1)];
            [label setAttributedText:amountAtt];
            [topView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.settleTitle.mas_bottom);
                make.centerX.equalTo(self.settleTitle);
                make.height.mas_equalTo(SCALES(22));
            }];
            label;
        });
        UILabel *settleHint = [[UILabel alloc] init];
        settleHint.font = TEXT_FONT_11;
        settleHint.textColor = UIColor.whiteColor;
        settleHint.text = STRING(self.model.wait_coin_tips);
        settleHint.numberOfLines = 0;
        [topView addSubview:settleHint];
        [settleHint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.settleMoney.mas_bottom).offset(SCALES(6));
            make.centerX.equalTo(self.settleMoney);
            make.width.mas_equalTo(SCALES(140));
        }];
    }
    UIView *itemBg = [[UIView alloc] init];
    itemBg.backgroundColor = UIColor.whiteColor;
    itemBg.layer.masksToBounds = YES;
    itemBg.layer.cornerRadius = SCALES(12);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [itemBg addGestureRecognizer:tap];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        ASWithdrawRecordController *vc = [[ASWithdrawRecordController alloc] init];
        [wself.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:itemBg];
    CGFloat freezeMoneyH = self.model.freeze_money.floatValue > 0 ? SCALES(65) : 0;//是否显示待结算样式
    [itemBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceMoney.mas_bottom).offset(self.model.wait_coin_show == 1 ? SCALES(55)+freezeMoneyH : SCALES(31)+freezeMoneyH);
        make.centerX.equalTo(topView);
        make.height.mas_equalTo(SCALES(110));
        make.width.mas_equalTo(SCALES(344));
    }];
    UIView *item1 = [self itemViewWithTitle:@"积分明细"];
    [itemBg addSubview:item1];
    [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(5));
        make.left.right.equalTo(itemBg);
        make.height.mas_equalTo(SCALES(55));
    }];
    UIView *item2 = [self itemViewWithTitle:@"兑换记录"];
    [itemBg addSubview:item2];
    [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(itemBg).offset(SCALES(-5));
        make.left.right.equalTo(itemBg);
        make.height.mas_equalTo(SCALES(55));
    }];
    UIButton *exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exchangeBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    exchangeBtn.titleLabel.font = TEXT_FONT_18;
    [exchangeBtn setTitle:@"提现兑换" forState:UIControlStateNormal];
    exchangeBtn.adjustsImageWhenHighlighted = NO;
    exchangeBtn.layer.masksToBounds = YES;
    exchangeBtn.layer.cornerRadius = SCALES(25);
    [[exchangeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ASWithdrawChangeController *vc = [[ASWithdrawChangeController alloc] init];
        [wself.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:exchangeBtn];
    [exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCALES(319), SCALES(50)));
        make.bottom.equalTo(self.view).offset(SCALES(-12) - TAB_BAR_MAGIN);
    }];
}

- (UIView *)itemViewWithTitle:(NSString *)title {
    UIView *itemView = [[UIView alloc] init];
    itemView.userInteractionEnabled = NO;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = TEXT_FONT_15;
    titleLabel.textColor = TITLE_COLOR;
    titleLabel.text = STRING(title);
    [itemView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(20));
        make.centerY.equalTo(itemView);
    }];
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:@"cell_back"];
    [itemView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(SCALES(-10));
        make.centerY.equalTo(itemView);
        make.width.height.mas_equalTo(SCALES(16));
    }];
    return itemView;
}
@end
