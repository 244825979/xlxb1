//
//  ASVipGradeListView.h
//  AS
//
//  Created by SA on 2025/6/27.
//

#import <UIKit/UIKit.h>
#import "ASVipDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASVipGradeListView : UIView
@property (nonatomic, strong) NSArray<ASVipPrivilegesModel *> *lists;
@end

@interface ASVipGradeItemCell : UICollectionViewCell
@property (nonatomic, strong) ASVipPrivilegesModel *model;
@end

NS_ASSUME_NONNULL_END
