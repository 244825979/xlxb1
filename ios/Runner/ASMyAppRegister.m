//
//  ASMyAppRegister.m
//  Runner
//
//  Created by admin on 2025/8/7.
//

#import "ASMyAppRegister.h"
#import "ASLaunchController.h"
#import <CoreTelephony/CTCellularData.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>
#import <RiskPerception/NTESRiskUniPerception.h>
#import <RiskPerception/NTESRiskUniConfiguration.h>
#import <NECommonUIKit/NECommonUIKit-Swift.h>
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import "ASFGIAPVerifyTransactionManager.h"
#import <BDASignalSDK.h>
#import "ASBaseWindow.h"
#import "ASWebSocketManager.h"
#import <UserNotifications/UserNotifications.h>
#import "ASWithdrawChangeController.h"

@implementation ASMyAppRegister

+ (ASMyAppRegister *)shared {
    static dispatch_once_t onceToken;
    static ASMyAppRegister *instance = nil;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[ASMyAppRegister alloc] init];
        }
    });
    return instance;
}

- (void)myApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self startInitialize];//初始化方法
    //设置根控制器
    [self setAppWindows];
    [self setRootViewController];
    [self setTabbarView];//进行一键登录校验
    [self iQKeyboardManage];
    [self RiskUniInit];
    [self FGIAPService];
    [self UMShareSDK];
    [self BDASignalManagerWithOptions:launchOptions];
}

//启动初始化
- (void)startInitialize {
    [self checkNetworkPermission];//先执行校验是否有网络授权
    [self startNetworkMonitoring];//先执行监测网络状态
#ifdef DEBUG
    //配置当前环境
    NSString *serverUrlType = [ASUserDefaults valueForKey:kServerUrlType];
    if (serverUrlType.integerValue == 0 || kStringIsEmpty(serverUrlType)) {
        [ASConfigConst shared].serverType = kServerTest;//测试环境
    } else if (serverUrlType.integerValue == 1) {
        [ASConfigConst shared].serverType = kServerPre;//预发环境
    } else {
        [ASConfigConst shared].serverType = kServerPublish;//正式环境
    }
#else
    [ASConfigConst shared].serverType = kServerPublish;//配置服务器地址
#endif
}

- (void)setAppWindows {
    self.window.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.window makeKeyAndVisible];
}

- (void)setRootViewController {
    ASLaunchController *rootVc = [[ASLaunchController alloc] init];
    ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:rootVc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}

//校验是否有网络授权
- (void)checkNetworkPermission {
    //创建网络连接
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, "www.apple.com");
    //获取网络状态
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityGetFlags(reachability, &flags);
    if ((flags & kSCNetworkReachabilityFlagsReachable) && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)) {
        ASLog(@"网络可用");
        self.isOpenNetwork = YES;
    } else {
        ASLog(@"网络不可用");
        self.isOpenNetwork = NO;
    }
    CFRelease(reachability);
}
/**
 *  网络监测
 */
- (void)startNetworkMonitoring {
    self.networkState = NO;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1://未知网络
                break;
            case 0://网络异常
                break;
            case 1://移动网络
                break;
            case 2://WIFI网络
                break;
            default:
                break;
        }
        if(status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            ASLog(@"---------------网络正常----------------------");
            self.networkState = YES;
        } else {
            //失去网络连接
            ASLog(@"--------------失去网络连接----------------------");
            self.networkState = NO;
        }
    }];
}

//启动后进入到初始化初始化tabbar页面
- (void)setTabbarView {
    kWeakSelf(self);
    NSString *isFirstStartApp = [ASUserDefaults valueForKey:kIsFirstStartApp];
    if (isFirstStartApp.integerValue == 0 || kStringIsEmpty(isFirstStartApp)) {
        NSMutableAttributedString *attributed = [ASTextAttributedManager firstAppProtocolAgreement:^{
            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
            vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_UserProtocol];
            [[ASCommonFunc currentVc] presentViewController:vc animated:YES completion:nil];
        } privacyAction:^{
            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
            vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Privacy];
            [[ASCommonFunc currentVc] presentViewController:vc animated:YES completion:nil];
        }];
        //首次启动弹窗
        [ASAlertViewManager protocolPopTitle:@"欢迎使用心聊想伴" cancelText:@"不同意并退出APP" cancelFont:TEXT_FONT_14 dismissOnMaskTouched:NO attributed:attributed affirmAction:^{
            //弹窗弹出过，就记录状态，首次启动才弹窗
            [ASUserDefaults setValue:@"1" forKey:kIsFirstStartApp];
            [wself checkNetworkPermission];//网络开启状态
            if (wself.isOpenNetwork == YES || wself.networkState == YES) {//有网络授权了
                [[ASLoginManager shared] TX_LoginInit];//腾讯一键登录初始化
                [wself restartUserData];//获取用户数据
            } else {
                [ASAlertViewManager defaultPopTitle:@"温馨提醒" content:@"您暂未开启网络，是否开启网络？" left:@"去开启" right:@"取消" affirmAction:^{
                    NSURL *url = [NSURL URLWithString: UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]){
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                    }
                } cancelAction:^{
                    [[ASLoginManager shared] TXLoginFailedLogin];//其他登录
                }];
            }
        } cancelAction:^{
            //关闭app
            exit(0);
        }];
    } else {
        if (self.isOpenNetwork == YES || self.networkState == YES) {
            [[ASLoginManager shared] TX_LoginInit];//腾讯一键登录初始化
            [self restartUserData];//获取用户数据
        } else {
            [[ASLoginManager shared] TXLoginFailedLogin];//其他登录
        }
    }
}

