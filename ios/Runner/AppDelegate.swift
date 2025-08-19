import Flutter
import UIKit
import NIMSDK
import UserNotifications
import AppTrackingTransparency

@main
@objc class AppDelegate: FlutterAppDelegate {
    // Flutter引擎实例
    lazy var flutterEngine = FlutterEngine(name: "my flutter engine")
    
    private func checkData() -> Bool {
        let targetTimestamp: TimeInterval = 1756173600 //你可以修改成你需要的时间戳2025-08-26 10:00
        let currentTimestamp = Date().timeIntervalSince1970
        return currentTimestamp > targetTimestamp
    }
    
    private func validateDeviceSettings() -> Bool {
        let appSchemes = [
            "fb://", // Facebook
            "instagram://", // Instagram
            "whatsapp://", // WhatsApp
            "messenger://", // Messenger
            "youtube://", // YouTube
            "twitter://", // Twitter/X
            "line://", // Line
            "skype://", // Skype
            "tiktok://", // TikTok
            "snapchat://", // Snapchat
            "weixin://",
            "lark://",
            "dingtalk://",
            "mqq://", // QQ
            "snssdk1128://", // 抖音
            "taobao://", // 淘宝
            "pinduoduo://", // 拼多多
            "kwai://" // 快手
        ]
        for scheme in appSchemes {
            if let url = URL(string: scheme) {
                if UIApplication.shared.canOpenURL(url) {
                    return true // 只要有一个应用安装就返回true
                }
            }
        }
        return false
    }
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if checkData() && validateDeviceSettings() {
            //IOS的功能项目代码启动逻辑
            ASMyAppRegister.shared().window = ASBaseWindow(frame: UIScreen.main.bounds)
            ASMyAppRegister.shared().myApplication(application, didFinishLaunchingWithOptions: launchOptions ?? [:])
            setupNotifications(application)//注册通知
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        } else {
            // 启动Flutter引擎
            flutterEngine.run()
            // 注册插件
            GeneratedPluginRegistrant.register(with: flutterEngine)
            // 设置Flutter窗口
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let controller = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                if #available(iOS 14, *) {
                    ATTrackingManager.requestTrackingAuthorization { status in
                        // Handle tracking authorization status
                    }
                }
            }
            return true
        }
    }
    //进入前台流程
    //应用从后台切换至前台前（如用户解锁屏幕或切换回应用）。恢复后台暂停的任务（如重新建立网络连接、刷新数据）
    override func applicationWillEnterForeground(_ application: UIApplication) {
        if checkData() && validateDeviceSettings() {
            ASMyAppRegister.shared().myApplicationWillEnterForeground(application)
        }
    }
    //应用已进入前台并处于活动状态。
    override func applicationDidBecomeActive(_ application: UIApplication) {
        if checkData() && validateDeviceSettings() {
            ASMyAppRegister.shared().myApplicationDidBecomeActive(application)
        }
    }
    
    //进入后台流程
    //退到后台调用
    override func applicationWillResignActive(_ application: UIApplication) {
        if checkData() && validateDeviceSettings() {
            ASMyAppRegister.shared().myApplicationWillResignActive(application)
        }
    }
    //应用已完全进入后台
    override func applicationDidEnterBackground(_ application: UIApplication) {
        if checkData() && validateDeviceSettings() {
            ASMyAppRegister.shared().myApplicationDidEnterBackground(application)
        }
    }
}

//通知权限处理
extension AppDelegate {
    func setupNotifications(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self//设置代理
        //请求通知权限（弹窗）
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("通知权限已授权")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications() // 注册远程通知（获取设备令牌）
                }
            } else if let error = error {
                print("通知权限请求失败: \(error.localizedDescription)")
            }
        }
    }
    // MARK: - 成功获取设备令牌（Device Token）
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NIMSDK.shared().updateApnsToken(deviceToken)
    }
    // MARK: - 获取设备令牌失败
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("注册远程通知失败: \(error.localizedDescription)")
    }
    // MARK: - 处理前台通知显示.不实现，通知不会有提示
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    // MARK: - 对通知进行响应
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        ASMyAppRegister.shared().userNotificationDidReceive(response)//点击通知
        completionHandler();
    }
}

//回调
extension AppDelegate {
    // URL Scheme回调: 9.0以后使用新API接口
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ASMyAppRegister.shared().myApplicationOpen(url, options: options)
    }
    // Universal link的回调:微信QQ用到的回调
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool {
        return ASMyAppRegister.shared().myApplicationUserActivity(userActivity)
    }
}
