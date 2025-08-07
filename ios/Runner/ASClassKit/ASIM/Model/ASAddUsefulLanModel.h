//
//  ASAddUsefulLanModel.h
//  AS
//
//  Created by SA on 2025/5/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASAddUsefulLanModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *word;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *create_time_text;
@property (nonatomic, copy) NSString *update_time_text;
@property (nonatomic, assign) NSInteger is_system;
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
