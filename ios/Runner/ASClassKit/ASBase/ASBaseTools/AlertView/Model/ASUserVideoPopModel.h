//
//  ASUserVideoPopModel.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASUserVideoPopModel : NSObject
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, assign) NSInteger is_show;//是否显示
@property (nonatomic, copy) NSString *avatar;//
@property (nonatomic, copy) NSString *nickname;//
@property (nonatomic, copy) NSString *video_price;//金额
@property (nonatomic, assign) NSInteger time_limit;//时间
@property (nonatomic, assign) NSInteger is_video_show;//是否播放视频秀
@property (nonatomic, copy) NSString *cover_img_url;//封面
@property (nonatomic, copy) NSString *video_url;//视频秀链接
@end

NS_ASSUME_NONNULL_END
