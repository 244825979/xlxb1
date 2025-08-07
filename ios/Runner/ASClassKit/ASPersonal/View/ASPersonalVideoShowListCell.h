//
//  ASPersonalVideoShowListCell.h
//  AS
//
//  Created by SA on 2025/5/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASPersonalVideoShowListCell : UITableViewCell
@property (nonatomic, copy) IndexNameBlock clikedBlock;
@property (nonatomic, strong) ASVideoShowDataModel *model;
@end

NS_ASSUME_NONNULL_END
