//
//  ASEditTextStateCell.h
//  AS
//
//  Created by SA on 2025/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASEditTextStateCell : UITableViewCell
@property (nonatomic, strong) ASSetCellModel *model;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@end

NS_ASSUME_NONNULL_END
