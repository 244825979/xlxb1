//
//  ASBottomAlertView.h
//  AS
//
//  Created by SA on 2025/4/11.
//  底部弹出的view

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASBottomAlertView : UIView
//确认
@property (nonatomic, copy) void (^indexBlock)(NSString *indexName);
//取消
@property (nonatomic, copy) void (^cancelBlock)(void);
//构造方法
- (instancetype)initWithTitles:(NSArray *)titles;

@end

NS_ASSUME_NONNULL_END
