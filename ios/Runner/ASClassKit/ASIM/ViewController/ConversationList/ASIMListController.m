//
//  ASIMListController.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASIMListController.h"
#import <JXCategoryView/JXCategoryView.h>
#import <UserNotifications/UserNotifications.h>
#import "心聊想伴-Swift.h"
#import "ASFriendHomeController.h"
#import "ASIMActionManager.h"
#import "ASIMConversationListTopView.h"
#import "ASCallRecordListController.h"
#import "ASDynamicNotifyController.h"
#import "NECommonKit/NECommonKit-Swift.h"
#import "ASHelperFloatingView.h"
#import "ASIMRequest.h"

@interface ASIMListController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryDotView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) ASIMConversationListTopView *topView;
@property (nonatomic, strong) zhPopupController *systemPopView;
@property (nonatomic, strong) ASHelperFloatingView *helperView;
@end

@implementation ASIMListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    [self createUI];
    [self homeData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([ASPopViewManager shared].popGoodAnchorState == 2 || [ASPopViewManager shared].popGoodAnchorState == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goodAnchorConfigNotification" object:nil];
    }
    self.categoryView.dotStates = @[@0,[[ASIMManager shared] miyouIsUnread] == YES ? @1 : @0];
    [self.categoryView reloadData];
    if (kAppType == 0) {
        [self clearMessage];
    }
    if (USER_INFO.gender == 1 && kAppType == 0 && USER_INFO.systemIndexModel.is_fate_helper_show == 1) {
        [self requestMatchHelperData];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.listContainerView.scrollView.scrollEnabled = NO;
}

- (void)createUI {
    kWeakSelf(self);
    UIImageView *topBg = [[UIImageView alloc]init];
    topBg.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100 + HEIGHT_NAVBAR);
    topBg.image = [UIImage imageNamed:@"im_top_bg"];
    topBg.contentMode = UIViewContentModeScaleAspectFill;
    topBg.userInteractionEnabled = YES;
    [self.view addSubview:topBg];
    [self.view addSubview:self.categoryView];
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerView.backgroundColor = UIColor.clearColor;
    self.listContainerView.frame = CGRectMake(0,
                                              HEIGHT_NAVBAR,
                                              SCREEN_WIDTH,
                                              SCREEN_HEIGHT - HEIGHT_NAVBAR - TAB_BAR_HEIGHT);
    [self.view addSubview:self.listContainerView];
    self.categoryView.listContainer = self.listContainerView;
    self.topView = ({
        ASIMConversationListTopView *view = [[ASIMConversationListTopView alloc] initWithFrame:CGRectMake(0, HEIGHT_NAVBAR, SCREEN_WIDTH, 100)];
        view.backgroundColor = UIColor.clearColor;
        view.indexBlock = ^(NSString * _Nonnull indexName) {
            if ([indexName isEqualToString:@"我的通话"]) {
                ASCallRecordListController *vc = [[ASCallRecordListController alloc] init];
                [wself.navigationController pushViewController:vc animated:YES];
                return;
            }
            if ([indexName isEqualToString:@"系统通知"]) {
                [wself.topView setHiddenRedWithType:1];
                [ASMyAppCommonFunc chatWithUserID:STRING([NEKitChatConfig shared].xitongxiaoxi_id) nickName:@"官方通知" action:^(id  _Nonnull data) {
                    
                }];
                return;
            }
            if ([indexName isEqualToString:@"活动通知"]) {
                [wself.topView setHiddenRedWithType:2];
                [ASMyAppCommonFunc chatWithUserID:STRING([NEKitChatConfig shared].huodongxiaozushou_id) nickName:@"活动通知" action:^(id  _Nonnull data) {
                    
                }];
                return;
            }
            if ([indexName isEqualToString:@"评论和赞"]) {
                ASDynamicNotifyController *vc = [[ASDynamicNotifyController alloc]init];
                [wself.navigationController pushViewController:vc animated:YES];
                return;
            }
        };
        [self.view addSubview:view];
        view;
    });
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(kScreenWidth - 44 - 10, STATUS_BAR_HEIGHT, 44, 44);
    [clearBtn setImage:[UIImage imageNamed:@"im_clear"] forState:UIControlStateNormal];
    [[clearBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [ASIMActionManager clearMessage];
    }];
    [self.view addSubview:clearBtn];
    if (USER_INFO.gender == 1 && kAppType == 0 && USER_INFO.systemIndexModel.is_fate_helper_show == 1) {
        [self.view addSubview:self.helperView];
        [self.helperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(SCALES(-15));
            make.bottom.equalTo(self.view.mas_bottom).offset(-SCALES(28) - SCALES(50));
            make.size.mas_equalTo(CGSizeMake(SCALES(70), SCALES(80)));
        }];
    }
}

