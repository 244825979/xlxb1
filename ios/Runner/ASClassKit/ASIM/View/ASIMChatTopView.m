//
//  ASIMChatTopView.m
//  AS
//
//  Created by SA on 2025/5/15.
//

#import "ASIMChatTopView.h"

@interface ASIMChatTopView ()
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIStackView *stackView;//整体容器
@property (nonatomic, strong) UIStackView *stackView1;//第一行容器
@property (nonatomic, strong) UIImageView *icon1;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UIStackView *stackView2;//第二行容器
@property (nonatomic, strong) UIImageView *icon2;
@property (nonatomic, strong) UIView *signBg;
@property (nonatomic, strong) UIStackView *stackView3;//第三行容器
@property (nonatomic, strong) UIImageView *icon3;
@property (nonatomic, strong) UILabel *infoText;
@property (nonatomic, strong) UIStackView *stackView4;//第四行容器
@property (nonatomic, strong) UIImageView *icon4;
@property (nonatomic, strong) UIScrollView *albumsBg;
@property (nonatomic, strong) UIStackView *stackView5;//第五行容器
@property (nonatomic, strong) UIImageView *icon5;
@property (nonatomic, strong) UILabel *subjectTaskText;
@property (nonatomic, strong) UIButton *userBtn;
/**数据**/
@property (nonatomic, assign) NSInteger isFollow;
@end

@implementation ASIMChatTopView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.bgImage];
        [self.bgImage addSubview:self.stackView];
        [self.bgImage addSubview:self.userBtn];
        [self.stackView addArrangedSubview:self.stackView1];
        [self.stackView addArrangedSubview:self.stackView2];
        [self.stackView addArrangedSubview:self.stackView3];
        [self.stackView addArrangedSubview:self.stackView4];
        [self.stackView addArrangedSubview:self.stackView5];
        [self.stackView1 addArrangedSubview:self.icon1];
        [self.stackView1 addArrangedSubview:self.nickName];
        [self.stackView1 addArrangedSubview:self.followBtn];
        [self.stackView1 addArrangedSubview:[UIView new]];
        [self.stackView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
        }];
        [self.icon1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(20);
        }];
        [self.followBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 20));
        }];
        [self.stackView2 addArrangedSubview:self.icon2];
        [self.stackView2 addArrangedSubview:self.signBg];
        [self.stackView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.stackView1);
        }];
        [self.icon2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.icon1);
        }];
        [self.signBg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH - 62 - 26);;
        }];
        [self.stackView3 addArrangedSubview:self.icon3];
        [self.stackView3 addArrangedSubview:self.infoText];
        [self.stackView3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.stackView1);
        }];
        [self.icon3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.icon1);
        }];
        [self.stackView4 addArrangedSubview:self.icon4];
        [self.stackView4 addArrangedSubview:self.albumsBg];
        [self.stackView4 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(46);
        }];
        [self.icon4 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.icon1);
        }];
        [self.albumsBg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(SCREEN_WIDTH - 62 - 26);
        }];
        [self.stackView5 addArrangedSubview:self.icon5];
        [self.stackView5 addArrangedSubview:self.subjectTaskText];
        [self.icon5 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.icon1);
        }];
        [self.subjectTaskText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH - 62 - 26);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(46);
        make.left.mas_equalTo(SCALES(16));
        make.right.equalTo(self.mas_right).offset(SCALES(-16));
        make.bottom.equalTo(self);
    }];
    [self.userBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.bgImage);
        make.size.mas_equalTo(CGSizeMake(80, 24));
    }];
    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(16);
        make.right.equalTo(self.bgImage).offset(-12);
        make.bottom.equalTo(self).offset(-16);
    }];
}

