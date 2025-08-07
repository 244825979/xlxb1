//
//  ASLookListCell.h
//  AS
//
//  Created by SA on 2025/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASLookListCell : UITableViewCell
@property (nonatomic, strong) ASUserInfoModel *model;
@property (nonatomic, assign) BOOL isBeckon;
@end

NS_ASSUME_NONNULL_END
