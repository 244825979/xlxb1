//
//  ASIntimacyDetailsAlertView.h
//  AS
//
//  Created by SA on 2025/4/15.
//

#import <UIKit/UIKit.h>
#import "ASIMIntimateUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ASIntimacyDetailsAlertView : UIView
- (instancetype)initIntimacyDetailsWithModel:(ASIMIntimateUserModel *)model;
@end

@interface ASIntimacyPopViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *lvTitle;
@property (nonatomic, strong) ASIntimateUserListModel *model;
@end
NS_ASSUME_NONNULL_END
