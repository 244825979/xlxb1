//
//  ASAudioPlayManager.m
//  AS
//
//  Created by SA on 2025/4/21.
//

#import "ASAudioPlayManager.h"

@interface ASAudioPlayManager ()
@property (copy, nonatomic) NSString *playUrl;
@end

@implementation ASAudioPlayManager

+ (instancetype)shared {
    static ASAudioPlayManager *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //创建FSAudioStream对象
        FSStreamConfiguration *config = [[FSStreamConfiguration alloc] init];
        config.httpConnectionBufferSize *= 2;
        config.requireStrictContentTypeChecking = NO;
        player = [[super alloc] initWithConfiguration: config];
        player.onFailure = ^(FSAudioStreamError error,NSString *description){
            player.isPlay = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioPlayCompletionNotifiction" object:
             STRING(player.playUrl)];
            player.playUrl = @"";
        };
        player.onCompletion = ^(){
            [player stop];
            player.isPlay = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioPlayCompletionNotifiction" object:
             STRING(player.playUrl)];
            player.playUrl = @"";
        };
        //音量
        [player setVolume:0.5];
        //设置播放速率
        //[player setPlayRate: 1];
    });
    return player;
}
  
/**
 *  播放指定地址的文件
 *
 *  @param url 文件地址
 */
- (void)playFromURL:(NSString *)url {
    [super playFromURL:[NSURL URLWithString:STRING(url)]];
    _isPlay = YES;
    _playUrl = url;
}
  
/**
 *  停止
 */
- (void)stop {
    [super stop];
    _isPlay = NO;
}
@end
