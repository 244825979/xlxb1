//
//  ASVideoShowMaskView.h
//  AS
//
//  Created by SA on 2025/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ASVideoShowMaskDelegate <NSObject>
- (void)clickScreen:(UITapGestureRecognizer *)gestureRecognizer;
- (void)cellClickBackBtn;
- (void)cellClickPublishBtn:(UIButton *)button;
- (void)cellClickVoiceOnOffBtn:(UIButton *)button;
- (void)cellClickVoicePause;
- (void)cellClickVoiceAttention:(BOOL)isAttention videoShowModel:(ASVideoShowDataModel *)model;
@optional
@end

@interface ASVideoShowMaskView : UIView
@property (nonatomic, weak) id<ASVideoShowMaskDelegate> delegate;
@property (nonatomic, strong) ASVideoShowDataModel *model;
@property (nonatomic, assign) VideoPlayListType popType;
@property (nonatomic, retain) UIButton *playBtn;
@property (nonatomic, assign) BOOL isSilence;//是否开启静音，默认NO不开启，YES表示开启
@property (nonatomic, strong) UIButton *silenceBtn;
@property (nonatomic, assign) BOOL isFollow;//是否关注
@property (nonatomic, copy) NSString *notifictionAcount;
@end

NS_ASSUME_NONNULL_END
