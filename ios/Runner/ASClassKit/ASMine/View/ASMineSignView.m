//
//  ASMineSignView.m
//  AS
//
//  Created by SA on 2025/4/18.
//

#import "ASMineSignView.h"
#import "ASMineRequest.h"

@interface ASMineSignView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIButton *signBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *listArray;
@end

@implementation ASMineSignView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.title];
        [self addSubview:self.signBtn];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0.0;
        flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - SCALES(42))/7, SCALES(95));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [self addSubview:self.collectionView];
        self.collectionView = ({
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCALES(5), SCALES(40), SCREEN_WIDTH - SCALES(42), SCALES(95)) collectionViewLayout:flowLayout];
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.backgroundColor = UIColor.whiteColor;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            [self addSubview:collectionView];
            collectionView;
        });
        [self.collectionView registerClass:[ASDaySignInCell class] forCellWithReuseIdentifier:@"daySignInCell"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(8));
        make.top.mas_equalTo(SCALES(12));
        make.height.mas_equalTo(SCALES(20));
    }];
    
    [self.signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(136), SCALES(40)));
    }];
}

- (void)setModel:(ASSignInModel *)model {
    _model = model;
    self.listArray = model.today;
    self.signBtn.selected = model.today_status;
    [self.collectionView reloadData];
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.text = @"每日签到";
        _title.textColor = TITLE_COLOR;
        _title.font = TEXT_FONT_16;
    }
    return _title;
}

- (UIButton *)signBtn {
    if (!_signBtn) {
        _signBtn = [[UIButton alloc]init];
        [_signBtn setBackgroundImage:[UIImage imageNamed:@"sign"] forState:UIControlStateNormal];
        [_signBtn setBackgroundImage:[UIImage imageNamed:@"sign1"] forState:UIControlStateSelected];
        _signBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_signBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.model.today_status == NO) {
                [wself requestSignIn];
            } else {
                [ASAlertViewManager popSignInList:wself.model affirmAction:^{
                    [wself requestSignIn];
                }];
            }
        }];
    }
    return _signBtn;
}

#pragma mark -- UICollectionViewDataSource
//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASDaySignInCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"daySignInCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.todayCount = self.model.today_count;
    cell.model = self.listArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ASSignInListModel *model = self.model.today[indexPath.row];
    if (model.now_day && !model.status) {//当天未签到
        [self requestSignIn];
    } else {
        kWeakSelf(self);
        [ASAlertViewManager popSignInList:self.model affirmAction:^{
            [wself requestSignIn];
        }];
    }
}

- (void)requestSignIn {
    kWeakSelf(self);
    [ASMineRequest requestDaySignInSuccess:^(ASSignInGiftModel *data) {
        if (wself.clikedBlock) {
            wself.clikedBlock();
        }
        wself.signBtn.selected = YES;
        wself.model.today_status = YES;
        //弹出确定签到成功框
        [ASAlertViewManager popDaySignIn: data];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}
@end


@interface ASDaySignInCell ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *goldIcon;//签到图标
@property (nonatomic,strong) UILabel *acount;//数量
@property (nonatomic,strong) UILabel *day;//时间
@property (nonatomic,strong) UIImageView *selectIcon;//签到后的图标
@property (nonatomic,strong) UIImageView *attendanceState;//提醒签到图标
@end

@implementation ASDaySignInCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.goldIcon];
        [self.bgView addSubview:self.acount];
        [self.bgView addSubview:self.day];
        [self.bgView addSubview:self.selectIcon];
        [self addSubview:self.attendanceState];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(2));
        make.right.offset(SCALES(-2));
        make.top.mas_equalTo(SCALES(12));
        make.height.mas_equalTo(SCALES(83));
    }];
    
    [self.goldIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.mas_equalTo(SCALES(10));
        make.size.mas_equalTo(CGSizeMake(SCALES(31), SCALES(31)));
    }];
    
    [self.acount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.goldIcon.mas_bottom).offset(SCALES(2));
        make.height.mas_equalTo(SCALES(14));
    }];
    
    [self.day mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.acount.mas_bottom).offset(SCALES(2));
        make.height.mas_equalTo(SCALES(14));
    }];
    
    [self.selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(SCALES(14), SCALES(12)));
    }];
    
    [self.attendanceState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(SCALES(45), SCALES(18)));
    }];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
}

