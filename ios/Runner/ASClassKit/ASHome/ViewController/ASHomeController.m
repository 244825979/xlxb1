//
//  ASHomeController.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASHomeController.h"
#import <JXCategoryView/JXCategoryView.h>
#import <JXPagerView.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "ASHomeTopView.h"
#import "ASHomeUserListController.h"
#import "ASSearchUserController.h"
#import "ASFirstPayDataModel.h"
#import "ASHomeRequest.h"
#import "ASIMRequest.h"
#import "ASIntimateListModel.h"
#import "ASUsersHiddenDataModel.h"
#import "ASFillInUserDataView.h"
#import "ASHomeIMMessageCell.h"
#import "ASDynamicRequest.h"
#import "ASEditDataController.h"
#import "Runner-Swift.h"
#import "ASVipDetailsController.h"
#import "UIView+Dragable.h"
#import "NEChatUIKit/NEChatUIKit-Swift.h"
#import "ASMineRequest.h"
#import "ASMineUserModel.h"
#import "ASHomeOnlineListController.h"

@interface ASHomeController ()<JXPagerViewDelegate, JXCategoryViewDelegate, SDCycleScrollViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) ASHomeTopView *topView;
@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, strong) UIView *firstPayView;//首充提醒悬浮
@property (nonatomic, strong) SDCycleScrollView *IMRemindView;//IM消息提醒悬浮
@property (nonatomic, strong) UIImageView *dayYuanfen;//今日缘分悬浮
@property (nonatomic, strong) ASFillInUserDataView *fillInUserDataView;//补充资料悬浮窗
/**数据**/
@property (nonatomic, strong) NSArray *titles;//标题
@property (nonatomic, strong) NSArray *dynamicList;//动态预加载数据
@property (nonatomic, assign) NSInteger selectedIndex;//当前页面tabbar索引
@property (nonatomic, assign) BOOL isShowSupplementView;//是否显示去完成任务悬浮窗，默认为NO
@property (nonatomic, strong) NSArray *messageRemindList;//未读IM消息用户数据
@property (nonatomic, assign) CGFloat topViewHeight;//顶部的高度，会更新高度
/**控制器**/
@property (nonatomic, strong) ASHomeUserListController *recommendVc;//用户列表推荐
@property (nonatomic, strong) ASHomeOnlineListController *onLineVc;//用户在线
@property (nonatomic, strong) ASHomeUserListController *callListVc;//视频列表
@end

@implementation ASHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    self.view.backgroundColor = BACKGROUNDCOLOR;
    if (USER_INFO.gender == 2) {
        self.titles = @[@"推荐", @"在线", @"新人"];
    } else {
        self.titles = @[@"推荐", @"在线"];
    }
    self.selectedIndex = 0;
    self.topViewHeight = SCALES(108);
    self.isShowSupplementView = NO;
    self.dynamicList = @[];
    [self createUI];
    [self setData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([ASPopViewManager shared].popGoodAnchorState == 2 || [ASPopViewManager shared].popGoodAnchorState == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goodAnchorConfigNotification" object:nil];
    }
    [self requestIsAuth];
    [self requestUsersHiddenList];
    [self requestRecommendStatus];
}

