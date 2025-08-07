//
//  ASVideoShowMaskView.m
//  AS
//
//  Created by SA on 2025/5/12.
//

#import "ASVideoShowMaskView.h"
#import "ASVideoShowPlayButtonView.h"
#import "ASVideoShowRequest.h"
#import "ASVideoShowNotifyController.h"

@interface ASVideoShowMaskView()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIButton *updateBtn;
@property (nonatomic, strong) UIButton *callBtn;
@property (nonatomic, strong) UIImageView *headerIcon;
@property (nonatomic, strong) UIView *isOnline;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, strong) UILabel *userDataLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *notifyBtn;
@property (nonatomic, strong) UIView *notifyRed;
@property (nonatomic, strong) ASVideoShowPlayButtonView *setBtn;//设置按钮
@property (nonatomic, strong) ASVideoShowPlayButtonView *likeBtn;//点赞按钮
@property (nonatomic, strong) ASVideoShowPlayButtonView *dashanBtn;//搭讪按钮or私聊
@property (nonatomic, strong) ASVideoShowPlayButtonView *awardVideo;//赞赏视频
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *bottomView;
@end

@implementation ASVideoShowMaskView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickScreen:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        kWeakSelf(self);
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"videoShowCountNotification" object:nil] subscribeNext:^(NSNotification * _Nullable data) {
            NSString *count = data.object;
            wself.notifictionAcount = count;
        }];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bottomView];
        [self addSubview:self.silenceBtn];
        [self addSubview:self.backBtn];
        [self addSubview:self.title];
        [self addSubview:self.userDataLabel];
        [self addSubview:self.updateBtn];
        [self addSubview:self.callBtn];
        [self addSubview:self.nameLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.setBtn];
        [self addSubview:self.notifyBtn];
        [self.notifyBtn addSubview:self.notifyRed];
        [self addSubview:self.awardVideo];
        [self addSubview:self.likeBtn];
        [self addSubview:self.headerIcon];
        [self addSubview:self.attentionBtn];
        [self addSubview:self.isOnline];
        [self addSubview:self.dashanBtn];
        [self addSubview:self.playBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.width.equalTo(self);
        make.height.mas_equalTo(SCALES(236));
    }];
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.silenceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_BAR_HEIGHT + 6);
        make.right.equalTo(self).offset(-16);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    if (self.popType == kVideoPlayTabbar && USER_INFO.gender == 1) {
        self.notifyBtn.hidden = NO;
        [self.notifyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.silenceBtn);
            make.right.equalTo(self.silenceBtn.mas_left).offset(-16);
            make.height.width.mas_equalTo(32);
        }];
        [self.notifyRed mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.notifyBtn).offset(4);
            make.right.equalTo(self.notifyBtn).offset(-4);
            make.height.width.mas_equalTo(8);
        }];
    } else {
        [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(STATUS_BAR_HEIGHT);
            make.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
    }
    [self.updateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(self.popType == kVideoPlayTabbar ? SCALES(-16) : -(SCALES(16) + TAB_BAR_MAGIN));
        make.size.mas_equalTo(CGSizeMake(SCALES(340), SCALES(48)));
    }];
    [self.callBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.updateBtn);
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.updateBtn.mas_top).offset(SCALES(-16));
        make.left.equalTo(self).offset(SCALES(16));
        make.right.equalTo(self).offset(SCALES(-78));
    }];
    if (self.popType == kVideoPlayMyListVideo) {//设置页
        [self.setBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.updateBtn.mas_top).offset(SCALES(-16));
            make.right.equalTo(self).offset(SCALES(-10));
            make.height.mas_equalTo(SCALES(65));
            make.width.mas_equalTo(SCALES(62));
        }];
        [self.awardVideo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.setBtn.mas_top).offset(SCALES(-15));
            make.centerX.equalTo(self.setBtn);
            make.height.mas_equalTo(SCALES(65));
            make.width.mas_equalTo(SCALES(62));
        }];
        [self.likeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.awardVideo.mas_top).offset(SCALES(-15));
            make.centerX.equalTo(self.setBtn);
            make.height.mas_equalTo(SCALES(65));
            make.width.mas_equalTo(SCALES(62));
        }];
    } else {
        if (USER_INFO.gender == 2) {//我是男用户
            [self.dashanBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.updateBtn.mas_top).offset(SCALES(-16));
                make.right.equalTo(self).offset(SCALES(-10));
                make.height.mas_equalTo(SCALES(65));
                make.width.mas_equalTo(SCALES(62));
            }];
            [self.awardVideo mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.dashanBtn.mas_top).offset(SCALES(-15));
                make.centerX.equalTo(self.dashanBtn);
                make.height.mas_equalTo(SCALES(65));
                make.width.mas_equalTo(SCALES(62));
            }];
        } else {
            [self.awardVideo  mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.updateBtn.mas_top).offset(SCALES(-16));
                make.right.equalTo(self).offset(SCALES(-10));
                make.height.mas_equalTo(SCALES(65));
                make.width.mas_equalTo(SCALES(62));
            }];
        }
        [self.likeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.awardVideo.mas_top).offset(SCALES(-15));
            make.centerX.equalTo(self.awardVideo);
            make.height.mas_equalTo(SCALES(65));
            make.width.mas_equalTo(SCALES(62));
        }];
    }
    [self.headerIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.likeBtn.mas_centerX);
        make.bottom.equalTo(self.likeBtn.mas_top).offset(SCALES(-24));
        make.height.width.mas_equalTo(SCALES(50));
    }];
    [self.isOnline mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.headerIcon);
        make.height.width.mas_equalTo(SCALES(12));
    }];
    [self.attentionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerIcon.mas_bottom).offset(SCALES(8));
        make.centerX.equalTo(self.headerIcon);
        make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
    }];
    [self.userDataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.bottom.equalTo(self.contentLabel.mas_top).offset(SCALES(-8));
        make.height.mas_equalTo(SCALES(18));
        make.width.equalTo(self.contentLabel);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userDataLabel);
        make.bottom.equalTo(self.userDataLabel.mas_top).offset(SCALES(-8));
        make.height.mas_equalTo(SCALES(28));
    }];
}

