//
//  ASPersonalController.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASPersonalController.h"
#import "ASBaseNavigationView.h"
#import <JXCategoryView/JXCategoryView.h>
#import <JXPagerView.h>
#import "ASPersonalTopView.h"
#import "ASPersonalUserController.h"
#import "ASPersonalRequest.h"
#import "ASPersonalBottomView.h"
#import "ASPersonalVideoShowController.h"
#import "ASPersonalDynamicListController.h"
#import "ASReportController.h"
#import "ASSetRequest.h"
#import "ASEditDataController.h"
#import "ASPersonalCallVideoShowController.h"

@interface ASPersonalController ()<JXPagerViewDelegate, JXCategoryViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) ASBaseNavigationView *navigationView;
@property (nonatomic, strong) ASPersonalTopView *topView;
@property (nonatomic, strong) ASPersonalBottomView *bottomView;
/**数据**/
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) ASUserInfoModel *homeModel;
@property (nonatomic, strong) ASPersonalUserController *userVc;
@property (nonatomic, assign) BOOL isPopCallVideo;//是否已经弹出视频电话
@property (nonatomic, strong) RACDisposable *callVideoDisposable;//10秒倒计时视频来电
@property (nonatomic, assign) int callVideoTimers;//视频来电计时时间
@property (nonatomic, strong) RACDisposable *chatPopDisposable;//3秒倒计时聊天提醒
@property (nonatomic, assign) int chatPopTimers;//计时时间
@property (nonatomic, strong) ASAlbumsModel *videoShowModel;//视频秀数据
@property (nonatomic, assign) BOOL isLeavePlayer;//离开当前页面是否在播放状态
@end

@implementation ASPersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[];
    self.shouldNavigationBarHidden = YES;
    self.callVideoTimers = 10;//10秒倒计时视频来电
    self.chatPopTimers = 3;//3秒倒计时聊天提醒
    [self createUI];
    [self requestData];
    //监听程序进入前台和后台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackGround:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForeGround:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.callVideoDisposable dispose];
    [self.chatPopDisposable dispose];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.topView.currentPlayer != nil && self.topView.currentPlayer.isPlaying == YES) {
        self.isLeavePlayer = YES;
        [self.topView.currentPlayer pause];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
}

//播放
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.topView.currentPlayer != nil && self.isLeavePlayer == YES && self.topView.currentPlayer.isPlaying == NO) {
        [self.topView.currentPlayer resume];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}

- (void)enterBackGround:(NSNotificationCenter *)notification {
    //程序进入了后台
    if (self.topView.currentPlayer != nil) {
        [self.topView.currentPlayer pause];
    }
}
- (void)enterForeGround:(NSNotificationCenter *)notification {
    //程序进入了前台
    if (self.topView.currentPlayer != nil) {
        [self.topView.currentPlayer resume];
    }
}

