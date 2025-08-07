//
//  ASDynamicListCell.h
//  AS
//
//  Created by SA on 2025/5/7.
//

#import <UIKit/UIKit.h>
#import "ASDynamicListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASDynamicListCell : UITableViewCell
@property (nonatomic, copy) IndexNameBlock clikedBlock;
@property (nonatomic, strong) ASDynamicListModel *model;
@property (nonatomic, assign) BOOL hiddenMore;
@end

NS_ASSUME_NONNULL_END