- (void)setModel:(ASIMChatCardModel *)model {
    _model = model;
    self.nickName.text = STRING(model.nickname);
    self.infoText.text = STRING(model.base_info);
    self.subjectTaskText.text = STRING(model.subjectTask);
    self.followBtn.hidden = NO;
    self.isFollow = model.is_follow;
    if (model.chat_label_new.count > 0) {
        self.stackView2.hidden = NO;
        NSInteger lableR = 0;
        for (int i = 0; i < model.chat_label_new.count; i++) {
            NSString *text = model.chat_label_new[i];
            UILabel *label = [[UILabel alloc] init];
            CGFloat labelW = [ASCommonFunc getSizeWithText:STRING(text) maxLayoutHeight:16 font:TEXT_FONT_10];
            label.frame = CGRectMake(lableR, 2, labelW+10, 16);
            label.text = STRING(text);
            label.font = TEXT_FONT_10;
            label.textColor = TEXT_SIMPLE_COLOR;
            label.backgroundColor = UIColorRGB(0xF7F7F9);
            label.layer.cornerRadius = 8;
            label.layer.masksToBounds = YES;
            label.layer.borderColor = UIColorRGB(0xF7F7F9).CGColor;
            label.layer.borderWidth = 1;
            label.textAlignment = NSTextAlignmentCenter;
            [self.signBg addSubview:label];
            lableR += (labelW+15);
        }
    } else {
        self.stackView2.hidden = YES;
    }
    if (model.albumList.count > 0) {
        self.stackView4.hidden = NO;
        NSInteger imageR = 0;
        for (int i = 0; i < model.albumList.count; i++) {
            id data = model.albumList[i];
            UIImageView *image = [[UIImageView alloc] init];
            image.frame = CGRectMake(imageR, 0, 46, 46);
            image.contentMode = UIViewContentModeScaleAspectFill;
            if ([data isKindOfClass:NSString.class]) {
                NSString *url = data;
                [image setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, url]] placeholder:nil];
            } else {
                ASIMAlbumListModel *albumListModel = data;
                [image setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, albumListModel.url]] placeholder:nil];
            }
            image.layer.cornerRadius = 4;
            image.layer.masksToBounds = YES;
            [self.albumsBg addSubview:image];
            imageR += (46+4);
            if (i == model.albumList.count -1) {
                self.albumsBg.contentSize = CGSizeMake(imageR + 52, 0);
            }
        }
    } else {
        self.stackView4.hidden = YES;
    }
}

- (void)setIsFollow:(NSInteger)isFollow {
    _isFollow = isFollow;
    if (isFollow == 0) {
        [self.followBtn setBackgroundImage:[UIImage imageNamed:@"chat_follow"] forState:UIControlStateNormal];
    } else {
        [self.followBtn setBackgroundImage:[UIImage imageNamed:@"chat_follow1"] forState:UIControlStateNormal];
    }
}

- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]init];
        _bgImage.image = [UIImage imageNamed:@"chat_top_bg"];
        _bgImage.userInteractionEnabled = YES;
    }
    return _bgImage;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc]init];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.spacing = 8;
    }
    return _stackView;
}

- (UIStackView *)stackView1 {
    if (!_stackView1) {
        _stackView1 = [[UIStackView alloc]init];
        _stackView1.axis = UILayoutConstraintAxisHorizontal;
        _stackView1.distribution = UIStackViewDistributionFill;
        _stackView1.spacing = 10;
    }
    return _stackView1;
}

- (UIImageView *)icon1 {
    if (!_icon1) {
        _icon1 = [[UIImageView alloc]init];
        _icon1.image = [UIImage imageNamed:@"chat_top1"];
    }
    return _icon1;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc] init];
        _nickName.textColor = TITLE_COLOR;
        _nickName.font = TEXT_MEDIUM(16);
        _nickName.text = @"昵称";
    }
    return _nickName;
}

- (UIButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [[UIButton alloc] init];
        _followBtn.hidden = YES;
        kWeakSelf(self);
        [[_followBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASMyAppCommonFunc followWithUserID:wself.model.user_id action:^(id  _Nonnull data) {
                NSString *isFollow = data;
                if ([isFollow isEqualToString:@"add"]) {
                    wself.isFollow = 1;
                    wself.model.is_follow = 1;
                    if (wself.indexBlock) {
                        wself.indexBlock(@"已关注");
                    }
                } else if ([isFollow isEqualToString:@"delete"]) {
                    wself.isFollow = 0;
                    wself.model.is_follow = 0;
                    if (wself.indexBlock) {
                        wself.indexBlock(@"取消关注");
                    }
                }
            }];
        }];
    }
    return _followBtn;
}

