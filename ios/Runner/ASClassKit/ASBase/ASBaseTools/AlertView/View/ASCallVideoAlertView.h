//
//  QWCallVideoAlertView.h
//  AS
//
//  Created by SA on 2025/6/19.
//

#import <UIKit/UIKit.h>
#import "ASUserVideoPopModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASCallVideoAlertView : UIView
@property (nonatomic, copy) VoidBlock cancelBlock;
@property (nonatomic, copy) VoidBlock affirmBlock;
- (instancetype)initCallVideoViewWithModel:(ASUserVideoPopModel *)model;
@end

NS_ASSUME_NONNULL_END
