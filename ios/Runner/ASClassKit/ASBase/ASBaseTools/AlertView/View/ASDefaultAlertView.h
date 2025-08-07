//
//  ASDefaultAlertView.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASDefaultAlertView : UIView

//确认
@property (nonatomic, copy) void (^affirmBlock)(void);
//取消
@property (nonatomic, copy) void (^cancelBlock)(void);

//构造方法
- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                   affirmText:(nullable NSString *)affirmText
                   cancelText:(nullable NSString *)cancelText;

@end

NS_ASSUME_NONNULL_END
