//
//  ASSendGiftView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASSendGiftView.h"
#import "ASGiftListCollectionViewLayout.h"
#import "ASPageControl.h"

@interface ASSendGiftView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (nonatomic ,strong) UIScrollView *titleBgView;
@property (nonatomic ,strong) UIView *bottomBgView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *selectTitleBtn;
@property (nonatomic, strong) UIImageView *indicatorView;
@property (nonatomic, strong) UIImageView *noDataIcon;
@property (nonatomic, strong) UILabel *noDataText;
@property (nonatomic, strong) UIButton *goPayBtn;
@property (nonatomic, strong) UIImageView *acountIcon;
@property (nonatomic, strong) UILabel *acount;
@property (nonatomic, strong) UIImageView *giveBg;
@property (nonatomic, strong) UIButton *giveBtn;
@property (nonatomic, strong) UILabel *giveAcount;
@property (nonatomic, strong) UIButton *giveAdd;
@property (nonatomic, strong) UIButton *giveReduce;
/**数据**/
@property (nonatomic, strong) NSMutableDictionary *gifts;
@property (nonatomic, assign) NSInteger selectAcountIndex;
@property (nonatomic, strong) NSArray *acounts;
@property (nonatomic, copy) NSString *selectTitleID;
@property (nonatomic, copy) NSString *selectTitle;
@property (nonatomic, copy) NSString *selectGiftID;
@property (nonatomic, copy) NSString *selectGiftSvga;
@property (nonatomic, copy) NSString *selectGiftType;
@end

@implementation ASSendGiftView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = UIColor.whiteColor;
        self.size = CGSizeMake(SCREEN_WIDTH, SCALES(342) + TAB_BAR_MAGIN);
        self.selectAcountIndex = 0;
        self.acounts = @[@"1", @"5", @"10", @"66", @"99", @"520"];
        [self createUI];
        kWeakSelf(self);
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"updateBalanceNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
        }];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(SCALES(10), SCALES(10))];
         CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.titleBgView];
    [self addSubview:self.goPayBtn];
    [self addSubview:self.collectionView];
    [self addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.acountIcon];
    [self.bottomBgView addSubview:self.acount];
    [self.bottomBgView addSubview:self.giveBg];
    [self.giveBg addSubview:self.giveBtn];
    [self.giveBg addSubview:self.giveAcount];
    [self.giveBg addSubview:self.giveAdd];
    [self.giveBg addSubview:self.giveReduce];
    [self.titleBgView addSubview:self.indicatorView];
    [self addSubview:self.noDataIcon];
    [self addSubview:self.noDataText];
    [self.collectionView registerClass:[ASGiftCell class] forCellWithReuseIdentifier:@"giftCell"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.right.equalTo(self).offset(-SCALES(100));
        make.height.mas_equalTo(SCALES(44));
    }];
    [self.goPayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(SCALES(-14));
        make.top.mas_equalTo(SCALES(9));
        make.size.mas_equalTo(CGSizeMake(SCALES(56), SCALES(32)));
    }];
    [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-TAB_BAR_MAGIN);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(SCALES(44));
    }];
    [self.acountIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.centerY.equalTo(self.bottomBgView);
        make.height.width.mas_equalTo(SCALES(24));
    }];
    [self.acount mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acountIcon.mas_right).offset(SCALES(8));
        make.centerY.equalTo(self.bottomBgView);
        make.height.mas_equalTo(SCALES(25));
        make.width.mas_lessThanOrEqualTo(SCALES(140));
    }];
    [self.giveBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomBgView.mas_right).offset(SCALES(-14));
        make.centerY.equalTo(self.bottomBgView);
        make.size.mas_equalTo(CGSizeMake(SCALES(164), SCALES(36)));
    }];
    [self.giveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.giveBg);
        make.width.mas_equalTo(SCALES(65));
    }];
    [self.giveAcount mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(32));
        make.width.mas_equalTo(SCALES(36));
        make.centerY.equalTo(self.giveBg);
    }];
    [self.giveReduce mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(6));
        make.width.height.mas_equalTo(SCALES(24));
        make.centerY.equalTo(self.giveBg);
    }];
    [self.giveAdd mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(70));
        make.width.height.mas_equalTo(SCALES(24));
        make.centerY.equalTo(self.giveBg);
    }];
    [self.noDataIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(SCALES(78));
        make.height.width.mas_equalTo(SCALES(160));
    }];
    [self.noDataText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.noDataIcon.mas_bottom).offset(SCALES(8));
        make.height.mas_equalTo(SCALES(18));
    }];
}

- (void)setUserID:(NSString *)userID {
    _userID = userID;
}

