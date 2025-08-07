//
//  ASFansListController.m
//  AS
//
//  Created by SA on 2025/5/15.
//

#import "ASFansListController.h"
#import "ASMineRequest.h"
#import "ASFansOrFollowListCell.h"

@interface ASFansListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
/**数据**/
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ASFansListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"粉丝";
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
    if (kObjectIsEmpty(self.lists)){
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    [self requestList];
}

#pragma mark -  请求列表数据
- (void)requestList {
    kWeakSelf(self);
    [ASMineRequest requestFansListWithPage:self.page success:^(id  _Nullable data) {
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
        wself.tableView.emptyType = kTableViewEmptyFansList;
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
    ASFansOrFollowListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASFansOrFollowListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.type = kFansCellType;
    }
    cell.model = self.lists[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(80);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ASUserInfoModel *model = self.lists[indexPath.row];
    [ASMyAppCommonFunc goPersonalHomeWithUserID:model.userid viewController:self action:^(id  _Nonnull data) {
        NSString *str = data;
        if ([str isEqualToString:@"addAttention"]) {
            model.is_follow = 1;
            ASFansOrFollowListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.isFollow = 1;
            return;
        }
        if ([str isEqualToString:@"delAttention"]) {
            model.is_follow = 0;
            ASFansOrFollowListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.isFollow = 0;
            return;
        }
    }];
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.emptyType = kTableViewEmptyFansList;
    }
    return _tableView;
}
@end
