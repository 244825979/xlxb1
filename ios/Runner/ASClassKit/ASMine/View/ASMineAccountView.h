//
//  ASMineAccountView.h
//  AS
//
//  Created by SA on 2025/4/18.
//

#import <UIKit/UIKit.h>
#import "ASAccountMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASMineAccountView : UIView
@property (nonatomic, strong) ASAccountMoneyModel *model;
@property (nonatomic, copy) IndexNameBlock indexNameBlock;
@end

@interface ASMineAccountItemView : UIView
@property (nonatomic, copy) NSString *acount;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIImageView *icon;
@end

NS_ASSUME_NONNULL_END
