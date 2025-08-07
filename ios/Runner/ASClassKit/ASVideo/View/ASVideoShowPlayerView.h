//
//  ASVideoShowPlayerView.h
//  AS
//
//  Created by SA on 2025/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASVideoShowPlayerView : UIView
@property (nonatomic, strong) ASVideoShowDataModel *model;
@property (nonatomic, assign) BOOL isHidenIcon;//是否隐藏视频秀的icon
@property (nonatomic, assign) BOOL isPopType;//是否跳转主页
- (void)destoryPlayer;
@end

NS_ASSUME_NONNULL_END
