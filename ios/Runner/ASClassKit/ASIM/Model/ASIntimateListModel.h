//
//  ASIntimateListModel.h
//  AS
//
//  Created by SA on 2025/4/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASIntimateListModel : NSObject
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, copy) NSString *score;
@end

NS_ASSUME_NONNULL_END
