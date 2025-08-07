//
//  ASIncomeRecordListController.h
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASBaseViewController.h"
#import <JXCategoryView/JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASIncomeRecordListController : ASBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, copy) void(^listScrollCallback)(UIScrollView *scrollView);
@property (nonatomic, assign) NSInteger type;//0收支记录 1退还记录
- (void)selectDateOnRefresh;//选择时间
@end

NS_ASSUME_NONNULL_END
