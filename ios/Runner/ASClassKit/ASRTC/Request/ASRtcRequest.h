//
//  ASRtcRequest.h
//  AS
//
//  Created by SA on 2025/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASRtcRequest : NSObject

//获取视频语音通话折扣信息
+ (void)requestGetPriceWithUserID:(NSString *)userID
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack;
//发起通话
+ (void)requestCallNewWithType:(NSInteger )type
                      toUserID:(NSString *)toUserID
                         scene:(NSString *)scene
                       success:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack;
//接听
+ (void)requestAnswerCallWithRoomID:(NSString *)roomID
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;
//接听校验余额
+ (void)requestCheckCallMoneyWithUserID:(NSString *)userID
                                success:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack;
@end

NS_ASSUME_NONNULL_END
