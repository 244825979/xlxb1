//
//  ASHomeOnlineUserListCell.h
//  AS
//
//  Created by SA on 2025/8/1.
//

#import <UIKit/UIKit.h>
#import "ASHomeVoicePlayView.h"
#import "ASHomeUserListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ASHomeOnlineUserListCell : UITableViewCell
@property (nonatomic, strong) ASHomeUserListModel *model;
@property (nonatomic, assign) NSInteger isBeckon;//是否招呼
@property (nonatomic, copy) void(^actionBlack)(ASHomeVoicePlayView *playView);
@property (nonatomic, strong) ASHomeVoicePlayView *playView;//播放语音
@end

NS_ASSUME_NONNULL_END