- (void)setTodayCount:(NSInteger)todayCount {
    _todayCount = todayCount;
}

- (void)setModel:(ASSignInListModel *)model {
    _model = model;
    self.day.text = model.now_day == YES ? @"今天" : [NSString stringWithFormat:@"第%zd天", self.index + 1];
    self.acount.textColor = model.now_day == YES ? MAIN_COLOR : TITLE_COLOR;
    
    if (model.list.count > 0) {
        ASSignInGiftModel *giftModel = model.list[0];
        self.acount.text = [NSString stringWithFormat:@"x%zd", giftModel.money];
        [self.goldIcon sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, giftModel.img]]];
    }
    
    if (model.now_day && !model.status) {//当天未签到
        self.bgView.backgroundColor = UIColorRGB(0xFFF1F3);
        self.selectIcon.hidden = YES;
        self.attendanceState.hidden = NO;
        self.attendanceState.image = [UIImage imageNamed:@"sign_day1"];
        self.day.font = TEXT_MEDIUM(10);
        self.day.textColor = MAIN_COLOR;
        self.acount.textColor = MAIN_COLOR;
    } else if (self.index >= self.todayCount){//大于今天
        self.selectIcon.hidden = YES;
        if (model.label == 3) {
            self.attendanceState.image = [UIImage imageNamed:@"sign_day2"];//明日可领
            self.attendanceState.hidden = NO;
        } else {
            self.attendanceState.hidden = YES;
        }
        self.bgView.backgroundColor = UIColorRGB(0xF5F5F5);
        self.day.font = TEXT_FONT_10;
        self.day.textColor = TEXT_SIMPLE_COLOR;
        self.acount.textColor = TITLE_COLOR;
    } else {//已经签到
        self.bgView.backgroundColor = UIColorRGB(0xFFF1F3);
        self.selectIcon.hidden = NO;
        self.attendanceState.hidden = YES;
        self.day.textColor = TITLE_COLOR;
        self.day.font = TEXT_MEDIUM(10);
        self.acount.textColor = TITLE_COLOR;
    }
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = UIColorRGB(0xF5F5F5);
        _bgView.layer.cornerRadius = SCALES(4);
        _bgView.layer.masksToBounds = YES;
        _bgView.userInteractionEnabled = NO;
    }
    return _bgView;
}

- (UIImageView *)goldIcon {
    if (!_goldIcon) {
        _goldIcon = [[UIImageView alloc]init];
        _goldIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _goldIcon;
}

- (UILabel *)acount {
    if (!_acount) {
        _acount = [[UILabel alloc]init];
        _acount.textColor = TITLE_COLOR;
        _acount.font = TEXT_FONT_10;
        _acount.textAlignment = NSTextAlignmentCenter;
    }
    return _acount;
}

- (UILabel *)day {
    if (!_day) {
        _day = [[UILabel alloc]init];
        _day.textColor = TEXT_SIMPLE_COLOR;
        _day.font = TEXT_FONT_12;
        _day.textAlignment = NSTextAlignmentCenter;
    }
    return _day;
}

- (UIImageView *)selectIcon {
    if (!_selectIcon) {
        _selectIcon = [[UIImageView alloc]init];
        _selectIcon.image = [UIImage imageNamed:@"sign_in"];
        _selectIcon.hidden = YES;
    }
    return _selectIcon;
}

- (UIImageView *)attendanceState {
    if (!_attendanceState) {
        _attendanceState = [[UIImageView alloc]init];
        _attendanceState.image = [UIImage imageNamed:@"sign_day"];
        _attendanceState.hidden = YES;
    }
    return _attendanceState;
}
@end
