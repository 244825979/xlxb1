//
//  ASVideoShowRequest.h
//  AS
//
//  Created by SA on 2025/5/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASVideoShowRequest : NSObject

//视频秀拨打电话
+ (void)requestVideoShowCallWithVideoID:(NSString *)videoID
                                success:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack;
//视频秀点赞
+ (void)requestVideoShowZanWithVideoID:(NSString *)videoID
                               success:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack;
//视频秀搭讪
+ (void)requestVideoShowDashanWithUserID:(NSString *)userID
                             videoShowID:(NSString *)videoShowID
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack;
//视频秀关注
+ (void)requestVideoShowFollowWithUserID:(NSString *)userID
                             videoShowID:(NSString *)videoShowID
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack;
//播放首页获取通知信息
+ (void)requestVideoShowNotifySuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//视频秀列表
+ (void)requestMyPlayerVideoShowWithVideoID:(NSString *)videoID
                                     userID:(NSString *)userID
                                       page:(NSInteger)page
                                    success:(ResponseSuccess)successBack
                                  errorBack:(ResponseFail)errorBack;
//tabbar视频秀列表
+ (void)requestPlayerVideoShowListWithPage:(NSInteger)page
                                   success:(ResponseSuccess)successBack
                                 errorBack:(ResponseFail)errorBack;
//视频秀播放量统计
+ (void)requestVideoShowAddPlayNumWithVideoID:(NSString *)videoID
                                  completeNum:(NSString *)completeNum
                                     stopLong:(NSInteger)stopLong
                                      success:(ResponseSuccess)successBack
                                    errorBack:(ResponseFail)errorBack;
//检查每日上传视频秀限制
+ (void)requestVideoShowCheckDayAcountSuccess:(ResponseSuccess)successBack
                                    errorBack:(ResponseFail)errorBack;

//视频秀设置是否打开关闭状态
+ (void)requestSetStateVideoShowWithVideoID:(NSString *)videoID
                                 showStatus:(NSString *)showStatus
                                    success:(ResponseSuccess)successBack
                                  errorBack:(ResponseFail)errorBack;
//视频秀设置封面
+ (void)requestSetVideoShowCoverWithVideoID:(NSString *)videoID
                                    success:(ResponseSuccess)successBack
                                  errorBack:(ResponseFail)errorBack;
//删除视频秀
+ (void)requestDelVideoShowCoverWithVideoID:(NSString *)videoID
                                    success:(ResponseSuccess)successBack
                                  errorBack:(ResponseFail)errorBack;
//视频秀上次签名
+ (void)requestVideoShowSignSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;
//上传视频,发布视频
+ (void)requestPublishVideoShowWithImageUrl:(NSString *)imageUrl
                                 showStatus:(BOOL)showStatus
                                      title:(NSString *)title
                                   videoUrl:(NSString *)videoUrl
                                    success:(ResponseSuccess)successBack
                                  errorBack:(ResponseFail)errorBack;
//我的视频秀列表
+ (void)requestVideoShowListWithPage:(NSInteger)page
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack;
//视频秀送礼列表
+ (void)requestVideoShowAwardListSuccess:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack;
//视频秀送礼
+ (void)requestVideoShowSendGiftWithType:(NSInteger)type
                                  showID:(NSString *)showID
                                   toUID:(NSString *)toUID
                                  giftID:(NSString *)giftID
                              giftTypeID:(NSString *)giftTypeID
                                  liveID:(NSString *)liveID
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack;
//视频秀通知列表
+ (void)requestVideoShowNotifyListWithPage:(NSInteger)page
                                   success:(ResponseSuccess)successBack
                                 errorBack:(ResponseFail)errorBack;
//视频秀提醒
+ (void)requestVideoShowRemindSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
@end

NS_ASSUME_NONNULL_END
