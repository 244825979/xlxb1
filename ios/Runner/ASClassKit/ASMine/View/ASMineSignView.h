//
//  ASMineSignView.h
//  AS
//
//  Created by SA on 2025/4/18.
//

#import <UIKit/UIKit.h>
#import "ASSignInModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASMineSignView : UIView
@property (nonatomic, strong) ASSignInModel *model;
@property (nonatomic, copy) VoidBlock clikedBlock;
@end

@interface ASDaySignInCell : UICollectionViewCell
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger todayCount;
@property (nonatomic, strong) ASSignInListModel *model;
@end
NS_ASSUME_NONNULL_END
