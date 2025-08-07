//
//  ASWithdrawRecordListController.h
//  AS
//
//  Created by SA on 2025/6/27.
//  收益记录

#import "ASBaseViewController.h"
#import <JXCategoryView/JXCategoryView.h>
NS_ASSUME_NONNULL_BEGIN

@interface ASWithdrawRecordListController : ASBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, copy) void(^listScrollCallback)(UIScrollView *scrollView);
@property (nonatomic, assign) NSInteger type;//0收益 1支出 3退还
- (void)selectDateOnRefresh;
@end

NS_ASSUME_NONNULL_END
