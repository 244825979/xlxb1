//
//  ASHomeUserListController.h
//  AS
//
//  Created by SA on 2025/4/16.
//

#import "ASBaseViewController.h"
#import <JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASHomeUserListController : ASBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) void(^scrollOffsetBolck)(BOOL isShowTopBtn);//是否显示置顶按钮
@property (nonatomic, strong) ASBaseCollectionView *collectionView;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) void(^onRefreshBack)(void);
- (void)onRefresh;
@end

NS_ASSUME_NONNULL_END
