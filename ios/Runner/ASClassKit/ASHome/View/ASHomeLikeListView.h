//
//  ASHomeLikeListView.h
//  AS
//
//  Created by SA on 2025/4/16.
//

#import <UIKit/UIKit.h>
#import "ASHomeUserListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASHomeLikeListView : UIView
@property (nonatomic, strong) NSArray *likes;
@property (nonatomic, copy) VoidBlock actionBlock;
@end

@interface ASHomeLikeListItemCell : UICollectionViewCell
@property (nonatomic, assign) NSInteger isBeckon;//是否招呼
@property (nonatomic, strong) ASHomeUserListModel *model;
@end
NS_ASSUME_NONNULL_END
