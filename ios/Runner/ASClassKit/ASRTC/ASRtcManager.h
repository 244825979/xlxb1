//
//  ASRtcManager.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>
#import <NERtcSDK/NERtcSDK.h>
#import <NERtcCallKit/NERtcCallKit.h>

NS_ASSUME_NONNULL_BEGIN
//通话类型
typedef NS_ENUM(NSInteger, ASCallType) {
    kCallTypeVideo = 1,//视频
    kCallTypeVoice = 2,//语音
};

@interface ASRtcManager : NSObject<NERtcCallKitDelegate>
+ (ASRtcManager *)shared;
- (void)initData;
- (void)callWithType:(ASCallType)type
            toUserID:(NSString *)toUserID
           moneyText:(NSString *)moneyText
               scene:(NSString *)scene
            complete:(void(^)(BOOL isSucceed))complete;
@end

NS_ASSUME_NONNULL_END
