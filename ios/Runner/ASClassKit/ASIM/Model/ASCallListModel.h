//
//  ASCallListModel.h
//  AS
//
//  Created by SA on 2025/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASCallListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger is_read;
@property (nonatomic, assign) NSInteger otherType;
@property (nonatomic, assign) NSInteger is_video;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger call_time;
@property (nonatomic, copy) NSString *call_amount;
@property (nonatomic, copy) NSString *call_income;
@property (nonatomic, copy) NSString *status_txt;
@property (nonatomic, assign) NSInteger vip;
@property (nonatomic, copy) NSString *vip_icon;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *usercode;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger is_video_show;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *scene;
@end

NS_ASSUME_NONNULL_END
