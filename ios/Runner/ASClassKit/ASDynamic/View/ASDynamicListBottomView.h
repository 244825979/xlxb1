//
//  ASDynamicListBottomView.h
//  AS
//
//  Created by SA on 2025/5/7.
//

#import <UIKit/UIKit.h>
#import "ASDynamicListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASDynamicListBottomView : UIView
@property (nonatomic, strong) UIButton *more;
@property (nonatomic, strong) ASDynamicListModel *model;
@property (nonatomic, copy) IndexNameBlock clikedBlock;
@end

NS_ASSUME_NONNULL_END
