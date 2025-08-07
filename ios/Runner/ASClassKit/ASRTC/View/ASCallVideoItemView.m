//
//  ASCallVideoItemView.m
//  AS
//
//  Created by SA on 2025/5/19.
//

#import "ASCallVideoItemView.h"

@interface ASCallVideoItemView()
@property (nonatomic, strong) UILabel *waitText;
@property (nonatomic, strong) ASCallItemView *cameraCutBtn;
@property (nonatomic, strong) ASCallItemView *closeBtn;
@property (nonatomic, strong) ASCallItemView *answerBtn;
@property (nonatomic, strong) ASCallItemView *loudspeakerBtn;
@property (nonatomic, strong) ASCallItemView *beautyBtn;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UILabel *moneyHintLabel;
@property (nonatomic, strong) UIButton *giftBtn;
/**数据**/
@property (nonatomic, assign) int callTimers;
@property (nonatomic, assign) BOOL isCutIcon;
@end

@implementation ASCallVideoItemView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.waitText];
        [self addSubview:self.closeBtn];
        [self addSubview:self.loudspeakerBtn];
        [self addSubview:self.cameraSwitch];
        [self addSubview:self.cameraCutBtn];
        [self addSubview:self.answerBtn];
        [self addSubview:self.beautyBtn];
        [self addSubview:self.timerLabel];
        [self addSubview:self.moneyHintLabel];
        [self addSubview:self.giftBtn];
        if (USER_INFO.gender == 2) {
            [self addSubview:self.goPayView];
        }
        self.isOpenCamera = YES;
        self.isOpenLoudspeaker = YES;
    }
    return self;
}

