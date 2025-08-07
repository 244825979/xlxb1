//
//  ASVideoShowNotifyListCell.h
//  AS
//
//  Created by SA on 2025/5/13.
//

#import <UIKit/UIKit.h>
#import "ASVideoShowNotifyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASVideoShowNotifyListCell : UITableViewCell
@property (nonatomic, strong) ASVideoShowNotifyModel *model;
@property (nonatomic, copy) IndexNameBlock indexNameBlock;
@end

NS_ASSUME_NONNULL_END
