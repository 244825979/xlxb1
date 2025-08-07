//
//  TXLoginOauthSDK.h
//  TXLoginoauthSDK
//
//  Created by zhouguanghui on 2020/9/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TXLoginUIModel.h"
#import <TYRZUISDK/TYRZUISDK.h>

#define TXSDKVERSION @"quick_login_iOS_4.1.4"

NS_ASSUME_NONNULL_BEGIN

@interface TXLoginOauthSDK : NSObject

/**
 声明一个block
 @param resultDic 网络返回的data的解析结果
 */
typedef void (^richSuccessBlock) (NSDictionary * _Nonnull resultDic);
/**
 声明一个block
 @param error 网络返回的错误或者其它错误
 */
typedef void (^richFailureBlock) (id error);
/**
 声明一个block
 @param isSuccess 网络返回的结果
 */
typedef void (^completionBlock) (BOOL isSuccess);

/**初始化方法 */
+ (void)initLoginWithId:(NSString*)apiId;
/**初始化方法回调方法 */
+(void)initLoginWithId:(NSString*)apiId completionBlock:(completionBlock)completionBlock;

/**
 设置超时，
 @param timeout 超时，
 设置取号、授权请求和本机号码校验请求时的超时时间，开发者不配置时，默认所有请求的超时时间都为8000，单位毫秒
 */
+ (void)setTimeoutInterval:(NSTimeInterval)timeout;

/**
 设置初始化init超时，
 @param timeout 超时，
 设置初始化init的超时时间，开发者不配置时，默认所有请求的超时时间都为5000，单位毫秒
 */
+ (void)setInitTimeoutInterval:(NSTimeInterval)timeout;



#pragma mark - 登录步骤
/**1、先做一次预登陆 */
+ (void)preLoginWithBack:(richSuccessBlock)successBlock failBlock:(richFailureBlock)failBlock;

/**2、再一键登录
  调用登录界面进行免密码认证的功能
  ====== 注意注意一定要先调用preLoginWithBack进行预登录才有用======
  uiModel 设置登录授权页面UI
  successBlock 成功返回回调
  failBlock  失败返回回调
  controller 当前跳转控制器
 */
+ (void)loginWithController:(UIViewController*)controller andUIModel:(TXLoginUIModel *)uiModel  successBlock:(richSuccessBlock)successBlock failBlock:(richFailureBlock)failBlock;

/** getSimInfo
  networkType 类型NSString 值 == 0.无网络; 1.数据流量; 2.wifi; 3.数据+wifi
  isSuccesscarrier 类型 NSNumber 值 == 0.未知(未插sim卡，其它运营商等); 1.中国移动mobile;2.中国联通unicom;3.中国电信telecom
 */
+ (NSDictionary*)getSimInfo;

/**
  删除取号缓存数据 + 重置网络开关（自定义按钮事件里dimiss授权界面需调用）
  @return YES：有缓存已执行删除操作，NO：无缓存不执行删除操作
 */
+ (BOOL)delectScrip;

/**
 关闭授权界面
 @param flag 动画开关
 @param txCompletion 回调参数
 */
+ (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^ __nullable)(void))txCompletion;

/**
 //UAFSDKLoginDelegate 代理，提供登录事件回调方法。需配合 ignorePrivacyState 方法，实现用户未勾选隐私协议时，弹窗二次提醒用户同意登录的 需求。
 代理方法见文档与demo
 1、获取隐私协议的勾选框状态的回调方法
 - (void)authViewPrivacyCheckboxStateToggled:(BOOL)checked;
 2、提供登录事件回调方法。需配合 ignorePrivacyState 方法，实现用户未勾选隐私协议时，弹窗二次提醒用户同意登录的 需求。
 - (void)authRequestWillStart:(void(^)(BOOL))loginEvent ;
 */
+ (void)setLoginDelegate:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END


