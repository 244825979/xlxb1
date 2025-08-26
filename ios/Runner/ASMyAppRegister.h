//
//  ASMyAppRegister.h
//  Runner
//
//  Created by admin on 2025/8/7.
//

#import <UIKit/UIKit.h>
#import <WXApi.h>
NS_ASSUME_NONNULL_BEGIN

@interface ASMyAppRegister : NSObject<WXApiDelegate>
+ (ASMyAppRegister *)shared;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) BOOL isOpenNetwork;//是否开启网络权限
@property (nonatomic, assign) BOOL networkState;//当前网络状态

- (void)myApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)myApplicationWillEnterForeground:(UIApplication *)application;
- (void)myApplicationWillResignActive:(UIApplication *)application;
- (void)myApplicationDidBecomeActive:(UIApplication *)application;
- (void)myApplicationDidEnterBackground:(UIApplication *)application;
//URL Scheme回调: 9.0以后使用新API接口
- (BOOL)myApplicationOpenURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id>*)options;
//通知点击处理
- (void)userNotificationDidReceiveNotificationResponse:(UNNotificationResponse *)response;
//Universal link的回调:微信QQ用到的回调
- (BOOL)myApplicationUserActivity:(nonnull NSUserActivity *)userActivity;

- (void)myAppComFuncNotiChange;
- (void)myAppFuncStartCliked;
- (void)requestIDFA;
@end

NS_ASSUME_NONNULL_END
