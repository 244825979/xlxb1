//
//  ASMineVipView.h
//  AS
//
//  Created by SA on 2025/4/18.
//

#import <UIKit/UIKit.h>
#import "ASMineUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ASMineVipView : UIView
@property (nonatomic, strong) ASMineUserModel *model;
@property (nonatomic, copy) IndexNameBlock indexNameBlock;
@end

NS_ASSUME_NONNULL_END
