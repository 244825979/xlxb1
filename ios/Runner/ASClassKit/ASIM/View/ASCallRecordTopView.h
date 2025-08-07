//
//  ASCallRecordTopView.h
//  AS
//
//  Created by SA on 2025/5/15.
//

#import <UIKit/UIKit.h>
#import "ASCallRecommendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASCallRecordTopView : UIView
@property (nonatomic, strong) NSArray *lists;
@property (nonatomic, copy) VoidBlock closeBlock;
@end

@interface ASCallRecommendCell : UICollectionViewCell
@property (nonatomic, strong) ASCallRecommendModel *model;
@end

NS_ASSUME_NONNULL_END
