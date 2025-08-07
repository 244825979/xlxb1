//
//  ASHelperListModel.h
//  AS
//
//  Created by SA on 2025/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASHelperListModel : NSObject
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSTimeInterval ctime;
@property (nonatomic, assign) NSInteger is_online;
@property (nonatomic, assign) NSInteger is_vip;
@property (nonatomic, assign) NSTimeInterval reply_time;
@end

NS_ASSUME_NONNULL_END
