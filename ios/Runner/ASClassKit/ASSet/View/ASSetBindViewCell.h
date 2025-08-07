//
//  ASSetBindViewCell.h
//  AS
//
//  Created by SA on 2025/7/23.
//

#import <UIKit/UIKit.h>
#import "ASSetBindStateModel.h"
NS_ASSUME_NONNULL_BEGIN

//通话类型
typedef NS_ENUM(NSInteger, ASBindCellType) {
    kBindTypePhone = 0,         //手机号码绑定
    kBindTypeWX = 1,            //微信绑定
};


@interface ASSetBindViewCell : UITableViewCell
@property (nonatomic, assign) ASBindCellType type;
@property (nonatomic, strong) ASSetBindStateModel *model;
@end

NS_ASSUME_NONNULL_END
