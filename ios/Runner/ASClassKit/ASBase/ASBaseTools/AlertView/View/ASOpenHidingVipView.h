//
//  ASOpenHidingVipView.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASOpenHidingVipView : UIView
@property (nonatomic, copy) VoidBlock affirmBlock;
@property (nonatomic, copy) VoidBlock cancelBlock;
- (instancetype)initOpenHidingVipView;
@end

NS_ASSUME_NONNULL_END
