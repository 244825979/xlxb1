//
//  ASFansOrFollowListCell.h
//  AS
//
//  Created by SA on 2025/5/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FansOrFollowType){
    kFansCellType = 0,       //粉丝列表
    kFollowCellType = 1,     //关注列表
};

@interface ASFansOrFollowListCell : UITableViewCell
@property (nonatomic, assign) FansOrFollowType type;
@property (nonatomic, strong) ASUserInfoModel *model;
@property (nonatomic, assign) NSInteger isFollow;
@end

NS_ASSUME_NONNULL_END
