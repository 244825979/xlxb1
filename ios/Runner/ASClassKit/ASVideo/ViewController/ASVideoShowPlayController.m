//
//  ASVideoShowPlayController.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASVideoShowPlayController.h"
#import "ASVideoShowPlayCell.h"
#import "ASVideoShowRequest.h"

#define PLAY_CLICK @"PLAY_CLICK"       //当前播放器启动播放
#define PLAY_PREPARE @"PLAY_PREPARE"   //当前播放器收到 PLAY_PREPARE 事件
typedef NS_ENUM(NSInteger,ASDragDirection){
    ASDragDirection_Down,
    ASDragDirection_Up,
};

@interface ASVideoShowPlayController ()<UITableViewDelegate, UITableViewDataSource, ASVideoShowMaskDelegate, TXVodPlayListener, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ASVideoShowPlayCell *currentCell;
/**数据**/
@property (nonatomic, strong) NSMutableArray *liveInfos;
@property (nonatomic, strong) NSMutableArray *playerList;
@property (nonatomic, assign) NSInteger liveSelectIndex;
@property (nonatomic, assign) ASDragDirection dragDirection;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL appIsInterrupt;
@property (nonatomic, assign) BOOL videoPause;//是否暂停
@property (nonatomic, assign) BOOL beginDragging;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isSilence;//是否开启静音，默认YES不开启，NO表示开启
@property (nonatomic, copy) NSString *completeNum;//播放完整度，1播放完，0否
@property (nonatomic, assign) NSInteger timers;//计时停留市场
@property (nonatomic, strong) RACDisposable *timerDisposable;//通话计时
@property (nonatomic, strong) NSMutableArray *followClikedList;
@property (nonatomic, assign) int cache_player;//预加载数据数量
@property (nonatomic, copy) NSString *notifictionAcount;//通知数量
@end

@implementation ASVideoShowPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self addNotify];
    [self refresh];
    if (self.popType == kVideoPlayTabbar) {
        [self requestData];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.popType == kVideoPlayTabbar) {
        if ([ASPopViewManager shared].popGoodAnchorState == 2 || [ASPopViewManager shared].popGoodAnchorState == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goodAnchorConfigNotification" object:nil];
        }
    }
    [self.currentPlayer setMute:!self.isSilence];
    if (self.videoPause == NO && self.currentPlayer) {//如果出去的时候是播放状态，就进行播放
        //这里如果是从录制界面，或则其他播放界面过来的，要重新startPlay，因为AudioSession有可能被修改了，导致当前视频播放有异常
        NSMutableDictionary *param = [self getPlayerParam:self.currentPlayer];
        [self.currentPlayer startVodPlay:param[@"playUrl"]];
        self.currentCell.maskView.playBtn.hidden = YES;
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        self.videoPause = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.currentPlayer pause];//暂停
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)createUI {
    self.shouldNavigationBarHidden = YES;
    self.cache_player = 3;
    self.page = 1;
    self.liveSelectIndex = 0;
    self.dragDirection = ASDragDirection_Down;
    self.videoPause = NO;
    
    self.view.backgroundColor = [UIColor blackColor];
    self.cellHeight = self.popType == kVideoPlayTabbar ? (SCREEN_HEIGHT - TAB_BAR_HEIGHT) : SCREEN_HEIGHT;
    self.isSilence = YES;
    [self.view addSubview: self.tableView];
    self.tableView.rowHeight = self.cellHeight;
}

- (void)addNotify {
    kWeakSelf(self);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    //更新消息数量
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"videoShowCountNotification" object:nil] subscribeNext:^(NSNotification * _Nullable data) {
        NSString *count = data.object;
        wself.notifictionAcount = count;
    }];
    //暂停播放
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"videoShowStopNotification" object:nil] subscribeNext:^(NSNotification * _Nullable data) {
        [wself.currentPlayer pause];
        wself.currentCell.maskView.playBtn.hidden = NO;
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }];
}

