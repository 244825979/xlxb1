//
//  ASSendGiftView.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>
#import "ASGiftDataModel.h"
#import "ASGiftTitleDataModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 礼物类型
typedef NS_ENUM(NSInteger, ASGiftType) {
    kSendGiftTypeIM = 0,            //IM发送礼物
    kSendGiftTypeCall = 1,          //通话音视频发送礼物
};

@interface ASSendGiftView : UIView
@property (nonatomic, copy) void (^cancelBlock)(void);
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, strong) NSArray<ASGiftTitleDataModel *> *titles;
@property (nonatomic, copy) void (^sendBlock)(NSString *giftID, NSString *giftCount, NSString *giftTypeID, NSString *selectGiftSvga);
@end

@interface ASGiftCell : UICollectionViewCell
@property (nonatomic, strong) ASGiftListModel *model;
@property (nonatomic, copy) NSString *giftTitle;
@end

NS_ASSUME_NONNULL_END
