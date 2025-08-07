//
//  ASRtcAnchorPriceModel.h
//  AS
//
//  Created by SA on 2025/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASRtcAnchorPriceModel : NSObject
@property (nonatomic, assign) NSInteger is_hidden;
@property (nonatomic, copy) NSString *video_price;
@property (nonatomic, copy) NSString *voice_price;
@property (nonatomic, copy) NSString *video_vip_txt;
@property (nonatomic, copy) NSString *voice_vip_txt;
@property (nonatomic, copy) NSString *videoTxt;
@property (nonatomic, copy) NSString *voiceTxt;
@property (nonatomic, copy) NSString *video_free;
@property (nonatomic, copy) NSString *voice_free;
@property (nonatomic, assign) NSInteger open_video_status;
@property (nonatomic, assign) NSInteger is_lock;
@property (nonatomic, copy) NSString *lock_tips;
@end

NS_ASSUME_NONNULL_END