- (void)initPlayer {
    for (NSMutableDictionary *param in self.playerList) {
        TXVodPlayer *player = param[@"player"];
        player.vodDelegate = nil;
        [player stopPlay];
        [player removeVideoWidget];
    }
    [self.playerList removeAllObjects];
    int playerCount = 0;
    int liveIndex = (int)self.liveSelectIndex;
    int liveIndexOffset = - self.cache_player / 2;
    if (self.liveSelectIndex <= self.cache_player / 2) {
        liveIndex = 0;
        liveIndexOffset = 0;
    }
    if (self.liveSelectIndex >= self.liveInfos.count - self.cache_player / 2 - 1) {
        liveIndex = (int)self.liveInfos.count - self.cache_player;
        liveIndexOffset = 0;
    }
    while (playerCount < self.cache_player && playerCount < self.liveInfos.count) {
        TXVodPlayer *player = [[TXVodPlayer alloc] init];
        player.isAutoPlay = NO;
        ASVideoShowDataModel *info = self.liveInfos[liveIndex + liveIndexOffset];
        NSString *playUrl = [self checkHttps:info.video_url];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:player forKey:@"player"];
        [param setObject:playUrl forKey:@"playUrl"];
        [param setObject:STRING(info.cover_img_url) forKey:@"coverUrl"];
        [param setObject:@(NO) forKey:PLAY_CLICK];
        [param setObject:@(NO) forKey:PLAY_PREPARE];
        [self.playerList addObject:param];
        playerCount++;
        liveIndexOffset++;
    }
}

- (void)refresh {
    self.page = 1;
    self.tableView.mj_header = [ASRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefresh)];
    kWeakSelf(self);
    ASRefreshFooter *footer = [ASRefreshFooter footerWithRefreshingBlock:^{
        [wself onNextPage];
    }];
    footer.autoTriggerTimes = -1;//自动触发时间，如果为 -1, 则为无限触发
    self.tableView.mj_footer = footer;
    [self requestListData];
}

- (void)onRefresh {
    if (self.popType != kVideoPlayMyListVideo) {
        [self.timerDisposable dispose];//关闭定时器
        [self requestAddPlayNumWithModel:self.liveInfos[0]];//请求上一个视频统计
    }
    self.page = 1;
    [self requestListData];
    [self.tableView.mj_footer endRefreshing];
}

