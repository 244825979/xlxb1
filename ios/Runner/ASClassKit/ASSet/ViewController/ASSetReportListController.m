//
//  ASSetReportListController.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASSetReportListController.h"
#import "ASSetRequest.h"
#import "ASReportListCell.h"
#import "ASReportDetailsController.h"

@interface ASSetReportListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ASSetReportListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"举报记录";
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCALES(10))];
    headerView.backgroundColor = BACKGROUNDCOLOR;
    [self.tableView setTableHeaderView:headerView];
}

- (void)onRefresh {
    self.page = 1;
    [self requestList];
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = NO;
}

- (void)onNextPage{
    if (kObjectIsEmpty(self.lists) || self.lists.count == 0){//数据为空禁止加载
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    [self requestList];
}

- (void)requestList {
    kWeakSelf(self);
    [ASSetRequest requestReportListWithPage:self.page success:^(id  _Nullable data) {
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
        wself.tableView.emptyType = kTableViewEmptyNoData;
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
    ASReportListCell *cell =  [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASReportListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.model = self.lists[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(70);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ASReportListModel *model = self.lists[indexPath.row];
    ASReportDetailsController *vc = [[ASReportDetailsController alloc] init];
    vc.model = model;
    vc.backBlock = ^(NSInteger index) {
        model.status = index;
        ASReportListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.model = model;
    };
    [self.navigationController pushViewController:vc animated:YES];
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
        _tableView.emptyType = kTableViewEmptyNoData;
        _tableView.textTitle = @"暂无举报记录";
    }
    return _tableView;
}
@end
