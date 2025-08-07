//
//  ASMyAppCommonFunc.h
//  AS
//
//  Created by SA on 2025/4/9.
//

#import <Foundation/Foundation.h>
#import "ASBannerModel.h"
#import "ASRtcManager.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^VoidBlock)(void);
typedef void (^ActionBlock)(id _Nonnull data);
typedef void (^TextBlock)(NSString *text);
typedef void (^IndexBlock)(NSInteger index);
typedef void (^DataBlock)(BOOL isSuccess, id _Nullable data);
typedef void (^IndexNameBlock)(NSString *indexName);
typedef void (^ResponseSuccess)(id _Nonnull response);//成功返回
typedef void (^ResponseFail)(NSInteger code, NSString *message);//失败返回
typedef void (^SelectBlock)(NSInteger index, id value);
typedef void (^MoreSelectBlock)(NSString *key, id value);
typedef void (^BoolBlock)(BOOL isSuccess);

@interface ASMyAppCommonFunc : NSObject
#pragma mark - 当前APP功能方法
//获取注册登录易盾token
+ (void)getLoginYDTokenSuccess:(TextBlock)YDLoginBack
                         login:(VoidBlock)loginBack;
//获取apple支付易盾token
+ (void)getApplePayYDTokenWithSuccess:(TextBlock)successBack
                            errorBack:(VoidBlock)errorBack;
//校验是否有录音权限
+ (void)verifyMicrophonePermissionBlock:(VoidBlock)block;
//校验是否有相机权限
+ (void)verifyCameraPermissionBlock:(VoidBlock)block;
//是否在tabbar主页
+ (BOOL)isTabHomeViewController;
//IM会话的最后一条消息显示的文本
+ (NSString *)lastMessgeHint:(NIMMessage *)message;
#pragma mark - 当前APP功能点击
//打招呼
+ (void)greetWithUserID:(NSString *)userID action:(ActionBlock)action;
//去聊天
+ (void)chatWithUserID:(NSString *)userID nickName:(NSString *)nickName action:(ActionBlock)action;
//去聊天 IM匹配小助手进入
+ (void)littleHelperChatWithUserID:(NSString *)userID nickName:(NSString *)nickName sendMsgBlock:(VoidBlock)sendMsgBlock;
//去拨打电话，弹出拨打视频or语音弹窗
+ (void)callPopViewWithUserID:(NSString *)userID scene:(NSString *)scene back:(void(^)(BOOL isSucceed))back;
//去拨打电话，传入类型：CallType
+ (void)callWithUserID:(NSString *)userID callType:(ASCallType)callType scene:(NSString *)scene back:(void(^)(BOOL isSucceed))back;
//去个人主页
+ (void)goPersonalHomeWithUserID:(NSString *)userID viewController:(UIViewController *)vc action:(ActionBlock)action;
//点赞
+ (void)likeWithDynamicID:(NSString *)dynamicID isLike:(NSInteger)isLike action:(ActionBlock)action;
//关注or取消关注
+ (void)followWithUserID:(NSString *)userID action:(ActionBlock)action;
//banner点击跳转处理
+ (void)bannerClikedWithBannerModel:(ASBannerModel *)model viewController:(UIViewController *)vc action:(ActionBlock)action;
//余额不足弹窗
+ (void)balanceDeficiencyPopViewWithPayScene:(NSString *)payScene cancel:(VoidBlock)cancel;
//对ta隐身判断是否开启vip
+ (void)openHidingClikedVipAction:(VoidBlock)VoidBlock;
//对ta隐身点击
+ (void)openHidingClikedWithIsOpen:(BOOL)isOpen
                            userID:(NSString *)userID
                          nickName:(NSString *)nickName
                            action:(void(^)(BOOL isOpen))action;
//赠送vip数据获取
+ (void)sendVipWithUserID:(NSString *)userID action:(VoidBlock)action;
//支付点击事件
+ (void)applePayRequestWithScene:(NSString *)scene//场景
                    rechargeType:(NSString *)rechargeType//充值类型，1金币充值，2VIP充值
                       productID:(NSString *)productID//充值商品ID
                          isOpen:(NSInteger)isOpen//是否开启易盾
                        toUserID:(NSString *)toUserID//如果是给别人开通vip或者充值的用户ID
                         success:(ActionBlock)successBack
                       errorBack:(void(^)(NSInteger code))errorBack;
//统计
+ (void)behaviorStatisticsWithType:(NSInteger)type;
//app启动次数统计
+ (void)appOpenStatistics;
//活动弹窗上报
+ (void)activityPopStatisticsWithUrl:(NSString *)linkUrl
                           eventType:(NSInteger)eventType
                           placement:(NSInteger)placement;
@end

NS_ASSUME_NONNULL_END