//上拉
- (void)onNextPage {
    if (kObjectIsEmpty(self.liveInfos)){//数据为空禁止加载
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    [self requestListData];
}

- (void)requestData {
    kWeakSelf(self);
    [ASVideoShowRequest requestVideoShowNotifySuccess:^(id _Nullable data) {
        NSNumber *unReadRecord = data;
        wself.notifictionAcount = [NSString stringWithFormat:@"%@", unReadRecord];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"videoShowCountNotification" object:STRING(wself.notifictionAcount)];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)requestListData {
    kWeakSelf(self);
    if (self.popType == kVideoPlayMyListVideo || self.popType == kVideoPlayPersonalHome) {
        [ASVideoShowRequest requestMyPlayerVideoShowWithVideoID:self.model.ID
                                                         userID:self.model.user_id
                                                           page:self.page
                                                        success:^(id _Nullable data) {
            NSArray *list = data;
            if(wself.page == 1){
                if (list.count == 0) {
                    wself.cache_player = 0;
                    wself.tableView.mj_footer.hidden = YES;
                    return;
                }
                [wself.followClikedList removeAllObjects];
                wself.liveInfos = [NSMutableArray arrayWithArray:list];
                if (list.count < 3) {
                    wself.cache_player = (int)list.count;
                } else {
                    wself.cache_player = 3;
                }
                [wself initPlayer];
                //下拉结束刷新
                [wself.tableView.mj_header endRefreshing];
                [wself.tableView reloadData];
                wself.liveSelectIndex = 0;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:wself.liveSelectIndex inSection:0];
                wself.currentCell = [wself.tableView cellForRowAtIndexPath:indexPath];
                [wself resumePlayer];
                wself.page++;
            } else {
                if (list.count > 0) {
                    [wself.liveInfos addObjectsFromArray:list];
                    [wself.tableView.mj_footer endRefreshing];
                    [wself.tableView reloadData];
                    
                    wself.liveSelectIndex++;
                    [wself.tableView setContentOffset:CGPointMake(0, (wself.cellHeight * wself.liveSelectIndex) + 52.0) animated:YES];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:wself.liveSelectIndex inSection:0];
                    wself.currentCell = [wself.tableView cellForRowAtIndexPath:indexPath];
                    wself.currentCell.maskView.silenceBtn.selected = wself.isSilence;
                    [wself resumePlayer];
                    wself.beginDragging = NO;
                    wself.page++;
                } else {
                    kShowToast(@"暂无更多内容");
                    [wself.tableView.mj_footer endRefreshing];
                }
            }
        } errorBack:^(NSInteger code, NSString *msg) {
            [wself.tableView.mj_footer endRefreshing];
            [wself.tableView.mj_header endRefreshing];
        }];
    } else {
        [ASVideoShowRequest requestPlayerVideoShowListWithPage:self.page success:^(id _Nullable data) {
            NSArray *list = data;
            if (wself.page == 1) {
                if (list.count == 0) {
                    wself.cache_player = 0;
                    wself.tableView.mj_footer.hidden = YES;
                    return;
                }
                [wself.followClikedList removeAllObjects];
                wself.liveInfos = [NSMutableArray arrayWithArray:list];
                if (list.count < 3) {
                    wself.cache_player = (int)list.count;
                } else {
                    wself.cache_player = 3;
                }
                [wself initPlayer];
                //下拉结束刷新
                [wself.tableView.mj_header endRefreshing];
                [wself.tableView reloadData];
                wself.liveSelectIndex = 0;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:wself.liveSelectIndex inSection:0];
                wself.currentCell = [wself.tableView cellForRowAtIndexPath:indexPath];
                [wself resumePlayer];
                wself.page++;
            } else {
                if (list.count > 0) {
                    [wself.liveInfos addObjectsFromArray:list];
                    [wself.tableView.mj_footer endRefreshing];
                    [wself.tableView reloadData];
                    wself.liveSelectIndex++;
                    [wself.tableView setContentOffset:CGPointMake(0, (wself.cellHeight * wself.liveSelectIndex) + 52.0) animated:YES];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:wself.liveSelectIndex inSection:0];
                    wself.currentCell = [wself.tableView cellForRowAtIndexPath:indexPath];
                    wself.currentCell.maskView.silenceBtn.selected = wself.isSilence;
                    [wself resumePlayer];
                    wself.beginDragging = NO;
                    wself.page++;
                } else {
                    kShowToast(@"暂无更多内容");
                    [wself.tableView.mj_footer endRefreshing];
                }
            }
        } errorBack:^(NSInteger code, NSString *msg) {
            [wself.tableView.mj_footer endRefreshing];
            [wself.tableView.mj_header endRefreshing];
        }];
    }
}

