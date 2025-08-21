//
//  ASWithdrawBalanceSubView.m
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASWithdrawBalanceSubView.h"

@interface ASWithdrawBalanceSubView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *withdrawTypeTitle;
@property (nonatomic, strong) ASWithdrawSelectTypeView *selectPayView;
@property (nonatomic, strong) UILabel *withdrawExplainTitle;//提现说明标题
@property (nonatomic, strong) UIView *explainBgView;
@property (nonatomic, strong) UIButton *submit;
@property (nonatomic, strong) YYLabel *agreementView;//协议
/**数据*/
@property (nonatomic, strong) NSMutableArray *lists;
@end

@implementation ASWithdrawBalanceSubView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        CGFloat itemW = floorf((SCREEN_WIDTH - SCALES(28) - SCALES(14)) / 3);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemW, SCALES(85));
        layout.minimumInteritemSpacing = SCALES(7);
        layout.minimumLineSpacing = SCALES(7);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCALES(14), SCALES(10), SCREEN_WIDTH - SCALES(28), SCALES(85) * 3 + SCALES(16)) collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.backgroundColor = UIColor.clearColor;
        [self.scrollView addSubview:self.collectionView];
        [self.collectionView registerClass:[ASWithdrawListCell class] forCellWithReuseIdentifier:@"withdrawListCell"];
     
        [self.scrollView addSubview:self.withdrawTypeTitle];
        [self.scrollView addSubview:self.selectPayView];
        [self.scrollView addSubview:self.withdrawExplainTitle];
        [self.scrollView addSubview:self.explainBgView];
        [self.explainBgView addSubview:self.agreementView];
        [self addSubview:self.submit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-TAB_BAR_MAGIN20 -SCALES(50) -SCALES(20));
    }];
    [self.withdrawTypeTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.top.equalTo(self.collectionView.mas_bottom).offset(SCALES(12));
        make.height.mas_equalTo(SCALES(22));
    }];
    [self.selectPayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(28));
        make.top.equalTo(self.withdrawTypeTitle.mas_bottom).offset(SCALES(12));
        make.height.mas_equalTo(SCALES(50));
    }];
    [self.withdrawExplainTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.withdrawTypeTitle);
        make.top.equalTo(self.withdrawTypeTitle.mas_bottom).offset(SCALES(78));
        make.height.mas_equalTo(SCALES(22));
    }];
    CGFloat textMaxLayoutWidth = floorf(SCREEN_WIDTH - SCALES(56));
    [self.agreementView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.top.mas_equalTo(SCALES(10));
        make.width.mas_equalTo(textMaxLayoutWidth);
        make.bottom.equalTo(self.explainBgView).offset(SCALES(-10));
    }];
    [self.explainBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.selectPayView);
        make.top.equalTo(self.withdrawExplainTitle.mas_bottom).offset(SCALES(14));
        make.height.equalTo(self.agreementView.mas_height).offset(SCALES(20));
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(SCALES(-20));
    }];
    [self.submit mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(319), SCALES(50)));
        make.bottom.equalTo(self.mas_bottom).offset(-TAB_BAR_MAGIN20 - SCALES(12));
    }];
}

