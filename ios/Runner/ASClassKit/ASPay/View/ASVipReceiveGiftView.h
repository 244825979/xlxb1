//
//  ASVipReceiveGiftView.h
//  AS
//
//  Created by SA on 2025/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASVipReceiveGiftView : UIView
@property (nonatomic, strong) ASGiftListModel *model;
@property (nonatomic, copy) VoidBlock clikedBlock;
@end

NS_ASSUME_NONNULL_END