//重新播放
- (void)resumePlayer {
    if (self.currentPlayer) {//先暂停上一个播放器
        [self.currentPlayer seek:0];
        [self.currentPlayer pause];
    }
    self.currentCell.maskView.playBtn.hidden = YES;
    BOOL findPlayer = NO;//开启下一个播放器
    for (int i = 0; i < self.playerList.count; i ++) {
        NSMutableDictionary *playParam = self.playerList[i];
        NSString *playUrl = [playParam objectForKey:@"playUrl"];
        if ([playUrl isEqualToString:[self playUrl]]) {
            findPlayer = YES;
            self.currentPlayer = (TXVodPlayer *)[playParam objectForKey:@"player"];
            [self.currentPlayer setupVideoWidget:self.currentCell.videoParentView insertIndex:0];
            if (![playParam[PLAY_CLICK] boolValue]) {
                [self startPlay:playParam];
            }
            if ([playParam[PLAY_PREPARE] boolValue]) {
                [self.currentPlayer resume];
                self.currentCell.maskView.playBtn.hidden = YES;
            }
            if (self.liveSelectIndex < self.cache_player / 2 || self.liveSelectIndex > self.liveInfos.count - self.cache_player / 2 - 1) {
                break;
            }
            if (i > self.cache_player / 2) {
                int needMove = i - self.cache_player / 2;
                for (int j = 0; j < needMove; j ++) {
                    NSMutableDictionary *oldParam = self.playerList[j];
                    TXVodPlayer *player = [oldParam objectForKey:@"player"];
                    [player stopPlay];
                    [player removeVideoWidget];
                    ASVideoShowDataModel *liveInfo = self.liveInfos[self.liveSelectIndex + 1 + j];
                    NSString *playUrl = [self checkHttps:STRING(liveInfo.video_url)];
                    NSMutableDictionary *newParam = [NSMutableDictionary dictionary];
                    [newParam setObject:player forKey:@"player"];
                    [newParam setObject:playUrl forKey:@"playUrl"];
                    [newParam setObject:@(NO) forKey:PLAY_CLICK];
                    [newParam setObject:@(NO) forKey:PLAY_PREPARE];
                    [newParam setObject:STRING(liveInfo.cover_img_url) forKey:@"coverUrl"];
                    [self.playerList removeObject:oldParam];
                    [self.playerList addObject:newParam];
                }
            }
            if (i < self.cache_player / 2){
                int needMove = self.cache_player / 2 - i;
                for (int j = 0; j < needMove; j ++) {
                    NSMutableDictionary *oldParam = self.playerList[self.cache_player - 1 - j];
                    TXVodPlayer *player = [oldParam objectForKey:@"player"];
                    [player stopPlay];
                    [player removeVideoWidget];
                    ASVideoShowDataModel *liveInfo = self.liveInfos[self.liveSelectIndex - 1 - j];
                    NSString *playUrl = [self checkHttps:STRING(liveInfo.video_url)];
                    NSMutableDictionary *newParam = [NSMutableDictionary dictionary];
                    [newParam setObject:player forKey:@"player"];
                    [newParam setObject:playUrl forKey:@"playUrl"];
                    [newParam setObject:@(NO) forKey:PLAY_CLICK];
                    [newParam setObject:@(NO) forKey:PLAY_PREPARE];
                    [newParam setObject:STRING(liveInfo.cover_img_url) forKey:@"coverUrl"];
                    [self.playerList removeObject:oldParam];
                    [self.playerList insertObject:newParam atIndex:0];
                }
            }
            break;
        }
    }
    if (!findPlayer) {
        [self resetPlayer];
        NSMutableDictionary *playerParam = self.playerList[self.cache_player / 2];
        self.currentPlayer = playerParam[@"player"];
        [self.currentPlayer setupVideoWidget:self.currentCell.videoParentView insertIndex:0];
        [self.currentPlayer setRenderRotation:HOME_ORIENTATION_DOWN];
        [self startPlay:playerParam];
    }
    [self loadNextPlayer];
}

