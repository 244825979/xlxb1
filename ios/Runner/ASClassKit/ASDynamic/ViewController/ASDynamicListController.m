//
//  ASDynamicListController.m
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASDynamicListController.h"
#import "ASDynamicListModel.h"
#import "ASDynamicRequest.h"
#import "ASDynamicListCell.h"
#import "ASDynamicListTopView.h"
#import "ASDynamicDetailsController.h"
#import "ASHomeRequest.h"

@interface ASDynamicListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) ASDynamicListTopView *topView;
/**数据**/
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ASDynamicListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
    [self createUI];
    if (self.type == 1) {
        [self onRefresh];
    }
}

- (void)createUI {
    self.tableView.mj_header = [ASRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefresh)];
    self.tableView.mj_footer = [ASRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(onNextPage)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (self.type == 0 && USER_INFO.systemIndexModel.you_like_switch_dynamic == 1) {//推荐
        self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        self.tableView.tableHeaderView = self.topView;
        [self requestLikeUser];
    }
}

- (void)refreshWithArray:(NSArray *)array {
    self.page = 2;
    self.lists = [NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];
}

- (void)onRefresh {
    self.page = 1;
    [self requestList];
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = NO;
    if (self.type == 0 && USER_INFO.systemIndexModel.you_like_switch_dynamic == 1) {
        [self requestLikeUser];
    }
}

- (void)onNextPage {
    if (kObjectIsEmpty(self.lists)) {
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    [self requestList];
}

- (void)requestList {
    kWeakSelf(self);
    [ASDynamicRequest requestDynamicListWithPage:self.page type:(self.type + 1) success:^(id  _Nullable data) {
        NSArray *array = data;
        if (wself.page == 1) {
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
        wself.tableView.emptyType = kTableViewEmptyDynamic;
    } errorBack:^(NSInteger code, NSString *msg) {
        [wself.tableView.mj_footer endRefreshing];
        [wself.tableView.mj_header endRefreshing];
        wself.tableView.emptyType = kTableViewEmptyLoadFail;
    }];
}

- (void)requestLikeUser {
    kWeakSelf(self);
    [ASHomeRequest requestLikeUserWithType:@"dynamic" HUD:NO success:^(id  _Nonnull response) {
        NSArray *list = response;
        wself.topView.lists = list;
        if (list.count == 0) {
            wself.topView.height = 0;
        } else {
            wself.topView.height = SCALES(68);
        }
        [wself.tableView reloadData];
    } errorBack:^(NSInteger code, NSString * _Nonnull message) {
        wself.topView.height = 0;
        [wself.tableView reloadData];
    }];
}

#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    ASDynamicListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASDynamicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    ASDynamicListModel *model = self.lists[indexPath.row];
    cell.model = model;
    kWeakSelf(self);
    cell.clikedBlock = ^(NSString * _Nonnull indexName) {
        if ([indexName isEqualToString:@"删除"]) {
            [wself.lists removeObject:model];
            [wself.tableView reloadData];
            return;
        }
        ASDynamicDetailsController *vc = [[ASDynamicDetailsController alloc] init];
        vc.model = model;
        vc.delBlock = ^{
            [wself.lists removeObject:model];
            [wself.tableView reloadData];
        };
        [wself.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASDynamicListModel *model = self.lists[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ASDynamicListModel *model = self.lists[indexPath.row];
    ASDynamicDetailsController *vc = [[ASDynamicDetailsController alloc] init];
    vc.model = model;
    kWeakSelf(self);
    vc.delBlock = ^{
        [wself.lists removeObject:model];
        [wself.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyType = kTableViewEmptyDynamic;
    }
    return _tableView;
}

- (ASDynamicListTopView *)topView {
    if (!_topView) {
        _topView = [[ASDynamicListTopView alloc]init];
        _topView.backgroundColor = UIColor.clearColor;
    }
    return _topView;
}
@end