- (void)setNotifictionAcount:(NSString *)notifictionAcount {
    _notifictionAcount = notifictionAcount;
    NSString *count = STRING(notifictionAcount);
    if (count.integerValue > 99) {
        count = @"99+";
    }
    if (notifictionAcount.integerValue > 0) {
        self.notifyRed.hidden = NO;
    } else {
        self.notifyRed.hidden = YES;
    }
}

- (void)setIsSilence:(BOOL)isSilence {
    _isSilence = isSilence;
    self.silenceBtn.selected = isSilence;
}

- (void)setIsFollow:(BOOL)isFollow {
    _isFollow = isFollow;
    if ([self.model.user_id isEqualToString:USER_INFO.user_id] || isFollow == YES || USER_INFO.gender == 1) {
        self.attentionBtn.hidden = YES;
    } else {
        self.attentionBtn.hidden = NO;
    }
}

- (void)setModel:(ASVideoShowDataModel *)model {
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"@%@", STRING(model.nickname)];
    self.contentLabel.attributedText = [ASCommonFunc attributedWithString:STRING(model.title) lineSpacing:SCALES(4.0)];
    self.userDataLabel.text = STRING(model.tag);
    self.likeBtn.isSelect = model.like;
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", SERVER_IMAGE_URL, model.avatar]]];
    if ([model.user_id isEqualToString:USER_INFO.user_id] || model.is_follow == YES || USER_INFO.gender == 1) {
        self.attentionBtn.hidden = YES;
    } else {
        self.attentionBtn.hidden = NO;
    }
    if ([model.user_id isEqualToString:USER_INFO.user_id] || model.online == NO) {
        self.isOnline.hidden = YES;
    } else {
        self.isOnline.hidden = NO;
    }
    if (model.online == NO) {
        self.dashanBtn.isSelect = NO;
        self.dashanBtn.textStr = @"搭讪";
    } else {
        self.dashanBtn.isSelect = YES;
        self.dashanBtn.textStr = @"私聊";
    }
    if (model.like_num < 1) {
        self.likeBtn.textStr = @"点赞";
    } else {
        self.likeBtn.textStr = [ASCommonFunc changeNumberAcount:model.like_num];
    }
    switch (self.popType) {
        case kVideoPlayTabbar:
        {
            self.backBtn.hidden = YES;
            self.title.hidden = YES;
            self.setBtn.hidden = YES;
            if (USER_INFO.gender == 1) {//我是女用户
                self.updateBtn.hidden = NO;
                self.callBtn.hidden = YES;
                self.dashanBtn.hidden = YES;
            } else {
                self.updateBtn.hidden = YES;
                self.callBtn.hidden = NO;
                self.dashanBtn.hidden = NO;
            }
            if (kAppType == 1) {
                self.updateBtn.hidden = NO;
                self.dashanBtn.hidden = YES;
                self.callBtn.hidden = YES;
            }
        }
            break;
        case kVideoPlayMyListVideo:
        {
            self.backBtn.hidden = NO;
            self.setBtn.hidden = NO;
            self.updateBtn.hidden = NO;
            self.callBtn.hidden = YES;
            if (model.audit_status.integerValue == 0 || model.show_status.integerValue != 1) {
                self.title.text = @"审核中";
                self.title.hidden = NO;
                if (model.show_status.integerValue != 1) {
                    self.title.text = @"私密状态";
                }
            } else {
                self.title.hidden = YES;
            }
        }
            break;
        case kVideoPlayPersonalHome:
        {
            self.backBtn.hidden = NO;
            self.title.hidden = YES;
            self.setBtn.hidden = YES;
            if (USER_INFO.gender == 1) {
                self.updateBtn.hidden = NO;
                self.callBtn.hidden = YES;
                self.dashanBtn.hidden = YES;
            } else {
                self.updateBtn.hidden = YES;
                self.callBtn.hidden = NO;
                self.dashanBtn.hidden = NO;
            }
            if (kAppType == 1) {
                self.updateBtn.hidden = YES;
                self.callBtn.hidden = YES;
                self.dashanBtn.hidden = YES;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Lazy
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc]init];
        _backBtn.adjustsImageWhenHighlighted = NO;
        [_backBtn setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            if ([wself.delegate respondsToSelector:@selector(cellClickBackBtn)]) {
                [wself.delegate cellClickBackBtn];
            }
        }];
    }
    return _backBtn;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = TEXT_FONT_20;
        _title.textColor = UIColorRGB(0xFAAC16);
        _title.textAlignment = NSTextAlignmentCenter;
        _title.hidden = YES;
    }
    return _title;
}

