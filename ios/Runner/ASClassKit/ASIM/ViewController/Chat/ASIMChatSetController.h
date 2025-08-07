//
//  ASIMChatSetController.h
//  AS
//
//  Created by SA on 2025/5/15.
//

#import "ASBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASIMChatSetController : ASBaseViewController
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) VoidBlock delBlock;
@end

NS_ASSUME_NONNULL_END
