//
//  ASCenterNotifyWebPopView.h
//  AS
//
//  Created by SA on 2025/6/19.
//

#import <UIKit/UIKit.h>
#import "ASCenterNotifyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASCenterNotifyWebPopView : UIView
@property (nonatomic, copy) VoidBlock closeBlock;
- (instancetype)initCenterNotifyWebWithModel:(ASCenterNotifyModel *)model;
@end

NS_ASSUME_NONNULL_END
