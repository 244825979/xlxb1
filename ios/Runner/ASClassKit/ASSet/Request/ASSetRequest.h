//
//  ASSetRequest.h
//  AS
//
//  Created by SA on 2025/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASSetRequest : NSObject
//黑名单列表
+ (void)requestBlackListWithPage:(NSInteger)page
                         success:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack;

//黑名单设置取消
+ (void)requestSetBlackWithBlackID:(NSString *)blackID
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;

//举报列表
+ (void)requestReportListWithPage:(NSInteger)page
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack;

//撤销举报
+ (void)requestReportDrawWithID:(NSInteger)ID
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack;

//举报详情
+ (void)requestReportDetailWithID:(NSInteger)ID
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack;
//缘分牵线状态
+ (void)requestFateMatchStateSuccess:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack;
//设置缘分牵线
+ (void)requestSetFateMatchWithState:(NSInteger)state
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack;
//点赞通知状态
+ (void)requestLikeStateSuccess:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack;
//设置点赞通知状态
+ (void)requestSetLikeStateWithState:(NSString *)state
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack;
//获取送礼飘屏匿名状态
+ (void)requestAnonymityStateSuccess:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack;
//设置送礼飘屏匿名状态
+ (void)requestSetAnonymityWithIsOpen:(NSInteger)isOpen
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//我的收费数据
+ (void)requestMyCollectFeeDataWithSuccess:(ResponseSuccess)successBack
                                 errorBack:(ResponseFail)errorBack;
//设置价格的列表金额
+ (void)requestCollectFeeSelectListWithSuccess:(ResponseSuccess)successBack
                                     errorBack:(ResponseFail)errorBack;
//设置价格
+ (void)requestSetCollectFeeWithModel:(ASCollectFeeSelectModel *)model
                                 type:(NSString *)type
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//设置青少年模式
+ (void)requestOpenTeenagerWithPwd:(NSString *)pwd
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;
//关闭青少年模式
+ (void)requestCloseTeenagerWithPwd:(NSString *)pwd
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;
//青少年模式状态
+ (void)requestTeenagerStateWithSuccess:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack;
//忘记密码关闭青少年模式
+ (void)requestForgetPwdTeenagerWithPhone:(NSString *)phone
                                     code:(NSString *)code
                                  success:(ResponseSuccess)successBack
                                errorBack:(ResponseFail)errorBack;
//举报选项
+ (void)requestReportDataSuccess:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack;
//进行举报
+ (void)requestReportWithType:(NSInteger)type
                       images:(NSString *)images
                      content:(NSString *)content
                    reportUid:(NSString *)reportUid
                       cateID:(NSString *)cateID
                      success:(ResponseSuccess)successBack
                    errorBack:(ResponseFail)errorBack;
//设置备注名
+ (void)requestChangeUserRemarkWithName:(NSString *)name
                                 userID:(NSString *)userID
                                success:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack;
//补充材料
+ (void)requestReplenishWithReportId:(NSInteger)reportId
                              images:(NSString *)images
                             content:(NSString *)content
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack;
//获取绑定状态
+ (void)requestBindStatusSuccess:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack;
//系统设置-账号绑定显示小红点
+ (void)requestSetRedStatusSuccess:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;
//绑定微信
+ (void)requestSetBindWxWithOpenid:(NSString *)openid
                             token:(NSString *)token
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;
@end

NS_ASSUME_NONNULL_END
