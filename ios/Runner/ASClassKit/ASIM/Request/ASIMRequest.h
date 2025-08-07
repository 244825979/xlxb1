//
//  ASIMRequest.h
//  AS
//
//  Created by SA on 2025/4/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASIMRequest : NSObject

//获取亲密度列表数据
+ (void)requestIntimateListWithIds:(NSString *)ids
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;
//获取聊天页用户卡片信息
+ (void)requestChatCardDataWithUserID:(NSString *)userID
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//获取用户的隐身数据
+ (void)requestUsersHiddenWithSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//获取对ta开启隐身状态
+ (void)requestOpenHidingStateWithID:(NSString *)ID
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack;
//设置隐身访问or取消隐身访问
+ (void)requestSetHideVisitWithUserID:(NSString *)userID
                                isSet:(NSInteger)isSet
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//设置对ta开启隐身
+ (void)requestSetHidingWithUserID:(NSString *)userID
                             state:(BOOL)state
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;
//IM聊天获取视频秀数据
+ (void)requestIMVideoShowWithUserID:(NSString *)userID
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack;
//常用语列表
+ (void)requestUsefulExpressionsListWithScene:(NSInteger)scene
                                      isReply:(NSInteger)isReply
                                      success:(ResponseSuccess)successBack
                                    errorBack:(ResponseFail)errorBack;
//添加常用语
+ (void)requestAddUsefulExpressionsWithText:(NSString *)text
                                    success:(ResponseSuccess)successBack
                                  errorBack:(ResponseFail)errorBack;
//删除常用语
+ (void)requestDelUsefulExpressionsWithID:(NSString *)ID
                                  success:(ResponseSuccess)successBack
                                errorBack:(ResponseFail)errorBack;
//亲密度详细数据
+ (void)requestUserIntimateWithUserID:(NSString *)userID
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//校验IM消息发送
+ (void)requestSendImWithType:(NSInteger)type
                        msgID:(NSString *)msgID
                      content:(NSString *)content
                     toUserID:(NSString *)toUserID
                        isTid:(NSInteger)isTid
                      success:(ResponseSuccess)successBack
                    errorBack:(ResponseFail)errorBack;
//查看好友设置个人信息数据
+ (void)requestChatSetWithUserID:(NSString *)userID
                         success:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack;
//通话列表
+ (void)requestCallListWithPage:(NSInteger)page
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack;
//通话列表的视频推荐
+ (void)requestCallRecommendSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;
//获取当前小助手状态
+ (void)requestMatchHelperStateSuccess:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack;
//获取小助手列表数据
+ (void)requestMatchHelperListSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//一键回复
+ (void)requestOneClickReplyWithParams:(id)params
                               success:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack;
//一键回复验证
+ (void)requestGreetTplListSuccess:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;
//私聊活动悬浮窗
+ (void)requestIMChatActiveWithCateId:(NSString *)cateId
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//私聊获取金币价格
+ (void)requestIMChatPriceWithToUserId:(NSString *)userId
                               success:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack;
@end

NS_ASSUME_NONNULL_END
