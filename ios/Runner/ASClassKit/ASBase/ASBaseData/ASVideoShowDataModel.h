//
//  ASVideoShowDataModel.h
//  AS
//
//  Created by SA on 2025/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASVideoShowDataModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *cover_img_url;
@property (nonatomic, copy) NSString *video_url;
@property (nonatomic, copy) NSString *is_cover;//是否封面
@property (nonatomic, assign) NSInteger like_num;
@property (nonatomic, assign) NSInteger play_num;//播放次数
@property (nonatomic, copy) NSString *show_status;//是否隐藏
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *audit_status;//是否审核中 0表示审核中
@property (nonatomic, assign) NSInteger admin_id;
@property (nonatomic, copy) NSString *audit_time;
@property (nonatomic, assign) NSInteger video_score;
@property (nonatomic, assign) NSInteger stop_long;
@property (nonatomic, assign) NSInteger call_num;
@property (nonatomic, assign) NSInteger complete_num;
@property (nonatomic, copy) NSString *package_name;
@property (nonatomic, assign) NSInteger accost_num;
@property (nonatomic, copy) NSString *tag;//"35岁 | 170cm | 研发 | 广东深圳"
@property (nonatomic, assign) NSInteger like;
@property (nonatomic, assign) NSInteger is_follow;
@property (nonatomic, assign) NSInteger active;
@property (nonatomic, assign) NSInteger online;//是否搭讪
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) CGFloat titleHeight;
@end

NS_ASSUME_NONNULL_END
