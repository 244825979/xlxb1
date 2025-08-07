//
//  ASHomeOnlineUserListCell.m
//  AS
//
//  Created by SA on 2025/8/1.
//

#import "ASHomeOnlineUserListCell.h"

@interface ASHomeOnlineUserListCell()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UIView *isOnline;//是否在线
@property (nonatomic, strong) UIButton *goChat;//去打招呼or私聊
//第一行容器
@property (nonatomic, strong) UIStackView *stackView1;
@property (nonatomic, strong) UILabel *nickName;//昵称
@property (nonatomic, strong) UIImageView *auth;//实名认证
@property (nonatomic, strong) UIImageView *vip;//vip图标
//第二行容器
@property (nonatomic, strong) UIStackView *stackView2;
@property (nonatomic, strong) UILabel *height;//身高
@property (nonatomic, strong) UILabel *occupation;//职业
@property (nonatomic, strong) UILabel *age;//学历
//第三行容器
@property (nonatomic, strong) UIStackView *stackView3;
@property (nonatomic, strong) UILabel *signature;//个性签名
@property (nonatomic, strong) UIImageView *image1;
@property (nonatomic, strong) UIImageView *image2;
@property (nonatomic, strong) UIImageView *image3;
@end

@implementation ASHomeOnlineUserListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BACKGROUNDCOLOR;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.header];
        [self.header addSubview:self.isOnline];
        [self.contentView addSubview:self.goChat];
        [self.contentView addSubview:self.stackView1];
        [self.stackView1 addArrangedSubview:self.nickName];
        [self.stackView1 addArrangedSubview:self.auth];
        [self.stackView1 addArrangedSubview:self.vip];
        [self.stackView1 addArrangedSubview:[UIView new]];
        [self.auth mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCALES(40));
        }];
        [self.vip mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCALES(40));
        }];
        [self.contentView addSubview:self.stackView2];
        [self.stackView2 addArrangedSubview:self.age];
        [self.stackView2 addArrangedSubview:self.height];
        [self.stackView2 addArrangedSubview:self.occupation];
        [self.stackView2 addArrangedSubview:[UIView new]];
        [self.height mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCALES(50));
        }];
        [self.contentView addSubview:self.stackView3];
        [self.stackView3 addArrangedSubview:self.playView];
        [self.stackView3 addArrangedSubview:self.image1];
        [self.stackView3 addArrangedSubview:self.image2];
        [self.stackView3 addArrangedSubview:self.image3];
        [self.stackView3 addArrangedSubview:self.signature];
        [self.stackView3 addArrangedSubview:[UIView new]];
        [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCALES(28));
        }];
        [self.image2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCALES(28));
        }];
        [self.image3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCALES(28));
        }];
        [self.playView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCALES(115));
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(80), SCALES(80)));
    }];
    [self.isOnline mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(SCALES(8));
        make.size.mas_equalTo(CGSizeMake(SCALES(8), SCALES(8)));
    }];
    [self.stackView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.header.mas_right).offset(SCALES(12));
        make.top.equalTo(self.header).offset(SCALES(3));
        make.height.mas_equalTo(SCALES(16));
        make.right.equalTo(self.contentView).offset(SCALES(-16));
    }];
    [self.goChat mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(61));
        make.size.mas_equalTo(CGSizeMake(SCALES(51), SCALES(20)));
        make.right.equalTo(self.contentView).offset(SCALES(-16));
    }];
    [self.stackView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.stackView1);
        make.top.equalTo(self.stackView1.mas_bottom).offset(SCALES(7));
        make.height.mas_equalTo(SCALES(16));
    }];
    [self.stackView3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stackView2);
        make.right.equalTo(self.goChat.mas_left).offset(SCALES(-12));
        make.top.equalTo(self.stackView2.mas_bottom).offset(SCALES(7));
        make.height.mas_equalTo(SCALES(28));
    }];
}

- (void)setIsBeckon:(NSInteger)isBeckon {
    _isBeckon = isBeckon;
    if (isBeckon == 1) {
        [self.goChat setBackgroundImage:[UIImage imageNamed:@"sixin_icon"] forState:UIControlStateNormal];
    } else {
        [self.goChat setBackgroundImage:[UIImage imageNamed:@"dashan_icon"] forState:UIControlStateNormal];
    }
}

