//
//  ASRtcCallRingManager.m
//  AS
//
//  Created by SA on 2025/5/19.
//

#import "ASRtcCallRingManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ASRtcCallRingManager()<AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *callPlayer;
@end

@implementation ASRtcCallRingManager

+ (instancetype)shared {
    static ASRtcCallRingManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ASRtcCallRingManager alloc] init];
    });
    return instance;
}
SystemSoundID sound;

- (void)play {
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"call_ring" withExtension:@"mp3"];
    self.callPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    self.callPlayer.delegate = self;
    self.callPlayer.numberOfLoops = -1;
    self.isCallPlaying = YES;
    [self.callPlayer play];
}

- (void)stop {
    self.isCallPlaying = NO;
    [self.callPlayer pause];
    [self.callPlayer stop];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (player == self.callPlayer){
        self.isCallPlaying = NO;
    }
}
@end
