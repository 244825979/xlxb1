//
//  ASCallRecordTopView.m
//  AS
//
//  Created by SA on 2025/5/15.
//

#import "ASCallRecordTopView.h"

@interface ASCallRecordTopView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ASCallRecordTopView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.title];
        [self addSubview:self.closeBtn];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = SCALES(8);
        flowLayout.itemSize = CGSizeMake(SCALES(98), SCALES(136));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = ({
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCALES(16), SCALES(44), SCREEN_WIDTH - SCALES(16),SCALES(137)) collectionViewLayout:flowLayout];
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            [self addSubview:collectionView];
            collectionView;
        });
        [self.collectionView registerClass:[ASCallRecommendCell class] forCellWithReuseIdentifier:@"callRecommendCell"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.height.mas_equalTo(SCALES(44));
        make.top.equalTo(self);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(SCALES(-14));
        make.centerY.equalTo(self.title);
        make.height.width.mas_equalTo(SCALES(44));
    }];
}

- (void)setLists:(NSArray *)lists {
    _lists = lists;
    [self.collectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASCallRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"callRecommendCell" forIndexPath:indexPath];
    cell.model = self.lists[indexPath.row];
    return cell;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close1"] forState:UIControlStateNormal];
        _closeBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.closeBlock) {
                wself.closeBlock();
            }
        }];
    }
    return _closeBtn;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.text = @"视频通话推荐";
        _title.textColor = TITLE_COLOR;
        _title.font = TEXT_FONT_16;
    }
    return _title;
}
@end

@interface ASCallRecommendCell ()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UIView *isOnline;
@property (nonatomic, strong) UIButton *callBtn;
@end

@implementation ASCallRecommendCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = SCALES(8);
        self.contentView.layer.borderWidth = SCALES(1);
        self.contentView.layer.borderColor = UIColorRGB(0xF6F5FF).CGColor;
        [self.contentView addSubview:self.header];
        [self.contentView addSubview:self.nickName];
        [self.header addSubview:self.isOnline];
        [self.contentView addSubview:self.callBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(10));
        make.centerX.equalTo(self.contentView);
        make.height.width.mas_equalTo(SCALES(52));
    }];
    [self.isOnline mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.header);
        make.height.width.mas_equalTo(SCALES(12));
    }];
    [self.nickName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header.mas_bottom).offset(SCALES(6));
        make.left.mas_equalTo(SCALES(10));
        make.right.equalTo(self.contentView).offset(SCALES(-10));
        make.height.mas_equalTo(SCALES(24));
    }];
    [self.callBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickName.mas_bottom).offset(SCALES(10));
        make.centerX.equalTo(self.nickName);
        make.size.mas_equalTo(CGSizeMake(SCALES(64), SCALES(24)));
    }];
}

- (void)setModel:(ASCallRecommendModel *)model {
    _model = model;
    [self.header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar]]];
    self.nickName.text = STRING(model.nickname);
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.contentMode = UIViewContentModeScaleAspectFill;
        _header.layer.masksToBounds = YES;
        _header.layer.cornerRadius = SCALES(9);
        _header.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_header addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            [ASMyAppCommonFunc goPersonalHomeWithUserID:wself.model.userid viewController:[ASCommonFunc currentVc] action:^(id  _Nonnull data) {
                
            }];
        }];
    }
    return _header;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc]init];
        _nickName.textColor = TITLE_COLOR;
        _nickName.font = TEXT_FONT_14;
        _nickName.textAlignment = NSTextAlignmentCenter;
    }
    return _nickName;
}

- (UIView *)isOnline {
    if (!_isOnline) {
        _isOnline = [[UIView alloc]init];
        _isOnline.backgroundColor = UIColor.greenColor;
        _isOnline.layer.borderColor = UIColor.whiteColor.CGColor;
        _isOnline.layer.borderWidth = SCALES(1.0);
        _isOnline.layer.cornerRadius = SCALES(4.5);
    }
    return _isOnline;
}

- (UIButton *)callBtn {
    if (!_callBtn) {
        _callBtn = [[UIButton alloc]init];
        [_callBtn setTitle:@"视频通话" forState:UIControlStateNormal];
        _callBtn.titleLabel.font = TEXT_FONT_12;
        [_callBtn setBackgroundColor:MAIN_COLOR];
        _callBtn.layer.cornerRadius = SCALES(12);
        _callBtn.layer.masksToBounds = YES;
        _callBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_callBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASMyAppCommonFunc callWithUserID:wself.model.userid
                                     callType:kCallTypeVideo
                                        scene:Call_Scene_CallRecommend
                                         back:^(BOOL isSucceed) {
                
            }];
        }];
    }
    return _callBtn;
}
@end
