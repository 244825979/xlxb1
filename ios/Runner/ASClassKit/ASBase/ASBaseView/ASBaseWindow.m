//
//  ASBaseWindow.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASBaseWindow.h"
#import "ASMineController.h"
#import "ASIMListController.h"
#import "ASDynamicController.h"
#import "ASPersonalController.h"

@interface ASBaseWindow ()
@property (nonatomic, strong) RACDisposable *timerDisposable;//触摸事件计时器
@property (nonatomic, assign) NSInteger times;//未触摸倒计时时间8s
@end

@implementation ASBaseWindow

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    //是否开启视频推送
    if (USER_INFO.systemIndexModel.is_video_show == 0) {
        return;
    }
    //1、先判断是否在动态首页、消息首页、我的主页
    if ([[ASCommonFunc currentVc] isKindOfClass: [ASMineController class]] ||
        [[ASCommonFunc currentVc] isKindOfClass: [ASIMListController class]] ||
        [[ASCommonFunc currentVc] isKindOfClass: [ASDynamicController class]]) {
        NSSet *allTouches = [event allTouches];
        kWeakSelf(self);
        if ([allTouches count] > 0) {
            UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
            if (phase == UITouchPhaseBegan) {
                ASLog(@"send UITouchPhaseBegan");
                self.times = 8;
                /* 关闭计时器 */
                [self.timerDisposable dispose];
            }
            if (phase == UITouchPhaseEnded) {
                ASLog(@"send UITouchPhaseEnded");
                //2、进行倒计时。如果超过8秒未处理，就进行一次请求校验弹出视频弹窗
                self.timerDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
                    wself.times--;
                    if (USER_INFO.isLogin == NO) {
                        /* 关闭计时器 */
                        [wself.timerDisposable dispose];
                    }
                    if (wself.times == 0) {
                        /* 关闭计时器 */
                        [wself.timerDisposable dispose];
                        ASLog(@"请求获取是否弹窗视频推送");
                        NSString *userVideoPushPopViewTime = [ASUserDefaults valueForKey:@"userVideoPushPopViewTime"];//获取当前推送视频弹窗时间
                        NSString *timeStr = [ASCommonFunc currentTimeStr];
                        //1、如果没有储存可弹窗时间，表示未进行弹窗过，可以进行弹窗请求 2、如果当前时间大于可弹窗的时间，就进行请求弹窗。
                        if (kStringIsEmpty(userVideoPushPopViewTime) || timeStr.integerValue > userVideoPushPopViewTime.integerValue) {
                            [[ASPopViewManager shared] requestUserVideoPush];//视频来电提醒
                        }
                    }
                }];
            }
            if (phase == UITouchPhaseMoved) {
                self.times = 8;
                /* 关闭计时器 */
                [self.timerDisposable dispose];
            }
            if (phase == UITouchPhaseCancelled) {
                self.times = 8;
                /* 关闭计时器 */
                [self.timerDisposable dispose];
            }
        }
    } else if ([[ASCommonFunc currentVc] isKindOfClass: [ASPersonalController class]]) {
        NSSet *allTouches = [event allTouches];
        if ([allTouches count] > 0) {
            UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
            if (phase == UITouchPhaseBegan) {
                //通知个人主页，开始触摸事件
                [[NSNotificationCenter defaultCenter] postNotificationName:@"personalPopVideoPushNotification" object:@"0"];
            }
            if (phase == UITouchPhaseEnded) {
                //通知个人主页，结束触摸事件
                [[NSNotificationCenter defaultCenter] postNotificationName:@"personalPopVideoPushNotification" object:@"1"];
            }
        }
        self.times = 8;
        /* 关闭计时器 */
        [self.timerDisposable dispose];
    } else {
        self.times = 8;
        /* 关闭计时器 */
        [self.timerDisposable dispose];
    }
}

@end
