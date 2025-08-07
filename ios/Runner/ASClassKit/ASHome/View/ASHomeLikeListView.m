//
//  ASHomeLikeListView.m
//  AS
//
//  Created by SA on 2025/4/16.
//

#import "ASHomeLikeListView.h"

@interface ASHomeLikeListView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIButton *changeBtn;
@end

@implementation ASHomeLikeListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.title];
        [self addSubview:self.icon];
        [self addSubview:self.changeBtn];
        CGFloat itemW = (SCREEN_WIDTH - SCALES(32) - SCALES(16)) /3;
        CGFloat itemH = SCALES(124);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = SCALES(8);//minimumInteritemSpacing
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = ({
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCALES(16), SCALES(50), SCREEN_WIDTH - SCALES(32), SCALES(124)) collectionViewLayout:flowLayout];
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.backgroundColor = UIColor.clearColor;
            [self addSubview:collectionView];
            collectionView;
        });
        [self.collectionView registerClass:[ASHomeLikeListItemCell class] forCellWithReuseIdentifier:@"homeLikeListItemCell"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(8));
        make.left.mas_equalTo(SCALES(16));
        make.height.mas_equalTo(SCALES(22));
    }];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom);
        make.centerX.equalTo(self.title);
        make.height.mas_equalTo(SCALES(8));
        make.width.mas_equalTo(SCALES(24));
    }];
    [self.changeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title);
        make.right.equalTo(self).offset(SCALES(-12));
        make.height.mas_equalTo(SCALES(28));
        make.width.mas_equalTo(SCALES(68));
    }];
}

- (void)setLikes:(NSArray *)likes {
    _likes = likes;
    [self.collectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.likes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASHomeLikeListItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeLikeListItemCell" forIndexPath:indexPath];
    cell.model = self.likes[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ASHomeUserListModel *model = self.likes[indexPath.row];
    [ASMyAppCommonFunc behaviorStatisticsWithType:Behavior_home_like_head];//统计
    [ASMyAppCommonFunc goPersonalHomeWithUserID:model.ID viewController:[ASCommonFunc currentVc] action:^(id  _Nonnull data) {
        NSString *str = data;
        if ([str isEqualToString:@"beckon"]) {
            model.is_beckon = 1;
            ASHomeLikeListItemCell *cell = (ASHomeLikeListItemCell *)[collectionView cellForItemAtIndexPath:indexPath];;
            cell.isBeckon = 1;
        }
    }];
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = TEXT_MEDIUM(20);
        _title.text = @"猜你喜欢";
        _title.textColor = TITLE_COLOR;
    }
    return _title;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.image = [UIImage imageNamed:@"bottom_icon"];
    }
    return _icon;
}

- (UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [[UIButton alloc]init];
        [_changeBtn setTitle:@" 换一批" forState:UIControlStateNormal];
        [_changeBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = TEXT_FONT_12;
        [_changeBtn setTitleColor:UIColorRGB(0xFD6E6A) forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_changeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.actionBlock) {
                [ASMyAppCommonFunc behaviorStatisticsWithType:Behavior_home_like_change];//统计
                wself.actionBlock();
            }
        }];
    }
    return _changeBtn;
}
@end

@interface ASHomeLikeListItemCell ()
@property (nonatomic, strong) UIView *headerBg;
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UIView *state;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UIButton *dashan;
@end

