//
//  ASCallRecordListController.m
//  AS
//
//  Created by SA on 2025/5/14.
//

#import "ASCallRecordListController.h"
#import "ASIMRequest.h"
#import "ASCallRecordTopView.h"
#import "ASCallListModel.h"
#import "ASCallRecordListCell.h"

@interface ASCallRecordListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) ASCallRecordTopView *topView;
/**数据**/
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *lists;
@end

@implementation ASCallRecordListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"我的通话";
    [self createUI];
    [self onRefresh];
}

- (void)createUI {
    self.tableView.mj_header = [ASRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefresh)];
    self.tableView.mj_footer = [ASRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(onNextPage)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    [self.tableView setTableHeaderView:self.topView];
}

- (void)onRefresh {
    self.page = 1;
    [self requestList];
    [self requestRecommend];
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = NO;
}

- (void)onNextPage {
    if (kObjectIsEmpty(self.lists)){
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    [self requestList];
}

- (void)requestList {
    kWeakSelf(self);
    [ASIMRequest requestCallListWithPage:self.page success:^(id  _Nullable data) {
        NSArray *array = data;
        if(wself.page == 1){
            wself.lists = [NSMutableArray arrayWithArray:array];
            [wself.tableView.mj_header endRefreshing];
            if (wself.lists.count == 0) {
                wself.tableView.mj_footer.hidden = YES;
            }
        } else {
            [wself.lists addObjectsFromArray:array];
            [wself.tableView.mj_footer endRefreshing];
        }
        wself.page++;
        [wself.tableView reloadData];
        wself.tableView.emptyType = kTableViewEmptyCallList;
    } errorBack:^(NSInteger code, NSString *msg) {
        [wself.tableView.mj_footer endRefreshing];
        [wself.tableView.mj_header endRefreshing];
        wself.tableView.emptyType = kTableViewEmptyLoadFail;
    }];
}

- (void)requestRecommend {
    kWeakSelf(self);
    [ASIMRequest requestCallRecommendSuccess:^(id  _Nullable data) {
        NSArray *array = data;
        if (array.count > 0) {
            wself.topView.lists = array;
            wself.topView.hidden = NO;
            wself.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(196));
            wself.tableView.verticalOffset = SCALES(50);
        } else {
            wself.topView.lists = @[];
            wself.topView.hidden = YES;
            wself.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
            wself.tableView.verticalOffset = SCALES(-80);
        }
        [wself.tableView reloadData];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

#pragma mark - JXPagingViewListViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    ASCallRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASCallRecordListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.model = self.lists[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ASCallListModel *model = self.lists[indexPath.row];
    [ASMyAppCommonFunc chatWithUserID:model.userid nickName:model.nickname action:^(id  _Nonnull data) {
    }];
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyType = kTableViewEmptyCallList;
    }
    return _tableView;
}

- (ASCallRecordTopView *)topView {
    if (!_topView) {
        _topView = [[ASCallRecordTopView alloc]init];
        _topView.hidden = YES;
        kWeakSelf(self);
        _topView.closeBlock = ^{
            wself.topView.hidden = YES;
            wself.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
            wself.tableView.verticalOffset = SCALES(-80);
            [wself.tableView reloadData];
        };
    }
    return _topView;
}

- (NSMutableArray *)lists {
    if (!_lists) {
        _lists = [[NSMutableArray alloc]init];
    }
    return _lists;
}
@end
