//
//  ASHomeOnlineListController.h
//  AS
//
//  Created by SA on 2025/8/1.
//

#import "ASBaseViewController.h"
#import <JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface ASHomeOnlineListController : ASBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) void(^listScrollCallback)(UIScrollView *scrollView);
@property (nonatomic, copy) void(^scrollOffsetBolck)(BOOL isShowTopBtn);//是否显示置顶按钮
@property (nonatomic, strong) ASBaseTableView *tableView;
//下拉刷新 第一页
- (void)onRefresh;
@property (nonatomic, copy) void(^onRefreshBack)(void);
@end

NS_ASSUME_NONNULL_END
