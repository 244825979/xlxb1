//
//  ASHomeOnlineListController.m
//  AS
//
//  Created by SA on 2025/8/1.
//

#import "ASHomeOnlineListController.h"
#import "ASHomeRequest.h"
#import "ASHomeUserListModel.h"
#import "ASHomeVoicePlayView.h"
#import "ASHomeOnlineUserListCell.h"

@interface ASHomeOnlineListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) ASHomeVoicePlayView *playView;
@end

@implementation ASHomeOnlineListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self createUI];
    [self onRefresh];
    kWeakSelf(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"AudioPlayCompletionNotifiction" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [wself.playView stopAnimating];
        [[ASAudioPlayManager shared] stop];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.playView stopAnimating];
    [[ASAudioPlayManager shared] stop];
}

- (void)createUI {
    self.tableView.mj_footer = [ASRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(onNextPage)];
    UIImageView *hintIcon = [[UIImageView alloc] init];
    hintIcon.image = [UIImage imageNamed:@"home_hint"];
    [self.view addSubview:hintIcon];
    [hintIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(SCALES(8));
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(SCALES(32));
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)onRefresh {
    self.page = 1;
    [self.playView stopAnimating];
    [[ASAudioPlayManager shared] stop];
    [self requestList];
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = NO;
}

- (void)onNextPage {
    [self.playView stopAnimating];
    [[ASAudioPlayManager shared] stop];
    if (kObjectIsEmpty(self.lists)) {
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    [self requestList];
}

- (void)requestList {
    kWeakSelf(self);
    [ASHomeRequest requestHomeNewUserListWithPage:self.page success:^(id  _Nullable data) {
        ASHomeUserModel *model = data;
        NSArray *array = model.list;
        if(wself.page == 1){
            wself.lists = [NSMutableArray arrayWithArray:array];
            if (wself.onRefreshBack) {
                wself.onRefreshBack();
            }
            if (wself.lists.count == 0) {
                wself.tableView.mj_footer.hidden = YES;
            }
        } else {
            [wself.lists addObjectsFromArray:array];
            [wself.tableView.mj_footer endRefreshing];
        }
        if (array.count > 0) {//数据大于0就有下一页
            wself.page++;
        }
        [wself.tableView reloadData];
    } errorBack:^(NSInteger code, NSString *msg) {
        [wself.tableView.mj_footer endRefreshing];
        if (wself.onRefreshBack) {
            wself.onRefreshBack();
        }
    }];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    ASHomeOnlineUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASHomeOnlineUserListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    ASHomeUserListModel *model = self.lists[indexPath.row];
    cell.model = model;
    cell.isBeckon = model.is_beckon;
    kWeakSelf(self);
    cell.actionBlack = ^(ASHomeVoicePlayView * _Nonnull playView) {
        if (!kObjectIsEmpty(wself.playView)) {
            if (wself.playView == playView) {
                if (playView.isPlaying == YES) {
                    [[ASAudioPlayManager shared] stop];
                    [wself.playView stopAnimating];
                } else {
                    [[ASAudioPlayManager shared] stop];
                    //播放语音
                    [playView playAnimating];
                    [[ASAudioPlayManager shared] playFromURL:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, playView.model.voice]];
                    wself.playView = playView;
                }
            } else {
                [wself.playView stopAnimating];
                [[ASAudioPlayManager shared] stop];
                //播放语音
                [playView playAnimating];
                [[ASAudioPlayManager shared] playFromURL:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, playView.model.voice]];
                wself.playView = playView;
            }
        } else {
            //播放语音
            [playView playAnimating];
            [[ASAudioPlayManager shared] playFromURL:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, playView.model.voice]];
            wself.playView = playView;
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(96);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ASHomeUserListModel *model = self.lists[indexPath.row];
    [ASMyAppCommonFunc goPersonalHomeWithUserID:model.ID viewController:self action:^(id  _Nonnull data) {
        NSString *str = data;
        if ([str isEqualToString:@"beckon"]) {
            model.is_beckon = 1;
            ASHomeOnlineUserListCell *cell = (ASHomeOnlineUserListCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.isBeckon = 1;
        }
    }];
}

#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.tableView;
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

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.emptyType = kTableViewEmptyNoData;
    }
    return _tableView;
}
@end
