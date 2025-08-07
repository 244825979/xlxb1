//
//  ASDynamicNotifyController.m
//  AS
//
//  Created by SA on 2025/5/16.
//

#import "ASDynamicNotifyController.h"
#import "ASDynamicRequest.h"
#import "ASDynamicNotifyListCell.h"
#import "ASDynamicNotifyListModel.h"
#import "ASDynamicListModel.h"
#import "ASDynamicDetailsController.h"

@interface ASDynamicNotifyController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
/**数据**/
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ASDynamicNotifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"动态消息";
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

- (void)onNextPage{
    if (kObjectIsEmpty(self.lists)){//数据为空禁止加载
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    [self requestList];
}

#pragma mark -  请求列表数据
- (void)requestList {
    kWeakSelf(self);
    [ASDynamicRequest requestDynamicNotifyListWithPage:self.page success:^(id  _Nullable data) {
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
    ASDynamicNotifyListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASDynamicNotifyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.model = self.lists[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASDynamicNotifyListModel *model = self.lists[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ASDynamicNotifyListModel *model = self.lists[indexPath.row];
    ASDynamicListModel *dynamicListModel = [[ASDynamicListModel alloc] init];
    dynamicListModel.ID = model.dynamic_id;
    dynamicListModel.status = 1;
    ASDynamicDetailsController *vc = [[ASDynamicDetailsController alloc] init];
    vc.model = dynamicListModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyType = kTableViewEmptyNoData;
    }
    return _tableView;
}
@end
