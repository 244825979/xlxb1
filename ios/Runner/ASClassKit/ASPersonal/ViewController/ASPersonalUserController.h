//
//  ASPersonalUserController.h
//  AS
//
//  Created by SA on 2025/5/6.
//

#import "ASBaseViewController.h"
#import <JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASPersonalUserController : ASBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic, strong) ASUserInfoModel *homeModel;
@property (nonatomic, copy) NSString *userID;
@end

NS_ASSUME_NONNULL_END
