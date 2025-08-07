//
//  ASBalanceDeficiencyAlertView.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASBalanceDeficiencyAlertView : UIView
@property (nonatomic, copy) VoidBlock cancelBlock;
- (instancetype)initBalanceDeficiencyViewWithModel:(ASPayGoodsDataModel *)model
                                             scene:(NSString *)scene;
@end

@interface ASBalanceListCell : UICollectionViewCell
@property (nonatomic, strong) ASGoodsListModel *model;
@end
NS_ASSUME_NONNULL_END
