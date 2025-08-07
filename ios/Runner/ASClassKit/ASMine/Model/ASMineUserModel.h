//
//  ASMineUserModel.h
//  AS
//
//  Created by SA on 2025/4/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASUserCountModel : NSObject
@property (nonatomic, assign) NSInteger fans_count;//粉丝
@property (nonatomic, assign) NSInteger new_fans_count;
@property (nonatomic, assign) NSInteger follow_count;//关注
@property (nonatomic, assign) NSInteger visitor_count;//访客
@property (nonatomic, assign) NSInteger viewer_count;//看过
@property (nonatomic, assign) NSInteger new_visitor_count;
@property (nonatomic, assign) NSInteger videoTrendsLike_count;
@property (nonatomic, assign) NSInteger new_videoTrendsLike_count;
@property (nonatomic, assign) NSInteger video_show_count;//视频秀数量
@end

@interface ASMineUserModel : NSObject
@property (nonatomic, strong) ASUserInfoModel *userinfo;
@property (nonatomic, strong) ASUserCountModel *usercount;
@property (nonatomic, assign) NSInteger avatar_task_reward_coin;//上传头像奖励的金额
@property (nonatomic, assign) NSInteger is_avatar_task_finish;//上传头像是否完成
@property (nonatomic, assign) NSInteger is_show_red_packet;//是否显示红包图标
@end

NS_ASSUME_NONNULL_END
