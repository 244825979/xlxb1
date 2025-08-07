//
//  ASGoodAnchorPopView.m
//  AS
//
//  Created by SA on 2025/6/11.
//

#import "ASGoodAnchorPopView.h"
#import "ASAudioPlayManager.h"

@interface ASGoodAnchorPopView ()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *msgCount;//未读消息数
@property (nonatomic, strong) UIImageView *messageIcon;//消息
@property (nonatomic, strong) ASGoodAnchorMessageView *messageView;//消息
@property (nonatomic, strong) UIImageView *usersIcon;//用户数量
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIButton *goChat;//去聊天
@property (nonatomic, strong) UILabel *freeView;//免费
@end

@implementation ASGoodAnchorPopView

- (instancetype)init {
    if (self = [super init]) {
        self.size = CGSizeMake(SCALES(303), SCALES(460));
        self.backgroundColor = UIColor.clearColor;
        [self addSubview:self.bgView];
        [self addSubview:self.changeBtn];
        [self.bgView addSubview:self.closeBtn];
        [self.bgView addSubview:self.header];
        [self.bgView addSubview:self.msgCount];
        [self.bgView addSubview:self.messageIcon];
        [self.bgView addSubview:self.messageView];
        [self.bgView addSubview:self.usersIcon];
        [self.bgView addSubview:self.content];
        [self.bgView addSubview:self.goChat];
        [self.bgView addSubview:self.freeView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(SCALES(410));
    }];
    [self.changeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(SCALES(50));
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(82));
        make.right.offset(SCALES(-21));
        make.height.width.mas_equalTo(SCALES(24));
    }];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(90));
        make.centerX.equalTo(self.bgView);
        make.height.width.mas_equalTo(SCALES(98));
    }];
    [self.msgCount mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header).offset(SCALES(2));
        make.right.equalTo(self.header).offset(SCALES(-10));
        make.height.width.mas_equalTo(SCALES(16));
    }];
    [self.messageIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header.mas_bottom).offset(SCALES(16));
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(SCALES(13), SCALES(8)));
    }];
    [self.messageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageIcon.mas_bottom);
        make.centerX.width.equalTo(self.bgView);
        make.height.mas_equalTo(SCALES(38));
    }];
    [self.usersIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageView.mas_bottom).offset(SCALES(16));
        make.centerX.equalTo(self.bgView);
        make.width.mas_equalTo(SCALES(170));
        make.height.mas_equalTo(SCALES(32));
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usersIcon.mas_bottom).offset(SCALES(16));
        make.centerX.equalTo(self.bgView);
        make.height.mas_equalTo(SCALES(16));
    }];
    [self.goChat mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content.mas_bottom).offset(SCALES(16));
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(SCALES(177), SCALES(48)));
    }];
    [self.freeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goChat).offset(SCALES(-9));
        make.right.equalTo(self.goChat).offset(SCALES(9));
        make.size.mas_equalTo(CGSizeMake(SCALES(34), SCALES(18)));
    }];
}

- (void)setModel:(ASGoodAnchorModel *)model {
    _model = model;
    if (!kStringIsEmpty(model.greetImg)) {
        [self.header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.greetImg]]];
    } else {
        [self.header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar]]];
    }
    if (!kStringIsEmpty(model.uid)) {
        NIMSession *session = [NIMSession session:STRING(model.uid) type:NIMSessionTypeP2P];
        NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
        NSInteger unreadCount = recent.unreadCount;
        if (unreadCount > 0) {
            self.msgCount.hidden = NO;
            self.msgCount.text = [NSString stringWithFormat:@"%zd",unreadCount];
        } else {
            self.msgCount.hidden = YES;
        }
    } else {
        self.msgCount.hidden = YES;
    }
    self.freeView.hidden = !model.isFree;
    self.messageView.model = model;
}

