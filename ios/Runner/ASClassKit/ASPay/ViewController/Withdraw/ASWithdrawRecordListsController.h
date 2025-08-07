//
//  ASWithdrawRecordListsController.h
//  AS
//
//  Created by SA on 2025/6/27.
//  单提现记录

#import "ASBaseViewController.h"
#import <JXCategoryView/JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASWithdrawRecordListsController : ASBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, copy) void(^listScrollCallback)(UIScrollView *scrollView);
@end

NS_ASSUME_NONNULL_END
