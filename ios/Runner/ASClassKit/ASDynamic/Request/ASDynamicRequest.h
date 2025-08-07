//
//  ASDynamicRequest.h
//  AS
//
//  Created by SA on 2025/5/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASDynamicRequest : NSObject
//动态列表
+ (void)requestDynamicListWithPage:(NSInteger)page
                              type:(NSInteger)type
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;
//减少该内容推荐
+ (void)requestDynamicDisLikeWithID:(NSString *)dynamicID
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;
//点赞
+ (void)requestLikeWithDynamicID:(NSString *)dynamicID
                            type:(NSInteger)type
                         success:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack;
//动态详情
+ (void)requestDynamicDetailWithID:(NSString *)dynamicID
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;
//进行评论
+ (void)requestCommentWithID:(NSString *)dynamicID
                   commentID:(NSString *)commentID
                     content:(NSString *)content
                     success:(ResponseSuccess)successBack
                   errorBack:(ResponseFail)errorBack;
//评论列表
+ (void)requestCommentListWithID:(NSString *)dynamicID
                            page:(NSInteger)page
                         success:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack;
//删除动态
+ (void)requestDynamicDeleteWithID:(NSString *)dynamicID
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;
//发布动态
+ (void)requestPublishDynamicWithContent:(NSString *)content
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack;
//发布图文的图片绑定
+ (void)requestPublishWithURL:(NSString *)URL
                    dynamicID:(NSString*)dynamicID
                      success:(ResponseSuccess)successBack
                    errorBack:(ResponseFail)errorBack;
//动态通知列表
+ (void)requestDynamicNotifyListWithPage:(NSInteger)page
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack;
//用户动态列表
+ (void)requestUserDynamicListWithUserID:(NSString *)userID
                                    page:(NSInteger)page
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack;
//未读动态
+ (void)requestUnreadDynamicCountSuccess:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack;
@end

NS_ASSUME_NONNULL_END