- (void)setModel:(ASHomeUserListModel *)model {
    _model = model;
    [self.header setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar]] placeholder:nil];
    self.nickName.text = STRING(model.nickname);
    //是否实名制
    if (model.is_auth == 1) {
        self.auth.hidden = NO;
    } else {
        self.auth.hidden = YES;
    }
    if (model.is_vip == 1) {
        self.nickName.textColor = MAIN_COLOR;
        self.vip.hidden = NO;
    } else {
        self.nickName.textColor = TITLE_COLOR;
        self.vip.hidden = YES;
    }
    self.age.text = [NSString stringWithFormat:@"  %zd岁  ",model.age];
    if (model.isHeight == YES) {
        self.height.hidden = NO;
        self.height.text = [NSString stringWithFormat:@"  %@  ",model.height];
    } else {
        self.height.hidden = YES;
    }
    if (!kStringIsEmpty(model.occupation)) {
        self.occupation.hidden = NO;
        self.occupation.text = [NSString stringWithFormat:@"  %@  ",model.occupation];
    } else {
        self.occupation.hidden = YES;
    }
    if (model.is_online == 1) {
        self.isOnline.hidden = NO;
    } else {
        self.isOnline.hidden = YES;
    }
    self.isBeckon = model.is_beckon;
    if (!kStringIsEmpty(model.mp3)) {
        ASVoiceModel *voiceModel = [[ASVoiceModel alloc] init];
        voiceModel.voice = model.mp3;
        voiceModel.voice_time = model.mp3_second;
        self.playView.model = voiceModel;
        self.playView.hidden = NO;
        self.signature.hidden = YES;
        self.image1.hidden = YES;
        self.image2.hidden = YES;
        self.image3.hidden = YES;
    } else {
        if (model.user_album.count > 0) {
            self.signature.hidden = YES;
            self.image1.hidden = YES;
            self.image2.hidden = YES;
            self.image3.hidden = YES;
            if (model.user_album.count == 1) {
                [self.image1 setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.user_album[0]]] placeholder:nil];
                self.image1.hidden = NO;
            }
            if (model.user_album.count == 2) {
                [self.image1 setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.user_album[0]]] placeholder:nil];
                [self.image2 setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.user_album[1]]] placeholder:nil];
                self.image1.hidden = NO;
                self.image2.hidden = NO;
            }
            if (model.user_album.count == 3 || model.user_album.count >3) {
                [self.image1 setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.user_album[0]]] placeholder:nil];
                [self.image2 setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.user_album[1]]] placeholder:nil];
                [self.image3 setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.user_album[2]]] placeholder:nil];
                self.image1.hidden = NO;
                self.image2.hidden = NO;
                self.image3.hidden = NO;
            }
        } else {
            self.signature.hidden = NO;
            self.signature.text = STRING(model.sign);
            self.image1.hidden = YES;
            self.image2.hidden = YES;
            self.image3.hidden = YES;
        }
        self.playView.hidden = YES;
    }
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.contentMode = UIViewContentModeScaleAspectFill;
        _header.layer.cornerRadius = SCALES(8);
        _header.layer.masksToBounds = YES;
    }
    return _header;
}

- (UIView *)isOnline {
    if (!_isOnline) {
        _isOnline = [[UIView alloc]init];
        _isOnline.hidden = YES;
        _isOnline.backgroundColor = UIColorRGB(0x63E170);
        _isOnline.layer.cornerRadius = SCALES(4);
    }
    return _isOnline;
}

- (UIStackView *)stackView1 {
    if (!_stackView1) {
        _stackView1 = [[UIStackView alloc]init];
        _stackView1.axis = UILayoutConstraintAxisHorizontal;
        _stackView1.distribution = UIStackViewDistributionFill;
        _stackView1.spacing = SCALES(4);
    }
    return _stackView1;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc] init];
        _nickName.textColor = TITLE_COLOR;
        _nickName.font = TEXT_MEDIUM(16);
        _nickName.text = @"昵称";
        [_nickName setContentHuggingPriority:UILayoutPrioritySceneSizeStayPut forAxis:UILayoutConstraintAxisHorizontal];//500拉伸权级
    }
    return _nickName;
}

