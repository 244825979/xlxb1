//
//  ASBaseCommonCell.h
//  AS
//
//  Created by SA on 2025/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASBaseCommonCell : UITableViewCell
@property (nonatomic, strong) ASSetCellModel *model;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UISwitch *setSwitch;
@property (nonatomic, strong) UIView *redView;//标题后方红点
@end

NS_ASSUME_NONNULL_END