- (void)createUI {
    kWeakSelf(self);
    self.pagingView = [[JXPagerView alloc] initWithDelegate:self];
    self.pagingView.mainTableView.backgroundColor = UIColor.clearColor;
    self.pagingView.listContainerView.backgroundColor = UIColor.clearColor;
    self.pagingView.automaticallyDisplayListVerticalScrollIndicator = NO;
    self.pagingView.mainTableView.bounces = NO;
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
    [self.view addSubview:self.pagingView];
    self.navigationView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_NAVBAR);
    [self.view addSubview:self.navigationView];
    self.navigationView.clikedBlock = ^(UIButton * _Nonnull button, NSString * _Nonnull type) {
        if ([type isEqualToString:@"返回"]) {
            [wself.navigationController popViewControllerAnimated:YES];
            return;
        }
        if ([type isEqualToString:@"铃音"]){
            button.selected = !button.isSelected;
            if (button.isSelected == NO) {
                [wself.topView.currentPlayer setMute:YES];
            } else {
                [wself.topView.currentPlayer setMute:NO];
            }
            return;
        }
        if ([type isEqualToString:@"更多"]) {
            [ASAlertViewManager bottomPopTitles:(![USER_INFO.user_id isEqualToString:wself.userID] ? @[@"修改备注", @"举报", wself.homeModel.is_black == YES ? @"取消拉黑" : @"拉黑"] : @[@"编辑资料"])
                                    indexAction:^(NSString *indexName) {
                if ([indexName isEqualToString:@"修改备注"]) {
                    [ASAlertViewManager popTextFieldWithTitle:@"设置备注名"
                                                      content:kStringIsEmpty(wself.homeModel.user_remark) ? wself.homeModel.nickname : wself.homeModel.user_remark
                                                  placeholder:@"请输入备注名..."
                                                       length:10
                                                   affirmText:@"确认"
                                                       remark:@""
                                                     isNumber:NO
                                                      isEmpty:YES
                                                 affirmAction:^(NSString * _Nonnull text) {
                        [ASSetRequest requestChangeUserRemarkWithName:text userID:wself.homeModel.userid success:^(id  _Nullable data) {
                            wself.topView.userRemarkStr = text;
                            wself.homeModel.user_remark = text;
                        } errorBack:^(NSInteger code, NSString *msg) {
                            
                        }];
                    } cancelAction:^{
                        
                    }];
                    return;
                }
                if ([indexName isEqualToString:@"举报"]) {
                    ASReportController *vc = [[ASReportController alloc] init];
                    vc.type = kReportTypePersonalHome;
                    vc.uid = wself.userID;
                    ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
                    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    [wself presentViewController:nav animated:YES completion:nil];
                    return;
                }
                if ([indexName isEqualToString:@"取消拉黑"]) {
                    [wself requestBlack];
                    return;
                }
                if ([indexName isEqualToString:@"拉黑"]) {
                    [ASAlertViewManager defaultPopTitle:@"提示" content:@"拉黑后，你将不再收到对方消息，并且你们互相看不到对方的动态更新。可以在”系统设置-黑名单”中解除" left:@"确定" right:@"取消" isTouched:YES affirmAction:^{
                        [wself requestBlack];
                    } cancelAction:^{
                        
                    }];
                    return;
                }
                if ([indexName isEqualToString:@"编辑资料"]) {
                    ASEditDataController *vc = [[ASEditDataController alloc]init];
                    [wself.navigationController pushViewController:vc animated:YES];
                    return;
                }
            } cancelAction:^{
                
            }];
            return;
        }
    };
    [self.view addSubview:self.bottomView];
    self.bottomView.userID = self.userID;
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pagingView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(TAB_BAR_MAGIN20 + SCALES(16) + SCALES(48));
    }];
    self.bottomView.nameBlock = ^(NSString * _Nonnull btnName) {
        if ([btnName isEqualToString:@"已关注"]) {
            if (wself.attentionBlock) {
                wself.attentionBlock(YES);
            }
            return;
        }
        if ([btnName isEqualToString:@"取消关注"]) {
            if (wself.attentionBlock) {
                wself.attentionBlock(NO);
            }
            return;
        }
        if ([btnName isEqualToString:@"打招呼"]) {
            if (wself.beckonBlock) {
                wself.beckonBlock();
            }
            return;
        }
        if ([btnName isEqualToString:@"编辑资料"]) {
            ASEditDataController *vc = [[ASEditDataController alloc]init];
            [wself.navigationController pushViewController:vc animated:YES];
            return;
        }
    };
    ///判断是否弹出视频通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"personalPopVideoPushNotification" object:nil] subscribeNext:^(NSNotification * _Nullable object) {
        if ([USER_INFO.user_id isEqualToString:wself.userID]) {
            return;
        }
        if (wself.homeModel.gender == USER_INFO.gender) {
            return;
        }
        if (wself.homeModel.is_video_show == 0) {
            return;
        }
        NSString *state = object.object;
        if (state.integerValue == 0) {
            wself.callVideoTimers = 10;
            [wself.callVideoDisposable dispose];
            return;
        } else {
            if (wself.isPopCallVideo == NO) {
                [wself popCallVideoController];
            }
        }
    }];
}

