//
//  ASInvitePosterAlertView.h
//  AS
//
//  Created by SA on 2025/7/25.
//

#import <UIKit/UIKit.h>
#import "ASWebJsBodyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASInvitePosterAlertView : UIView
@property (nonatomic, strong) ASWebJsBodyModel *bodyModel;
@property (nonatomic, copy) VoidBlock affirmBlock;
@property (nonatomic, copy) VoidBlock cancelBlock;
@end

@interface ASInvitePosterCell : UICollectionViewCell
@property (nonatomic, strong) ASWebPosterListModel *model;
@end
NS_ASSUME_NONNULL_END
