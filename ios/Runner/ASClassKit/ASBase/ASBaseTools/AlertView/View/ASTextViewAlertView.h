//
//  ASTextViewAlertView.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASTextViewAlertView : UIView

//键盘高度
@property (nonatomic, copy) void (^keyboardHeight)(CGFloat height, CGFloat duration);
//确认
@property (nonatomic, copy) void (^affirmBlock)(NSString *text);
//取消
@property (nonatomic, copy) void (^cancelBlock)(void);
//构造方法 个性签名
- (instancetype)initTextViewWithTitle:(NSString *)title
                              content:(NSString *)content
                          placeholder:(NSString *)titleplaceholder
                               length:(NSInteger)length
                               affirm:(NSString *)affirm;
@end

NS_ASSUME_NONNULL_END
