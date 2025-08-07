//
//  ASDynamicListTopView.h
//  AS
//
//  Created by SA on 2025/5/7.
//

#import <UIKit/UIKit.h>
#import "ASHomeUserListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ASDynamicListTopView : UIView
@property (nonatomic, strong) NSArray *lists;
@end

@interface ASDynamicLikeListItemCell : UICollectionViewCell
@property (nonatomic, strong) ASHomeUserListModel *model;
@end

NS_ASSUME_NONNULL_END
