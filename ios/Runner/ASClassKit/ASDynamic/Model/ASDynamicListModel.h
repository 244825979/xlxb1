//
//  ASDynamicListModel.h
//  AS
//
//  Created by SA on 2025/5/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ASDynamicMediaType) {
    kDynamicMediaDefault = 0,           //无图
    kDynamicMediaImageOne = 1,          //单张图片
    kDynamicMediaImageTwo = 2,          //两张图片
    kDynamicMediaVideo = 3,             //视频
    kDynamicMediaImageMore = 4,         //多张
};

@interface ASDynamicPictureModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *exts;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@end

@interface ASDynamicUserModel: NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *occupation;
@end

@interface ASDynamicVideoModel: NSObject
@property (nonatomic, copy) NSString *cover_url;
@property (nonatomic, copy) NSString *file_url;
@end


@interface ASDynamicListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, assign) NSInteger is_anchor;
@property (nonatomic, assign) NSInteger is_doctor;
@property (nonatomic, copy) NSString *occupation;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) NSInteger is_follow;
@property (nonatomic, assign) NSInteger like_count;
@property (nonatomic, assign) NSInteger comment_count;
@property (nonatomic, assign) BOOL is_like;
@property (nonatomic, assign) NSInteger reward_count;
@property (nonatomic, assign) NSInteger is_reward;
@property (nonatomic, assign) NSInteger vip;
@property (nonatomic, assign) NSInteger is_vip;
@property (nonatomic, assign) NSInteger is_live;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger is_beckon;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *video_id;
@property (nonatomic, copy) NSString *cover_url;
@property (nonatomic, copy) NSString *file_url;
@property (nonatomic, copy) NSString *give_score;
@property (nonatomic, assign) NSInteger is_rp_auth;
@property (nonatomic, assign) NSInteger is_auth;
@property (nonatomic, strong) NSArray<ASDynamicPictureModel *> *images;
@property (nonatomic, strong) ASDynamicUserModel *user;
@property (nonatomic, strong) ASDynamicVideoModel *video;
@property (nonatomic, copy) NSString *time_day;
@property (nonatomic, copy) NSString *time_month;

@property (nonatomic, assign) ASDynamicMediaType mediaType;
@property (nonatomic, assign) CGFloat mediaHeight;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGFloat mediaPersonalHeight;
@property (nonatomic, assign) CGFloat cellPersonalHeight;
@end

NS_ASSUME_NONNULL_END