- (void)setData {
    //预加载动态数据
    [self requestDynamicList];
    //首页首充提示
    [self requestFirstPopView];
    //获取首页info数据
    [self requestHomeInfo];
    //获取banner及猜你喜欢数据
    [self requestBanner];
    //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    kWeakSelf(self);
    self.pagingView.mainTableView.mj_header = [ASRefreshHeader headerWithRefreshingBlock:^{
        [wself requestBanner];
        switch (wself.selectedIndex) {
            case 0:
                [wself.recommendVc onRefresh];
                break;
            case 1:
                [wself.onLineVc onRefresh];
                break;
            case 2:
                [wself.callListVc onRefresh];
                break;
            default:
                break;
        }
    }];
    //预加载列表数据，发送动态列表获取首页数据，做一个预加载
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"dynamicListHomeNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
        dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
            //收到动态页加载了的通知，可以把预加载数据给动态页进行预加载
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dynamicListRefreshNotification" object:@{@"list" : self.dynamicList}];
        });
    }];
    //获取亲密度值，保存到本地
    [self requestIntimateList];
    //充值成功，不再显示首充悬浮
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"updateBalanceNotification" object:nil]
     subscribeNext:^(NSNotification * _Nullable notifiction) {
        wself.firstPayView.hidden = YES;
    }];
    //首页进行弹窗
    [[ASPopViewManager shared] homePopViewWithVc:self complete:^{
        [wself requestRecommendStatus];
    }];
    //腾讯短视频鉴权
    [self TXLiteAVSDKInit];
    //我的页面数据
    [self requestMineData];
}

- (void)createUI {
    UIImageView *topBg = [[UIImageView alloc]init];
    topBg.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(176) + STATUS_BAR_HEIGHT);
    topBg.image = [UIImage imageNamed:@"home_top"];
    topBg.contentMode = UIViewContentModeScaleAspectFill;
    topBg.userInteractionEnabled = YES;
    [self.view addSubview:topBg];
    self.pagingView = [[JXPagerView alloc] initWithDelegate:self];
    self.pagingView.mainTableView.backgroundColor = UIColor.clearColor;
    self.pagingView.listContainerView.backgroundColor = UIColor.clearColor;
    self.pagingView.automaticallyDisplayListVerticalScrollIndicator = NO;
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
    [self.view addSubview:self.pagingView];
    kWeakSelf(self);
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(SCREEN_WIDTH - SCALES(38) - SCALES(8), 0, SCALES(38), SCALES(38));
    [[searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ASSearchUserController *vc = [[ASSearchUserController alloc] init];
        [wself.navigationController pushViewController:vc animated:YES];
    }];
    [searchBtn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [self.categoryView addSubview:searchBtn];
    self.IMRemindView = ({
        SDCycleScrollView *view = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        view.backgroundColor = UIColor.clearColor;
        view.scrollDirection = UICollectionViewScrollDirectionVertical;
        view.showPageControl = NO;
        view.hidden = YES;
        view.autoScrollTimeInterval = 5.0;
        [view disableScrollGesture];
        view;
    });
    [self.view addSubview:self.IMRemindView];
    [self.IMRemindView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(SCALES(-50));
        make.width.mas_equalTo(SCALES(118));
        make.height.mas_equalTo(SCALES(38));
    }];
    if (USER_INFO.gender != 1) {
        [self.view addSubview:self.dayYuanfen];
        [self.dayYuanfen mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(SCALES(-10));
            make.bottom.equalTo(self.view).offset(SCALES(-114));
            make.size.mas_equalTo(CGSizeMake(SCALES(88), SCALES(82)));
        }];
    }
    [self.view addSubview:self.firstPayView];
    [self.firstPayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(SCALES(-16));
        make.bottom.equalTo(self.view).offset(SCALES(-206));
        make.width.mas_equalTo(SCALES(75));
        make.height.mas_equalTo(SCALES(75));
    }];
    [self.view addSubview:self.topBtn];
    [self.topBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(SCALES(-6));
        make.bottom.equalTo(self.view).offset(SCALES(-291));
        make.width.height.mas_equalTo(SCALES(70));
    }];
    [self.view addSubview:self.fillInUserDataView];
    [self.fillInUserDataView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.height.mas_equalTo(SCALES(36));
    }];
    //延迟执行获取未读消息数据
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        [[ASIMManager shared] updateUnreadCount];
        [wself IMMessageRemindView];
    });
    //根据新增会话或者来消息、首页消息提示悬浮窗状态更新
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"homeMessageRemindUpdate" object:nil]
     subscribeNext:^(NSNotification * _Nullable notifiction) {
        [wself IMMessageRemindView];
    }];
    //更新隐身用户数据
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"uploadUsersHidenListNotify" object:nil]
     subscribeNext:^(NSNotification * _Nullable notifiction) {
        [wself requestUsersHiddenList];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagingView.frame = CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT);
}

