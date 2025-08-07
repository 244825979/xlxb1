//
//  ASNewUserPopView.h
//  AS
//
//  Created by AS on 2025/3/7.
//

#import <UIKit/UIKit.h>
#import "ASNewUserGiftModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASNewUserPopView : UIView
- (instancetype)initNewUserGiftViewWithModel:(ASNewUserGiftModel *)model;
@property (nonatomic, copy) VoidBlock closeBlock;
@end

@interface ASNewUserGiftView : UIView
@property (nonatomic, strong) ASNewUserGiftListModel *model;
@end


NS_ASSUME_NONNULL_END
