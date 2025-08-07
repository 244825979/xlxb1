//
//  ASUsersHiddenStateModel.h
//  AS
//
//  Created by SA on 2025/4/10.
//  隐身状态

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASUsersHiddenStateModel : NSObject
@property (nonatomic, assign) BOOL from_hidden;//1 对其隐身，0对其不隐身
@property (nonatomic, assign) BOOL to_hidden;//1 对方对我隐身， 0对方对我不隐身
@end

NS_ASSUME_NONNULL_END
