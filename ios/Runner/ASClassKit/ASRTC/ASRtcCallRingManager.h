//
//  ASRtcCallRingManager.h
//  AS
//
//  Created by SA on 2025/5/19.
//  来电铃声

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASRtcCallRingManager : NSObject
+ (instancetype)shared;
@property (nonatomic, assign) BOOL isCallPlaying;
- (void)play;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
