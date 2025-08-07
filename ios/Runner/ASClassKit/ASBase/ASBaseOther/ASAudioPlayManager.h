//
//  ASAudioPlayManager.h
//  AS
//
//  Created by SA on 2025/4/21.
//

#import <Foundation/Foundation.h>
#import <FSAudioStream.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASAudioPlayManager : FSAudioStream
+ (instancetype)shared;
@property (assign, nonatomic) BOOL isPlay;
- (void)playFromURL:(NSString *)url;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
