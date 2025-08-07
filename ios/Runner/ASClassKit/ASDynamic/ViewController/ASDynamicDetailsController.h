//
//  ASDynamicDetailsController.h
//  AS
//
//  Created by SA on 2025/5/8.
//

#import "ASBaseViewController.h"
#import "ASDynamicListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASDynamicDetailsController : ASBaseViewController
@property (nonatomic, copy) VoidBlock delBlock;
@property (nonatomic, strong) ASDynamicListModel *model;
@end

NS_ASSUME_NONNULL_END
