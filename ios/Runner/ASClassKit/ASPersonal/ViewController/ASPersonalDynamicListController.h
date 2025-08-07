//
//  ASPersonalDynamicListController.h
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASBaseViewController.h"
#import <JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASPersonalDynamicListController : ASBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) NSString *userID;
@end

NS_ASSUME_NONNULL_END