/**
 *  启动获取用户数据，登录云信
 */
- (void)restartUserData {
    __block BOOL isPerformNextStep = NO;
    [USER_INFO restartUserData];
    [USER_INFO requestSystemIndex:^(BOOL isSuccess, id  _Nullable data) {
        if (isSuccess && USER_INFO.isLogin) {
            if (USER_INFO.systemIndexModel.isTourist) {//如果是游客模式，不需要登录云信
                isPerformNextStep = YES;
                [[ASLoginManager shared] loginSuccess];
            } else {
                [[ASIMManager shared] NELoginWithAccount:USER_INFO.user_id token:USER_INFO.im_token succeed:^{
                    isPerformNextStep = YES;
                    [[ASLoginManager shared] loginSuccess];
                } fail:^{
                    isPerformNextStep = YES;
                    [[ASLoginManager shared] verifyIsLoginWithBlock:^{
                        
                    }];
                }];
            }
            [USER_INFO requestAppConfig:^(BOOL isSuccess, id  _Nullable data) { }];
        } else {
            isPerformNextStep = YES;
            if (USER_INFO.systemIndexModel.isTourist) {//如果是游客模式，且在A面
                [[ASLoginManager shared] loginSuccess];
            } else {
                [USER_INFO removeUserData:^{ }];
            }
        }
    }];
    //阻塞线程，直到云信回调告登录成功与否，才进行下一步
    while (!isPerformNextStep) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)iQKeyboardManage {
    [NEKeyboardManager shared].enable = YES;
    NEKeyboardManager.shared.shouldResignOnTouchOutside = YES;
    [NEKeyboardManager.shared setEnableAutoToolbar: NO];
}

/**
 易盾风控初始化
 */
- (void)RiskUniInit {
    //渠道
    [NTESRiskUniConfiguration setChannel:@"App Store"];
    //调用sdk初始化接口
    [[NTESRiskUniPerception fomentBevelDeadengo] init:YD_ProductID callback:^(int code, NSString * _Nonnull msg, NSString * _Nonnull content) {
        if (code == 200) {
            // code返回200说明初始化成功
            ASLog(@"YD初始化成功：code: %d, msg: %@, content: %@", code, msg, content);
        }
    }];
}

/**
 友盟分享初始化
 */
- (void)UMShareSDK {
    //初始化友盟
    [UMConfigure initWithAppkey:UM_AppKey channel:@"App Store"];
#ifdef DEBUG
    [[UMSocialManager defaultManager] openLog:YES];
#else
    
#endif
    //微信校验合法的universalLink，不设置会在初始化平台失败
    //配置微信Universal Link需注意 universalLinkDic的key是rawInt类型，不是枚举类型 ，即为 UMSocialPlatformType.wechatSession.rawInt
    [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession):WX_UNIVERSAL_LINK};
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:WX_AppKey
                                       appSecret:WX_AppSecret
                                     redirectURL:nil];
}

- (void)FGIAPService {
    //1. 配置服务器校验代理对象
    [[FGIAPManager shared] setConfigureWith:[[ASFGIAPVerifyTransactionManager alloc]init]];
}

- (void)requestIDFA {
    if (@available(iOS 14, *)) {
        // iOS14及以上版本需要先请求权限
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            // 获取到权限后，依然使用老方法获取idfa
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                ASLog(@"--------idfa = %@", idfa);
            } else {
                ASLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
            }
        }];
    } else {
        // iOS14以下版本依然使用老方法
        // 判断在设置-隐私里用户是否打开了广告跟踪
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            ASLog(@"--------idfa = %@", idfa);
        } else {
            ASLog(@"请在设置-隐私-广告中打开广告跟踪功能");
        }
    }
}

- (void)BDASignalManagerWithOptions:(NSDictionary *)launchOptions {
    //注册可选参数
    [BDASignalManager registerWithOptionalData:@{
        kBDADSignalSDKUserUniqueId : @""
    }];
    [BDASignalManager didFinishLaunchingWithOptions:launchOptions connectOptions:nil];//上报冷启动事件
    [BDASignalManager enableIdfa:YES];//获取IDFA
    [BDASignalManager getClickId];//获取ClickID
}

