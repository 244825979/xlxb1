//
//  ASIntimacyUpgradeAlertView.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>
#import "ASIMSystemNotifyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASIntimacyUpgradeAlertView : UIView
//确认
@property (nonatomic, copy) void (^affirmBlock)(void);
//构造方法 亲密度升级弹窗
- (instancetype)initIntimacyUpgradeWithModel:(ASIMSystemNotifyModel *)model;

@end

NS_ASSUME_NONNULL_END