- (void)setTitles:(NSArray<ASGiftTitleDataModel *> *)titles {
    _titles = titles;
    if (titles == 0) {
        return;
    }
    CGFloat buttonW = SCALES(64);
    self.titleBgView.contentSize = CGSizeMake(titles.count *buttonW, SCALES(44));
    for (NSInteger i = 0; i < titles.count; i++) {
        ASGiftTitleDataModel *model = titles[i];
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:model.name forState:UIControlStateNormal];
        button.titleLabel.font = TEXT_FONT_16;
        button.tag = i;
        [button setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        [button setTitleColor:TITLE_COLOR forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clikedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleBgView addSubview:button];
        button.frame = CGRectMake(i*buttonW + SCALES(6), SCALES(8), buttonW, SCALES(28));
        NSString *selectTitleID = [NSString stringWithFormat:@"%zd", model.ID];
        if (i == 0) {
            button.titleLabel.font = TEXT_MEDIUM(20);;
            button.selected = YES;
            self.selectTitleBtn = button;
            self.indicatorView.frame = CGRectMake(self.selectTitleBtn.centerX - SCALES(12), SCALES(36), SCALES(24), SCALES(8));
            self.selectTitleID = selectTitleID;
            self.selectTitle = model.name;
        }
        kWeakSelf(self);
        [ASCommonRequest requestGiftListWithType:model.ID success:^(id  _Nullable data) {
            ASGiftDataModel *giftModel = data;
            wself.acount.text = STRING(giftModel.coin);
            NSArray *list = giftModel.gift_list;
            [wself.gifts setValue:list forKey:selectTitleID];
            if (i == 0) {
                [wself.collectionView reloadData];
                if (list.count > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [wself.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                    ASGiftListModel *giftListModel = list[0];
                    wself.selectGiftID = giftListModel.ID;
                    wself.selectGiftSvga = giftListModel.svga;
                    wself.selectGiftType = giftListModel.p_type;
                    wself.noDataIcon.hidden = YES;
                    wself.noDataText.hidden = YES;
                } else {
                    wself.noDataIcon.hidden = NO;
                    wself.noDataText.hidden = NO;
                }
            }
        } errorBack:^(NSInteger code, NSString *msg) {
            
        }];
    }
}

- (void)clikedButton:(UIButton *)button {
    if (!button.selected) {
        self.selectTitleBtn.titleLabel.font = TEXT_FONT_16;
        self.selectTitleBtn.selected = !self.selectTitleBtn.selected;
        button.selected = !button.selected;
        self.selectTitleBtn = button;
        self.selectTitleBtn.titleLabel.font = TEXT_MEDIUM(20);
        self.indicatorView.frame = CGRectMake(self.selectTitleBtn.centerX - SCALES(12), SCALES(36), SCALES(24), SCALES(8));
        ASGiftTitleDataModel *model = self.titles[button.tag];
        self.selectTitleID = [NSString stringWithFormat:@"%zd",model.ID];
        self.selectTitle = model.name;
        NSArray *list = self.gifts[self.selectTitleID];
        [self.collectionView reloadData];
        if (list.count > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            ASGiftListModel *giftListModel = list[0];
            self.selectGiftID = giftListModel.ID;
            self.selectGiftSvga = giftListModel.svga;
            self.selectGiftType = giftListModel.p_type;
            self.noDataIcon.hidden = YES;
            self.noDataText.hidden = YES;
        } else {
            self.noDataIcon.hidden = NO;
            self.noDataText.hidden = NO;
        }
    }
}

- (NSMutableDictionary *)gifts {
    if (!_gifts) {
        _gifts = [[NSMutableDictionary alloc]init];
    }
    return _gifts;
}

- (UIScrollView *)titleBgView {
    if (!_titleBgView) {
        _titleBgView = [[UIScrollView alloc]init];
        _titleBgView.backgroundColor = UIColor.whiteColor;
    }
    return _titleBgView;
}

- (UIImageView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIImageView alloc]init];
        _indicatorView.image = [UIImage imageNamed:@"bottom_icon"];
    }
    return _indicatorView;
}

- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc]init];
        _bottomBgView.backgroundColor = UIColor.whiteColor;
    }
    return _bottomBgView;
}

- (UIImageView *)giveBg {
    if (!_giveBg) {
        _giveBg = [[UIImageView alloc]init];
        _giveBg.image = [UIImage imageNamed:@"send_acount"];
        _giveBg.userInteractionEnabled = YES;
    }
    return _giveBg;
}

- (UILabel *)giveAcount {
    if (!_giveAcount) {
        _giveAcount = [[UILabel alloc]init];
        _giveAcount.textColor = TITLE_COLOR;
        _giveAcount.text = @"1";
        _giveAcount.font = TEXT_FONT_16;
        _giveAcount.textAlignment = NSTextAlignmentCenter;
    }
    return _giveAcount;
}

