//
//  ASEditSetVoiceSignController.h
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASEditSetVoiceSignController : ASBaseViewController
@property (nonatomic, copy) void (^saveBlock)(NSString *url, NSInteger time);
@end

NS_ASSUME_NONNULL_END