- (void)setModel:(ASWithdrawModel *)model {
    _model = model;
    self.lists = [NSMutableArray arrayWithArray:model.list];
    self.selectPayView.model = model;
    [self.collectionView reloadData];
    kWeakSelf(self);
    if (model.list.count > 0) {
        NSNumber *number = model.list[0];
        if (model.income_money.floatValue > number.floatValue) {
            if (self.selectMoneyBlock) {
                self.selectMoneyBlock(number);
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
            dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
                [wself.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            });
        }
    }
    self.agreementView.attributedText = [ASTextAttributedManager withdrawExplainWithText:model.des agreement:^{
        if (wself.clikedBlock) {
            wself.clikedBlock(@"合作协议");
        }
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASWithdrawListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"withdrawListCell" forIndexPath:indexPath];
    NSNumber* number = self.lists[indexPath.row];
    cell.number = number.integerValue;
    cell.income_money = self.model.income_money.floatValue;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *money = self.model.list[indexPath.row];
    if (self.selectMoneyBlock) {
        self.selectMoneyBlock(money);
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = UIColor.whiteColor;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UILabel *)withdrawTypeTitle {
    if (!_withdrawTypeTitle) {
        _withdrawTypeTitle = [[UILabel alloc]init];
        _withdrawTypeTitle.text = @"提现方式";
        _withdrawTypeTitle.textColor = TITLE_COLOR;
        _withdrawTypeTitle.font = TEXT_FONT_15;
    }
    return _withdrawTypeTitle;
}

- (ASWithdrawSelectTypeView *)selectPayView {
    if (!_selectPayView) {
        _selectPayView = [[ASWithdrawSelectTypeView alloc]init];
        _selectPayView.backgroundColor = UIColorRGB(0xF5F5F5);
        _selectPayView.layer.cornerRadius = SCALES(8);
        _selectPayView.layer.masksToBounds = YES;
        kWeakSelf(self);
        _selectPayView.clikedBlock = ^{
            if (wself.clikedBlock) {
                wself.clikedBlock(@"账号绑定");
            }
        };
    }
    return _selectPayView;
}

- (UILabel *)withdrawExplainTitle {
    if (!_withdrawExplainTitle) {
        _withdrawExplainTitle = [[UILabel alloc]init];
        _withdrawExplainTitle.text = @"提现说明";
        _withdrawExplainTitle.textColor = TITLE_COLOR;
        _withdrawExplainTitle.font = TEXT_FONT_16;
    }
    return _withdrawExplainTitle;
}

- (UIView *)explainBgView {
    if (!_explainBgView) {
        _explainBgView = [[UIView alloc]init];
        _explainBgView.backgroundColor = UIColorRGB(0xF5F5F5);
        _explainBgView.layer.cornerRadius = SCALES(8);
        _explainBgView.layer.masksToBounds = YES;
    }
    return _explainBgView;
}

- (YYLabel *)agreementView {
    if (!_agreementView) {
        _agreementView = [[YYLabel alloc]init];
        _agreementView.numberOfLines = 0;
        _agreementView.preferredMaxLayoutWidth = floorf(SCREEN_WIDTH - SCALES(56));
        kWeakSelf(self);
        _agreementView.attributedText = [ASTextAttributedManager withdrawExplainWithText:@"1、收益提现服务需年满18周岁且不超过55周岁。\n2、每天最多可申请12次提现，同一套餐每日最多申请提现4次，提现在次日24点前到账（如遇周末，节假日顺延）\n3、每笔提现合作方会收取8%的手续费 \n4、若因账号违规被封号，提现中的金额将会被系统自动扣除 \n5、您点击申请提现即代表您已同意并确认《合作服务协议》" agreement:^{
            
        }];
    }
    return _agreementView;
}

- (UIButton *)submit {
    if (!_submit) {
        _submit = [[UIButton alloc]init];
        [_submit setTitle:@"立即提现" forState:UIControlStateNormal];
        _submit.titleLabel.font = TEXT_FONT_18;
        _submit.layer.cornerRadius = SCALES(25);
        _submit.layer.masksToBounds = YES;
        _submit.adjustsImageWhenHighlighted = NO;
        [_submit setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_submit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.clikedBlock) {
                wself.clikedBlock(@"立即提现");
            }
        }];
    }
    return _submit;
}
@end

@interface ASWithdrawListCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *acount;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, assign) BOOL isInsufficient;//是否余额不足
@end

@implementation ASWithdrawListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.acount];
        [self.bgView addSubview:self.content];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    if (self.isInsufficient == YES) {//余额不足
        [self.acount mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(22));
            make.centerX.equalTo(self.contentView);
            make.height.mas_equalTo(SCALES(22));
        }];
        [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.top.equalTo(self.acount.mas_bottom).offset(SCALES(6));
            make.height.mas_equalTo(SCALES(15));
        }];
    } else {
        [self.acount mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.contentView);
        }];
    }
}