- (void)popCallVideoController {
    if (kObjectIsEmpty(self.videoShowModel)) {
        return;
    }
    kWeakSelf(self);
    self.callVideoDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        wself.callVideoTimers--;
        if (wself.callVideoTimers == 0) {
            wself.isPopCallVideo = YES;
            ASVideoShowDataModel *videoShowModel = [[ASVideoShowDataModel alloc] init];
            videoShowModel.video_url = wself.videoShowModel.video_url;
            videoShowModel.cover_img_url = wself.videoShowModel.cover_img_url;
            ASPersonalCallVideoShowController *vc = [[ASPersonalCallVideoShowController alloc] init];
            vc.userModel = wself.homeModel;
            if (!kObjectIsEmpty(wself.videoShowModel)) {
                vc.videoShowModel = videoShowModel;
            }
            ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [wself presentViewController:nav animated:YES completion:nil];
            [wself.callVideoDisposable dispose];
        }
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.pagingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
    }];
}

- (void)requestData {
    kWeakSelf(self);
    [ASPersonalRequest requestPersonalDataWithUserID:self.userID success:^(id  _Nullable data) {
        wself.homeModel = data;
        wself.topView.homeModel = wself.homeModel;
        wself.userVc.homeModel = wself.homeModel;
        if (wself.homeModel.gender == USER_INFO.gender) {
            if (![wself.userID isEqualToString:USER_INFO.user_id]) {
                wself.bottomView.hidden = YES;
                [wself.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(wself.pagingView.mas_bottom);
                    make.left.right.bottom.equalTo(wself.view);
                    make.height.mas_equalTo(0);
                }];
            } else {
                wself.bottomView.hidden = NO;
            }
        } else {
            wself.bottomView.model = wself.homeModel;
            wself.bottomView.hidden = NO;
        }
        if ([USER_INFO.user_id isEqualToString:wself.userID]) {
            wself.titles = wself.homeModel.gender == 2 ? @[@"资料", @"动态"] : @[@"资料", @"视频秀", @"动态"];
        } else {
            wself.titles = wself.homeModel.gender == 2 ? @[@"Ta的资料", @"Ta的动态"] : @[@"Ta的资料", @"Ta的视频秀", @"Ta的动态"];
        }
        wself.categoryView.titles = wself.titles;
        [wself.categoryView reloadDataWithoutListContainer];
        if (wself.homeModel.gender == 1) {//女用户，否有视频秀
            wself.navigationView.silenceBtn.hidden = YES;
            for (int i = 0; i < wself.homeModel.albums.count; i++) {
                ASAlbumsModel *model = wself.homeModel.albums[i];
                if (model.is_video_show == 1) {
                    wself.videoShowModel = model;
                    wself.navigationView.silenceBtn.hidden = NO;
                    break;
                }
            }
        }
        if (kAppType == 0) {
            if (wself.homeModel.gender == USER_INFO.gender) {
                return;
            }
            if ([USER_INFO.user_id isEqualToString:wself.userID]) {
                return;
            }
            if (wself.homeModel.is_video_show == 1 && USER_INFO.systemIndexModel.is_video_show == 1) {
                [wself popCallVideoController];
            }
            if (!kStringIsEmpty(wself.homeModel.text_content)) {
                wself.chatPopDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
                    wself.chatPopTimers--;
                    if (wself.chatPopTimers == 0) {
                        [UIAlertController personalHomeChatAlertWithUserInfo:wself.homeModel view:wself.view];
                        [wself.chatPopDisposable dispose];
                    }
                }];
            }
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        wself.navigationView.moreBtn.hidden = YES;
        [wself.navigationView.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        if (code == 3002 || code == 3001) {
            //用户异常状态背景
            UIView *view = [wself userExceptionBgWithTitle:STRING(msg)];
            [wself.view addSubview:view];
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(HEIGHT_NAVBAR);
                make.left.bottom.right.equalTo(wself.view);
            }];
        }
    }];
}