- (void)setItemType:(ASCallItemType)itemType {
    _itemType = itemType;
    self.waitText.hidden = YES;
    self.answerBtn.hidden = YES;
    self.closeBtn.hidden = YES;
    self.cameraSwitch.hidden = YES;
    self.loudspeakerBtn.hidden = YES;
    self.cameraCutBtn.hidden = YES;
    self.beautyBtn.hidden = YES;
    self.timerLabel.hidden = YES;
    self.giftBtn.hidden = YES;
    self.moneyHintLabel.hidden = YES;
    switch (itemType) {
        case kItemTypeCallNoCalling://拨打视频，未接通
        {
            self.waitText.text = @"正在等待对方接受邀请...";
            self.waitText.hidden = NO;
            [self.waitText mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.closeBtn.mas_top).offset(SCALES(-28));
                make.height.mas_equalTo(SCALES(24));
            }];
            self.closeBtn.hidden = NO;
            [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.mas_bottom).offset(-TAB_BAR_MAGIN - SCALES(40));
                make.size.mas_equalTo(CGSizeMake(SCALES(71), SCALES(100)));
            }];
            if (USER_INFO.gender == 2) {//我是男用户
                self.cameraSwitch.hidden = NO;//摄像头开关
                [self.cameraSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.closeBtn.mas_left).offset(SCALES(-40));
                    make.centerY.width.height.equalTo(self.closeBtn);
                }];
                self.loudspeakerBtn.hidden = NO;//扬声器开关
                [self.loudspeakerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.closeBtn.mas_right).offset(SCALES(40));
                    make.centerY.width.height.equalTo(self.closeBtn);
                }];
            }
            self.moneyHintLabel.hidden = NO;
            [self.moneyHintLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.waitText.mas_top).offset(SCALES(-34));
                make.height.mas_equalTo(SCALES(28));
            }];
        }
            break;
        case kItemTypeAnswerNoCalling://接听视频，未接通
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
            self.waitText.text = @"正在邀请你视频通话...";
            if (USER_INFO.gender == 2) {
                self.cameraCutBtn.hidden = NO;//摄像头翻转
                self.cameraCutBtn.icon.image = [UIImage imageNamed:@"call_fanzhuan2"];
                self.isCutIcon = NO;
                [self.cameraCutBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.closeBtn.mas_top).offset(-SCALES(20));
                    make.centerX.height.width.equalTo(self.closeBtn);
                }];
                self.cameraSwitch.hidden = NO;//摄像头开关
                [self.cameraSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.answerBtn.mas_top).offset(-SCALES(20));
                    make.centerX.height.width.equalTo(self.answerBtn);
                }];
                [self.waitText mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self);
                    make.bottom.equalTo(self.cameraSwitch.mas_top).offset(SCALES(-28));
                    make.height.mas_equalTo(SCALES(24));
                }];
            } else {
                [self.waitText mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self);
                    make.bottom.equalTo(self.closeBtn.mas_top).offset(SCALES(-28));
                    make.height.mas_equalTo(SCALES(24));
                }];
            }
            self.moneyHintLabel.hidden = NO;
            [self.moneyHintLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.waitText.mas_top).offset(SCALES(-34));
                make.height.mas_equalTo(SCALES(28));
            }];
        }
            break;
        case kItemTypeCallCalling://已接通
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
            if (USER_INFO.gender == 2) {
                self.cameraSwitch.hidden = NO;//摄像头开关
                [self.cameraSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.closeBtn.mas_left).offset(SCALES(-40));
                    make.centerY.width.height.equalTo(self.closeBtn);
                }];
                self.cameraCutBtn.hidden = NO;//摄像头翻转
                self.cameraCutBtn.icon.image = [UIImage imageNamed:@"call_fanzhuan"];
                self.isCutIcon = YES;
                [self.cameraCutBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.closeBtn.mas_top).offset(-SCALES(32));
                    make.centerX.equalTo(self.loudspeakerBtn);
                    make.size.mas_equalTo(CGSizeMake(SCALES(36), SCALES(62)));
                }];
                self.beautyBtn.hidden = NO;//美颜
                [self.beautyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.cameraSwitch.mas_top).offset(-SCALES(32));
                    make.centerX.equalTo(self.cameraSwitch);
                    make.size.mas_equalTo(CGSizeMake(SCALES(36), SCALES(62)));
                }];
                self.giftBtn.hidden = NO;
                [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.cameraCutBtn.mas_top).offset(-SCALES(30));
                    make.centerX.equalTo(self.cameraCutBtn);
                    make.height.width.mas_equalTo(SCALES(71));
                }];
                [self.goPayView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(SCALES(15));
                    make.bottom.equalTo(self.giftBtn.mas_top).offset(SCALES(-20));
                    make.width.mas_equalTo(SCALES(240));
                    make.height.mas_equalTo(SCALES(53));
                }];
            } else {//女用户不允许关闭摄像头
                self.cameraCutBtn.hidden = NO;//摄像头翻转
                self.cameraCutBtn.icon.image = [UIImage imageNamed:@"call_fanzhuan2"];
                self.isCutIcon = NO;
                [self.cameraCutBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.closeBtn.mas_left).offset(SCALES(-40));
                    make.centerY.width.height.equalTo(self.closeBtn);
                }];
                self.beautyBtn.hidden = NO;//美颜
                [self.beautyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.cameraCutBtn.mas_top).offset(-SCALES(32));
                    make.centerX.equalTo(self.cameraCutBtn);
                    make.size.mas_equalTo(CGSizeMake(SCALES(36), SCALES(62)));
                }];
                self.giftBtn.hidden = NO;
                [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.loudspeakerBtn.mas_top).offset(-SCALES(30));
                    make.centerX.equalTo(self.loudspeakerBtn);
                    make.height.width.mas_equalTo(SCALES(71));
                }];
            }
            self.timerLabel.hidden = NO;
            [self.timerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.beautyBtn);
                make.centerX.equalTo(self.closeBtn);
                make.height.mas_equalTo(SCALES(21));
            }];
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

- (void)setIsOpenCamera:(BOOL)isOpenCamera {
    _isOpenCamera = isOpenCamera;
    if (isOpenCamera) {
        self.cameraSwitch.title.text = @"摄像头已开";
        self.cameraSwitch.icon.image = [UIImage imageNamed:@"call_video"];
        if (self.isCutIcon == YES) {
            self.cameraCutBtn.icon.image = [UIImage imageNamed:@"call_fanzhuan"];
        } else {
            self.cameraCutBtn.icon.image = [UIImage imageNamed:@"call_fanzhuan2"];
        }
    } else {
        self.cameraSwitch.title.text = @"摄像头已关";
        self.cameraSwitch.icon.image = [UIImage imageNamed:@"call_video1"];
        if (self.isCutIcon == YES) {
            self.cameraCutBtn.icon.image = [UIImage imageNamed:@"call_fanzhuan1"];
        } else {
            self.cameraCutBtn.icon.image = [UIImage imageNamed:@"call_fanzhuan3"];
        }
    }
}