- (void)setNumber:(NSInteger)number {
    _number = number;
    self.acount.text = [NSString stringWithFormat:@"￥%zd",number];
}

- (void)setIncome_money:(CGFloat)income_money {
    _income_money = income_money;
    CGFloat number = [NSString stringWithFormat:@"%zd",self.number].floatValue;
    if (number > income_money) {
        self.isInsufficient = YES;//余额不足
    } else {
        self.isInsufficient = NO;
    }
}

- (void)setIsInsufficient:(BOOL)isInsufficient {
    _isInsufficient = isInsufficient;
    if (isInsufficient == YES) {
        self.content.hidden = NO;
        self.userInteractionEnabled = NO;
    } else {
        self.content.hidden = YES;
        self.userInteractionEnabled = YES;
    }
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = SCALES(8);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderColor = UIColorRGB(0xEEEEEE).CGColor;
        _bgView.layer.borderWidth = SCALES(2);
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UILabel *)acount {
    if (!_acount) {
        _acount = [[UILabel alloc]init];
        _acount.text = @"￥0";
        _acount.textColor = UIColorRGB(0xC0C0C0);
        _acount.font = TEXT_MEDIUM(20);
        _acount.textAlignment = NSTextAlignmentCenter;
    }
    return _acount;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.text = @"余额不足";
        _content.textColor = UIColorRGB(0xC0C0C0);
        _content.font = TEXT_FONT_11;
        _content.hidden = YES;
    }
    return _content;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.isInsufficient == YES) {
        return;
    }
    if (selected) {
        self.bgView.backgroundColor = UIColorRGB(0xFFF1F3);
        self.bgView.layer.borderColor = MAIN_COLOR.CGColor;
        self.acount.textColor = TITLE_COLOR;
    } else {
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.borderColor = UIColorRGB(0xEEEEEE).CGColor;
        self.acount.textColor = UIColorRGB(0xC0C0C0);
    }
}
@end

@interface ASWithdrawSelectTypeView ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *leftTitle;
@property (nonatomic, strong) UILabel *rightTitle;
@end
@implementation ASWithdrawSelectTypeView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.icon];
        [self addSubview:self.leftTitle];
        [self addSubview:self.rightTitle];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.clikedBlock) {
                wself.clikedBlock();
            }
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(SCALES(14));
        make.size.mas_equalTo(CGSizeMake(SCALES(28), SCALES(28)));
    }];
    [self.leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.icon);
        make.left.equalTo(self.icon.mas_right).offset(SCALES(10));
    }];
    [self.rightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(SCALES(-14));
        make.left.equalTo(self.leftTitle.mas_right);
        make.centerY.equalTo(self.icon);
    }];
}

- (void)setModel:(ASWithdrawModel *)model {
    _model = model;
    if (!kStringIsEmpty(model.icon)) {
        [self.icon sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.icon]]];
    }
    self.leftTitle.text = STRING(model.bank);
    if (!kStringIsEmpty(model.alipay_account)) {
        self.rightTitle.text = [NSString stringWithFormat:@"%@(%@)", model.alipay_name, model.alipay_account];
        self.rightTitle.textColor = TITLE_COLOR;
    } else {
        self.rightTitle.text = @"请先绑定账号";
        self.rightTitle.textColor = TEXT_SIMPLE_COLOR;
    }
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}

- (UILabel *)leftTitle {
    if (!_leftTitle) {
        _leftTitle = [[UILabel alloc]init];
        _leftTitle.text = @"";
        _leftTitle.textColor = TITLE_COLOR;
        _leftTitle.font = TEXT_FONT_16;
    }
    return _leftTitle;
}

- (UILabel *)rightTitle {
    if (!_rightTitle) {
        _rightTitle = [[UILabel alloc]init];
        _rightTitle.textColor = TITLE_COLOR;
        _rightTitle.font = TEXT_FONT_14;
        _rightTitle.textAlignment = NSTextAlignmentRight;
    }
    return _rightTitle;
}

@end
