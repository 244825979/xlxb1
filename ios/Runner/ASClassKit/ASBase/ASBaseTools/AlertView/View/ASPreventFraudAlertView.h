//
//  ASPreventFraudAlertView.h
//  AS
//
//  Created by SA on 2025/4/11.
//  防止诈骗弹窗

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASPreventFraudAlertView : UIView
@property (nonatomic, copy) VoidBlock affirmBlock;
- (instancetype)initPreventFraudView;
@end

NS_ASSUME_NONNULL_END