@implementation ASHomeLikeListItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.contentView.layer.cornerRadius = SCALES(8);
        self.contentView.layer.masksToBounds = YES;
        [self addSubview:self.headerBg];
        [self.headerBg addSubview:self.header];
        [self addSubview:self.state];
        [self addSubview:self.userName];
        [self addSubview:self.dashan];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.headerBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(10));
        make.centerX.equalTo(self);
        make.height.width.mas_equalTo(SCALES(53));
    }];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.headerBg);
        make.height.width.mas_equalTo(SCALES(49));
    }];
    [self.state mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.headerBg).offset(SCALES(-4));
        make.height.width.mas_equalTo(SCALES(8));
    }];
    [self.userName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerBg.mas_bottom).offset(SCALES(8));
        make.left.mas_equalTo(SCALES(5));
        make.right.equalTo(self).offset(SCALES(-5));
        make.height.mas_equalTo(SCALES(14));
    }];
    [self.dashan mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.mas_bottom).offset(SCALES(9));
        make.centerX.equalTo(self);
        make.height.mas_equalTo(SCALES(20));
        make.width.mas_equalTo(SCALES(51));
    }];
}

- (void)setModel:(ASHomeUserListModel *)model {
    _model = model;
    [self.header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar]]];
    self.userName.text = [NSString stringWithFormat:@"@%@",STRING(model.nickname)];
    if (model.is_online == 1) {
        self.state.hidden = NO;
    } else {
        self.state.hidden = YES;
    }
    self.isBeckon = model.is_beckon;
    self.userName.textColor = model.is_vip == YES ? RED_COLOR : TITLE_COLOR;
}

- (void)setIsBeckon:(NSInteger)isBeckon {
    _isBeckon = isBeckon;
    if (isBeckon == 0) {
        [self.dashan setBackgroundImage:[UIImage imageNamed:@"dashan_icon"] forState:UIControlStateNormal];
    } else {
        [self.dashan setBackgroundImage:[UIImage imageNamed:@"sixin_icon"] forState:UIControlStateNormal];
    }
}

- (UIView *)headerBg {
    if (!_headerBg) {
        _headerBg = [[UIView alloc]init];
        _headerBg.layer.masksToBounds = YES;
        _headerBg.layer.cornerRadius = SCALES(26.5);
        _headerBg.layer.borderColor = UIColorRGB(0xFF79B9).CGColor;
        _headerBg.layer.borderWidth = SCALES(0.5);
    }
    return _headerBg;
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.contentMode = UIViewContentModeScaleAspectFill;
        _header.layer.masksToBounds = YES;
        _header.layer.cornerRadius = SCALES(24.5);
    }
    return _header;
}

- (UIView *)state {
    if (!_state) {
        _state = [[UIView alloc]init];
        _state.backgroundColor = UIColorRGB(0x63E170);
        _state.layer.masksToBounds = YES;
        _state.layer.cornerRadius = SCALES(4);
        _state.layer.borderColor = UIColor.whiteColor.CGColor;
        _state.layer.borderWidth = SCALES(1);
        _state.hidden = YES;
    }
    return _state;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc]init];
        _userName.font = TEXT_FONT_13;
        _userName.text = @"昵称";
        _userName.textColor = TITLE_COLOR;
        _userName.textAlignment = NSTextAlignmentCenter;
    }
    return _userName;
}

- (UIButton *)dashan {
    if (!_dashan) {
        _dashan = [[UIButton alloc]init];
        [_dashan setBackgroundImage:[UIImage imageNamed:@"dashan_icon"] forState:UIControlStateNormal];
        _dashan.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_dashan rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.model.is_beckon == 0) {
                [ASMyAppCommonFunc behaviorStatisticsWithType:Behavior_home_like_dashan];//统计
                [ASMyAppCommonFunc greetWithUserID:wself.model.ID action:^(id  _Nonnull data) {
                    wself.model.is_beckon = 1;
                    wself.isBeckon = 1;
                    [wself.dashan setBackgroundImage:[UIImage imageNamed:@"sixin_icon"] forState:UIControlStateNormal];
                }];
            } else {
                [ASMyAppCommonFunc behaviorStatisticsWithType:Behavior_home_like_sixin];//统计
                [ASMyAppCommonFunc chatWithUserID:wself.model.ID nickName:wself.model.nickname action:^(id  _Nonnull data) {
                    
                }];
            }
        }];
    }
    return _dashan;
}
@end
