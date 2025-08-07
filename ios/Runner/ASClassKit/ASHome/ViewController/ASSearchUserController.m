//
//  ASSearchUserController.m
//  AS
//
//  Created by SA on 2025/4/16.
//

#import "ASSearchUserController.h"
#import "ASHomeUserListCell.h"
#import "ASHomeRequest.h"
#import "ASSearchBarView.h"

@interface ASSearchUserController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *lists;
@property (nonatomic, strong) ASBaseCollectionView *collectionView;
@property (nonatomic, strong) ASSearchBarView *searchBarView;
@end

@implementation ASSearchUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"搜索";
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self createUI];
}

- (void)createUI {
    kWeakSelf(self);
    self.searchBarView = ({
        ASSearchBarView *view = [[ASSearchBarView alloc] init];
        view.textBlock = ^(NSString * _Nonnull text) {
            [ASHomeRequest requestHomeSearchWithID:text success:^(ASHomeUserListModel * _Nullable data) {
                if (!kStringIsEmpty(data.ID)) {
                    wself.lists = @[data];
                } else {
                    wself.lists = @[];
                    wself.collectionView.emptyType = kCollectionViewEmptySearch;
                }
                [wself.collectionView reloadData];
            } errorBack:^(NSInteger code, NSString *msg) {
                wself.collectionView.emptyType = kCollectionViewEmptyLoadFail;
            }];
        };
        [self.view addSubview:view];
        view;
    });
   
    [self.searchBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(SCALES(78));
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = SCALES(9);
    flowLayout.itemSize = CGSizeMake(floor((SCREEN_WIDTH - SCALES(41))/2), SCALES(209)); //固定的itemsize
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滑动方向，水平滚动
    self.collectionView = ({
        ASBaseCollectionView *collectionView = [[ASBaseCollectionView alloc] initWithFrame:CGRectMake(SCALES(16),
                                                                                                      SCALES(78),
                                                                                                      SCREEN_WIDTH - SCALES(32),
                                                                                                      SCREEN_HEIGHT - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT - SCALES(78)) collectionViewLayout:flowLayout];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.backgroundColor = BACKGROUNDCOLOR;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.emptyType = kCollectionViewEmptySearch;
        collectionView;
    });
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[ASHomeUserListCell class] forCellWithReuseIdentifier:@"homeUserCell"];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASHomeUserListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeUserCell" forIndexPath:indexPath];
    ASHomeUserListModel *model = self.lists[indexPath.row];
    cell.model = model;
    cell.isCall = NO;
    cell.isBeckon = model.is_beckon;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ASHomeUserListModel *model = self.lists[indexPath.row];
    [ASMyAppCommonFunc goPersonalHomeWithUserID:model.ID viewController:self action:^(id  _Nonnull data) {
        
    }];
}
@end
