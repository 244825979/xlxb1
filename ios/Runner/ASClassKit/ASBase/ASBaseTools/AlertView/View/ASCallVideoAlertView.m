//
//  QWCallVideoAlertView.m
//  AS
//
//  Created by SA on 2025/6/19.
//

#import "ASCallVideoAlertView.h"
#import "ASVideoShowPlayerView.h"

@interface ASCallVideoAlertView ()
@property (nonatomic, strong) ASVideoShowPlayerView *videoShowPlayView;
@end

@implementation ASCallVideoAlertView

- (void)dealloc {
    [self.videoShowPlayView destoryPlayer];
}

//构造方法
- (instancetype)initCallVideoViewWithModel:(ASUserVideoPopModel *)model {
    if (self = [super init]) {
        self.size = CGSizeMake(SCALES(309), SCALES(528));
        kWeakSelf(self);
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"video_pop"];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        UIImageView *userImage = [[UIImageView alloc]init];
        userImage.contentMode = UIViewContentModeScaleAspectFill;
        [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar]]];
        userImage.layer.cornerRadius = SCALES(8);
        userImage.layer.masksToBounds = YES;
        [bgView addSubview:userImage];
        [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(64));
            make.centerX.equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(SCALES(269), SCALES(316)));
        }];
        if (model.is_video_show == 1) {
            userImage.hidden = YES;
            ASVideoShowDataModel *videoShowModel = [[ASVideoShowDataModel alloc] init];
            videoShowModel.cover_img_url = model.cover_img_url;
            videoShowModel.video_url = model.video_url;
            self.videoShowPlayView = [[ASVideoShowPlayerView alloc] init];
            self.videoShowPlayView.model = videoShowModel;
            self.videoShowPlayView.layer.masksToBounds = YES;
            self.videoShowPlayView.layer.cornerRadius = SCALES(6);
            [bgView addSubview:self.videoShowPlayView];
            [self.videoShowPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(userImage);
            }];
        }
        //昵称
        UILabel *nickName = [[UILabel alloc] init];
        nickName.font = TEXT_FONT_16;
        nickName.text = STRING(model.nickname);
        nickName.textColor = TITLE_COLOR;
        [bgView addSubview:nickName];
        [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(20));
            make.top.equalTo(userImage.mas_bottom).offset(SCALES(14));
            make.height.mas_equalTo(SCALES(20));
        }];
        //真人认证
        UIImageView *rpAuth = [[UIImageView alloc]init];
        rpAuth.image = [UIImage imageNamed:@"personal_zhenren"];
        [bgView addSubview:rpAuth];
        [rpAuth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nickName.mas_right).offset(SCALES(8));
            make.centerY.equalTo(nickName);
            make.height.mas_equalTo(SCALES(16));
            make.width.mas_equalTo(SCALES(40));
        }];
        //实名认证
        UIImageView *auth = [[UIImageView alloc]init];
        auth.image = [UIImage imageNamed:@"personal_shiming"];
        [bgView addSubview:auth];
        [auth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rpAuth.mas_right).offset(SCALES(4));
            make.centerY.equalTo(nickName);
            make.height.mas_equalTo(SCALES(16));
            make.width.mas_equalTo(SCALES(40));
        }];
        //金额图标
        UIImageView *moneyIcon = [[UIImageView alloc]init];
        moneyIcon.image = [UIImage imageNamed:@"money"];
        [bgView addSubview:moneyIcon];
        [moneyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nickName);
            make.top.equalTo(nickName.mas_bottom).offset(SCALES(6));
            make.height.width.mas_equalTo(SCALES(20));
        }];
        //提示
        UILabel *text = [[UILabel alloc]init];
        text.font = TEXT_FONT_14;
        text.text = STRING(model.video_price);
        text.textColor = TEXT_SIMPLE_COLOR;
        [bgView addSubview:text];
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moneyIcon.mas_right).offset(SCALES(4));
            make.centerY.equalTo(moneyIcon);
        }];
        //挂断
        UIButton *hangUpBtn = [[UIButton alloc] init];
        hangUpBtn.adjustsImageWhenHighlighted = NO;
        [hangUpBtn setBackgroundImage:[UIImage imageNamed:@"pop_guaduan"] forState:UIControlStateNormal];
        [[hangUpBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                [wself.videoShowPlayView destoryPlayer];
                wself.cancelBlock();
            }
        }];
        [bgView addSubview:hangUpBtn];
        [hangUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(20));
            make.height.mas_equalTo(SCALES(50));
            make.bottom.equalTo(bgView).offset(SCALES(-15));
        }];
        //接通
        UIButton *answerBtn = [[UIButton alloc] init];
        answerBtn.adjustsImageWhenHighlighted = NO;
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"pop_jieting"] forState:UIControlStateNormal];
        [[answerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.affirmBlock) {
                wself.affirmBlock();
            }
        }];
        [bgView addSubview:answerBtn];
        [answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.width.height.equalTo(hangUpBtn);
            make.left.equalTo(hangUpBtn.mas_right).offset(SCALES(15));
            make.right.offset(SCALES(-20));
        }];
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"updateBalanceNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            if (wself.cancelBlock) {
                [wself.videoShowPlayView destoryPlayer];
                wself.cancelBlock();
            }
        }];
    }
    return self;
}
@end
