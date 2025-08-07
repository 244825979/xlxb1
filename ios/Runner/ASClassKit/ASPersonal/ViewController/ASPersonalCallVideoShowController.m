//
//  ASPersonalCallVideoShowController.m
//  AS
//
//  Created by SA on 2025/7/2.
//

#import "ASPersonalCallVideoShowController.h"
#import "ASCallUserView.h"
#import "ASCallItemView.h"
#import "ASVideoShowPlayerView.h"
#import "ASRtcCallRingManager.h"

@interface ASPersonalCallVideoShowController ()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *icon;//邀请图标
@property (nonatomic, strong) UILabel *titleLabel;//邀请标题
@property (nonatomic, strong) ASCallUserView *callUserView;//用户显示view
@property (nonatomic, strong) ASCallItemView *closeBtn;//挂断按钮
@property (nonatomic, strong) ASCallItemView *answerBtn;//接听按钮
@property (nonatomic, strong) ASVideoShowPlayerView *videoPlayerView;
/**数据*/
@property (nonatomic, strong) RACDisposable *timerDisposable;//30秒倒计时
@property (nonatomic, assign) int timers;//计时时间
@end

@implementation ASPersonalCallVideoShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    self.timers = 30;
    [[ASRtcCallRingManager shared] play];
    [self createUI];
    kWeakSelf(self);
    self.timerDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        wself.timers--;
        if (wself.timers == 0) {
            [wself closeViewController];
        }
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"updateBalanceNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [wself closeViewController];
    }];
}

- (void)createUI {
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (!kObjectIsEmpty(self.videoShowModel)) {
        [self.bgView addSubview:self.videoPlayerView];
        [self.videoPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bgView);
        }];
        self.videoPlayerView.model = self.videoShowModel;
    }
    [self.bgView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.top.mas_equalTo(STATUS_BAR_HEIGHT + SCALES(28));
        make.width.height.mas_equalTo(SCALES(32));
    }];
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(SCALES(10));
        make.centerY.equalTo(self.icon);
    }];
    [self.bgView addSubview:self.callUserView];
    [self.callUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(SCALES(50));
        make.centerX.equalTo(self.bgView);
        make.width.height.mas_equalTo(SCALES(200));
    }];
    [self.bgView addSubview:self.closeBtn];
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(70));
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-TAB_BAR_MAGIN - SCALES(45));
        make.size.mas_equalTo(CGSizeMake(SCALES(71), SCALES(100)));
    }];
    [self.bgView addSubview:self.answerBtn];
    [self.answerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(SCALES(-70));
        make.centerY.equalTo(self.closeBtn);
        make.size.mas_equalTo(CGSizeMake(SCALES(71), SCALES(100)));
    }];
}

- (void)closeViewController {
    kWeakSelf(self);
    [self dismissViewControllerAnimated:YES completion:^{
        if (!kObjectIsEmpty(self.videoShowModel)) {
            [wself.videoPlayerView destoryPlayer];
        }
        [wself.timerDisposable dispose];
        [[ASRtcCallRingManager shared] stop];
    }];
}

- (ASCallUserView *)callUserView {
    if (!_callUserView) {
        _callUserView = [[ASCallUserView alloc]init];
        _callUserView.userInfo = self.userModel;
    }
    return _callUserView;
}

- (ASVideoShowPlayerView *)videoPlayerView {
    if (!_videoPlayerView) {
        _videoPlayerView = [[ASVideoShowPlayerView alloc] init];
    }
    return _videoPlayerView;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.image = [UIImage imageNamed:@"personal_call1"];
    }
    return _icon;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"邀请你视频通话";
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = TEXT_FONT_16;
    }
    return _titleLabel;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
        [_bgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, self.userModel.avatar]]];
        _bgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgView.userInteractionEnabled = YES;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [_bgView addSubview:effectView];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_bgView);
        }];
    }
    return _bgView;
}

- (ASCallItemView *)answerBtn {
    if (!_answerBtn) {
        _answerBtn = [[ASCallItemView alloc]init];
        _answerBtn.title.text = @"接听";
        _answerBtn.icon.image = [UIImage imageNamed:@"call_answer"];
        kWeakSelf(self);
        _answerBtn.actionBlock = ^{
            wself.timers = 30;
            [wself.timerDisposable dispose];
            [[ASRtcCallRingManager shared] stop];
            [ASMyAppCommonFunc balanceDeficiencyPopViewWithPayScene:Pay_Scene_VideoCalling cancel:^{
                wself.timerDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
                    wself.timers--;
                    if (wself.timers == 0) {
                        [wself closeViewController];
                    }
                }];
            }];
        };
    }
    return _answerBtn;
}

- (ASCallItemView *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[ASCallItemView alloc] init];
        _closeBtn.title.text = @"拒绝";
        _closeBtn.icon.image = [UIImage imageNamed:@"call_close"];
        kWeakSelf(self);
        _closeBtn.actionBlock = ^{
            [wself closeViewController];
        };
    }
    return _closeBtn;
}
@end
