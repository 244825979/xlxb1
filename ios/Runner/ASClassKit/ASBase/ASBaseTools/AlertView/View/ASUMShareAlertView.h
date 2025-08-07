//
//  ASUMShareAlertView.h
//  AS
//
//  Created by SA on 2025/7/11.
//

#import <UIKit/UIKit.h>
#import <UMShare/UMShare.h>
#import "ASWebJsBodyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASUMShareAlertView : UIView
@property (nonatomic, copy) void (^affirmBlock)(UMSocialPlatformType platformType, id value);
@property (nonatomic, copy) VoidBlock cancelBlock;
@property (nonatomic, copy) ASWebJsBodyModel *bodyModel;//数据
@end

NS_ASSUME_NONNULL_END