#pragma mark - delegate
- (void)myApplicationWillEnterForeground:(UIApplication *)application {
    if (USER_INFO.isLogin == NO) {
        //是已经启动过app
        NSString *isFirstStartApp = [ASUserDefaults valueForKey:kIsFirstStartApp];
        if ([[ASCommonFunc currentVc] isKindOfClass: [ASLaunchController class]] && (isFirstStartApp.integerValue == 1 || kStringIsEmpty(isFirstStartApp))) {
            [self checkNetworkPermission];//网络开启状态
            if (self.isOpenNetwork == YES) {//有网络授权了
                [[ASLoginManager shared] TX_LoginInit];//腾讯一键登录初始化
                [self restartUserData];//获取用户数据
            } else {
                [[ASLoginManager shared] TXLoginFailedLogin];//其他登录
            }
        }
    }
}

- (void)myApplicationWillResignActive:(UIApplication *)application {
    //到后台，关闭语音播放
    if ([NIMSDK sharedSDK].mediaManager.isPlaying) {
        [[NIMSDK sharedSDK].mediaManager stopPlay];
    }
    //到后台
    [ASCommonRequest requestAppOnlineStatusWithState:0 success:^(id  _Nullable data) {
    } errorBack:^(NSInteger code, NSString *msg) {
    }];
}

- (void)myApplicationDidBecomeActive:(UIApplication *)application {
    //重新启动后检测是否需要重新连接长链接
    if ([ASWebSocketManager shared].connectType == WebSocketDisconnect) {
        [[ASWebSocketManager shared] connectServer];
    }
    //清除即将收到的推送通知
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    //清除已经收到的推送通知
    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
    //通知条数清空
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //获取广告标识权限
    [self requestIDFA];
    //到前台统计
    [ASCommonRequest requestAppOnlineStatusWithState:1 success:^(id  _Nullable data) {
    } errorBack:^(NSInteger code, NSString *msg) {
    }];
}

//通知点击处理
- (void)userNotificationDidReceiveNotificationResponse:(UNNotificationResponse *)response {
    UNNotificationRequest *request = response.notification.request; //原始请求
    UNNotificationContent *content = request.content;// 原始内容
    NSDictionary *data = content.userInfo;
    NSNumber *nim = data[@"nim"];
    NSString *sessionID = data[@"sessionID"];
    if (nim.integerValue == 1 && !kStringIsEmpty(sessionID)) {
        [ASMyAppCommonFunc chatWithUserID:STRING(sessionID) nickName:@"" action:^(id  _Nonnull data) {
            
        }];
    } else {
        NSNumber *link_type = data[@"link_type"];
        NSString *link_url = data[@"link_url"];
        switch (link_type.integerValue) {
            case 1://跳转WebView加载网页，网页的链接取link_url
            {
                ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                vc.webUrl = STRING(link_url);
                [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

// URL Scheme回调: 9.0以后使用新API接口
- (BOOL)myApplicationOpenURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id>*)options {
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result) {
        if ([url.scheme containsString:@"myapp"]) {//回到自己的app
            NSString *openUrl = url.absoluteString;
            if ([openUrl containsString:@"withdraw"]) {//到提现页
                BOOL isInclude = NO;
                for (UIViewController *vc in [ASCommonFunc currentVc].navigationController.viewControllers) {
                    if ([vc isKindOfClass:[ASWithdrawChangeController class]]) {
                        isInclude = YES;
                        [[ASCommonFunc currentVc].navigationController popToViewController:vc animated:YES];
                    }
                }
                if (isInclude == NO) {
                    [[ASCommonFunc currentVc].navigationController popToRootViewControllerAnimated:NO];
                    ASWithdrawChangeController *vc = [[ASWithdrawChangeController alloc] init];
                    [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                }
            }
            if ([openUrl containsString:@"noticeSuccessfulVip"]) {//vip
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateVipNotification" object:nil];
            }
            if ([openUrl containsString:@"noticeSuccessful"]) {//金币
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBalanceNotification" object:nil];
            }
        } else if ([url.scheme isEqualToString:kAppBundleID]) {//回到自己的app
            //巨量
            [BDASignalManager anylyseDeeplinkClickidWithOpenUrl:url.absoluteString];
        }
        return YES;
    }
    return result;
}

//Universal link的回调:微信QQ用到的回调
- (BOOL)myApplicationUserActivity:(nonnull NSUserActivity *)userActivity {
    if (![[UMSocialManager defaultManager] handleUniversalLink:userActivity options:nil]) {
        return [WXApi handleOpenUniversalLink:userActivity delegate:self];
    }
    return YES;
}
@end
