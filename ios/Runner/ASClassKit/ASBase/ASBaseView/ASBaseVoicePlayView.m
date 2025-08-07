//
//  ASBaseVoicePlayView.m
//  AS
//
//  Created by SA on 2025/4/21.
//

#import "ASBaseVoicePlayView.h"

@interface ASBaseVoicePlayView ()
@property (nonatomic, strong) UIButton *playerBtn;
@property (nonatomic, strong) UILabel *second;
@property (nonatomic, strong) RACDisposable *timerDisposable;
@property (nonatomic, assign) NSInteger timers;
@property (nonatomic, strong) UIImageView *bgView;
@end

@implementation ASBaseVoicePlayView
- (void)dealloc {
    [self.timerDisposable dispose];
    [[ASAudioPlayManager shared] stop];
}

- (instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.bgView];
    [self addSubview:self.playerBtn];
    [self addSubview:self.second];
    
    kWeakSelf(self);
    //播放完成
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"AudioPlayCompletionNotifiction" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        wself.playerBtn.selected = NO;
        /* 关闭计时器 */
        [wself.timerDisposable dispose];
        [[ASAudioPlayManager shared] stop];
        wself.timers = wself.model.voice_time;
        wself.second.text = [NSString stringWithFormat:@"%zds",wself.model.voice_time];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    if (self.type == 0) {
        [self.playerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(2));
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(SCALES(24));
        }];
        
        [self.second mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(SCALES(-6));
            make.centerY.equalTo(self);
        }];
    } else if (self.type == 1) {
        [self.playerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(4));
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(SCALES(21));
        }];
        
        [self.second mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(SCALES(-14));
            make.centerY.equalTo(self);
        }];
    } else {
        [self.playerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(2));
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(SCALES(24));
        }];
        
        [self.second mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(SCALES(-8));
            make.centerY.equalTo(self);
        }];
    }
}

- (void)setModel:(ASVoiceModel *)model {
    _model = model;
    self.second.text = [NSString stringWithFormat:@"%zds",model.voice_time];
    self.timers = model.voice_time;
    self.playerBtn.selected = NO;
}

- (void)setType:(NSInteger)type {
    _type = type;
}

- (UILabel *)second {
    if (!_second) {
        _second = [[UILabel alloc] init];
        _second.textColor = UIColor.whiteColor;
        _second.font = TEXT_FONT_12;
    }
    return _second;
}

- (UIButton *)playerBtn {
    if (!_playerBtn) {
        _playerBtn = [[UIButton alloc]init];
        [_playerBtn setImage:[UIImage imageNamed:@"voice_stop"] forState:UIControlStateNormal];
        [_playerBtn setImage:[UIImage imageNamed:@"voice_play"] forState:UIControlStateSelected];
        _playerBtn.userInteractionEnabled = NO;
    }
    return _playerBtn;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
        _bgView.userInteractionEnabled = YES;
        _bgView.image = [UIImage imageNamed:@"button_bg"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_bgView addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.playerBtn.selected == NO) {//当前没有播放的状态
            wself.playerBtn.selected = YES;
            [[ASAudioPlayManager shared] playFromURL:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, wself.model.voice]];
            /* 定义计时器监听 */
            wself.timerDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
                wself.timers--;
                wself.second.text = [NSString stringWithFormat:@"%zds",wself.timers];
                if (wself.timers == 0) {//播放结束
                    wself.playerBtn.selected = NO;
                    /* 关闭计时器 */
                    [wself.timerDisposable dispose];
                    [[ASAudioPlayManager shared] stop];
                    wself.timers = wself.model.voice_time;
                    wself.second.text = [NSString stringWithFormat:@"%zds",wself.model.voice_time];
                }
            }];
            return;
        }
        if (wself.playerBtn.selected == YES) {//当前是播放的状态
            wself.playerBtn.selected = NO;
            [[ASAudioPlayManager shared] stop];
            /* 关闭计时器 */
            [wself.timerDisposable dispose];
            wself.timers = wself.model.voice_time;
            wself.second.text = [NSString stringWithFormat:@"%zds",wself.model.voice_time];
            return;
        }
        }];
    }
    return _bgView;
}

@end
