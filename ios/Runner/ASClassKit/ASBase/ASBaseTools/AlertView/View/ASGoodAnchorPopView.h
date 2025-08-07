//
//  ASGoodAnchorPopView.h
//  AS
//
//  Created by SA on 2025/6/11.
//

#import <UIKit/UIKit.h>
#import "ASGoodAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASGoodAnchorPopView : UIView
@property (nonatomic, strong) ASGoodAnchorModel *model;
@property (nonatomic, copy) VoidBlock cancelBlock;
@end

@interface ASGoodAnchorMessageView : UIView
@property (nonatomic, strong) ASGoodAnchorModel *model;
@end
NS_ASSUME_NONNULL_END