- (UIImageView *)vip {
    if (!_vip) {
        _vip = [[UIImageView alloc]init];
        _vip.image = [UIImage imageNamed:@"personal_vip"];
        _vip.hidden = YES;
        [_vip setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _vip;
}

- (UIImageView *)auth {
    if (!_auth) {
        _auth = [[UIImageView alloc]init];
        _auth.image = [UIImage imageNamed:@"personal_shiming"];
        _auth.hidden = YES;
        [_auth setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _auth;
}

- (UIStackView *)stackView2 {
    if (!_stackView2) {
        _stackView2 = [[UIStackView alloc]init];
        _stackView2.axis = UILayoutConstraintAxisHorizontal;
        _stackView2.distribution = UIStackViewDistributionFill;
        _stackView2.spacing = SCALES(6);
    }
    return _stackView2;
}

- (ASHomeVoicePlayView *)playView {
    if (!_playView) {
        _playView = [[ASHomeVoicePlayView alloc]init];
        _playView.hidden = YES;
        kWeakSelf(self);
        _playView.actionBlack = ^{
            if (wself.actionBlack) {
                wself.actionBlack(wself.playView);
            }
        };
        [_playView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _playView;
}

- (UIImageView *)image1 {
    if (!_image1) {
        _image1 = [[UIImageView alloc]init];
        [_image1 setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _image1.contentMode = UIViewContentModeScaleAspectFill;
        _image1.layer.cornerRadius = SCALES(4);
        _image1.layer.masksToBounds = YES;
        _image1.hidden = YES;
    }
    return _image1;
}

- (UIImageView *)image2 {
    if (!_image2) {
        _image2 = [[UIImageView alloc]init];
        [_image2 setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _image2.contentMode = UIViewContentModeScaleAspectFill;
        _image2.layer.cornerRadius = SCALES(4);
        _image2.layer.masksToBounds = YES;
        _image2.hidden = YES;
    }
    return _image2;
}

- (UIImageView *)image3 {
    if (!_image3) {
        _image3 = [[UIImageView alloc]init];
        [_image3 setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _image3.contentMode = UIViewContentModeScaleAspectFill;
        _image3.layer.cornerRadius = SCALES(4);
        _image3.layer.masksToBounds = YES;
        _image3.hidden = YES;
    }
    return _image3;
}

- (UILabel *)signature {
    if (!_signature) {
        _signature = [[UILabel alloc]init];
        _signature.font = TEXT_FONT_13;
        _signature.textColor = TEXT_COLOR;
        _signature.hidden = YES;
        [_signature setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _signature;
}

- (UIButton *)goChat {
    if (!_goChat) {
        _goChat = [[UIButton alloc]init];
        _goChat.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_goChat rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.model.is_beckon == 0) {
                [ASMyAppCommonFunc greetWithUserID:wself.model.ID action:^(id  _Nonnull data) {
                    wself.model.is_beckon = 1;
                    wself.isBeckon = 1;
                    [wself.goChat setBackgroundImage:[UIImage imageNamed:@"sixin_icon"] forState:UIControlStateNormal];
                }];
            } else {
                [ASMyAppCommonFunc chatWithUserID:wself.model.ID nickName:wself.model.nickname action:^(id  _Nonnull data) {
                    
                }];
            }
        }];
    }
    return _goChat;
}

- (UIStackView *)stackView3 {
    if (!_stackView3) {
        _stackView3 = [[UIStackView alloc]init];
        _stackView3.axis = UILayoutConstraintAxisHorizontal;
        _stackView3.distribution = UIStackViewDistributionFill;
        _stackView3.spacing = SCALES(5);
    }
    return _stackView3;
}

- (UILabel *)age {
    if (!_age) {
        _age = [[UILabel alloc]init];
        _age.font = TEXT_FONT_11;
        _age.textColor = TEXT_SIMPLE_COLOR;
        _age.layer.cornerRadius = SCALES(8);
        _age.layer.masksToBounds = YES;
        _age.layer.borderColor = UIColorRGB(0xD9D9D9).CGColor;
        _age.layer.borderWidth = SCALES(1);
        [_age setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _age;
}

- (UILabel *)height {
    if (!_height) {
        _height = [[UILabel alloc]init];
        _height.font = TEXT_FONT_11;
        _height.textColor = TEXT_SIMPLE_COLOR;
        _height.layer.cornerRadius = SCALES(8);
        _height.layer.masksToBounds = YES;
        _height.layer.borderColor = UIColorRGB(0xD9D9D9).CGColor;
        _height.layer.borderWidth = SCALES(1);
        _height.textAlignment = NSTextAlignmentCenter;
        _height.hidden = YES;
        [_height setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _height;
}

- (UILabel *)occupation {
    if (!_occupation) {
        _occupation = [[UILabel alloc]init];
        _occupation.font = TEXT_FONT_11;
        _occupation.textColor = TEXT_SIMPLE_COLOR;
        _occupation.layer.cornerRadius = SCALES(8);
        _occupation.layer.masksToBounds = YES;
        _occupation.layer.borderColor = UIColorRGB(0xD9D9D9).CGColor;
        _occupation.layer.borderWidth = SCALES(1);
        _occupation.hidden = YES;
        [_occupation setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _occupation;
}
@end