//腾讯云视频鉴权
- (void)TXLiteAVSDKInit {
    [TXUGCBase setLicenceURL:TX_VideoShowLicence
                         key:TX_VideoShowKey];
#if DEBUG
    [TXLiveBase setConsoleEnabled:NO];
    [TXLiveBase setLogLevel:LOGLEVEL_DEBUG];
#else
    
#endif
}

- (void)requestDynamicList {
    kWeakSelf(self);
    [ASDynamicRequest requestDynamicListWithPage:1 type:1 success:^(id  _Nullable data) {
        NSArray *array = data;
        if (array > 0) {
            wself.dynamicList = array;
        }
    } errorBack:^(NSInteger code, NSString *msg) {
    }];
}

- (void)requestFirstPopView {
    kWeakSelf(self);
    [ASHomeRequest requestFirstPayData:NO success:^(id  _Nullable data) {
        ASFirstPayDataModel *model = data;
        wself.firstPayView.hidden = model.is_show == 1 ? NO : YES;
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)requestIsAuth {
    [ASCommonRequest requestAuthStateWithIsRequest:YES success:^(id  _Nullable data) {
    } errorBack:^(NSInteger code, NSString *msg) {
    }];
}

- (void)requestMineData {
    //获取个人主页数据
    [ASMineRequest requestMineHomeSuccess:^(id _Nullable data) {
        ASMineUserModel *model = data;
        //男用户头像是否完成引导用户
        USER_INFO.is_avatar_task_finish = model.is_avatar_task_finish;
        USER_INFO.avatar_task_reward_coin = model.avatar_task_reward_coin;
    } errorBack:^(NSInteger code, NSString *msg) {
    }];
}

- (void)requestRecommendStatus {
    kWeakSelf(self);
    [ASCommonRequest requestRecommendStatusdSuccess:^(id  _Nullable data) {
        NSNumber *isPop = data[@"isPop"];
        wself.dayYuanfen.hidden = isPop.integerValue == 1 ? NO : YES;
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

//进入首页请求，人脸核验比对提示
- (void)requestIndexConfig {
    [ASCommonRequest requestIndexConfigWithSuccess:^(id  _Nullable data) {
        NSNumber *isFaceCheck = data;
        if (isFaceCheck.integerValue == 1) {
            [ASAlertViewManager popFaceVerificationView];
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

//预获取亲密度列表
- (void)requestIntimateList {
    [ASIMRequest requestIntimateListWithIds:@"" success:^(id  _Nullable data) {
        NSArray *list = [ASIntimateListModel mj_objectArrayWithKeyValuesArray:data];
        for (ASIntimateListModel *model in list) {
            NSDictionary *valueDict = @{@"user_id": STRING(model.user_id),
                                        @"grade": @(model.grade),
                                        @"score": STRING(model.score)};
            NSString *key = [NSString stringWithFormat:@"%@_intimate_%@",USER_INFO.user_id, STRING(model.user_id)];
            [ASUserDefaults setValue:valueDict forKey:key];
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

//获取所有设置的隐身数据
- (void)requestUsersHiddenList {
    [ASIMRequest requestUsersHiddenWithSuccess:^(ASUsersHiddenDataModel *_Nullable data) {
        [ASUserDataManager shared].usesHiddenListModel = data;
        NSMutableArray *meUsersID = [NSMutableArray array];
        NSMutableArray *toUsersID = [NSMutableArray array];
        for (ASUserHiddenListModel *model in data.hidden_me_user) {
            if (!kStringIsEmpty(model.user_id)) {
                [meUsersID addObject:model.user_id];
            }
        }
        for (ASUserHiddenListModel *model in data.hidden_to_user) {
            if (!kStringIsEmpty(model.user_id)) {
                [toUsersID addObject:model.user_id];
            }
        }
        [ASUserDataManager shared].usesHiddenListModel.hiddenMeUsersID = meUsersID;
        [ASUserDataManager shared].usesHiddenListModel.hiddenToUserID = toUsersID;
        [ASIMDataConfig hiddenMeUserListDataWithUsers:meUsersID];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)requestHomeInfo {
    kWeakSelf(self);
    [ASHomeRequest requestHomeIndexInfoSuccess:^(id  _Nullable data) {
        NSNumber *isShow = data;
        wself.isShowSupplementView = isShow.boolValue;
        wself.fillInUserDataView.hidden = wself.isShowSupplementView;
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)requestBanner {
    kWeakSelf(self);
    self.topViewHeight = SCALES(108);
    [ASMineRequest requestBannerWithType:@"7" success:^(NSArray * _Nullable banner) {
        wself.topView.banners = banner;
        if (banner.count > 0) {
            wself.topViewHeight += SCALES(70);
        }
        //banner数据获取后再获取猜你喜欢的数据来更新UI
        [wself requestYouLikeWithHUD:NO];
    } errorBack:^(NSInteger code, NSString *msg) {
        //banner数据获取后再获取猜你喜欢的数据来更新UI
        [wself requestYouLikeWithHUD:NO];
    }];
}

- (void)requestYouLikeWithHUD:(BOOL)HUD {
    kWeakSelf(self);
    if (USER_INFO.systemIndexModel.you_like_switch_home == 0) {
        self.topViewHeight = self.topView.banners.count > 0 ? SCALES(178) : SCALES(108);
        self.topView.likes = @[];
        [self.pagingView resizeTableHeaderViewHeightWithAnimatable:YES duration:0.2 curve:UIViewAnimationCurveEaseInOut];
        return;
    }
    [ASHomeRequest requestLikeUserWithType:@"home" HUD:HUD success:^(id  _Nonnull response) {
        NSArray *list = response;
        wself.topView.likes = list;
        if (list.count > 0) {
            wself.topViewHeight = wself.topView.banners.count > 0 ? SCALES(178) + SCALES(186) : SCALES(108)+SCALES(186);
        } else {
            wself.topViewHeight = wself.topView.banners.count > 0 ? SCALES(178) : SCALES(108);
        }
        //刷新一下UI
        [wself.pagingView resizeTableHeaderViewHeightWithAnimatable:YES duration:0.2 curve:UIViewAnimationCurveEaseInOut];
    } errorBack:^(NSInteger code, NSString * _Nonnull message) {
        wself.topView.likes = @[];
        [wself.pagingView resizeTableHeaderViewHeightWithAnimatable:YES duration:0.2 curve:UIViewAnimationCurveEaseInOut];
    }];
}

//获取IM未读消息用户
- (void)IMMessageRemindView {
    NSInteger unreadCount = [[ASIMManager shared] conversationCount];
    if (unreadCount > 0) {
        NSArray *recentSessions = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
        if (recentSessions.count > 0) {
            NSMutableArray *unreadSessions = [NSMutableArray array];
            NSMutableArray *URLStrings = [NSMutableArray array];
            for (NIMRecentSession *recentSession in recentSessions) {
                NSDictionary *localExt = recentSession.localExt;
                NSString *conversationType = localExt[@"conversation_type"];
                if ([conversationType isEqualToString:@"1"] ||
                    [conversationType isEqualToString:@"2"] ||
                    [recentSession.session.sessionId isEqualToString:NEKitChatConfig.shared.xitongxiaoxi_id] ||
                    [recentSession.session.sessionId isEqualToString:NEKitChatConfig.shared.huodongxiaozushou_id]) {
                    continue;
                }
                if (recentSession.unreadCount > 0) {
                    [unreadSessions addObject:recentSession];
                    [URLStrings addObject:@"1"];//保证有数据与用户未读消息数据量一致即可，仅仅为了刷新消息窗
                }
            }
            if (unreadSessions.count > 0) {
                self.messageRemindList = unreadSessions;
                self.IMRemindView.imageURLStringsGroup = URLStrings;
                self.IMRemindView.hidden = NO;
            }
        }
    } else {
        self.IMRemindView.hidden = YES;
    }
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.selectedIndex = index;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    self.selectedIndex = index;
}

#pragma mark - JXPagingViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.topView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.topViewHeight;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titles.count;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return SCALES(38);
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    kWeakSelf(self);
    if (index == 1) {
        ASHomeOnlineListController *vc = [[ASHomeOnlineListController alloc] init];
        vc.scrollOffsetBolck = ^(BOOL isShow) {
            wself.topBtn.hidden = !isShow;
        };
        vc.onRefreshBack = ^{
            [wself.pagingView.mainTableView.mj_header endRefreshing];
        };
        self.onLineVc = vc;
        return vc;
    } else {
        ASHomeUserListController *vc = [[ASHomeUserListController alloc] init];
        vc.type = index;
        vc.scrollOffsetBolck = ^(BOOL isShowTopBtn) {
            wself.topBtn.hidden = !isShowTopBtn;
        };
        vc.onRefreshBack = ^{
            [wself.pagingView.mainTableView.mj_header endRefreshing];
        };
        switch (index) {
            case 0:
                self.recommendVc = vc;
                break;
            case 2:
                self.callListVc = vc;
                break;
            default:
                break;
        }
        return vc;
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
    if (view != self.IMRemindView) {
        return nil;
    }
    return [ASHomeIMMessageCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
    ASHomeIMMessageCell *myCell = (ASHomeIMMessageCell *)cell;
    NIMRecentSession *session = self.messageRemindList[index];
    myCell.session = session;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NIMRecentSession *session = self.messageRemindList[index];
    [ASMyAppCommonFunc chatWithUserID:session.lastMessage.from nickName:session.lastMessage.senderName action:^(id  _Nonnull data) {

    }];
}

- (ASHomeTopView *)topView {
    if (!_topView) {
        _topView = [[ASHomeTopView alloc]init];
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(294));
        _topView.backgroundColor = UIColor.clearColor;
        kWeakSelf(self);
        _topView.indexBlock = ^(NSInteger index) {
            switch (index) {
                case 0://会员
                {
                    ASVipDetailsController *vc = [[ASVipDetailsController alloc] init];
                    [wself.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1://每日任务
                {
                    ASBaseWebViewController *h5Vc = [[ASBaseWebViewController alloc]init];
                    h5Vc.webUrl = USER_INFO.configModel.webUrl.taskCenter;
                    [wself.navigationController pushViewController:h5Vc animated:YES];
                }
                    break;
                case 2://邀请好友
                {
                    ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                    vc.webUrl = USER_INFO.configModel.webUrl.share;
                    [wself.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3://在线客服
                {
                    ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                    vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Customer];
                    [wself.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
        };
        _topView.actionBlock = ^{
            [wself requestYouLikeWithHUD:YES];
        };
    }
    return _topView;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 64, SCALES(38))];
        _categoryView.backgroundColor = UIColor.clearColor;
        _categoryView.delegate = self;
        _categoryView.titleColor = TEXT_SIMPLE_COLOR;
        _categoryView.titleSelectedColor = TITLE_COLOR;
        _categoryView.titleFont = TEXT_FONT_16;
        _categoryView.titleSelectedFont = TEXT_MEDIUM(20);
        _categoryView.titles = self.titles;
        _categoryView.contentEdgeInsetLeft = SCALES(18);
        _categoryView.cellSpacing = SCALES(24);
        _categoryView.averageCellSpacingEnabled = NO;
        JXCategoryIndicatorImageView *indicatorImageView = [[JXCategoryIndicatorImageView alloc] init];
        indicatorImageView.verticalMargin = 0;
        indicatorImageView.indicatorImageView.image = [UIImage imageNamed:@"bottom_icon"];
        indicatorImageView.indicatorImageViewSize = CGSizeMake(SCALES(24), SCALES(8));
        _categoryView.indicators = @[indicatorImageView];
    }
    return _categoryView;
}

- (UIButton *)topBtn {
    if (!_topBtn) {
        _topBtn = [[UIButton alloc]init];
        [_topBtn setBackgroundImage:[UIImage imageNamed:@"up_top"] forState:UIControlStateNormal];
        _topBtn.adjustsImageWhenHighlighted = NO;
        _topBtn.hidden = YES;
        kWeakSelf(self);
        [[_topBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            switch (wself.selectedIndex) {
                case 0:
                {
                    [wself.recommendVc.collectionView setContentOffset:CGPointZero animated:YES];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
                        [wself.recommendVc onRefresh];
                    });
                }
                    break;
                case 1:
                {
                    [wself.onLineVc.tableView setContentOffset:CGPointZero animated:YES];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
                        [wself.onLineVc onRefresh];
                    });
                }
                    break;
                case 2:
                {
                    [wself.callListVc.collectionView setContentOffset:CGPointZero animated:YES];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
                        [wself.callListVc onRefresh];
                    });
                }
                    break;
                default:
                    break;
            }
        }];
    }
    return _topBtn;
}

- (UIView *)firstPayView {
    if (!_firstPayView) {
        _firstPayView = [[UIView alloc]init];
        _firstPayView.hidden = YES;
        kWeakSelf(self);
        UIButton *payBtn = [[UIButton alloc] init];
        [payBtn setBackgroundImage:[UIImage imageNamed:@"first_pay"] forState:UIControlStateNormal];
        payBtn.adjustsImageWhenHighlighted = NO;
        [[payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASMyAppCommonFunc behaviorStatisticsWithType:Behavior_home_first_pay];//统计
            [[ASPopViewManager shared] firstPayViewPop];
        }];
        [_firstPayView addSubview:payBtn];
        [payBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_firstPayView);
            make.width.height.mas_equalTo(SCALES(75));
        }];
        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        closeBtn.adjustsImageWhenHighlighted = NO;
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            wself.firstPayView.hidden = YES;
        }];
        [_firstPayView addSubview:closeBtn];
        [closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(_firstPayView);
            make.width.height.mas_equalTo(SCALES(14));
        }];
        [_firstPayView addDragableActionWithEnd:^(CGRect endFrame) {
            
        }];
    }
    return _firstPayView;
}

- (UIImageView *)dayYuanfen {
    if (!_dayYuanfen) {
        _dayYuanfen = [[UIImageView alloc]init];
        _dayYuanfen.image = [UIImage imageNamed:@"home_yuanfen"];
        _dayYuanfen.userInteractionEnabled = YES;
        [_dayYuanfen addDragableActionWithEnd:^(CGRect endFrame) {
            
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_dayYuanfen addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            [[ASPopViewManager shared] requestRecommendUserWithVc:wself complete:^{
                [wself requestRecommendStatus];
            }];
        }];
    }
    return _dayYuanfen;
}

- (ASFillInUserDataView *)fillInUserDataView {
    if (!_fillInUserDataView) {
        _fillInUserDataView = [[ASFillInUserDataView alloc]init];
        _fillInUserDataView.hidden = YES;
        _fillInUserDataView.layer.masksToBounds = YES;
        _fillInUserDataView.layer.cornerRadius = SCALES(8);
        kWeakSelf(self);
        _fillInUserDataView.clikedBlock = ^{
            ASEditDataController *vc = [[ASEditDataController alloc] init];
            vc.refreshBolck = ^{
                [wself requestHomeInfo];
            };
            [wself.navigationController pushViewController:vc animated:YES];
        };
    }
    return _fillInUserDataView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
