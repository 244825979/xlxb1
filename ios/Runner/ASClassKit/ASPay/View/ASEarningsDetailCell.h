//
//  ASEarningsDetailCell.h
//  AS
//
//  Created by SA on 2025/6/26.
//

#import <UIKit/UIKit.h>
#import "ASSendBackDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASEarningsDetailCell : UITableViewCell
@property (nonatomic, strong) ASSendBackDetailListModel *model;
@property (nonatomic, assign) BOOL isLast;//是否是最后一个cell
@property (nonatomic, assign) NSInteger type;//0退还详情。1退回详情
@end

NS_ASSUME_NONNULL_END
