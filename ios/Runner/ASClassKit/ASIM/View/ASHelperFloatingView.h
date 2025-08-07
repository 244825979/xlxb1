//
//  ASHelperFloatingView.h
//  AS
//
//  Created by SA on 2025/7/4.
//

#import <UIKit/UIKit.h>
#import "ASFateHelperStatusModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASHelperFloatingView : UIView
@property (nonatomic, copy) NSString *fateHelperStatus;//状态
@property (nonatomic, copy) NSString *helperTips;//暂停后的文案
@property (nonatomic, assign) NSInteger acount;//匹配数量
@property (nonatomic, strong) ASFateHelperStatusModel *model;
@property (nonatomic, copy) VoidBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
