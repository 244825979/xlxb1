//
//  ASMineRequest.h
//  AS
//
//  Created by SA on 2025/4/18.
//

#import <Foundation/Foundation.h>
#import "ASEditDataModel.h"
#import "ASConvenienceLanAddModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASMineRequest : NSObject

//获取签到数据
+ (void)requestTodaySignDataSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;
//个人中心数据
+ (void)requestMineHomeSuccess:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack;
//收益及金币数据
+ (void)requestWalletIndexSuccess:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack;
//签到
+ (void)requestDaySignInSuccess:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack;
//banner
+ (void)requestBannerWithType:(NSString *)type
                      success:(ResponseSuccess)successBack
                    errorBack:(ResponseFail)errorBack;
//更新头像
+ (void)requestUpdataAvatarWithURL:(NSString *)URL
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;
//获取编辑页数据
+ (void)requestEditDataSuccess:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack;
//编辑页保存
+ (void)requestEditSaveDataWithModel:(ASEditDataModel *)model
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack;
//设置语音签名获取文本
+ (void)requestVoiceTextListSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;
//选择的标签数据
+ (void)requestTagsListSuccess:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack;
//关注列表
+ (void)requestFollowListWithPage:(NSInteger)page
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack;
//粉丝列表
+ (void)requestFansListWithPage:(NSInteger )page
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack;
//看过列表
+ (void)requestLookListWithPage:(NSInteger)page
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack;
//访客列表
+ (void)requestVisitorListWithPage:(NSInteger)page
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;
//快捷用语列表
+ (void)requestConvenienceLanListSuccess:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack;
//设置快捷语标题
+ (void)requestConvenienceLanSetNameWithName:(NSString *)name
                                          ID:(NSString *)ID
                                     success:(ResponseSuccess)successBack
                                   errorBack:(ResponseFail)errorBack;
//删除快捷语
+ (void)requestDelConvenienceLanWithID:(NSString *)ID
                               success:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack;
//设置默认快捷语
+ (void)requestSetDefaultConvenienceLanWithID:(NSString *)ID
                                      success:(ResponseSuccess)successBack
                                    errorBack:(ResponseFail)errorBack;
//添加快捷用语
+ (void)requestAddConvenienceLanWithModel:(ASConvenienceLanAddModel *)model
                                  success:(ResponseSuccess)successBack
                                errorBack:(ResponseFail)errorBack;
//安全中心
+ (void)requestSecurityCenterWithSuccess:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack;
//用户通知弹窗-同意接口
+ (void)requestNoticeAgreeWithID:(NSString *)ID
                         success:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack;
//用户通知弹窗-是否弹出接口
+ (void)requestIsPopNoticeWithSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//我的页面是否弹出绑定微信弹窗或者绑定手机号弹窗
+ (void)requestIsPopBindAlertWithSuccess:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack;

@end

NS_ASSUME_NONNULL_END
