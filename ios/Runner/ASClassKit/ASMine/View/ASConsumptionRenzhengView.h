//
//  ASConsumptionRenzhengView.h
//  AS
//
//  Created by SA on 2025/5/22.
//

#import <UIKit/UIKit.h>
#import "ASConsumptionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASConsumptionRenzhengView : UIView
@property (nonatomic, strong) ASConsumptionModel *model;
@property (nonatomic, copy) VoidBlock actionBlock;
@end

NS_ASSUME_NONNULL_END
