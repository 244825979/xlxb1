//
//  ASDynamicListMediaView.h
//  AS
//
//  Created by SA on 2025/5/7.
//

#import <UIKit/UIKit.h>
#import "ASDynamicListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASDynamicListMediaView : UIView
@property (nonatomic, strong) ASDynamicListModel *model;
@property (nonatomic, copy) void (^imageBlock)(ASDynamicMediaType mediaType, NSInteger index, UIImage *image);
@end

@interface ASDynamicMediaCell : UICollectionViewCell
@property (nonatomic, copy) ASDynamicPictureModel *model;
@property (nonatomic, strong) UIImageView *coverImage;
@end
NS_ASSUME_NONNULL_END