- (void)requestBlack {
    kWeakSelf(self);
    [ASSetRequest requestSetBlackWithBlackID:self.homeModel.userid success:^(id  _Nullable data) {
        NSNumber *status = data;
        if (status.integerValue == 1) {//拉黑成功
            wself.homeModel.is_black = YES;
            kShowToast(@"成功加入黑名单");
        } else {//取消拉黑成功
            wself.homeModel.is_black = NO;
            kShowToast(@"取消拉黑");
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
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
    return SCALES(338) + HEIGHT_NAVBAR;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return 3;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return SCALES(38);
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (self.titles.count == 2) {
        if (index == 0) {
            ASPersonalUserController *vc = [[ASPersonalUserController alloc] init];
            vc.userID = self.userID;
            self.userVc = vc;
            return vc;
        } else {
            ASPersonalDynamicListController *vc = [[ASPersonalDynamicListController alloc] init];
            vc.userID = self.userID;
            return vc;
        }
    } else {
        if (index == 0) {
            ASPersonalUserController *vc = [[ASPersonalUserController alloc] init];
            vc.userID = self.userID;
            self.userVc = vc;
            return vc;
        } else if (index == 1) {
            ASPersonalVideoShowController *vc = [[ASPersonalVideoShowController alloc] init];
            vc.userID = self.userID;
            return vc;
        } else {
            ASPersonalDynamicListController *vc = [[ASPersonalDynamicListController alloc] init];
            vc.userID = self.userID;
            return vc;
        }
    }
}

- (void)pagerView:(JXPagerView *)pagerView mainTableViewDidScroll:(UIScrollView *)scrollView {
    UIColor *color = UIColor.whiteColor;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat hiddenY = HEIGHT_NAVBAR;//选择需要开始隐藏显示的y值
    CGFloat height = SCALES(200);
    if (offset < hiddenY) {
        self.navigationView.backgroundColor = [color colorWithAlphaComponent:0];
        [self.navigationView.backBtn setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    } else {
        CGFloat alpha = (offset - hiddenY) / height;
        self.navigationView.backgroundColor = [color colorWithAlphaComponent:alpha];
        [self.navigationView.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
}

- (ASPersonalTopView *)topView {
    if (!_topView) {
        _topView = [[ASPersonalTopView alloc]init];
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_NAVBAR + SCALES(338));
        _topView.backgroundColor = UIColor.clearColor;
        _topView.userID = self.userID;
    }
    return _topView;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCALES(38))];
        _categoryView.backgroundColor = UIColor.clearColor;
        _categoryView.delegate = self;
        _categoryView.titleColor = TEXT_SIMPLE_COLOR;
        _categoryView.titleSelectedColor = TITLE_COLOR;
        _categoryView.titleFont = TEXT_FONT_16;
        _categoryView.titleSelectedFont = TEXT_MEDIUM(20);
        _categoryView.contentEdgeInsetLeft = SCALES(18);
        _categoryView.cellSpacing = SCALES(24);
        _categoryView.averageCellSpacingEnabled = NO;
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(0, SCALES(37.5), SCREEN_WIDTH, SCALES(0.5));
        line.backgroundColor = LINE_COLOR;
        [_categoryView addSubview:line];
    }
    return _categoryView;
}

- (ASBaseNavigationView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[ASBaseNavigationView alloc]init];
        _navigationView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.0];
    }
    return _navigationView;
}

- (ASPersonalBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[ASPersonalBottomView alloc]init];
        _bottomView.backgroundColor = UIColor.whiteColor;
        _bottomView.hidden = YES;
        _bottomView.layer.shadowColor = [UIColor grayColor].CGColor;
        _bottomView.layer.shadowOpacity = 0.3;
    }
    return _bottomView;
}

- (UIView *)userExceptionBgWithTitle:(NSString *)title {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = UIColor.whiteColor;
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:@"empty_common"];
    [view addSubview:icon];
    [icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view).offset(-HEIGHT_NAVBAR);
        make.height.width.mas_equalTo(SCALES(165));
    }];
    UILabel *text = [[UILabel alloc] init];
    text.textColor = TEXT_SIMPLE_COLOR;
    text.font = TEXT_FONT_15;
    text.text = STRING(title);
    [view addSubview:text];
    [text mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(icon.mas_bottom).offset(SCALES(26));
        make.height.mas_equalTo(SCALES(22));
    }];
    return view;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.topView.currentPlayer != nil) {
        [self.topView.currentPlayer stopPlay];
        [self.topView.currentPlayer removeVideoWidget];
    }
}
@end

