//
//  ASCallVoiceItemView.m
//  AS
//
//  Created by SA on 2025/5/19.
//

#import "ASCallVoiceItemView.h"

@interface ASCallVoiceItemView ()
@property (nonatomic, strong) UILabel *waitText;
@property (nonatomic, strong) ASCallItemView *closeBtn;
@property (nonatomic, strong) ASCallItemView *answerBtn;
@property (nonatomic, strong) ASCallItemView *loudspeakerBtn;
@property (nonatomic, strong) ASCallItemView *microphoneBtn;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UILabel *moneyHintLabel;
@property (nonatomic, strong) UIButton *giftBtn;
/**数据**/
@property (nonatomic, assign) int callTimers;
@end

@implementation ASCallVoiceItemView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.waitText];
        [self addSubview:self.closeBtn];
        [self addSubview:self.answerBtn];
        [self addSubview:self.loudspeakerBtn];
        [self addSubview:self.microphoneBtn];
        [self addSubview:self.timerLabel];
        [self addSubview:self.moneyHintLabel];
        [self addSubview:self.giftBtn];
        if (USER_INFO.gender == 2) {
            [self addSubview:self.goPayView];
        }
        self.isOpenMicrophone = YES;
        self.isOpenLoudspeaker = YES;
    }
    return self;
}

- (void)setItemType:(ASCallItemType)itemType {
    _itemType = itemType;
    self.waitText.hidden = YES;
    self.closeBtn.hidden = YES;
    self.answerBtn.hidden = YES;
    self.loudspeakerBtn.hidden = YES;
    self.microphoneBtn.hidden = YES;
    self.timerLabel.hidden = YES;
    self.moneyHintLabel.hidden = YES;
    self.timerLabel.hidden = YES;
    self.giftBtn.hidden = YES;
    switch (itemType) {
        case kItemTypeCallNoCalling://拨打，未接通
        {
            self.closeBtn.title.text = @"取消";
            self.closeBtn.hidden = NO;
            [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.mas_bottom).offset(-TAB_BAR_MAGIN - SCALES(40));
                make.size.mas_equalTo(CGSizeMake(SCALES(71), SCALES(100)));
            }];
            self.waitText.text = @"正在等待对方接受邀请...";
            self.waitText.hidden = NO;
            [self.waitText mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.closeBtn.mas_top).offset(SCALES(-28));
                make.height.mas_equalTo(SCALES(24));
            }];
            self.moneyHintLabel.hidden = NO;
            [self.moneyHintLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.waitText.mas_top).offset(SCALES(-34));
                make.height.mas_equalTo(SCALES(28));
            }];
        }
            break;
        case kItemTypeAnswerNoCalling://接听，未接通
        {
            self.closeBtn.hidden = NO;
            [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(SCALES(72));
                make.bottom.equalTo(self.mas_bottom).offset(-TAB_BAR_MAGIN - SCALES(40));
                make.size.mas_equalTo(CGSizeMake(SCALES(71), SCALES(100)));
            }];
            self.answerBtn.hidden = NO;
            [self.answerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(SCALES(-72));
                make.centerY.equalTo(self.closeBtn);
                make.size.mas_equalTo(CGSizeMake(SCALES(70), SCALES(100)));
            }];
            self.waitText.hidden = NO;
            self.waitText.text = @"正在邀请你语音通话...";
            [self.waitText mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.closeBtn.mas_top).offset(SCALES(-28));
                make.height.mas_equalTo(SCALES(24));
            }];
            self.moneyHintLabel.hidden = NO;
            [self.moneyHintLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.waitText.mas_top).offset(SCALES(-34));
                make.height.mas_equalTo(SCALES(28));
            }];
        }
            break;
        case kItemTypeCallCalling://拨打视频，已接通
        {
            self.closeBtn.hidden = NO;
            self.closeBtn.title.text = @"挂断";
            [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.mas_bottom).offset(-TAB_BAR_MAGIN - SCALES(40));
                make.size.mas_equalTo(CGSizeMake(SCALES(71), SCALES(100)));
            }];
            self.loudspeakerBtn.hidden = NO;//扬声器开关
            [self.loudspeakerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.closeBtn.mas_right).offset(SCALES(40));
                make.centerY.width.height.equalTo(self.closeBtn);
            }];
            self.microphoneBtn.hidden = NO;//麦克风开关
            [self.microphoneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.closeBtn.mas_left).offset(SCALES(-40));
                make.centerY.width.height.equalTo(self.closeBtn);
            }];
            self.giftBtn.hidden = NO;
            [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.loudspeakerBtn.mas_top).offset(-SCALES(30));
                make.centerX.equalTo(self.loudspeakerBtn);
                make.height.width.mas_equalTo(SCALES(71));
            }];
            self.timerLabel.hidden = NO;
            [self.timerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.giftBtn);
                make.centerX.equalTo(self.closeBtn);
                make.height.mas_equalTo(SCALES(21));
            }];
            if (USER_INFO.gender == 2) {
                [self.goPayView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(SCALES(15));
                    make.bottom.equalTo(self.giftBtn.mas_top).offset(SCALES(-20));
                    make.width.mas_equalTo(SCALES(240));
                    make.height.mas_equalTo(SCALES(53));
                }];
            }
            kWeakSelf(self);
            self.callTimerDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
                wself.callTimers++;
                wself.timerLabel.text = [ASCommonFunc timeFormatted:wself.callTimers];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)setIsOpenLoudspeaker:(BOOL)isOpenLoudspeaker {
    _isOpenLoudspeaker = isOpenLoudspeaker;
    if (isOpenLoudspeaker) {
        self.loudspeakerBtn.title.text = @"扬声器已开";
        self.loudspeakerBtn.icon.image = [UIImage imageNamed:@"call_laba"];
    } else {
        self.loudspeakerBtn.title.text = @"扬声器已关";
        self.loudspeakerBtn.icon.image = [UIImage imageNamed:@"call_laba1"];
    }
}

