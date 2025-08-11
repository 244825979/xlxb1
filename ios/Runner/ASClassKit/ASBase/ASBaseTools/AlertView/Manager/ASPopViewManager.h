//
//  ASPopViewManager.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASPopViewManager : NSObject
@property (nonatomic, assign) NSInteger popGoodAnchorState;//弹出优质弹窗状态0、表示没弹出过 1、首次倒计时结束允许弹出未弹首次。2、首次倒计时结束弹出了首次弹窗
//单例
+ (ASPopViewManager *)shared;
//首页进行有序弹窗
- (void)homePopViewWithVc:(UIViewController *)vc complete:(VoidBlock)complete;
//我的页面进行有序弹窗
- (void)minePopViewWithVc:(UIViewController *)vc complete:(VoidBlock)complete;
//会话列表有序弹窗
- (void)IMListPopViewWithVc:(UIViewController *)vc complete:(VoidBlock)complete;
//IM页男用户来了首条折叠消息处理
- (void)IMListManPopDemonstrationViewWithVc:(UIViewController *)vc complete:(VoidBlock)complete;
#pragma mark - 首页
//更新弹窗
- (void)requestAppVersionPopViewWithVc:(UIViewController *)vc complete:(VoidBlock)complete;
//开启青少年模式弹窗
- (void)isOpenTeenagerPopWithVc:(UIViewController *)vc complete:(VoidBlock)complete;
//缘分推荐
- (void)requestRecommendUserWithVc:(UIViewController *)vc complete:(VoidBlock)complete;
//新人礼包
- (void)requestNewUserGiftWithVc:(UIViewController *)vc complete:(VoidBlock)complete;
//关闭青少年模式弹窗
- (void)closeTeenagerPop;
//删除弹窗
- (void)removePopView;
//首充
- (void)firstPayViewPop;
//视频来电推送
- (void)requestUserVideoPush;
//优质女用户
- (void)requestGoodAnchorWithIsFirst:(BOOL)isFirst complete:(VoidBlock)complete;
//活动配置弹窗
- (void)activityPopWithPlacement:(NSInteger)placement
                              vc:(UIViewController *)vc
                     isPopWindow:(BOOL)isPopWindow
                    affirmAction:(VoidBlock)affirmAction
                     cancelBlock:(VoidBlock)cancelBlock;
#pragma mark - 我的页面
//我的页面：视频秀发布引导提示
- (void)requestVideoShowRemindWithVc:(UIViewController *)vc complete:(VoidBlock)complete;
//我的页面：头像引导提醒
- (void)headerPopRemindWithVc:(UIViewController *)vc complete:(VoidBlock)complete;
//获取是否弹出须知弹窗
- (void)requestXuzhiPopWithVc:(UIViewController *)vc complete:(VoidBlock)complete;
//弹出绑定提醒
- (void)requestPopBindWithVc:(UIViewController *)vc complete:(VoidBlock)complete;
#pragma mark - IM会话列表
//防诈骗提醒弹窗
- (void)popPreventFraudViewWithVc:(UIViewController *)vc complete:(VoidBlock)complete;
//IM引导折叠提示的弹窗
- (void)popDemonstrationViewWithVc:(UIViewController *)vc isMan:(BOOL)isMan complete:(VoidBlock)complete;
@end

NS_ASSUME_NONNULL_END
