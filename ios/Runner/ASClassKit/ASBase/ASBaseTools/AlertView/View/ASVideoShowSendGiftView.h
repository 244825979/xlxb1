//
//  ASVideoShowSendGiftView.h
//  AS
//
//  Created by SA on 2025/5/13.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ASVideoShowSendGiftView : UIView
@property (nonatomic, strong) ASVideoShowDataModel *model;
@property (nonatomic, copy) void (^cancelBlock)(void);//取消
@end

@interface ASVideoShowAwardGiftCell : UICollectionViewCell
@property (nonatomic, strong) ASGiftListModel *giftModel;
@property (nonatomic, strong) UIView *bgView;
@end
NS_ASSUME_NONNULL_END
