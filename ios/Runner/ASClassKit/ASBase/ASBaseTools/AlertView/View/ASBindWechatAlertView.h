//
//  ASBindWechatAlertView.h
//  AS
//
//  Created by SA on 2025/7/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASBindWechatAlertView : UIView
@property (nonatomic, copy) VoidBlock affirmBlock;
@property (nonatomic, copy) VoidBlock closeBlock;
@end

NS_ASSUME_NONNULL_END
