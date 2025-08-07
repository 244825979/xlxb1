//
//  ASCommonRequest.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASCommonRequest : NSObject
//前后台上报
+ (void)requestAppOnlineStatusWithState:(NSInteger)state
                                success:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack;
//查询阿里OSS配置
+ (void)requestAliOSSWithType:(NSString *)type
                      success:(ResponseSuccess)successBack
                    errorBack:(ResponseFail)errorBack;
//启动获取AppConfig
+ (void)requestAppConfigSuccess:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack;
//获取配置信息SystemIndex
+ (void)requestAppSystemIndexIsLoading:(BOOL)isLoading
                               success:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack;
//上报参数
+ (void)requestActivateIndexWithSuccess:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack;
//获取风控提示
+ (void)requestCallRiskWithSuccess:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;
//获取认证状态
+ (void)requestAuthStateWithIsRequest:(BOOL)isRequest
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//首页进入请求，获取是否需要人脸认证弹窗
+ (void)requestIndexConfigWithSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//选择数据：所在地
+ (void)requestProvinceCitysSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;
//家乡
+ (void)requestCityOptionsSuccess:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack;
//选择器数据
+ (void)requestSelectListSuccess:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack;
//打招呼
+ (void)requestDaZhaohuWithUserID:(NSString *)userID
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack;
//关注or取消关注
+ (void)requestFollowWithUserID:(NSString *)userID
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack;
//获取礼物title
+ (void)requestGiftTitleSuccess:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack;
//获取礼物列表
+ (void)requestGiftListWithType:(NSInteger)type
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack;
//赠送礼物
+ (void)requestGiveGiftWithGiftTypeID:(NSString *)giftTypeID
                             toUserID:(NSString *)toUserID
                               number:(NSString *)number
                               giftID:(NSString *)giftID
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//获取苹果支付内购商品链接 scene场景
+ (void)requestGoodsListWithScene:(NSString *)scene
                          showHUD:(BOOL)showHUD
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack;
//苹果支付前调用接口
+ (void)requestApplePayWithParams:(NSDictionary *)params
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack;
//赠送vip弹窗
+ (void)requestSendVipDataWithUserID:(NSString *)userID
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack;
//理性消费数据
+ (void)requestMyConsumeInfoSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;
//消费设置
+ (void)requestSetConsumeWithIsExtra:(BOOL)isExtra
                               value:(NSString *)value
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack;
//支付校验 服务器验证购买凭证
+ (void)requestVerifyApplePayWithReceiptData:(NSString *)receiptData
                               transactionId:(NSString *)tranQWctionId
                                     orderNo:(NSString *)orderNo
                                     success:(ResponseSuccess)successBack
                                   errorBack:(ResponseFail)errorBack;
//兑换金币
+ (void)requestChangeCoinWithMoney:(NSString *)money
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;
//首页今日缘分用户推荐
+ (void)requestRecommendUserWithScene:(NSInteger)scene
                                isHUD:(BOOL)isHUD
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//首页今日缘分推荐搭讪
+ (void)requestRecommendBeckonWithUserIds:(NSString *)userIds
                                 zhaohuyu:(NSString *)zhaohuyu
                                  success:(ResponseSuccess)successBack
                                errorBack:(ResponseFail)errorBack;
//首页今日缘分招呼语
+ (void)requestRecommendRandCommonWordSuccess:(ResponseSuccess)successBack
                                    errorBack:(ResponseFail)errorBack;
//今日缘分状态
+ (void)requestRecommendStatusdSuccess:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack;
//版本升级弹窗
+ (void)requestAppVersionSuccess:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack;
//优质用户弹窗
+ (void)requestGoodAnchorIndexSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//优质女用户弹框点击聊天按钮
+ (void)requestGoodAnchorClickSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//视频提醒数据请求
+ (void)requestUserVideoPopPushSuccess:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack;
//点击事件统计处理
+ (void)requestBehaviorStatsWithType:(NSInteger)type
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack;
//APP启动次数上报
+ (void)requestReportAppOpenSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;
//活动弹窗行为上报
+ (void)requestTrackingPopupWithUrl:(NSString *)linkUrl
                          eventType:(NSInteger)eventType
                          placement:(NSInteger)placement
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;
//获取活动弹窗配置
+ (void)requestActivityPopupWithPlacement:(NSInteger)placement
                                  success:(ResponseSuccess)successBack
                                errorBack:(ResponseFail)errorBack;
@end

NS_ASSUME_NONNULL_END