- (void)setIsCutCamera:(BOOL)isCutCamera {
    _isCutCamera = isCutCamera;
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

- (ASCallItemView *)cameraSwitch {
    if (!_cameraSwitch) {
        _cameraSwitch = [[ASCallItemView alloc]init];
        _cameraSwitch.title.text = @"摄像头已开";
        _cameraSwitch.icon.image = [UIImage imageNamed:@"call_video"];
        kWeakSelf(self);
        _cameraSwitch.actionBlock = ^{
            if (wself.isOpenCamera == NO){//摄像头关闭状态，开启摄像头
                NSInteger status = [NERtcCallKit.sharedInstance enableLocalVideo:YES];
                if (status == 0) {
                    wself.isOpenCamera = YES;
                    if (wself.cameraSwitchBlock) {
                        wself.cameraSwitchBlock(YES);//摄像头开
                    }
                } else {
                    kShowToast(@"摄像头开启失败，请重试！");
                }
            } else {//摄像头开启状态，关闭摄像头
                NSInteger status = [NERtcCallKit.sharedInstance enableLocalVideo:NO];
                if (status == 0) {
                    wself.isOpenCamera = NO;
                    if (wself.cameraSwitchBlock) {
                        wself.cameraSwitchBlock(NO);//摄像头关闭
                    }
                } else {
                    kShowToast(@"摄像头关闭失败，请重试！");
                }
            }
        };
    }
    return _cameraSwitch;
}

- (ASCallItemView *)loudspeakerBtn {
    if (!_loudspeakerBtn) {
        _loudspeakerBtn = [[ASCallItemView alloc]init];
        _loudspeakerBtn.title.text = @"扬声器已开";
        _loudspeakerBtn.icon.image = [UIImage imageNamed:@"call_laba"];
        kWeakSelf(self);
        _loudspeakerBtn.actionBlock = ^{
            if (wself.isOpenLoudspeaker == NO){//扬声器关闭状态，开启扬声器
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
                            wself.closeBlock(NO);//挂断
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
                            wself.closeBlock(YES);//拒绝
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
                            wself.closeBlock(YES);//取消
                        }
                    }];
                    return;
                }
            }
        };
    }
    return _closeBtn;
}

- (ASCallItemView *)cameraCutBtn {
    if (!_cameraCutBtn) {
        _cameraCutBtn = [[ASCallItemView alloc]init];
        _cameraCutBtn.title.text = @"翻转";
        _cameraCutBtn.icon.image = [UIImage imageNamed:@"call_fanzhuan"];
        kWeakSelf(self);
        _cameraCutBtn.actionBlock = ^{
            if (wself.isOpenCamera == YES) {//摄像头开启，允许切换摄像头
                wself.isCutCamera = !wself.isCutCamera;
                if (wself.cameraCutBlock) {
                    wself.cameraCutBlock(!wself.isCutCamera);//摄像头切换
                }
            }
        };
    }
    return _cameraCutBtn;
}

- (ASCallItemView *)beautyBtn {
    if (!_beautyBtn) {
        _beautyBtn = [[ASCallItemView alloc]init];
        _beautyBtn.icon.image = [UIImage imageNamed:@"call_meiyan"];
        _beautyBtn.title.text = @"美颜";
        kWeakSelf(self);
        _beautyBtn.actionBlock = ^{
            if (wself.meiyanBlock) {
                wself.meiyanBlock();
            }
        };
    }
    return _beautyBtn;
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
        _goPayView.type = kCallTypeVideo;
    }
    return _goPayView;
}

- (void)dealloc {
    [self.callTimerDisposable dispose];
}

@end
