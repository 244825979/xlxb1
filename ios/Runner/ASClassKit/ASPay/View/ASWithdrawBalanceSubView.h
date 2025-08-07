//
//  ASWithdrawBalanceSubView.h
//  AS
//
//  Created by SA on 2025/6/26.
//

#import <UIKit/UIKit.h>
#import "ASWithdrawModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ASWithdrawBalanceSubView : UIView
@property (nonatomic, strong) ASWithdrawModel *model;
@property (nonatomic, copy) IndexNameBlock clikedBlock;//合作协议、立即提现、提现方式
@property (nonatomic, copy) ResponseSuccess selectMoneyBlock;
@end

@interface ASWithdrawListCell : UICollectionViewCell
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) CGFloat income_money;
@end

//选择支付方式view
@interface ASWithdrawSelectTypeView : UIView
@property (nonatomic, strong) ASWithdrawModel *model;
@property (nonatomic, copy) VoidBlock clikedBlock;
@end
NS_ASSUME_NONNULL_END
