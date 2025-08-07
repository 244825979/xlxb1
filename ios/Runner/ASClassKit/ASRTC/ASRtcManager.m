//
//  ASRtcManager.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASRtcManager.h"
#import "ASRtcRequest.h"
#import "ASCallRtcDataModel.h"
#import "ASCallRtcExtendModel.h"
#import "ASCallRtcVideoController.h"
#import "ASCallRtcVoiceController.h"
#import "ASCallRtcVideoAnswerController.h"
#import "ASCallRtcVoiceAnswerController.h"

@implementation ASRtcManager

+ (ASRtcManager *)shared {
    static dispatch_once_t onceToken;
    static ASRtcManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

- (void)initData {
    NERtcCallOptions *rtcOption = [[NERtcCallOptions alloc] init];
    rtcOption.disableRecord = YES;
    rtcOption.APNSCerName = NEIM_APNS;
    [NERtcCallKit.sharedInstance setupAppKey:NEIM_AppKey withRtcUid:USER_INFO.user_id.integerValue options:rtcOption];
    [NERtcCallKit.sharedInstance addDelegate:self];
}

- (void)callWithType:(ASCallType)type
            toUserID:(NSString *)toUserID
           moneyText:(NSString *)moneyText
               scene:(NSString *)scene
            complete:(void(^)(BOOL isSucceed))complete {
    if (type == kCallTypeVideo) {
        [ASMyAppCommonFunc verifyCameraPermissionBlock:^{
            [ASRtcRequest requestCallNewWithType:0 toUserID:toUserID scene:scene success:^(id  _Nullable data) {
                ASCallRtcDataModel *model = data;
                ASCallRtcVideoController *vc = [[ASCallRtcVideoController alloc] init];
                vc.callModel = model;
                vc.moneyText = moneyText;
                ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [[ASCommonFunc currentVc] presentViewController:nav animated:YES completion:nil];
                complete(YES);
            } errorBack:^(NSInteger code, NSString *msg) {
                complete(NO);
            }];
        }];
    } else {
        [ASMyAppCommonFunc verifyMicrophonePermissionBlock:^{
            [ASRtcRequest requestCallNewWithType:1 toUserID:toUserID scene:scene success:^(id  _Nullable data) {
                ASCallRtcDataModel *model = data;
                ASCallRtcVoiceController *vc = [[ASCallRtcVoiceController alloc] init];
                vc.callModel = model;
                vc.moneyText = moneyText;
                ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [[ASCommonFunc currentVc] presentViewController:nav animated:YES completion:nil];
                complete(YES);
            } errorBack:^(NSInteger code, NSString *msg) {
                complete(NO);
            }];
        }];
    }
}

#pragma mark - NERtcCallKitDelegate
/// 收到邀请的回调
/// @param invitor 邀请方
/// @param userIDs 房间中的被邀请的所有人（不包含邀请者）
/// @param isFromGroup 是否是群组
/// @param groupID 群组ID
/// @param type 通话类型
- (void)onInvited:(NSString *)invitor
          userIDs:(NSArray<NSString *> *)userIDs
      isFromGroup:(BOOL)isFromGroup
          groupID:(nullable NSString *)groupID
             type:(NERtcCallType)type
       attachment:(nullable NSString *)attachment {
    if ([[ASCommonFunc currentVc] isKindOfClass: [ASVideoShowPlayController class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"videoShowStopNotification" object:nil];
    }
    NSDictionary *data = [ASCommonFunc convertJsonStringToNSDictionary:attachment];
    ASCallRtcExtendModel *extendModel = [ASCallRtcExtendModel mj_objectWithKeyValues:data];
    [ASRtcRequest requestAnswerCallWithRoomID:extendModel.roomId success:^(id  _Nullable data) {
        ASCallRtcDataModel *model = data;
        if (type == NERtcCallTypeVideo) {
            ASCallRtcVideoAnswerController *vc = [[ASCallRtcVideoAnswerController alloc] init];
            vc.callModel = model;
            ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [[ASCommonFunc currentVc] presentViewController:nav animated:YES completion:nil];
        } else {
            ASCallRtcVoiceAnswerController *vc = [[ASCallRtcVoiceAnswerController alloc] init];
            vc.callModel = model;
            ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [[ASCommonFunc currentVc] presentViewController:nav animated:YES completion:nil];
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}
@end
