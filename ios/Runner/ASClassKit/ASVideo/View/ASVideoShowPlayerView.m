//
//  ASVideoShowPlayerView.m
//  AS
//
//  Created by SA on 2025/5/12.
//

#import "ASVideoShowPlayerView.h"
#import <TXLiteAVSDK_UGC/TXLiteAVSDK.h>
#import "ASVideoShowPlayController.h"

@interface ASVideoShowPlayerView ()
@property (nonatomic, strong) UIImageView *portraitViewBgImage;
@property (nonatomic, strong) UIView *portraitView;
@property (nonatomic, strong) UIImageView *videoShowIcon;
@property (nonatomic, strong) TXVodPlayer *currentPlayer;
@end

@implementation ASVideoShowPlayerView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.portraitViewBgImage];
        [self addSubview:self.portraitView];
        [self addSubview:self.videoShowIcon];
        [self initPlayer];
    }
    return self;
}

- (void)destoryPlayer {
    [self.currentPlayer stopPlay];
    [self.currentPlayer removeVideoWidget];
}

- (void)initPlayer {
    if (self.currentPlayer == nil) {
        TXVodPlayer *voidPlayer = [[TXVodPlayer alloc] init];
        TXVodPlayConfig *cfg = voidPlayer.config;
        if (cfg == nil) {
            cfg = [[TXVodPlayConfig alloc] init];
        }
        cfg.cacheFolderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/txcache"];
        cfg.maxCacheItems = 30;
        voidPlayer.config = cfg;
        voidPlayer.isAutoPlay = YES;
        [voidPlayer setMute:YES];
        voidPlayer.enableHWAcceleration = YES;
        [voidPlayer setRenderRotation:HOME_ORIENTATION_DOWN];
        [voidPlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
        voidPlayer.loop = YES;
        self.currentPlayer = voidPlayer;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    [self.portraitViewBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    [self.videoShowIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(self);
        make.height.mas_equalTo(SCALES(18));
    }];
}

- (void)setModel:(ASVideoShowDataModel *)model {
    _model = model;
    if (!kStringIsEmpty(model.video_url)) {
        [self.portraitViewBgImage sd_setImageWithURL:[NSURL URLWithString:model.cover_img_url]];
        [self.currentPlayer setupVideoWidget:self.portraitView insertIndex:0];
        int result = [self.currentPlayer startVodPlay:STRING(model.video_url)];
        if (result != 0) { }
    }
}

- (void)setIsHidenIcon:(BOOL)isHidenIcon {
    _isHidenIcon = isHidenIcon;
    self.videoShowIcon.hidden = isHidenIcon;
}

- (UIImageView *)portraitViewBgImage {
    if (!_portraitViewBgImage) {
        _portraitViewBgImage = [[UIImageView alloc] init];
        _portraitViewBgImage.contentMode = UIViewContentModeScaleAspectFill;
        _portraitViewBgImage.clipsToBounds = YES;
        _portraitViewBgImage.userInteractionEnabled = YES;
    }
    return _portraitViewBgImage;
}

- (UIView *)portraitView {
    if (!_portraitView) {
        _portraitView = [[UIView alloc] init];
        _portraitView.backgroundColor = UIColor.clearColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_portraitView addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.isPopType == YES) {
                ASVideoShowPlayController *vc = [[ASVideoShowPlayController alloc] init];
                vc.model = wself.model;
                vc.popType = kVideoPlayPersonalHome;
                [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return _portraitView;
}

- (UIImageView *)videoShowIcon {
    if (!_videoShowIcon) {
        _videoShowIcon = [[UIImageView alloc]init];
        _videoShowIcon.hidden = YES;
        _videoShowIcon.image = [UIImage imageNamed:@"video_play_bottom"];
    }
    return _videoShowIcon;
}

@end
