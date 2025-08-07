//
//  ASPersonalController.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASPersonalController : ASBaseViewController
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) VoidBlock beckonBlock;
@property (nonatomic, copy) BoolBlock attentionBlock;
@end

NS_ASSUME_NONNULL_END
