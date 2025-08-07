//
//  ASVersionUpgradeAlertView.h
//  AS
//
//  Created by SA on 2025/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASVersionUpgradeAlertView : UIView
@property (nonatomic, copy) VoidBlock affirmBlock;
@property (nonatomic, copy) VoidBlock cancelBlock;
- (instancetype)initAppVersionViewWithModel:(ASVersionModel *)model;
@end

NS_ASSUME_NONNULL_END