- (UIStackView *)stackView2 {
    if (!_stackView2) {
        _stackView2 = [[UIStackView alloc]init];
        _stackView2.axis = UILayoutConstraintAxisHorizontal;
        _stackView2.distribution = UIStackViewDistributionFill;
        _stackView2.spacing = 10;
        _stackView2.hidden = YES;
    }
    return _stackView2;
}

- (UIImageView *)icon2 {
    if (!_icon2) {
        _icon2 = [[UIImageView alloc]init];
        _icon2.image = [UIImage imageNamed:@"chat_top2"];
    }
    return _icon2;
}

- (UIView *)signBg {
    if (!_signBg) {
        _signBg = [[UIView alloc]init];
    }
    return _signBg;
}

- (UIStackView *)stackView3 {
    if (!_stackView3) {
        _stackView3 = [[UIStackView alloc]init];
        _stackView3.axis = UILayoutConstraintAxisHorizontal;
        _stackView3.distribution = UIStackViewDistributionFill;
        _stackView3.spacing = 8;
    }
    return _stackView3;
}

- (UIImageView *)icon3 {
    if (!_icon3) {
        _icon3 = [[UIImageView alloc]init];
        _icon3.image = [UIImage imageNamed:@"chat_top3"];
    }
    return _icon3;
}

- (UILabel *)infoText {
    if (!_infoText) {
        _infoText = [[UILabel alloc] init];
        _infoText.textColor = TITLE_COLOR;
        _infoText.font = TEXT_FONT_14;
        _infoText.text = @"一级文字";
    }
    return _infoText;
}

- (UIStackView *)stackView4 {
    if (!_stackView4) {
        _stackView4 = [[UIStackView alloc]init];
        _stackView4.axis = UILayoutConstraintAxisHorizontal;
        _stackView4.distribution = UIStackViewDistributionFill;
        _stackView4.alignment = UIStackViewAlignmentCenter;
        _stackView4.spacing = 8;
    }
    return _stackView4;
}

- (UIImageView *)icon4 {
    if (!_icon4) {
        _icon4 = [[UIImageView alloc]init];
        _icon4.image = [UIImage imageNamed:@"chat_top4"];
    }
    return _icon4;
}

- (UIScrollView *)albumsBg {
    if (!_albumsBg) {
        _albumsBg = [[UIScrollView alloc] init];
    }
    return _albumsBg;
}

- (UIStackView *)stackView5 {
    if (!_stackView5) {
        _stackView5 = [[UIStackView alloc]init];
        _stackView5.axis = UILayoutConstraintAxisHorizontal;
        _stackView5.distribution = UIStackViewDistributionFill;
        _stackView5.alignment = UIStackViewAlignmentCenter;
        _stackView5.spacing = 8;
    }
    return _stackView5;
}

- (UIImageView *)icon5 {
    if (!_icon5) {
        _icon5 = [[UIImageView alloc]init];
        _icon5.image = [UIImage imageNamed:@"chat_top5"];
    }
    return _icon5;
}

- (UILabel *)subjectTaskText {
    if (!_subjectTaskText) {
        _subjectTaskText = [[UILabel alloc] init];
        _subjectTaskText.textColor = TITLE_COLOR;
        _subjectTaskText.font = TEXT_FONT_14;
        _subjectTaskText.numberOfLines = 0;
        _subjectTaskText.preferredMaxLayoutWidth = SCREEN_WIDTH - 62 - 26;
    }
    return _subjectTaskText;
}

- (UIButton *)userBtn {
    if (!_userBtn) {
        _userBtn = [[UIButton alloc]init];
        [_userBtn setBackgroundImage:[UIImage imageNamed:@"chat_top_data"] forState:UIControlStateNormal];
        _userBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_userBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASMyAppCommonFunc goPersonalHomeWithUserID:wself.model.user_id viewController:[ASCommonFunc currentVc] action:^(id  _Nonnull data) {
                
            }];
        }];
    }
    return _userBtn;
}
@end
