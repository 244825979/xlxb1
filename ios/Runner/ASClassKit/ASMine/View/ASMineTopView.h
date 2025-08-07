//
//  ASMineTopView.h
//  AS
//
//  Created by SA on 2025/4/18.
//

#import <UIKit/UIKit.h>
#import "ASMineUserModel.h"
#import "ASAccountMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ASMineTopView : UIView
@property (nonatomic, strong) ASMineUserModel *model;
@property (nonatomic, strong) ASAccountMoneyModel *moneyModel;
@property (nonatomic, copy) IndexNameBlock indexNameBlock;
@end

NS_ASSUME_NONNULL_END
