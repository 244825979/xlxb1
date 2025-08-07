//
//  ASCallAlertView.h
//  AS
//
//  Created by SA on 2025/5/19.
//

#import <UIKit/UIKit.h>
#import "ASRTCAnchorPriceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASCallAlertView : UIView
@property (nonatomic, copy) void (^affirmBlock)(ASCallType type);
@property (nonatomic, copy) VoidBlock cancelBlock;
- (instancetype)initCallViewWithModel:(ASRtcAnchorPriceModel *)model;
@end

@interface ASCallCellView: UIView
@property (nonatomic, strong) ASRtcAnchorPriceModel *model;
@property (nonatomic ,assign) ASCallType type;
@property (nonatomic, copy) VoidBlock cliledBlock;
@end

NS_ASSUME_NONNULL_END
