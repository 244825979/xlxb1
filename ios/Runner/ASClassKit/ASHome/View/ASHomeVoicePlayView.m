//
//  ASHomeVoicePlayView.m
//  AS
//
//  Created by SA on 2025/8/1.
//

#import "ASHomeVoicePlayView.h"
#import <SVGAImageView.h>

@interface ASHomeVoicePlayView ()
@property (nonatomic, strong) UIImageView *playState;
@property (nonatomic, strong) SVGAImageView *playIcon;
@property (nonatomic, strong) UILabel *second;
@property (nonatomic, assign) NSInteger timers;//计时时间
@end

@implementation ASHomeVoicePlayView

- (void)dealloc {
    [self.timerDisposable dispose];
    [[ASAudioPlayManager shared] stop];
}

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.playState];
        [self addSubview:self.playIcon];
        [self addSubview:self.second];
        kWeakSelf(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.actionBlack) {
                wself.actionBlack();
            }
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.playState mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.width.height.mas_equalTo(SCALES(18));
    }];
    [self.playIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playState.mas_right).offset(SCALES(1));
        make.centerY.equalTo(self);
        make.height.mas_equalTo(SCALES(18));
        make.width.mas_equalTo(SCALES(60));
    }];
    [self.second mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playIcon.mas_right).offset(SCALES(2));
        make.centerY.equalTo(self);
        make.height.mas_equalTo(SCALES(18));
    }];
}

- (void)setModel:(ASVoiceModel *)model {
    _model = model;
    self.second.text = [NSString stringWithFormat:@"%zd''",model.voice_time];
    self.timers = model.voice_time;
}

//播放动画
- (void)playAnimating {
    if (self.isPlaying == YES) {//如果正在播放中，进行暂停
        [self stopAnimating];
        return;
    }
    kWeakSelf(self);
    self.isPlaying = YES;
    /* 定义计时器监听 */
    self.timerDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        wself.timers--;
        wself.second.text = [NSString stringWithFormat:@"%zd''",wself.timers];
        if (wself.timers == 0) {
            [wself stopAnimating];
        }
    }];
}

//停止动画
- (void)stopAnimating {
    self.isPlaying = NO;
    [self.timerDisposable dispose];
    self.timers = self.model.voice_time;
    self.second.text = [NSString stringWithFormat:@"%zd''",self.model.voice_time];
}

- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    kWeakSelf(self);
    if (isPlaying) {
        self.playState.image = [UIImage imageNamed:@"home_voice_stop"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself.playIcon startAnimation];
        });
    } else {
        [self.playIcon stopAnimation];
        self.playIcon.imageName = @"home_voice_play";
        self.playState.image = [UIImage imageNamed:@"home_voice_play"];
    }
}

- (UILabel *)second {
    if (!_second) {
        _second = [[UILabel alloc] init];
        _second.textColor = MAIN_COLOR;
        _second.font = TEXT_MEDIUM(14);
    }
    return _second;
}

- (UIImageView *)playState {
    if (!_playState) {
        _playState = [[UIImageView alloc]init];
        _playState.image = [UIImage imageNamed:@"home_voice_play"];
    }
    return _playState;
}

- (SVGAImageView *)playIcon {
    if (!_playIcon) {
        _playIcon = [[SVGAImageView alloc] init];
        _playIcon.imageName = @"home_voice_play";
    }
    return _playIcon;
}

@end
