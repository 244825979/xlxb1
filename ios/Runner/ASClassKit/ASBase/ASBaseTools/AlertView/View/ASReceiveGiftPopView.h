//
//  ASReceiveGiftPopView.h
//  AS
//
//  Created by AS on 2025/5/11.
//

#import <UIKit/UIKit.h>
#import "ASGiftDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASReceiveGiftPopView : UIView
@property (nonatomic, copy) VoidBlock affirmBlock;
@property (nonatomic, copy) VoidBlock cancelBlock;
- (instancetype)initReceiveGiftPopViewWithModel:(ASGiftListModel *)model;
@end

NS_ASSUME_NONNULL_END
