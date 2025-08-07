//
//  ASHeadPopRemindView.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASHeadPopRemindView : UIView
@property (nonatomic, copy) VoidBlock affirmBlock;
- (instancetype)initHeadPopViewWithCoin:(NSInteger)coin;
@end

NS_ASSUME_NONNULL_END
