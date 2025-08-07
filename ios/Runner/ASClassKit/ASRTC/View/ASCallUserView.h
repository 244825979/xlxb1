//
//  ASCallUserView.h
//  AS
//
//  Created by SA on 2025/5/19.
//

#import <UIKit/UIKit.h>
#import "ASCallRtcDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASCallUserView : UIView
@property (nonatomic, assign) BOOL isCaller;//是否拨打YES:接听
@property (nonatomic, strong) ASCallRtcDataModel *model;
@property (nonatomic, strong) ASUserInfoModel *userInfo;
@end

NS_ASSUME_NONNULL_END
