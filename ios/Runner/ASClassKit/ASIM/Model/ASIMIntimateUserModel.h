//
//  ASIMIntimateUserModel.h
//  AS
//
//  Created by SA on 2025/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASIntimateUserListModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger current_grade;
@property (nonatomic, assign) NSInteger next_grade;
@property (nonatomic, assign) NSInteger unlock;
@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *des;
//自定义字段
@property (nonatomic, assign) CGFloat cellHeight;
@end

@interface ASIntimateUserHeadModel : NSObject
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *man_url;
@property (nonatomic, copy) NSString *woman_url;
@end

@interface ASIMIntimateUserModel : NSObject
@property (nonatomic, strong) ASIntimateUserHeadModel *current;
@property (nonatomic, strong) NSArray<ASIntimateUserListModel *> *list;
@end

NS_ASSUME_NONNULL_END
