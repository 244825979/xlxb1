//
//  ASCallRtcDataModel.h
//  AS
//
//  Created by SA on 2025/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASCallRtcDataModel : NSObject
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *from_uid;
@property (nonatomic, copy) NSString *from_nickname;
@property (nonatomic, copy) NSString *from_avatar;
@property (nonatomic, assign) NSInteger from_gender;
@property (nonatomic, copy) NSString *from_age_text;
@property (nonatomic, copy) NSString *from_city;
@property (nonatomic, copy) NSString *from_occupation;
@property (nonatomic, copy) NSString *from_height;
@property (nonatomic, copy) NSString *to_uid;
@property (nonatomic, copy) NSString *to_nickname;
@property (nonatomic, copy) NSString *to_avatar;
@property (nonatomic, assign) NSInteger to_gender;
@property (nonatomic, copy) NSString *to_age_text;
@property (nonatomic, copy) NSString *to_city;
@property (nonatomic, copy) NSString *to_occupation;
@property (nonatomic, copy) NSString *to_height;
@property (nonatomic, copy) NSString *socket_url;
@property (nonatomic, copy) NSString *socket_http_url;
@property (nonatomic, assign) NSInteger is_video_show;
@property (nonatomic, copy) NSString *cover_img_url;
@property (nonatomic, copy) NSString *video_url;
@end

NS_ASSUME_NONNULL_END
