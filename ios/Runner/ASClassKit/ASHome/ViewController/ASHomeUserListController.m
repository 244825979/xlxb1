//
//  ASHomeUserListController.m
//  AS
//
//  Created by SA on 2025/4/16.
//

#import "ASHomeUserListController.h"
#import "ASHomeUserListCell.h"
#import "ASHomeRequest.h"

@interface ASHomeUserListController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ASHomeUserListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self createUI];
    self.collectionView.mj_footer = [ASRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(onNextPage)];
    [self onRefresh];
}

- (void)createUI {
    UIImageView *hintIcon = [[UIImageView alloc] init];
    hintIcon.image = [UIImage imageNamed:@"home_hint"];
    [self.view addSubview:hintIcon];
    [hintIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(SCALES(8));
    }];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = SCALES(10);
    flowLayout.itemSize = CGSizeMake(floor((SCREEN_WIDTH - SCALES(42))/2), SCALES(180)); //固定的itemsize
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滑动方向，水平滚动
    self.collectionView = ({
        ASBaseCollectionView *collectionView = [[ASBaseCollectionView alloc] initWithFrame:CGRectMake(SCALES(16),
                                                                                                      SCALES(32),
                                                                                                      SCREEN_WIDTH - SCALES(32),
                                                                                                      SCREEN_HEIGHT - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT - SCALES(32)) collectionViewLayout:flowLayout];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.backgroundColor = BACKGROUNDCOLOR;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.emptyType = kCollectionViewEmptyNoData;
        collectionView.verticalOffset = SCALES(-180);
        collectionView;
    });
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[ASHomeUserListCell class] forCellWithReuseIdentifier:@"homeUserCell"];
}

- (void)onRefresh {
    self.page = 1;
    [self requestList];
    [self.collectionView.mj_footer endRefreshing];
    self.collectionView.mj_footer.hidden = NO;
}

- (void)onNextPage {
    if (kObjectIsEmpty(self.lists)){
        self.collectionView.mj_footer.hidden = YES;
        return;
    }
    [self requestList];
}

- (void)requestList {
    kWeakSelf(self);
    if (self.type == 0) {
        [ASHomeRequest requestHomeUserListWithPage:self.page success:^(id  _Nullable data) {
            ASHomeUserModel *model = data;
            NSArray *array = model.list;
            if(wself.page == 1){
                wself.lists = [NSMutableArray arrayWithArray:array];
                if (wself.onRefreshBack) {
                    wself.onRefreshBack();
                }
                if (wself.lists.count == 0) {
                    wself.collectionView.mj_footer.hidden = YES;
                }
            } else {
                [wself.lists addObjectsFromArray:array];
                [wself.collectionView.mj_footer endRefreshing];
            }
            if (array.count > 0) {
                wself.page++;
            }
            [wself.collectionView reloadData];
        } errorBack:^(NSInteger code, NSString *msg) {
            [wself.collectionView.mj_footer endRefreshing];
            if (wself.onRefreshBack) {
                wself.onRefreshBack();
            }
        }];
    } else {//新人，更换了接口
        [ASHomeRequest requestNewListWithPage:self.page success:^(id  _Nullable data) {
            ASHomeUserModel *model = data;
            NSArray *array = model.list;
            if(wself.page == 1){
                wself.lists = [NSMutableArray arrayWithArray:array];
                if (wself.onRefreshBack) {
                    wself.onRefreshBack();
                }
                if (wself.lists.count == 0) {
                    wself.collectionView.mj_footer.hidden = YES;
                }
            } else {
                [wself.lists addObjectsFromArray:array];
                [wself.collectionView.mj_footer endRefreshing];
            }
            if (array.count > 0) {//数据大于0就有下一页
                wself.page++;
            }
            [wself.collectionView reloadData];
        } errorBack:^(NSInteger code, NSString *msg) {
            [wself.collectionView.mj_footer endRefreshing];
            if (wself.onRefreshBack) {
                wself.onRefreshBack();
            }
        }];
    }
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
    if (self.type == 2) {
        cell.isCall = YES;
    } else {
        cell.isCall = NO;
        cell.isBeckon = model.is_beckon;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ASHomeUserListModel *model = self.lists[indexPath.row];
    [ASMyAppCommonFunc goPersonalHomeWithUserID:model.ID viewController:self action:^(id  _Nonnull data) {
        NSString *str = data;
        if ([str isEqualToString:@"beckon"]) {
            model.is_beckon = 1;
            ASHomeUserListCell *cell = (ASHomeUserListCell *)[collectionView cellForItemAtIndexPath:indexPath];;
            cell.isBeckon = 1;
        }
    }];
}

#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollOffsetBolck) {
        self.scrollOffsetBolck(scrollView.contentOffset.y > 500 ? YES : NO);
    }
    if (self.scrollCallback != nil) {
        self.scrollCallback(scrollView);
    }
}

- (UIView *)listView {
    return self.view;
}

- (void)dealloc {
    self.scrollCallback = nil;
}
@end
