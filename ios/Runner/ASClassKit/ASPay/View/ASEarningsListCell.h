//
//  ASEarningsListCell.h
//  AS
//
//  Created by SA on 2025/6/26.
//

#import <UIKit/UIKit.h>
#import "ASEarningsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASEarningsListCell : UITableViewCell
@property (nonatomic, assign) BOOL isTimeCell;
@property (nonatomic, copy) NSString *dayTimeOrIncomeStr;
@property (nonatomic, strong) ASEarningsListModel *model;
@property (nonatomic, strong) ASEarningsListModel *earningsModel;
@end

NS_ASSUME_NONNULL_END
