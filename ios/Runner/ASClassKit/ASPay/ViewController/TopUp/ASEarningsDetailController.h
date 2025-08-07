//
//  ASEarningsDetailController.h
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASEarningsDetailController : ASBaseViewController
@property (nonatomic, assign) NSInteger type;//0退还详情。1退回详情
@property (nonatomic, copy) NSString *giftID;//退回或者退还的礼物ID
@end

NS_ASSUME_NONNULL_END
