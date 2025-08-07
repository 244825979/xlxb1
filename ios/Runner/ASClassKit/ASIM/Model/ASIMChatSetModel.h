//
//  ASIMChatSetModel.h
//  AS
//
//  Created by SA on 2025/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASIMChatSetModel : NSObject
@property (nonatomic, assign) BOOL is_black;
@property (nonatomic, assign) BOOL is_follow;
@property (nonatomic, assign) BOOL is_set;
@property (nonatomic, assign) BOOL is_hidden_visit;
@property (nonatomic, strong) ASUserInfoModel *info;
@end

NS_ASSUME_NONNULL_END
