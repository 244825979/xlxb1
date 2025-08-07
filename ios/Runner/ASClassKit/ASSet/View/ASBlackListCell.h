//
//  ASBlackListCell.h
//  AS
//
//  Created by SA on 2025/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASBlackListCell : UITableViewCell
@property (nonatomic, strong) ASUserInfoModel *model;
@property (nonatomic, copy) VoidBlock refreshBlock;
@end

NS_ASSUME_NONNULL_END