- (void)setIsOpenMicrophone:(BOOL)isOpenMicrophone {
    _isOpenMicrophone = isOpenMicrophone;
    if (_isOpenMicrophone) {
        self.microphoneBtn.title.text = @"麦克风已开";
        self.microphoneBtn.icon.image = [UIImage imageNamed:@"call_maikefeng"];
    } else {
        self.microphoneBtn.title.text = @"麦克风已关";
        self.microphoneBtn.icon.image = [UIImage imageNamed:@"call_maikefeng1"];
    }
}

- (void)setMoneyText:(NSString *)moneyText {
    _moneyText = moneyText;
    if (USER_INFO.gender == 2) {
        self.moneyHintLabel.text = [NSString stringWithFormat:@"    %@    ", STRING(moneyText)];
        self.moneyHintLabel.hidden = kStringIsEmpty(moneyText) ? YES : NO;
    } else {
        self.moneyHintLabel.hidden = YES;
    }
}

- (UILabel *)waitText {
    if (!_waitText) {
        _waitText = [[UILabel alloc]init];
        _waitText.text = @"正在等待对方接受邀请...";
        _waitText.textColor = UIColor.whiteColor;
        _waitText.font = TEXT_FONT_16;
        _waitText.textAlignment = NSTextAlignmentCenter;
    }
    return _waitText;
}

- (ASCallItemView *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[ASCallItemView alloc] init];
        _closeBtn.title.text = @"取消";
        _closeBtn.icon.image = [UIImage imageNamed:@"call_close"];
        kWeakSelf(self);
        _closeBtn.actionBlock = ^{
            if (NERtcCallKit.sharedInstance.callStatus == NERtcCallStatusInCall) {//已接通，主动挂断
                [ASAlertViewManager defaultPopTitle:USER_INFO.gender == 1 ? @"温馨提示" : @"是否要挂断？" content:USER_INFO.gender == 1 ? @"多次主动挂断音视频通话，会降低你的推荐值以及女神星级。如果发现为恶意、无故挂断导致对方金币损失，平台会进行封号处理！请真诚交友。" : @"" left:@"挂断" right:@"继续聊" affirmAction:^{
                    [NERtcCallKit.sharedInstance hangup:^(NSError * _Nullable error) {
                        if (error) {
                            ASLog(@"挂断失败，再次点击可以继续取消 error = %@", error);
                            return;
                        }
                        if (wself.closeBlock) {
                            wself.closeBlock(NO);
                        }
                    }];
                } cancelAction:^{
                    
                }];
            } else {
                if (wself.itemType == kItemTypeAnswerNoCalling) {//我是接听方，我拒绝
                    [[NERtcCallKit sharedInstance] reject:^(NSError * _Nullable error) {
                        if (error) {
                            ASLog(@"拒绝失败，再次点击可以继续取消 error = %@", error);
                            return;
                        }
                        if (wself.closeBlock) {
                            wself.closeBlock(YES);
                        }
                    }];
                    return;
                }
                if (wself.itemType == kItemTypeCallNoCalling) {//我是拨打方，取消呼叫
                    [NERtcCallKit.sharedInstance cancel:^(NSError * _Nullable error) {
                        if (error) {
                            ASLog(@"取消呼叫失败，再次点击可以继续取消 error = %@", error);
                            return;
                        }
                        if (wself.closeBlock) {
                            wself.closeBlock(YES);
                        }
                    }];
                    return;
                }
            }
        };
    }
    return _closeBtn;
}

