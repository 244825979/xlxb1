//
//  ASVipUnlockAlertView.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASVipUnlockAlertView : UIView
@property (nonatomic, copy) VoidBlock affirmBlock;
//解锁vip
- (instancetype)initVipUnlock;
@end

NS_ASSUME_NONNULL_END
