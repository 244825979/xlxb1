//
//  ASSetBackListController.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASSetBackListController.h"
#import "ASSetRequest.h"
#import "ASBlackListCell.h"

@interface ASSetBackListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray<ASUserInfoModel *> *lists;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ASSetBackListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"黑名单";
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
}

- (void)onRefresh {
    self.page = 1;
    [self requestList];
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = NO;
}

- (void)onNextPage {
    if (kObjectIsEmpty(self.lists) || self.lists.count == 0){//数据为空禁止加载
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    [self requestList];
}

- (void)requestList {
    kWeakSelf(self);
    [ASSetRequest requestBlackListWithPage:self.page success:^(id  _Nullable data) {
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
        wself.tableView.emptyType = kTableViewEmptyBlackList;
    } errorBack:^(NSInteger code, NSString *msg) {
        [wself.tableView.mj_footer endRefreshing];
        [wself.tableView.mj_header endRefreshing];
        wself.tableView.emptyType = kTableViewEmptyLoadFail;
    }];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    ASBlackListCell *cell =  [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASBlackListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.model = self.lists[indexPath.row];
    kWeakSelf(self);
    cell.refreshBlock = ^{
        [wself onRefresh];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(76);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ASUserInfoModel *model = self.lists[indexPath.row];
    [ASMyAppCommonFunc goPersonalHomeWithUserID:model.user_id viewController:self action:^(id  _Nonnull data) {
        
    }];
}

- (NSMutableArray *)lists {
    if (!_lists) {
        _lists = [[NSMutableArray alloc]init];
    }
    return _lists;
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyType = kTableViewEmptyBlackList;
    }
    return _tableView;
}
@end
