//
//  ASEarningsListModel.h
//  AS
//
//  Created by SA on 2025/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASEarningsListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *from_username;
@property (nonatomic, assign) NSInteger account_type;
@property (nonatomic, copy) NSString *change_value;
@property (nonatomic, copy) NSString *change_value_new;
@property (nonatomic, copy) NSString *system_str;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *track_user_id;
@property (nonatomic, copy) NSString *user_gift_id;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *day_income;
@property (nonatomic, assign) NSInteger is_detail;
@property (nonatomic, copy) NSString *coin_color;
@property (nonatomic, copy) NSString *system_str_tips;
@end

NS_ASSUME_NONNULL_END
