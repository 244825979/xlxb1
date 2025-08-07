//
//  ASConvenienceLanAddModel.h
//  AS
//
//  Created by SA on 2025/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASConvenienceLanAddModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger is_multi;
@property (nonatomic, copy) NSString *file;
@property (nonatomic, copy) NSString *voice_file;
@property (nonatomic, assign) NSInteger length;
@end

NS_ASSUME_NONNULL_END
