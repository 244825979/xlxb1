//
//  ASIMActivityFloatingView.h
//  AS
//
//  Created by SA on 2025/7/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASIMActivityFloatingView : UIView
@property (nonatomic, strong) ASBannerModel *model;
@property (nonatomic, copy) VoidBlock closeBlock;
@end

NS_ASSUME_NONNULL_END
