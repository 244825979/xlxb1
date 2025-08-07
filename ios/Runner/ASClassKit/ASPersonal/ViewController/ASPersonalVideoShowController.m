//
//  ASPersonalVideoShowController.m
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASPersonalVideoShowController.h"
#import "ASVideoShowRequest.h"
#import "ASPersonalVideoShowListCell.h"

@interface ASPersonalVideoShowController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
/**数据**/
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *lists;
@end

@implementation ASPersonalVideoShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self onRefresh];
}

- (void)createUI {
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
    if (kObjectIsEmpty(self.lists)) {
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    [self requestList];
}

- (void)requestList {
    kWeakSelf(self);
    [ASVideoShowRequest requestMyPlayerVideoShowWithVideoID:self.videoShowID
                                                     userID:self.userID
                                                       page:self.page
                                                    success:^(id _Nullable data) {
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
    ASPersonalVideoShowListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASPersonalVideoShowListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    ASVideoShowDataModel *model = self.lists[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASVideoShowDataModel *model = self.lists[indexPath.row];
    return model.titleHeight > 0 ? model.titleHeight + SCALES(16) + SCALES(234) + SCALES(12) + SCALES(44) :  SCALES(16) + SCALES(234) + SCALES(44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ASVideoShowDataModel *videoModel = self.lists[indexPath.row];
    ASVideoShowPlayController *vc = [[ASVideoShowPlayController alloc] init];
    vc.model = videoModel;
    if ([self.userID isEqualToString:USER_INFO.user_id]) {
        vc.popType = kVideoPlayMyListVideo;
    } else {
        vc.popType = kVideoPlayPersonalHome;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyType = kTableViewEmptyVideoShow;
        _tableView.verticalOffset = kISiPhoneX ? -SCALES(200) : -SCALES(170);
        _tableView.textTitle = @"暂无视频秀~";
    }
    return _tableView;
}

#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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
