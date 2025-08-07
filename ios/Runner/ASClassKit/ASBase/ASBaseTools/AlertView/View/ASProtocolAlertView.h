//
//  ASProtocolAlertView.h
//  AS
//
//  Created by AS on 2025/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASProtocolAlertView : UIView
@property (nonatomic, copy) VoidBlock affirmBlock;
@property (nonatomic, copy) VoidBlock cancelBlock;
- (instancetype)initWithTitle:(nullable NSString *)title
                   cancelFont:(nullable UIFont *)cancelFont
                   cancelText:(nullable NSString *)cancelText
                   attributed:(NSMutableAttributedString *)attributed;
@end

NS_ASSUME_NONNULL_END
