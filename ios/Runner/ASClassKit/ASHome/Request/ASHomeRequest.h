//
//  ASHomeRequest.h
//  AS
//
//  Created by SA on 2025/4/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASHomeRequest : NSObject

//首页推荐用户
+ (void)requestHomeUserListWithPage:(NSInteger )page
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;

//首页新人列表
+ (void)requestHomeNewUserListWithPage:(NSInteger)page
                               success:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack;

//首充数据获取
+ (void)requestFirstPayData:(BOOL)isLoading
                    success:(ResponseSuccess)successBack
                  errorBack:(ResponseFail)errorBack;

//首页的用户字段配置接口，是否需要资料补充
+ (void)requestHomeIndexInfoSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;

//视频交友列表
+ (void)requestHomeCallListWithPage:(NSInteger )page
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;
//搜索用户
+ (void)requestHomeSearchWithID:(NSString *)ID
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack;
//猜你喜欢
+ (void)requestLikeUserWithType:(NSString *)type
                            HUD:(BOOL)HUD
                       success:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack;
//首页新人
+ (void)requestNewListWithPage:(NSInteger )page
                       success:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack;
@end

NS_ASSUME_NONNULL_END
