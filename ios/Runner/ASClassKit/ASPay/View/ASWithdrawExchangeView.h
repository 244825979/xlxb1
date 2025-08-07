//
//  ASWithdrawExchangeView.h
//  AS
//
//  Created by SA on 2025/6/27.
//

#import <UIKit/UIKit.h>
#import "ASWithdrawModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASWithdrawExchangeView : UIView
@property (nonatomic, strong) ASWithdrawModel *model;
@property (nonatomic, copy) VoidBlock backBlock;
@end

NS_ASSUME_NONNULL_END
