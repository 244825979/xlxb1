//
//  ASBaseVoicePlayView.h
//  AS
//
//  Created by SA on 2025/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASBaseVoicePlayView : UIView
@property (nonatomic, strong) ASVoiceModel *model;
@property (nonatomic, assign) NSInteger type;//0编辑页声音展示 1个人主页播放 2便捷用语
@end

NS_ASSUME_NONNULL_END
