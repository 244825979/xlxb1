//
//  ASHomeVoicePlayView.h
//  AS
//
//  Created by SA on 2025/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASHomeVoicePlayView : UIView
@property (nonatomic, copy) void(^actionBlack)(void);
@property (nonatomic, strong) ASVoiceModel *model;
@property (nonatomic, assign) BOOL isPlaying;//是否正在播放
@property (nonatomic, strong) RACDisposable *timerDisposable;//时间倒计时
- (void)playAnimating;//播放动画
- (void)stopAnimating;//停止动画
@end

NS_ASSUME_NONNULL_END
