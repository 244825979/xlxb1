//
//  ASWithdrawBalanceTopView.h
//  AS
//
//  Created by SA on 2025/6/26.
//

#import <UIKit/UIKit.h>
#import "ASAccountMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASWithdrawBalanceTopView : UIView
@property (nonatomic, strong) ASAccountMoneyModel *model;//账户数据模型
@property (nonatomic, copy) NSString *acountStr;//积分兑现、兑换金币
@property (nonatomic, copy) IndexNameBlock clikedBlock;
@end

NS_ASSUME_NONNULL_END
