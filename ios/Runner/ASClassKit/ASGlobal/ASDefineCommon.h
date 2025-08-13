//
//  ASDefineCommon.h
//  AS
//
//  Created by SA on 2025/4/9.
//

#ifndef ASDefineCommon_h
#define ASDefineCommon_h

#pragma mark - 第三方appKey
#define YD_ProductID        @"YD00189913999748"                                     //易盾产品ID
#define YD_LoginBusinessID  @"23e84b9fc5b71f4c22a4e90057d3c8fe"                     //易盾注册登录检测BusinessID
#define YD_PayBusinessID    @"d8a608596136a695d6a687d866cb8a6e"                     //易盾支付检测BusinessID
#define AESKey              @"ZRghOdN2phjhfb)Z"                                     //正式环境秘钥
#define NEIM_AppKey         @"262cd20eba3ed3040679012b52bdc0d7"                     //网易IM appkey
#define NEIM_AppSecret      @"29b0b56977d6"                                         //网易IM appSecret
#define TX_LoginID          @"1400921954"                                           //腾讯一键登录的ID 正式：1400921954 测试：1400922059
#define UM_AppKey           @"68677d9779267e02109f80a8"                             //友盟appkey
#define WX_UNIVERSAL_LINK   @"https://testoeglngldnzfgs.ixyys.cn/app/"              //微信跳转的UNIVERSAL_LINK
#define WX_AppKey           @"wx69b3fd56af9da2d3"                                   //微信appKey
#define WX_AppSecret        @"1382481cd501acf6e9603a205a83f125"                     //微信WX_AppSecret
#define APP_CHANNEL         @"2585"                                                 //渠道号
#define NEIM_APNS_DEV       @"xlxb_dev"
#define NEIM_APNS_Rel       @"xlxb_push"
#define TX_VideoShowKey     @"26936db97cd60c1c143927af2d15a7ef"
#define TX_VideoShowLicence @"https://license.vod2.myqcloud.com/license/v2/1324494570_1/v_cube.license"
#define APP_UUID_KEY        @"AS_UUID_KEY"                                          //APP存储唯一性的key

#pragma mark - 常用的key
#define kLoginPhoneText           @"kLoginPhoneText"                                //保存本地的登录手机号码key
#define kIsFirstStartApp          @"kIsFirstStartApp"                               //保存本地是否首次启动app的key
#define kIsPopPreventFraudView    @"kIsPopPreventFraudView"                         //保存本地是否弹出防诈骗提醒弹窗
#define kIsPopLoginTeenagerView   @"kIsPopLoginTeenagerView"                        //保存本地是否登录进行青少年开启弹窗
#define kIsPopDynamicConvention   @"kIsPopDynamicConventionView"                    //保存本地是否弹出动态公约
#define kServerUrlType            @"kServerUrlType"                                 //保存本地当前服务器环境
#define kIsChatMessageNotifyPop   @"kIsChatMessageNotifyPop"                        //保存是否开启顶部IM消息提醒
#define kIsPopUnderAgePopView     @"kIsPopUnderAgePopView"                          //保存本地充值未成年弹窗提示
#define kIsUploadParamRequest     @"kIsUploadParamRequest"                          //保存启动上报参数key

#pragma mark - 语法糖
#define kAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]    //Appdelegate
#define kShowToast(string) [ASMsgTool showTips:string]                              //toast提示
#define USER_INFO [ASUserDataManager shared]                                        //用户信息
#define kCurrentWindow [ASCommonFunc getKeyWindow]                                  //window
#define IDFV [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define STRING(string) [ASCommonFunc jsonDataChange:string]                         //解析数据 nil字符串类型改为空字符串
#define kAppType [ASUserDataManager shared].systemIndexModel.mtype                  //环境

#pragma mark - 版本信息
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] //APP版本号
#define kAppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]           //App名称

#pragma mark - 判断机型
#define kISiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)          //判断是否为iPhone
#define kISiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)              //判断是否为iPad
#define KISiPhone6 (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)        //判断是否是iPhone6、iPhone7、iPhone8
#define kISiPhone6_PLUS (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)   //判断是否是iPhone6plush、7plus、8plus
#define kISiPhoneX ((STATUS_BAR_HEIGHT >= 44) ? YES : NO)                           //是否是X系列

#pragma mark - 注册，强弱引用
#define kWeakSelf(type)  __weak typeof(type) w##type = type;                        //弱引用
#define kStrongSelf(type) __strong typeof(type) type = weak##type;                  //强引用

#pragma mark - 判断属性
//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#pragma mark - 其他
//开发的时候打印，但是发布的时候不打印的NSLog
#ifdef DEBUG
#define ASLog(format,...) printf("%s 第%d行 \n %s\n\n",__func__,__LINE__,[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else
#define ASLog(...)
#endif

#endif /* ASDefineCommon_h */
