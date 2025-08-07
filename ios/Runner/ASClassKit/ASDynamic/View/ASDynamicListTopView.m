//
//  ASDynamicListTopView.m
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASDynamicListTopView.h"

@interface ASDynamicListTopView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ASDynamicListTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat itemW = (SCREEN_WIDTH - SCALES(32) - SCALES(32)) /5;
        CGFloat itemH = SCALES(64);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumLineSpacing = SCALES(8);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = ({
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCALES(16), 0, SCREEN_WIDTH - SCALES(32), SCALES(64)) collectionViewLayout:flowLayout];
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.backgroundColor = UIColor.clearColor;
            [self addSubview:collectionView];
            collectionView;
        });
        [self.collectionView registerClass:[ASDynamicLikeListItemCell class] forCellWithReuseIdentifier:@"dynamicLikeListItemCell"];
    }
    return self;
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
    ASDynamicLikeListItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dynamicLikeListItemCell" forIndexPath:indexPath];
    cell.model = self.lists[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ASHomeUserListModel *model = self.lists[indexPath.row];
    [ASMyAppCommonFunc behaviorStatisticsWithType:Behavior_dynamic_like_head];
    [ASMyAppCommonFunc goPersonalHomeWithUserID:model.ID viewController:[ASCommonFunc currentVc] action:^(id  _Nonnull data) {
        
    }];
}
@end

@interface ASDynamicLikeListItemCell ()
@property (nonatomic, strong) UIView *headerBg;
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UIView *state;
@property (nonatomic, strong) UILabel *userName;
@end

@implementation ASDynamicLikeListItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.headerBg];
        [self.headerBg addSubview:self.header];
        [self.headerBg addSubview:self.state];
        [self addSubview:self.userName];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.headerBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(10));
        make.centerX.equalTo(self);
        make.height.width.mas_equalTo(SCALES(34));
    }];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.headerBg);
        make.height.width.mas_equalTo(SCALES(32));
    }];
    [self.state mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.headerBg);
        make.height.width.mas_equalTo(SCALES(8));
    }];
    [self.userName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(SCALES(14));
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
    self.userName.textColor = model.is_vip == YES ? RED_COLOR : TITLE_COLOR;
}

- (UIView *)headerBg {
    if (!_headerBg) {
        _headerBg = [[UIView alloc]init];
        _headerBg.layer.masksToBounds = YES;
        _headerBg.layer.cornerRadius = SCALES(17);
        _headerBg.layer.borderColor = UIColorRGB(0xFF79B9).CGColor;
        _headerBg.layer.borderWidth = SCALES(0.5);
    }
    return _headerBg;
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.layer.masksToBounds = YES;
        _header.layer.cornerRadius = SCALES(16);
        _header.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _header;
}

- (UIView *)state {
    if (!_state) {
        _state = [[UIView alloc]init];
        _state.backgroundColor = UIColorRGB(0x63E170);
        _state.hidden = YES;
        _state.layer.masksToBounds = YES;
        _state.layer.cornerRadius = SCALES(4);
        _state.layer.borderColor = UIColor.whiteColor.CGColor;
        _state.layer.borderWidth = SCALES(1);
    }
    return _state;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc]init];
        _userName.font = TEXT_FONT_11;
        _userName.text = @"昵称";
        _userName.textColor = TITLE_COLOR;
        _userName.textAlignment = NSTextAlignmentCenter;
    }
    return _userName;
}
@end
