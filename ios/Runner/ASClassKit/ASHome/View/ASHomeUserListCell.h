//
//  ASHomeUserListCell.h
//  AS
//
//  Created by SA on 2025/4/16.
//

#import <UIKit/UIKit.h>
#import "ASHomeUserListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASHomeUserListCell : UICollectionViewCell
@property (nonatomic, strong) ASHomeUserListModel *model;
@property (nonatomic, assign) NSInteger isBeckon;//是否招呼
@property (nonatomic, assign) BOOL isCall;//视频类型
@end

NS_ASSUME_NONNULL_END
