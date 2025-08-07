//
//  ASActivityPopView.h
//  AS
//
//  Created by SA on 2025/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASActivityPopView : UIView
@property (nonatomic, copy) VoidBlock cancelBlock;
@property (nonatomic, copy) VoidBlock affirmBlock;
- (instancetype)initActivityPopWithModel:(ASBannerModel *)model;
@end

NS_ASSUME_NONNULL_END
