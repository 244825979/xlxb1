//
//  ASDynamicListController.h
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASBaseViewController.h"
#import <JXCategoryView/JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASDynamicListController : ASBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, copy) void(^listScrollCallback)(UIScrollView *scrollView);
@property (nonatomic, assign) NSInteger type;//0:推荐， 1关注
- (void)refreshWithArray:(NSArray *)array;
- (void)onRefresh;
@end

NS_ASSUME_NONNULL_END