- (UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [[UIButton alloc]init];
        [_changeBtn setTitle:@"不感兴趣，换一个" forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = TEXT_FONT_16;
        kWeakSelf(self);
        [[_changeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASCommonRequest requestGoodAnchorIndexSuccess:^(ASGoodAnchorModel * _Nullable data) {
                if (!kStringIsEmpty(data.uid)) {
                    wself.model = data;
                } else {
                    wself.changeBtn.hidden = YES;
                    kShowToast(@"暂无新的用户");
                }
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        }];
    }
    return _changeBtn;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
        _bgView.image = [UIImage imageNamed:@"taohua_pop"];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.layer.cornerRadius = SCALES(49);
        _header.layer.masksToBounds = YES;
        _header.layer.borderWidth = SCALES(1.5);
        _header.layer.borderColor = MAIN_COLOR.CGColor;
        _header.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _header;
}

- (UILabel *)msgCount {
    if (!_msgCount) {
        _msgCount = [[UILabel alloc]init];
        _msgCount.backgroundColor = MAIN_COLOR;
        _msgCount.textColor = UIColor.whiteColor;
        _msgCount.font = TEXT_FONT_10;
        _msgCount.textAlignment = NSTextAlignmentCenter;
        _msgCount.layer.cornerRadius = SCALES(8);
        _msgCount.layer.masksToBounds = YES;
        _msgCount.hidden = YES;
    }
    return _msgCount;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close1"] forState:UIControlStateNormal];
        _closeBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
        }];
    }
    return _closeBtn;
}

- (UIImageView *)messageIcon {
    if (!_messageIcon) {
        _messageIcon = [[UIImageView alloc]init];
        _messageIcon.image = [UIImage imageNamed:@"taohua_pop1"];
    }
    return _messageIcon;
}

- (ASGoodAnchorMessageView *)messageView {
    if (!_messageView) {
        _messageView = [[ASGoodAnchorMessageView alloc]init];
    }
    return _messageView;
}

- (UIImageView *)usersIcon {
    if (!_usersIcon) {
        _usersIcon = [[UIImageView alloc]init];
        _usersIcon.image = [UIImage imageNamed:@"taohua_user"];
    }
    return _usersIcon;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.text = @"超多女神活跃，快来邂逅你的聊天搭子";
        _content.textColor = TITLE_COLOR;
        _content.font = TEXT_FONT_12;
        _content.textAlignment = NSTextAlignmentCenter;
    }
    return _content;
}

- (UIButton *)goChat {
    if (!_goChat) {
        _goChat = [[UIButton alloc]init];
        _goChat.adjustsImageWhenHighlighted = NO;
        [_goChat setBackgroundImage:[UIImage imageNamed:@"taohua_btn"] forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_goChat rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            //埋点
            [ASCommonRequest requestGoodAnchorClickSuccess:^(id  _Nullable data) {
                
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
            //去私聊页
            [ASMyAppCommonFunc chatWithUserID:wself.model.uid nickName:wself.model.nickname action:^(id  _Nonnull data) {
                
            }];
            if (wself.cancelBlock) {
                wself.cancelBlock();
                [wself removeView];
            }
        }];
    }
    return _goChat;
}

- (UILabel *)freeView {
    if (!_freeView) {
        _freeView = [[UILabel alloc]init];
        _freeView.text = @"免费";
        _freeView.textColor = UIColor.whiteColor;
        _freeView.font = TEXT_FONT_12;
        _freeView.backgroundColor = MAIN_COLOR;
        _freeView.layer.cornerRadius = SCALES(4);
        _freeView.layer.masksToBounds = YES;
        _freeView.textAlignment = NSTextAlignmentCenter;
        _freeView.hidden = YES;
    }
    return _freeView;
}

- (void)removeView {
    [self removeFromSuperview];
}
@end

@interface ASGoodAnchorMessageView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *voicePlayerIcon;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIView *voicePoint;
@property (nonatomic, strong) RACDisposable *timerDisposable;//时间倒计时播放语音
@property (nonatomic, assign) NSInteger timers;//计时时间
@property (nonatomic, assign) BOOL isPlaying;
@end

@implementation ASGoodAnchorMessageView

- (void)dealloc {
    [self.timerDisposable dispose];
    [[ASAudioPlayManager shared] stop];
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = UIColor.clearColor;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.voicePlayerIcon];
    [self.bgView addSubview:self.content];
    [self addSubview:self.voicePoint];
    kWeakSelf(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"AudioPlayCompletionNotifiction" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        wself.isPlaying = NO;
        [[ASAudioPlayManager shared] stop];
        [wself.voicePlayerIcon stopAnimating];
        [wself.timerDisposable dispose];
        if (!kStringIsEmpty(wself.model.greetVoice)) {
            wself.voicePlayerIcon.hidden = NO;
            wself.content.text = [NSString stringWithFormat:@"%zds",wself.model.greetVoiceLen];
            wself.timers = wself.model.greetVoiceLen;
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!kStringIsEmpty(self.model.greetVoice)) {
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCALES(159), SCALES(38)));
        }];
        [self.voicePlayerIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(15));
            make.centerY.equalTo(self.bgView);
            make.width.height.mas_equalTo(SCALES(20));
        }];
        [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.voicePlayerIcon.mas_right).offset(SCALES(12));
            make.centerY.equalTo(self.bgView);
        }];
        [self.voicePoint mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.bgView.mas_right).offset(SCALES(8));
            make.height.width.mas_equalTo(SCALES(12));
        }];
    } else {
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self);
            make.height.mas_equalTo(SCALES(38));
        }];
        [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(10));
            make.centerX.centerY.equalTo(self.bgView);
            make.right.equalTo(self.bgView).offset(SCALES(-10));
            make.width.mas_lessThanOrEqualTo(SCALES(245));//最大宽度限制
        }];
    }
}

