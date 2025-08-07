//
//  ASVideoShowPlayController.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASBaseViewController.h"
#import <TXLiteAVSDK_UGC/TXLiteAVSDK.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VideoPlayListType) {
    kVideoPlayTabbar = 0,               //列表播放
    kVideoPlayPersonalHome = 1,         //个人主页进入
    kVideoPlayMyListVideo = 2,          //我的个人列表进入
};

@interface ASVideoShowPlayController : ASBaseViewController
@property (nonatomic, strong) ASVideoShowDataModel *model;
@property (nonatomic, assign) VideoPlayListType popType;
@property (nonatomic, strong) TXVodPlayer *currentPlayer;
@end

NS_ASSUME_NONNULL_END
