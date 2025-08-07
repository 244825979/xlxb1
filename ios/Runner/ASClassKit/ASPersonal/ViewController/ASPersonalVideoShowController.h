//
//  ASPersonalVideoShowController.h
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASBaseViewController.h"
#import <JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASPersonalVideoShowController : ASBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *videoShowID;
@end

NS_ASSUME_NONNULL_END
