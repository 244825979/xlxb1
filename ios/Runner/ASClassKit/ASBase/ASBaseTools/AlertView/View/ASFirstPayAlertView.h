//
//  ASFirstPayAlertView.h
//  AS
//
//  Created by SA on 2025/6/11.
//

#import <UIKit/UIKit.h>
#import "ASFirstPayDataModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface ASFirstPayAlertView : UIView
@property (nonatomic, copy) VoidBlock cancelBlock;
- (instancetype)initFirstPayViewWithModel:(ASFirstPayDataModel *)model;
@end

@interface ASFirstPayGiftView : UIView
@property (nonatomic, strong) ASFirstGiftModel *giftModel;
@end
NS_ASSUME_NONNULL_END
