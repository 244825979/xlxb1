//
//  ASWithdrawHintView.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASWithdrawHintView : UIView
@property (nonatomic, copy) TextBlock affirmBlock;
@property (nonatomic, copy) VoidBlock cancelBlock;
- (instancetype)initDrawHintViewWithContent:(NSString *)content isProtocol:(BOOL)isProtocol;
@end

NS_ASSUME_NONNULL_END
