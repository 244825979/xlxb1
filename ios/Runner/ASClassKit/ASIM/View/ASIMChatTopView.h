//
//  ASIMChatTopView.h
//  AS
//
//  Created by SA on 2025/5/15.
//

#import <UIKit/UIKit.h>
#import "ASIMChatCardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASIMChatTopView : UIView
@property (nonatomic, strong) ASIMChatCardModel *model;
@property (nonatomic, copy) IndexNameBlock indexBlock;
@end

NS_ASSUME_NONNULL_END