- (ASCallItemView *)loudspeakerBtn {
    if (!_loudspeakerBtn) {
        _loudspeakerBtn = [[ASCallItemView alloc]init];
        _loudspeakerBtn.title.text = @"扬声器已开";
        _loudspeakerBtn.hidden = YES;
        _loudspeakerBtn.icon.image = [UIImage imageNamed:@"call_laba"];
        kWeakSelf(self);
        _loudspeakerBtn.actionBlock = ^{
            if (wself.isOpenLoudspeaker == NO){
                NSError *error;
                [NERtcCallKit.sharedInstance setLoudSpeakerMode:YES error:&error];
                if (error == nil) {
                    wself.isOpenLoudspeaker = YES;
                } else {
                    kShowToast(@"扬声器开启失败，请重试！");
                }
            } else {//关闭扬声器
                NSError *error;
                [NERtcCallKit.sharedInstance setLoudSpeakerMode:NO error:&error];
                if (error == nil) {
                    wself.isOpenLoudspeaker = NO;
                } else {
                    kShowToast(@"扬声器开启失败，请重试！");
                }
            }
        };
    }
    return _loudspeakerBtn;
}

- (ASCallItemView *)answerBtn {
    if (!_answerBtn) {
        _answerBtn = [[ASCallItemView alloc]init];
        _answerBtn.title.text = @"接听";
        _answerBtn.hidden = YES;
        _answerBtn.icon.image = [UIImage imageNamed:@"call_answer"];
        kWeakSelf(self);
        _answerBtn.actionBlock = ^{
            if (wself.answerBlock) {
                wself.answerBlock();
            }
        };
    }
    return _answerBtn;
}

- (UILabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc]init];
        _timerLabel.hidden = YES;
        _timerLabel.textColor = UIColor.whiteColor;
        _timerLabel.font = TEXT_FONT_15;
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        _timerLabel.text = @"00:00";
    }
    return _timerLabel;
}

- (UILabel *)moneyHintLabel {
    if (!_moneyHintLabel) {
        _moneyHintLabel = [[UILabel alloc]init];
        _moneyHintLabel.textColor = UIColor.whiteColor;
        _moneyHintLabel.font = TEXT_FONT_14;
        _moneyHintLabel.backgroundColor = UIColorRGBA(0x000000, 0.5);
        _moneyHintLabel.layer.cornerRadius = SCALES(14);
        _moneyHintLabel.layer.masksToBounds = YES;
    }
    return _moneyHintLabel;
}

- (ASCallItemView *)microphoneBtn {
    if (!_microphoneBtn) {
        _microphoneBtn = [[ASCallItemView alloc]init];
        _microphoneBtn.title.text = @"麦克风已开";
        _microphoneBtn.hidden = YES;
        _microphoneBtn.icon.image = [UIImage imageNamed:@"call_maikefeng"];
        kWeakSelf(self);
        _microphoneBtn.actionBlock = ^{
            if (wself.isOpenMicrophone == NO){ //开启麦克风
                NSInteger status = [NERtcCallKit.sharedInstance muteLocalAudio:NO];
                if (status == 0) {
                    wself.isOpenMicrophone = YES;
                } else {
                    kShowToast(@"麦克风开启失败，请重试！");
                }
            } else {//关闭麦克风
                NSInteger status = [NERtcCallKit.sharedInstance muteLocalAudio:YES];
                if (status == 0) {
                    wself.isOpenMicrophone = NO;
                } else {
                    kShowToast(@"麦克风关闭失败，请重试！");
                }
            }
        };
    }
    return _microphoneBtn;
}

- (UIButton *)giftBtn {
    if (!_giftBtn) {
        _giftBtn = [[UIButton alloc]init];
        [_giftBtn setBackgroundImage:[UIImage imageNamed:@"call_gift"] forState:UIControlStateNormal];
        _giftBtn.hidden = YES;
        kWeakSelf(self);
        [[_giftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.sendGiftBlock) {
                wself.sendGiftBlock();
            }
        }];
    }
    return _giftBtn;
}

- (ASCallGoPayView *)goPayView {
    if (!_goPayView) {
        _goPayView = [[ASCallGoPayView alloc]init];
        _goPayView.backgroundColor = UIColorRGBA(0x000000, 0.5);
        _goPayView.layer.cornerRadius = SCALES(8);
        _goPayView.layer.masksToBounds = YES;
        _goPayView.hidden = YES;
        _goPayView.type = kCallTypeVoice;
    }
    return _goPayView;
}
@end