- (UIButton *)giveReduce {
    if (!_giveReduce) {
        _giveReduce = [[UIButton alloc]init];
        [_giveReduce setImage:[UIImage imageNamed:@"jian1"] forState:UIControlStateNormal];
        [_giveReduce setImage:[UIImage imageNamed:@"jian"] forState:UIControlStateSelected];
        _giveReduce.selected = NO;
        _giveReduce.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_giveReduce rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.selectAcountIndex == 0) {
                return;
            }
            wself.selectAcountIndex--;
            wself.giveAcount.text = STRING(wself.acounts[wself.selectAcountIndex]);
            wself.giveAdd.selected = YES;
            if (wself.selectAcountIndex == 0) {
                wself.giveReduce.selected = NO;
            }
        }];
    }
    return _giveReduce;
}

- (UIButton *)giveAdd {
    if (!_giveAdd) {
        _giveAdd = [[UIButton alloc]init];
        [_giveAdd setImage:[UIImage imageNamed:@"jia1"] forState:UIControlStateNormal];
        [_giveAdd setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateSelected];
        _giveAdd.selected = YES;
        _giveAdd.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_giveAdd rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.selectAcountIndex == (wself.acounts.count -1)) {
                return;
            }
            wself.selectAcountIndex++;
            wself.giveReduce.selected = YES;
            wself.giveAcount.text = STRING(wself.acounts[wself.selectAcountIndex]);
            if (wself.selectAcountIndex == (wself.acounts.count -1)) {
                wself.giveAdd.selected = NO;
            }
        }];
    }
    return _giveAdd;
}

- (UIButton *)giveBtn {
    if (!_giveBtn) {
        _giveBtn = [[UIButton alloc]init];
        [_giveBtn setTitle:@"赠送" forState:UIControlStateNormal];
        _giveBtn.titleLabel.font = TEXT_FONT_16;
        kWeakSelf(self);
        [[_giveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (!kStringIsEmpty(wself.selectGiftType)) {
                return;
            }
            if (wself.sendBlock) {
                wself.sendBlock(wself.selectGiftID, wself.acounts[wself.selectAcountIndex], wself.selectTitleID, wself.selectGiftSvga);
            }
        }];
    }
    return _giveBtn;
}

- (UIView *)collectionView {
    if(!_collectionView){
        CGFloat itemW = floorf((SCREEN_WIDTH - SCALES(26)*2 - SCALES(5)*3) / 4);
        CGFloat itemH = SCALES(100);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = SCALES(5);
        flowLayout.minimumInteritemSpacing = SCALES(5);
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCALES(12), SCALES(60), floorf(SCREEN_WIDTH - SCALES(26)), SCALES(230)) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UIImageView *)noDataIcon {
    if (!_noDataIcon) {
        _noDataIcon = [[UIImageView alloc]init];
        _noDataIcon.image = [UIImage imageNamed:@"empty_gift"];
        _noDataIcon.hidden = YES;
    }
    return _noDataIcon;
}

- (UILabel *)noDataText {
    if (!_noDataText) {
        _noDataText = [[UILabel alloc]init];
        _noDataText.text = @"暂无礼物哦~";
        _noDataText.textColor = TEXT_SIMPLE_COLOR;
        _noDataText.font = TEXT_FONT_14;
        _noDataText.hidden = YES;
    }
    return _noDataText;
}

- (UIImageView *)acountIcon {
    if (!_acountIcon) {
        _acountIcon = [[UIImageView alloc]init];
        _acountIcon.image = [UIImage imageNamed:@"money"];
    }
    return _acountIcon;
}

- (UILabel *)acount {
    if (!_acount) {
        _acount = [[UILabel alloc]init];
        _acount.text = @"0";
        _acount.textColor = MAIN_COLOR;
        _acount.font = TEXT_FONT_16;
    }
    return _acount;
}

- (UIButton *)goPayBtn {
    if (!_goPayBtn) {
        _goPayBtn = [[UIButton alloc]init];
        [_goPayBtn setTitle:@"充值" forState:UIControlStateNormal];
        _goPayBtn.titleLabel.font = TEXT_FONT_16;
        [_goPayBtn setBackgroundColor:CHANGE_BG_COLOR(UIColorRGB(0xFBE6A2), UIColorRGB(0xECCD8A), SCALES(56), SCALES(32))];
        [_goPayBtn setTitleColor:UIColorRGB(0x624F26) forState:UIControlStateNormal];
        _goPayBtn.layer.cornerRadius = SCALES(16);
        _goPayBtn.layer.masksToBounds = YES;
        kWeakSelf(self);
        [[_goPayBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
            [ASMyAppCommonFunc balanceDeficiencyPopViewWithPayScene:Pay_Scene_ChatGift cancel:^{
                
            }];
        }];
    }
    return _goPayBtn;
}

