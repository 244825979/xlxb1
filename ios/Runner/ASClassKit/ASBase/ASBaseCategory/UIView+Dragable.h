//
//  UIView+Dragable.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Dragable)
- (void)addDragableActionWithEnd:(void (^)(CGRect endFrame))endBlock;
@end

NS_ASSUME_NONNULL_END
