//
//  ASDaySignInAlertView.h
//  AS
//
//  Created by SA on 2025/4/18.
//

#import <UIKit/UIKit.h>
#import "ASSignInModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASDaySignInAlertView : UIView
//确认
@property (nonatomic, copy) void (^affirmBlock)(void);
//构造方法 当天签到成功弹窗
- (instancetype)initWithDaySignInModel:(nullable ASSignInGiftModel *)model;
//构造方法 签到列表弹窗
- (instancetype)initWithSignInListModel:(nullable ASSignInModel *)model;
@end

NS_ASSUME_NONNULL_END
