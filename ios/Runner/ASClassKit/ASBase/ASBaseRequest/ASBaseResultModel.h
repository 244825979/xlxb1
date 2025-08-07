//
//  ASBaseResultModel.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASBaseResultModel : NSObject
@property (nonatomic, strong) id data;//返回的数据
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *time;//时间戳
@end

NS_ASSUME_NONNULL_END