#pragma mark collectionview 事件
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ASGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"giftCell" forIndexPath:indexPath];
    NSArray *list = self.gifts[self.selectTitleID];
    cell.model = list[indexPath.row];
    cell.giftTitle = self.selectTitle;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *list = self.gifts[self.selectTitleID];
    return list.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *list = self.gifts[self.selectTitleID];
    ASGiftListModel *model = list[indexPath.row];
    self.selectGiftID = model.ID;
    self.selectGiftSvga = model.svga;
    self.selectGiftType = model.p_type;
}
@end

@interface ASGiftCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *giftImage;
@property (nonatomic, strong) UILabel *giftName;
@property (nonatomic, strong) UIImageView *acountIcon;
@property (nonatomic, strong) UILabel *acount;
@property (nonatomic, strong) UILabel *numLabel;//数量
@end

@implementation ASGiftCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.giftImage];
        [self.bgView addSubview:self.giftName];
        [self.bgView addSubview:self.acountIcon];
        [self.bgView addSubview:self.acount];
        [self.bgView addSubview:self.numLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat itemW = floorf((SCREEN_WIDTH - SCALES(26)*2 - SCALES(5)*3) / 4);
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.mas_equalTo(SCALES(4));
        make.size.mas_equalTo(CGSizeMake(itemW - SCALES(4), SCALES(100)));
    }];
    [self.giftImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(5));
        make.centerX.equalTo(self.bgView);
        make.height.width.mas_equalTo(SCALES(50));
    }];
    [self.giftName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftImage.mas_bottom).offset(SCALES(6));
        make.centerX.equalTo(self.giftImage);
        make.height.mas_equalTo(SCALES(16));
    }];
    if (!kStringIsEmpty(self.model.p_type)) {
        [self.acount mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.top.equalTo(self.giftName.mas_bottom).offset(SCALES(2));
            make.height.mas_equalTo(SCALES(14));
        }];
    } else {
        [self.acount mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView).offset(SCALES(8));
            make.top.equalTo(self.giftName.mas_bottom).offset(SCALES(2));
            make.height.mas_equalTo(SCALES(14));
        }];
        [self.acountIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.acount.mas_left).offset(SCALES(-2));
            make.centerY.equalTo(self.acount);
            make.width.height.mas_equalTo(SCALES(12));
        }];
    }
    [self.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(SCALES(1.5));
        make.right.equalTo(self.bgView).offset(SCALES(-1.5));
        make.height.mas_equalTo(SCALES(16));
    }];
}

- (void)setModel:(ASGiftListModel *)model {
    _model = model;
    [self.giftImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.img]]];
    self.giftName.text = model.name;
    if (!kStringIsEmpty(model.p_type)) {
        self.acount.text = model.expire;
        self.acountIcon.hidden = YES;
    } else {
        self.acount.text = [NSString stringWithFormat:@"%zd", self.model.price];
        self.acountIcon.hidden = NO;
    }
}

- (void)setGiftTitle:(NSString *)giftTitle {
    _giftTitle = giftTitle;
    if ([giftTitle isEqualToString:@"背包"] && self.model.num > 0) {
        self.numLabel.text = [NSString stringWithFormat:@" x%zd ", self.model.num];
        self.numLabel.hidden = NO;
        self.numLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        self.numLabel.hidden = YES;
    }
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = SCALES(8);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderColor = UIColor.whiteColor.CGColor;
        _bgView.layer.borderWidth = SCALES(1);
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UIImageView *)giftImage {
    if (!_giftImage) {
        _giftImage = [[UIImageView alloc]init];
        _giftImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _giftImage;
}

- (UILabel *)giftName {
    if (!_giftName) {
        _giftName = [[UILabel alloc]init];
        _giftName.textColor = TITLE_COLOR;
        _giftName.font = TEXT_FONT_12;
        _giftName.textAlignment = NSTextAlignmentCenter;
    }
    return _giftName;
}

- (UIImageView *)acountIcon {
    if (!_acountIcon) {
        _acountIcon = [[UIImageView alloc]init];
        _acountIcon.image = [UIImage imageNamed:@"money1"];
    }
    return _acountIcon;
}

- (UILabel *)acount {
    if (!_acount) {
        _acount = [[UILabel alloc]init];
        _acount.textColor = MAIN_COLOR;
        _acount.font = TEXT_FONT_12;
        _acount.textAlignment = NSTextAlignmentCenter;
    }
    return _acount;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]init];
        _numLabel.textColor = UIColorRGB(0x8B87A0);
        _numLabel.backgroundColor = UIColorRGB(0xF2F2F2);
        _numLabel.font = TEXT_FONT_11;
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.layer.cornerRadius = SCALES(8);
        _numLabel.layer.masksToBounds = YES;
    }
    return _numLabel;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.bgView.layer.borderColor = MAIN_COLOR.CGColor;
    } else {
        self.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

@end