//女用户上传视频秀
- (UIButton *)updateBtn {
    if (!_updateBtn) {
        _updateBtn = [[UIButton alloc]init];
        [_updateBtn setBackgroundImage:[UIImage imageNamed:@"video_up"] forState:UIControlStateNormal];
        _updateBtn.adjustsImageWhenHighlighted = NO;
        _updateBtn.hidden = YES;
        kWeakSelf(self);
        [[_updateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if ([wself.delegate respondsToSelector:@selector(cellClickVoicePause)]) {
                [wself.delegate cellClickVoicePause];
            }
            if ([wself.delegate respondsToSelector:@selector(cellClickPublishBtn:)]) {
                [wself.delegate cellClickPublishBtn:wself.updateBtn];
            }
        }];
    }
    return _updateBtn;
}

//男用户拨打
- (UIButton *)callBtn {
    if (!_callBtn) {
        _callBtn = [[UIButton alloc]init];
        [_callBtn setBackgroundImage:[UIImage imageNamed:@"video_call"] forState:UIControlStateNormal];
        _callBtn.adjustsImageWhenHighlighted = NO;
        _callBtn.hidden = YES;
        kWeakSelf(self);
        [[_callBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if ([wself.delegate respondsToSelector:@selector(cellClickVoicePause)]) {
                [wself.delegate cellClickVoicePause];
            }
            [ASVideoShowRequest requestVideoShowCallWithVideoID:wself.model.ID
                                                        success:^(id  _Nullable data) {
                [ASMyAppCommonFunc callWithUserID:wself.model.user_id
                                         callType:kCallTypeVideo
                                            scene:Call_Scene_VideoShow
                                             back:^(BOOL isSucceed) {
                    
                }];
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        }];
    }
    return _callBtn;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = TEXT_MEDIUM(20);
        _nameLabel.textColor = UIColor.whiteColor;
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = TEXT_FONT_14;
        _contentLabel.textColor = UIColor.whiteColor;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)userDataLabel {
    if (!_userDataLabel) {
        _userDataLabel = [[UILabel alloc]init];
        _userDataLabel.font = TEXT_FONT_14;
        _userDataLabel.textColor = UIColor.whiteColor;
    }
    return _userDataLabel;
}

//设置
- (ASVideoShowPlayButtonView *)setBtn {
    if (!_setBtn) {
        _setBtn = [[ASVideoShowPlayButtonView alloc]init];
        _setBtn.normalIcon = @"video_set";
        _setBtn.isSelect = NO;
        _setBtn.textStr = @"设置";
        _setBtn.hidden = YES;
        kWeakSelf(self);
        _setBtn.clikedBlock = ^{
            [ASAlertViewManager popVideoShowSetWithModel:wself.model action:^{
                if ([wself.delegate respondsToSelector:@selector(cellClickBackBtn)]) {
                    [wself.delegate cellClickBackBtn];
                }
            }];
        };
    }
    return _setBtn;
}

//通知
- (UIButton *)notifyBtn {
    if (!_notifyBtn) {
        _notifyBtn = [[UIButton alloc]init];
        [_notifyBtn setImage:[UIImage imageNamed:@"video_notify"] forState:UIControlStateNormal];
        _notifyBtn.adjustsImageWhenHighlighted = NO;
        _notifyBtn.hidden = YES;
        [[_notifyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            ASVideoShowNotifyController *vc = [[ASVideoShowNotifyController alloc] init];
            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
        }];
    }
    return _notifyBtn;
}

- (UIView *)notifyRed {
    if (!_notifyRed) {
        _notifyRed = [[UIView alloc]init];
        _notifyRed.hidden = YES;
        _notifyRed.backgroundColor = UIColorRGB(0xFF4365);
        _notifyRed.layer.cornerRadius = SCALES(4);
        _notifyRed.layer.masksToBounds = YES;
        _notifyRed.layer.borderColor = UIColor.whiteColor.CGColor;
        _notifyRed.layer.borderWidth = 1;
    }
    return _notifyRed;
}

//赞赏
- (ASVideoShowPlayButtonView *)awardVideo {
    if (!_awardVideo) {
        _awardVideo = [[ASVideoShowPlayButtonView alloc]init];
        _awardVideo.normalIcon = @"video_gift";
        _awardVideo.textStr = @"赞赏";
        _awardVideo.isSelect = NO;
        kWeakSelf(self);
        _awardVideo.clikedBlock = ^{
            [ASAlertViewManager popVideoShowGiftWithModel:wself.model];
        };
    }
    return _awardVideo;
}

//点赞
- (ASVideoShowPlayButtonView *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [[ASVideoShowPlayButtonView alloc] init];
        _likeBtn.selectIcon = @"video_like1";
        _likeBtn.normalIcon = @"video_like";
        kWeakSelf(self);
        _likeBtn.clikedBlock = ^{
            [ASVideoShowRequest requestVideoShowZanWithVideoID:wself.model.ID success:^(id  _Nullable data) {
                NSNumber *isLike = data;
                if (isLike.integerValue == 1) {
                    wself.likeBtn.isSelect = YES;
                    wself.model.like_num += 1;
                } else {
                    wself.likeBtn.isSelect = NO;
                    wself.model.like_num -= 1;
                }
                wself.model.like = isLike.integerValue;
                if (wself.model.like_num < 1) {
                    wself.likeBtn.textStr = @"点赞";
                } else {
                    wself.likeBtn.textStr = [ASCommonFunc changeNumberAcount:wself.model.like_num];
                }
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        };
    }
    return _likeBtn;
}

//搭讪
- (ASVideoShowPlayButtonView *)dashanBtn {
    if (!_dashanBtn) {
        _dashanBtn = [[ASVideoShowPlayButtonView alloc] init];
        _dashanBtn.normalIcon = @"video_dashan";
        _dashanBtn.selectIcon = @"video_chat";
        _dashanBtn.isSelect = NO;
        _dashanBtn.textStr = @"搭讪";
        _dashanBtn.hidden = YES;
        kWeakSelf(self);
        _dashanBtn.clikedBlock = ^{
            if (wself.model.online == NO) {
                [ASVideoShowRequest requestVideoShowDashanWithUserID:wself.model.user_id
                                                         videoShowID:wself.model.ID
                                                             success:^(id  _Nullable data) {
                    kShowToast(@"搭讪成功");
                    wself.dashanBtn.textStr = @"私聊";
                    wself.dashanBtn.isSelect = YES;
                    wself.model.online = YES;
                } errorBack:^(NSInteger code, NSString *msg) {
                    if (code == 1) {
                        wself.dashanBtn.textStr = @"私聊";
                        wself.dashanBtn.isSelect = YES;
                        wself.model.online = YES;
                    }
                }];
            } else {
                [ASMyAppCommonFunc chatWithUserID:wself.model.user_id nickName:wself.model.nickname action:^(id  _Nonnull data) {
                    
                }];
            }
        };
    }
    return _dashanBtn;
}

//点击头像
- (UIImageView *)headerIcon {
    if (!_headerIcon) {
        _headerIcon = [[UIImageView alloc]init];
        _headerIcon.userInteractionEnabled = YES;
        _headerIcon.layer.masksToBounds = YES;
        _headerIcon.layer.cornerRadius = SCALES(25);
        _headerIcon.layer.borderColor = UIColor.whiteColor.CGColor;
        _headerIcon.layer.borderWidth = SCALES(1.0);
        _headerIcon.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_headerIcon addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (USER_INFO.gender == 1) {
                return;
            }
            [ASMyAppCommonFunc goPersonalHomeWithUserID:wself.model.user_id viewController:[ASCommonFunc currentVc] action:^(id  _Nonnull data) {
                NSString *str = data;
                if ([str isEqualToString:@"addAttention"]) {//关注
                    wself.model.is_follow = 1;
                    wself.attentionBtn.selected = YES;
                    if ([wself.delegate respondsToSelector:@selector(cellClickVoiceAttention:videoShowModel:)]) {
                        [wself.delegate cellClickVoiceAttention:YES videoShowModel:wself.model];
                    }
                    return;
                }
                if ([str isEqualToString:@"delAttention"]) {//取消关注
                    wself.model.is_follow = 0;
                    wself.attentionBtn.selected = NO;
                    if ([wself.delegate respondsToSelector:@selector(cellClickVoiceAttention:videoShowModel:)]) {
                        [wself.delegate cellClickVoiceAttention:NO videoShowModel:wself.model];
                    }
                    return;
                }
                if ([str isEqualToString:@"beckon"]) {//搭讪了
                    wself.dashanBtn.textStr = @"私聊";
                    wself.dashanBtn.isSelect = YES;
                    wself.model.online = YES;
                    return;
                }
            }];
        }];
    }
    return _headerIcon;
}

//关注
- (UIButton *)attentionBtn {
    if (!_attentionBtn) {
        _attentionBtn = [[UIButton alloc]init];
        [_attentionBtn setBackgroundImage:[UIImage imageNamed:@"video_guanzhu"] forState:UIControlStateNormal];
        [_attentionBtn setBackgroundImage:[UIImage imageNamed:@"video_guanzhu1"] forState:UIControlStateSelected];
        _attentionBtn.adjustsImageWhenHighlighted = NO;
        _attentionBtn.hidden = YES;
        kWeakSelf(self);
        [[_attentionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASVideoShowRequest requestVideoShowFollowWithUserID:wself.model.user_id
                                                     videoShowID:wself.model.ID
                                                         success:^(id  _Nullable data) {
                if ([data isEqualToString:@"add"]) {
                    wself.attentionBtn.selected = YES;
                    wself.model.is_follow = 1;
                    kShowToast(@"关注成功");
                    if ([wself.delegate respondsToSelector:@selector(cellClickVoiceAttention:videoShowModel:)]) {
                        [wself.delegate cellClickVoiceAttention:YES videoShowModel:wself.model];
                    }
                } else if ([data isEqualToString:@"delete"]) {
                    wself.attentionBtn.selected = NO;
                    wself.model.is_follow = 0;
                    if ([wself.delegate respondsToSelector:@selector(cellClickVoiceAttention:videoShowModel:)]) {
                        [wself.delegate cellClickVoiceAttention:NO videoShowModel:wself.model];
                    }
                }
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        }];
    }
    return _attentionBtn;
}

- (UIView *)isOnline {
    if (!_isOnline) {
        _isOnline = [[UIView alloc]init];
        _isOnline.backgroundColor = UIColor.greenColor;
        _isOnline.layer.masksToBounds = YES;
        _isOnline.layer.cornerRadius = SCALES(6);
        _isOnline.layer.borderColor = UIColor.whiteColor.CGColor;
        _isOnline.layer.borderWidth = SCALES(1);
        _isOnline.hidden = YES;
    }
    return _isOnline;
}

//设置外放声音
- (UIButton *)silenceBtn {
    if (!_silenceBtn) {
        _silenceBtn = [[UIButton alloc]init];
        [_silenceBtn setImage:[UIImage imageNamed:@"video_mute"] forState:UIControlStateNormal];
        [_silenceBtn setImage:[UIImage imageNamed:@"video_mute1"] forState:UIControlStateSelected];
        _silenceBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_silenceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            wself.silenceBtn.selected = !wself.silenceBtn.isSelected;
            if ([wself.delegate respondsToSelector:@selector(cellClickVoiceOnOffBtn:)]) {
                [wself.delegate cellClickVoiceOnOffBtn:wself.silenceBtn];
            }
        }];
    }
    return _silenceBtn;
}

//播放暂停
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        [_playBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
        _playBtn.adjustsImageWhenHighlighted = NO;
        _playBtn.userInteractionEnabled = NO;
        _playBtn.hidden = YES;
    }
    return _playBtn;
}

- (UIImageView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIImageView alloc]init];
        _bottomView.image = [UIImage imageNamed:@"video_bottom"];
    }
    return _bottomView;
}

#pragma mark - 点击事件
- (void)clickScreen:(UITapGestureRecognizer *)gestureRecognizer{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickScreen:)]) {
        [self.delegate clickScreen:gestureRecognizer];
    }
}
@end
