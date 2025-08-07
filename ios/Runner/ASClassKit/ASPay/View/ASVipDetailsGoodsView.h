//
//  ASVipDetailsGoodsView.h
//  AS
//
//  Created by SA on 2025/6/27.
//

#import <UIKit/UIKit.h>
#import "ASVipDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASVipDetailsGoodsView : UIView
@property (nonatomic, strong) NSArray<ASVipGoodsModel *> *list;
@property (nonatomic, copy) void (^itemBlock)(ASVipGoodsModel *model);
@end

@interface ASVipGoodsItemView : UIView
@property (nonatomic, copy) void (^itemBlock)(ASVipGoodsItemView *view);
@property (nonatomic, strong) ASVipGoodsModel *model;
@property (nonatomic, assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
