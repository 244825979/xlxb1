//
//  ASVideoShowNotifyController.m
//  AS
//
//  Created by SA on 2025/5/12.
//

#import "ASVideoShowNotifyController.h"
#import "ASVideoShowRequest.h"
#import "ASVideoShowNotifyListCell.h"
#import "ASVideoShowNotifyModel.h"

@interface ASVideoShowNotifyController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) ASBaseTableView *tableView;
/**数据**/
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ASVideoShowNotifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"视频秀通知";
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
    if (kObjectIsEmpty(self.lists)){
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    [self requestList];
}

#pragma mark -  请求列表数据
- (void)requestList {
    kWeakSelf(self);
    [ASVideoShowRequest requestVideoShowNotifyListWithPage:self.page success:^(id  _Nullable data) {
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
        wself.tableView.emptyType = kTableViewEmptyVideoShow;
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
    ASVideoShowNotifyListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASVideoShowNotifyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    ASVideoShowNotifyModel *model = self.lists[indexPath.row];
    cell.model = model;
    kWeakSelf(self);
    cell.indexNameBlock = ^(NSString *indexName) {
        if ([indexName isEqualToString:@"去主页"]) {
            [ASMyAppCommonFunc goPersonalHomeWithUserID:model.from_uid viewController:self action:^(id  _Nonnull data) {
            }];
            return;
        }
        if ([indexName isEqualToString:@"视频秀"]) {
            ASVideoShowDataModel *videoShowModel = [[ASVideoShowDataModel alloc] init];
            videoShowModel.ID = STRING(model.show_id);
            videoShowModel.user_id = USER_INFO.user_id;
            videoShowModel.cover_img_url = model.cover;
            ASVideoShowPlayController *vc = [[ASVideoShowPlayController alloc] init];
            vc.model = videoShowModel;
            vc.popType = kVideoPlayMyListVideo;
            [wself.navigationController pushViewController:vc animated:YES];
            return;
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(82);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ASVideoShowNotifyModel *model = self.lists[indexPath.row];
    [ASMyAppCommonFunc goPersonalHomeWithUserID:model.from_uid viewController:self action:^(id  _Nonnull data) {
        
    }];
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyType = kTableViewEmptyVideoShow;
    }
    return _tableView;
}
@end
