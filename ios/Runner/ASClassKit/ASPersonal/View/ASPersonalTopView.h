//
//  ASPersonalTopView.h
//  AS
//
//  Created by SA on 2025/4/24.
//

#import <UIKit/UIKit.h>
#import <TXLiteAVSDK_UGC/TXLiteAVSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASPersonalTopView : UIView
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, strong) ASUserInfoModel *homeModel;
@property (nonatomic, strong) TXVodPlayer *currentPlayer;
@property (nonatomic, copy) NSString *userRemarkStr;
@end

NS_ASSUME_NONNULL_END