- (void)setModel:(ASGoodAnchorModel *)model {
    _model = model;
    [[ASAudioPlayManager shared] stop];
    /* 关闭计时器 */
    [self.timerDisposable dispose];
    [self.voicePlayerIcon stopAnimating];
    if (!kStringIsEmpty(model.greetVoice)) {
        self.isPlaying = NO;
        self.content.text = [NSString stringWithFormat:@"%zds",model.greetVoiceLen];
        self.timers = model.greetVoiceLen;
        self.voicePlayerIcon.hidden = NO;
        self.voicePoint.hidden = NO;
    } else {
        self.content.text = STRING(model.greetTxt);
        self.voicePlayerIcon.hidden = YES;
        self.voicePoint.hidden = YES;
    }
    [self layoutSubviews];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = MAIN_COLOR;
        _bgView.layer.cornerRadius = SCALES(8);
        _bgView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_bgView addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (!kStringIsEmpty(wself.model.greetVoice)) {
                if (wself.isPlaying == NO) {
                    wself.voicePoint.hidden = YES;
                    wself.isPlaying = YES;
                    [wself.voicePlayerIcon startAnimating];
                    [[ASAudioPlayManager shared] playFromURL:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, wself.model.greetVoice]];
                    /* 定义计时器监听 */
                    wself.timerDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
                        wself.timers--;
                        wself.content.text = [NSString stringWithFormat:@"%zds",wself.timers];
                        if (wself.timers == 0) {
                            wself.isPlaying = NO;
                            [wself.voicePlayerIcon stopAnimating];
                            /* 关闭计时器 */
                            [wself.timerDisposable dispose];
                            [[ASAudioPlayManager shared] stop];
                            wself.content.text = [NSString stringWithFormat:@"%zds",wself.model.greetVoiceLen];
                            wself.timers = wself.model.greetVoiceLen;
                        }
                    }];
                } else {
                    wself.isPlaying = NO;
                    [wself.voicePlayerIcon stopAnimating];
                    /* 关闭计时器 */
                    [wself.timerDisposable dispose];
                    [[ASAudioPlayManager shared] stop];
                    wself.content.text = [NSString stringWithFormat:@"%zds",wself.model.greetVoiceLen];
                    wself.timers = wself.model.greetVoiceLen;
                }
            }
        }];
    }
    return _bgView;
}

- (UIImageView *)voicePlayerIcon {
    if (!_voicePlayerIcon) {
        _voicePlayerIcon = [[UIImageView alloc]init];
        _voicePlayerIcon.hidden = YES;
        _voicePlayerIcon.image = [UIImage imageNamed:@"taohua_voice3"];
        _voicePlayerIcon.animationDuration = 1;
        UIImage *image1 = [UIImage imageNamed:@"taohua_voice1"];
        UIImage *image2 = [UIImage imageNamed:@"taohua_voice2"];
        UIImage *image3 = [UIImage imageNamed:@"taohua_voice3"];
        _voicePlayerIcon.animationImages = @[image1,image2,image3];
    }
    return _voicePlayerIcon;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.textColor = UIColor.whiteColor;
        _content.font = TEXT_FONT_16;
    }
    return _content;
}

- (UIView *)voicePoint {
    if (!_voicePoint) {
        _voicePoint = [[UIView alloc]init];
        _voicePoint.backgroundColor = MAIN_COLOR;
        _voicePoint.layer.cornerRadius = SCALES(6);
        _voicePoint.layer.masksToBounds = YES;
        _voicePoint.hidden = YES;
    }
    return _voicePoint;
}
@end