- (void)requestMatchHelperData {
    kWeakSelf(self);
    [ASIMRequest requestMatchHelperStateSuccess:^(id  _Nullable data) {
        wself.helperView.model = data;
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)homeData {
    //IM引导折叠提示的弹窗
    NSString *isDemonstrationPop = [ASUserDefaults valueForKey:[NSString stringWithFormat:@"im_demonstration_%@",USER_INFO.user_id]];
    if (USER_INFO.gender == 1 && (kStringIsEmpty(isDemonstrationPop) || isDemonstrationPop.integerValue == 0)) {
        [ASAlertViewManager imDashanDemonstrationPopViewWithCancelBlock:^{ }];
        [ASUserDefaults setValue:@"1" forKey:[NSString stringWithFormat:@"im_demonstration_%@",USER_INFO.user_id]];
    }
    //防诈骗提醒弹窗
    NSString *isPop = [ASUserDefaults valueForKey:kIsPopPreventFraudView];
    if (kStringIsEmpty(isPop) || isPop.integerValue == 0) {
        [ASAlertViewManager popPreventFraudAlertView];
        [ASUserDefaults setValue:@"1" forKey:kIsPopPreventFraudView];
    }
    kWeakSelf(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"requestMatchHelperNotification" object:nil]
     subscribeNext:^(NSNotification * _Nullable notifiction) {
        [wself requestMatchHelperData];
    }];
    //网络监听
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"netWorkReachabilityNotify" object:nil]
     subscribeNext:^(NSNotification * _Nullable notifiction) {
        NSNumber *status = notifiction.object;
        if (status.integerValue == 0) {
            wself.topView.y = 36 + HEIGHT_NAVBAR;
        } else {
            wself.topView.y = HEIGHT_NAVBAR;
        }
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"refreshMiyouNotification" object:nil]
     subscribeNext:^(NSNotification * _Nullable notifiction) {
        NSNumber *status = notifiction.object;
        if (status.integerValue == 1) {
            wself.categoryView.dotStates = @[@0, @1];
            [wself.categoryView reloadData];
        }
    }];
    //用户通知权限是否开启提示
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (kObjectIsEmpty(wself.systemPopView) || wself.systemPopView.isClose == YES) {
                    //系统通知开启提醒
                    wself.systemPopView = [UIAlertController systemNotifyLimitPopView:wself.view affirmAction:^{
                        //去设置开启通知权限
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        };
                    }];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!kObjectIsEmpty(wself.systemPopView) && wself.systemPopView.isClose == NO) {
                    [wself.systemPopView dismiss];
                }
            });
        }
    }];
    [[ASPopViewManager shared] activityPopWithPlacement:3 vc:self isPopWindow:YES affirmAction:^{
        
    } cancelBlock:^{
        
    }];//活动弹窗
}

//自动清理
- (void)clearMessage {
    NSString *clearMessageMime = [ASUserDataManager shared].systemIndexModel.clear_message_time;
    NSString *lastClearTime = [ASUserDefaults valueForKey:@"lastClearTime"];
    NSString *timeStr = [ASCommonFunc currentTimeStr];
    if (kStringIsEmpty(lastClearTime)) {
        [ASUserDefaults setValue:STRING(timeStr) forKey:@"lastClearTime"];
        return;
    }
    if (timeStr.integerValue > (lastClearTime.integerValue + clearMessageMime.integerValue/1000)) {
        [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clearDeleteMsgListNotification" object:nil];
        }];
    }
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        UIViewController *vc = [ASIMFuncManager conversationListController];
        return vc;
    } else {
        ASFriendHomeController *vc = [[ASFriendHomeController alloc] init];
        return vc;
    }
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 2;
}

#pragma mark - JXCategoryViewDelegate
- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index {
    return YES;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    if (index == 0) {
        [[RACScheduler mainThreadScheduler] afterDelay:0.3 schedule:^{
            self.topView.hidden = NO;
        }];
    } else {
        self.topView.hidden = YES;
    }
}

- (JXCategoryDotView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryDotView alloc] initWithFrame:CGRectMake(SCALES(120), STATUS_BAR_HEIGHT, SCREEN_WIDTH - SCALES(240), 44)];
        _categoryView.backgroundColor = UIColor.clearColor;
        _categoryView.delegate = self;
        _categoryView.titleColor = TEXT_SIMPLE_COLOR;
        _categoryView.titleSelectedColor = TITLE_COLOR;
        _categoryView.titleFont = TEXT_FONT_16;
        _categoryView.titleSelectedFont = TEXT_MEDIUM(20);
        _categoryView.titles = @[@"消息", @"好友"];
        _categoryView.cellSpacing = SCALES(28);
        _categoryView.dotSize = CGSizeMake(SCALES(8), SCALES(8));
        _categoryView.dotColor = RED_COLOR;
        JXCategoryIndicatorImageView *indicatorImageView = [[JXCategoryIndicatorImageView alloc] init];
        indicatorImageView.verticalMargin = 0;
        indicatorImageView.indicatorImageView.image = [UIImage imageNamed:@"bottom_icon"];
        indicatorImageView.indicatorImageViewSize = CGSizeMake(SCALES(24), SCALES(8));
        _categoryView.indicators = @[indicatorImageView];
    }
    return _categoryView;
}

- (ASHelperFloatingView *)helperView {
    if (!_helperView) {
        _helperView = [[ASHelperFloatingView alloc]init];
        kWeakSelf(self);
        _helperView.clickBlock = ^{
            [ASAlertViewManager popMatchHelperListViewModel:wself.helperView.model refreshAction:^{
                [wself requestMatchHelperData];
            }];
        };
    }
    return _helperView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