- (BOOL)startPlay:(NSMutableDictionary *)playerParam {
    NSString *playUrl = playerParam[@"playUrl"];
    if (![self checkPlayUrl:playUrl]) {
        return NO;
    }
    TXVodPlayer *voidPlayer = (TXVodPlayer *)playerParam[@"player"];
    if(voidPlayer != nil) {
        TXVodPlayConfig *cfg = voidPlayer.config;
        if (cfg == nil) {
            cfg = [[TXVodPlayConfig alloc] init];
        }
        cfg.cacheFolderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/txcache"];
        cfg.maxCacheItems = 30;
        voidPlayer.config = cfg;
        voidPlayer.vodDelegate = self;
        voidPlayer.isAutoPlay = NO;
        voidPlayer.enableHWAcceleration = YES;
        [voidPlayer setRenderRotation:HOME_ORIENTATION_DOWN];
        [voidPlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
        voidPlayer.loop = YES;
        [voidPlayer setMute:!self.isSilence];
        [playerParam setObject:@(YES) forKey:PLAY_CLICK];
        self.videoPause = NO;
        int result = [voidPlayer startVodPlay:playUrl];
        if (result != 0) {
            kShowToast(@"播放失败，退出页面");
            return NO;
        }
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    return YES;
}

- (void)resetPlayer {
    int liveIndexOffset = - self.cache_player / 2;
    for(NSMutableDictionary *playerParam in self.playerList){
        TXVodPlayer *player = playerParam[@"player"];
        [player stopPlay];
        [player removeVideoWidget];
        if (self.liveSelectIndex + liveIndexOffset >= 0 && self.liveSelectIndex + liveIndexOffset < self.liveInfos.count) {
            ASVideoShowDataModel *model = self.liveInfos[self.liveSelectIndex + liveIndexOffset];
            NSString *playUrl = [self checkHttps:STRING(model.video_url)];
            [playerParam setObject:playUrl forKey:@"playUrl"];
            [playerParam setObject:STRING(model.cover_img_url) forKey:@"coverUrl"];
            [playerParam setObject:@(NO) forKey:PLAY_CLICK];
            [playerParam setObject:@(NO) forKey:PLAY_PREPARE];
        }
        liveIndexOffset++;
    }
}

- (void)loadNextPlayer {
    int index = (int)[self.playerList indexOfObject:[self getPlayerParam:self.currentPlayer]];
    switch (_dragDirection) {
        case ASDragDirection_Down:
        {
            if (index < self.playerList.count - 1) {
                NSMutableDictionary *param = self.playerList[index + 1];
                if (![param[PLAY_CLICK] boolValue]) {
                    [self startPlay:param];
                }
            }
        }
            break;
        case ASDragDirection_Up:
        {
            if (index > 0) {
                NSMutableDictionary *param = self.playerList[index - 1];
                if (![param[PLAY_CLICK] boolValue]) {
                    [self startPlay:param];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)stopRtmp {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.popType != kVideoPlayMyListVideo) {
        [self.timerDisposable dispose];//关闭定时器
    }
    for (NSMutableDictionary *param in self.playerList) {
        TXVodPlayer *player = param[@"player"];
        player.vodDelegate = nil;
        [player stopPlay];
        [player removeVideoWidget];
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (NSString *)playUrl {
    ASVideoShowDataModel *model = self.liveInfos[self.liveSelectIndex];
    NSString *playUrl = [self checkHttps:STRING(model.video_url)];
    return playUrl;
}

- (NSMutableDictionary *)getPlayerParam:(TXVodPlayer *)player {
    for (NSMutableDictionary *param in self.playerList) {
        if ([[param objectForKey:@"player"] isEqual:player]) {
            return param;
        }
    }
    return nil;
}

- (NSString *)checkHttps:(NSString *)playUrl {
    if ([playUrl hasPrefix:@"http:"]) {
        playUrl = [playUrl stringByReplacingOccurrencesOfString:@"http:" withString:@"https:"];
    }
    return playUrl;
}

- (BOOL)checkPlayUrl:(NSString*)playUrl {
    if ([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) {
        if ([playUrl rangeOfString:@".flv"].length > 0) {
            
        } else if ([playUrl rangeOfString:@".m3u8"].length > 0){
            
        } else if ([playUrl rangeOfString:@".mp4"].length > 0){
            
        } else {
            kShowToast(@"播放地址不合法，点播目前仅支持flv,hls,mp4播放方式!");
            return NO;
        }
    } else {
        kShowToast(@"播放地址不合法，点播目前仅支持flv,hls,mp4播放方式!");
        return NO;
    }
    return YES;
}

- (void)onAudioSessionEvent:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        if (self.appIsInterrupt == NO) {
            if (!self.videoPause) {
                [self.currentPlayer pause];
            }
            self.appIsInterrupt = YES;
        }
    } else {
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            if (self.appIsInterrupt == YES) {
                if (!self.videoPause) {
                    if ([[ASCommonFunc currentVc] isKindOfClass:[ASVideoShowPlayController class]]) {
                        [self.currentPlayer resume];
                    }
                }
                self.appIsInterrupt = NO;
            }
        }
    }
}

- (void)onAppDidEnterBackGround:(UIApplication*)app {
    if (self.appIsInterrupt == NO) {
        if (!self.videoPause) {
            [self.currentPlayer pause];
        }
        self.appIsInterrupt = YES;
    }
}

- (void)onAppWillEnterForeground:(UIApplication*)app {
    if (self.appIsInterrupt == YES) {
        if (!self.videoPause) {
            if ([[ASCommonFunc currentVc] isKindOfClass:[ASVideoShowPlayController class]]) {
                [self.currentPlayer resume];
            }
        }
        self.appIsInterrupt = NO;
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    return self.liveInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuseIdentifier";
    ASVideoShowPlayCell *cell = (ASVideoShowPlayCell *)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[ASVideoShowPlayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.notifictionAcount = self.notifictionAcount;
    ASVideoShowDataModel *model = self.liveInfos[indexPath.row];
    cell.delegate = self;
    cell.popType = self.popType;
    cell.model = model;
    cell.isSilence = self.isSilence;
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginDragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint rect = scrollView.contentOffset;
    NSInteger index = rect.y / self.cellHeight;
    if (self.beginDragging && self.liveSelectIndex != index) {
        if (index > self.liveSelectIndex) {
            self.dragDirection = ASDragDirection_Down;
        } else {
            self.dragDirection = ASDragDirection_Up;
        }
        if (self.popType != kVideoPlayMyListVideo) {
            [self.timerDisposable dispose];//关闭定时器
            [self requestAddPlayNumWithModel:self.liveInfos[self.liveSelectIndex]];//请求上一个视频统计
        }
        self.liveSelectIndex = index;
        self.currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.liveSelectIndex inSection:0]];
        self.currentCell.maskView.silenceBtn.selected = self.isSilence;
        [self resumePlayer];
        self.beginDragging = NO;
        //如果用户有操作关注，关注数据进行更新
        if (self.followClikedList.count > 0) {
            ASVideoShowDataModel * model = self.liveInfos[self.liveSelectIndex];
            for (ASVideoShowDataModel *videoShowModel in self.followClikedList) {
                if ([videoShowModel.user_id isEqualToString:model.user_id]) {
                    self.currentCell.isFollow = videoShowModel.is_follow;
                }
            }
        }
    }
}

- (void)requestAddPlayNumWithModel:(ASVideoShowDataModel *)model {
    if (self.timers > 1) {
        [ASVideoShowRequest requestVideoShowAddPlayNumWithVideoID:model.ID
                                                      completeNum:self.completeNum
                                                         stopLong:self.timers
                                                          success:^(id  _Nullable data) {
            
        } errorBack:^(NSInteger code, NSString *msg) {
            
        }];
    }
}

#pragma mark SATCPlayDecorateDelegate
- (void)cellClickBackBtn {
    [self stopRtmp];
    [self.navigationController popViewControllerAnimated:YES];
}

//点击暂停
- (void)clickScreen:(UITapGestureRecognizer *)gestureRecognizer {
    [self clickPlayVod];
}

- (void)clickPlayVod {
    if (self.videoPause) {
        [self.currentPlayer resume];
        self.currentCell.maskView.playBtn.hidden = YES;
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    } else {
        [self.currentPlayer pause];
        self.currentCell.maskView.playBtn.hidden = NO;
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
    self.videoPause = !self.videoPause;
}

- (void)cellClickPublishBtn:(UIButton *)button {
    kWeakSelf(self);
    [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthPopVideoShow succeed:^{
        [ASVideoShowRequest requestVideoShowCheckDayAcountSuccess:^(id  _Nullable data) {
            [[ASUploadImageManager shared] selectVideoShowPickerWithViewController:wself didFinish:^(UIImage * _Nonnull coverImage, PHAsset * _Nonnull asset) {
                [ASVideoShowManager popPublishVideoShowWithAssets:asset];
            }];
        } errorBack:^(NSInteger code, NSString *msg) {
            
        }];
    }];
}

//声音开关
- (void)cellClickVoiceOnOffBtn:(UIButton *)button {
    self.isSilence = button.isSelected;
    [self.currentPlayer setMute:!self.isSilence];
}

//暂停
- (void)cellClickVoicePause {
    if (self.currentPlayer) {
        self.videoPause = YES;
        [self.currentPlayer pause];
        self.currentCell.maskView.playBtn.hidden = NO;
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
}

//是否关注
- (void)cellClickVoiceAttention:(BOOL)isAttention videoShowModel:(ASVideoShowDataModel *)model {
    if (self.followClikedList.count > 0) {
        for (int i = 0; i < self.followClikedList.count; i++) {
            ASVideoShowDataModel *videoShowModel = self.followClikedList[i];
            if ([videoShowModel.user_id isEqualToString:model.user_id]) {
                [self.followClikedList replaceObjectAtIndex:i withObject:model];
            } else {
                [self.followClikedList addObject:model];
            }
        }
    } else {
        [self.followClikedList addObject:model];
    }
}

#pragma mark TXVodPlayListener
- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary*)param {
    kWeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [player setMute:!self.isSilence];
        if (EvtID == PLAY_EVT_VOD_PLAY_PREPARED) {
            NSMutableDictionary *playerParam = [wself getPlayerParam:player];
            [playerParam setObject:@(YES) forKey:PLAY_PREPARE];
            if ([wself.currentPlayer isEqual:player]){
                if ([[ASCommonFunc currentVc] isKindOfClass:[ASVideoShowPlayController class]]) {
                    [player resume];
                }
            }
        }
        if (![wself.currentPlayer isEqual:player]) {
            return;
        }
        if (EvtID == PLAY_EVT_VOD_PLAY_PREPARED) {
            if ([[ASCommonFunc currentVc] isKindOfClass:[ASVideoShowPlayController class]]) {
                [wself.currentPlayer resume];
                wself.currentCell.maskView.playBtn.hidden = YES;
            }
        } else if (EvtID == PLAY_EVT_PLAY_BEGIN) {
            
        } else if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME) {
            if ([[ASCommonFunc currentVc] isKindOfClass:[ASVideoShowPlayController class]]) {
                [wself.currentPlayer resume];
                wself.currentCell.maskView.playBtn.hidden = YES;
            }
            if (wself.popType != kVideoPlayMyListVideo) {
                wself.completeNum = @"0";
                wself.timerDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
                    wself.timers++;
                }];
            }
            
        } else if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
            
        } else if (EvtID == PLAY_ERR_NET_DISCONNECT || EvtID == PLAY_EVT_PLAY_END) {
            [wself.currentPlayer pause];
            wself.videoPause  = NO;
            wself.currentCell.maskView.playBtn.hidden = NO;
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        } else if (EvtID == PLAY_EVT_PLAY_LOADING) {
            
        } else if (EvtID == VOD_PLAY_EVT_LOOP_ONCE_COMPLETE) {//播放一轮结束
            if (wself.popType != kVideoPlayMyListVideo) {
                wself.completeNum = @"1";
            }
        }
    });
}

