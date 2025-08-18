//
//  ASBaseTabBarController.m
//  AS
//
//  Created by SA on 2025/4/9.
//

#import "ASBaseTabBarController.h"

@interface ASBaseTabBarController ()<UITabBarControllerDelegate, UITabBarDelegate>

@end

@implementation ASBaseTabBarController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    //销毁所有通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTabbarNotification:) name:@"removeTabbarNotification" object:nil];
    //麦克风权限提示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openRecordPowerNotification:) name:@"openRecordPowerNotification" object:nil];
    //删除IM单条消息弹窗提示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeRecentSessionNotification:) name:@"removeRecentSessionNotification" object:nil];
}

#pragma mark 通知事件
- (void)removeTabbarNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)openRecordPowerNotification:(NSNotification *)notification {
    [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"无麦风克权限，前往开启？" left:@"去开启" right:@"取消" isTouched:YES affirmAction:^{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        };
    } cancelAction:^{
        
    }];
}

- (void)removeRecentSessionNotification:(NSNotification *)notification {
    [ASAlertViewManager defaultPopTitle:@"确认删除" content:@"删除后无法恢复，确定删除聊天记录吗？" left:@"删除" right:@"取消" isTouched:YES affirmAction:^{
        NIMSession *session = notification.object[@"session"];
        if (!kObjectIsEmpty(session)) {
            //清空聊天内容
            NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc] init];
            option.removeSession = YES;
            option.removeTable = YES;
            [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:session option:option];
            NIMClearMessagesOption *cloudOption = [[NIMClearMessagesOption alloc] init];
            [[NIMSDK sharedSDK].conversationManager deleteSelfRemoteSession:session option:cloudOption completion:^(NSError * _Nullable error) {
                
            }];
            //取消在线状态订阅
            NIMSubscribeRequest *request = [[NIMSubscribeRequest alloc] init];
            request.type = 1;
            request.expiry = 60*60*24*1;
            request.syncEnabled = YES;
            request.publishers = @[session.sessionId];
            [[NIMSDK sharedSDK].subscribeManager unSubscribeEvent:request completion:^(NSError * _Nullable error, NSArray * _Nullable failedPublishers) {
                
            }];
        }
    } cancelAction:^{
        
    }];
}

- (void)setUI {
    //透明度,设置为不是半透明
    self.tabBar.translucent = NO;
    //背景图去掉
    self.delegate = self;
    self.tabBar.tintColor = MAIN_COLOR;
    
    //去掉分割线
    if (@available(iOS 13.0,*)) {
        [UITabBar appearance].layer.borderWidth = 0.0f;
        [UITabBar appearance].clipsToBounds = YES;
    } else {
        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
    //tabbar数据数组
    NSArray *itemTitles = @[@"首页", @"发现", @"视频秀", @"消息", @"我的"];
    NSArray *normalImageItems = @[@"tabbar", @"tabbar1", @"tabbar2", @"tabbar3", @"tabbar4"];
    NSArray *selectImageItems = @[@"tabbar_sel", @"tabbar_sel1", @"tabbar_sel2", @"tabbar_sel3", @"tabbar_sel4"];
    NSArray *controllClass = @[@"ASHomeController", @"ASDynamicController", @"ASVideoShowPlayController", @"ASIMListController", @"ASMineController"];
    NSMutableArray *controllers = [[NSMutableArray alloc]init];
    //设置文字的颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = TEXT_SIMPLE_COLOR;
    textAttrs[NSFontAttributeName] = TEXT_FONT_12;
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSFontAttributeName] = TEXT_FONT_12;
    selectTextAttrs[NSForegroundColorAttributeName] = MAIN_COLOR;
    //循环添加tabbar的Controller
    for (int i = 0; i< (itemTitles.count); i++) {
        //实例化控制器
        UIViewController *oneTabController = [[NSClassFromString(controllClass[i]) alloc]init];
        ASBaseNavigationController *navigation = [[ASBaseNavigationController alloc]initWithRootViewController:oneTabController];
        //图片
        navigation.tabBarItem.image = [[UIImage imageNamed:normalImageItems[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navigation.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageItems[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //偏移量
        navigation.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 0);//文字向上偏移-3
        [controllers addObject:navigation];
        //设置字体大小
        //navigation.tabBarItem
        [navigation.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
        [navigation.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
        //设置tabbaritem 的title
        navigation.tabBarItem.title = itemTitles[i];
        navigation.tabBarItem.tag = i;
    }
    self.viewControllers = controllers;
}

- (UINavigationController *)yq_navigationController {
    return self.selectedViewController;
}

//点击事件
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 2) {
        self.tabBar.backgroundColor = UIColor.blackColor;
        self.tabBar.barTintColor = UIColor.blackColor;
    } else {
        self.tabBar.backgroundColor = UIColor.whiteColor;
        self.tabBar.barTintColor = UIColor.whiteColor;
    }
}
@end
