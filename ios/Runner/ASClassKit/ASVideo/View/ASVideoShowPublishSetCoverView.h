//
//  ASVideoShowPublishSetCoverView.h
//  AS
//
//  Created by SA on 2025/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASVideoShowPublishSetCoverView : UIView
@property (nonatomic, strong) NSArray<UIImage *> *images;
@property (nonatomic, copy) ActionBlock backBlock;
@end

@interface ASVideoShowCoverCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *coverImage;
@end
NS_ASSUME_NONNULL_END