//网络状态通知
- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary*)param {
    
}

- (void)report:(int)EvtID {
    if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME) {
        kShowToast(@"视频播放成功");
    } else if(EvtID == PLAY_ERR_NET_DISCONNECT) {
        kShowToast(@"网络断连,且经多次重连抢救无效,可以放弃治疗,更多重试请自行重启播放");
    } else if(EvtID == PLAY_ERR_GET_RTMP_ACC_URL_FAIL) {
        kShowToast(@"获取加速拉流地址失败");
    } else if(EvtID == PLAY_ERR_FILE_NOT_FOUND) {
        kShowToast(@"播放文件不存在");
    } else if(EvtID == PLAY_ERR_HEVC_DECODE_FAIL) {
        kShowToast(@"H265解码失败");
    } else if(EvtID == PLAY_ERR_HLS_KEY) {
        kShowToast(@"HLS解码key获取失败");
    } else if(EvtID == PLAY_ERR_GET_PLAYINFO_FAIL) {
        kShowToast(@"获取点播文件信息失败");
    }
}

#pragma mark - lazy
- (NSMutableArray *)playerList {
    if (!_playerList) {
        _playerList = [[NSMutableArray alloc]init];
    }
    return _playerList;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.cellHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pagingEnabled = YES;
        _tableView.backgroundColor = UIColor.blackColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.allowsMultipleSelection = YES;
        _tableView.allowsSelectionDuringEditing = YES;
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

- (NSMutableArray *)followClikedList {
    if (!_followClikedList) {
        _followClikedList = [[NSMutableArray alloc]init];
    }
    return _followClikedList;
}
@end
