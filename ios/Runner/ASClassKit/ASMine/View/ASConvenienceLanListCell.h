//
//  ASConvenienceLanListCell.h
//  AS
//
//  Created by SA on 2025/5/21.
//

#import <UIKit/UIKit.h>
#import "ASConvenienceLanListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASConvenienceLanListCell : UITableViewCell
@property (nonatomic, strong) ASConvenienceLanListModel *model;
@property (nonatomic, copy) VoidBlock delBlock;
@property (nonatomic, copy) IndexNameBlock selectBlock;
@property (nonatomic, strong) UIButton *selectBtn;
@end

NS_ASSUME_NONNULL_END
