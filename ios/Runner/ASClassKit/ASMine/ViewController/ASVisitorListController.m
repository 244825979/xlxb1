//
//  ASVisitorListController.m
//  AS
//
//  Created by SA on 2025/6/30.
//

#import "ASVisitorListController.h"
#import "ASVipDetailsController.h"
#import "ASMineRequest.h"
#import "ASVisitorListCell.h"

@interface ASVisitorListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) zhPopupController *vipUnlockPopView;//解锁访客弹窗
@end

@implementation ASVisitorListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"访客";
    self.view.backgroundColor = BACKGROUNDCOLOR;
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
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCALES(10))];
    headView.backgroundColor = BACKGROUNDCOLOR;
    self.tableView.tableHeaderView = headView;
    
    kWeakSelf(self);
    if (USER_INFO.gender == 2 && self.isVip == NO) {//是男且没有开通vip
        [ASAlertViewManager popVipUnlockWithAction:^{
            ASVipDetailsController *vc = [[ASVipDetailsController alloc] init];
            [wself.navigationController pushViewController:vc animated:YES];
        } cancelAction:^{
            [wself.navigationController popViewControllerAnimated:YES];
        }];
    }
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
    [ASMineRequest requestVisitorListWithPage:self.page success:^(id  _Nullable data) {
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
        wself.tableView.emptyType = kTableViewEmptyFangke;
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
    ASVisitorListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASVisitorListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.model = self.lists[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(76);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ASUserInfoModel *model = self.lists[indexPath.row];
    [ASMyAppCommonFunc goPersonalHomeWithUserID:model.userid viewController:self action:^(id  _Nonnull data) {
        NSString *str = data;
        if ([str isEqualToString:@"beckon"]) {
            model.is_beckon = 1;
            ASVisitorListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.isBeckon = 1;
        }
    }];
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyType = kTableViewEmptyFangke;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
    }
    return _tableView;
}

@end
