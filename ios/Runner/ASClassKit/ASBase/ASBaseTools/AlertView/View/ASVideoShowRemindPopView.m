//
//  ASVideoShowRemindPopView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASVideoShowRemindPopView.h"

@interface ASVideoShowRemindPopView ()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *textHint;
@property (nonatomic, strong) UIView *userBg;
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *userText;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *affirmBtn;
@end

@implementation ASVideoShowRemindPopView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = UIColor.whiteColor;
        self.size = CGSizeMake(SCALES(307), SCALES(264));
        self.layer.cornerRadius = SCALES(12);
        [self addSubview:self.title];
        [self addSubview:self.textHint];
        [self addSubview:self.userBg];
        [self.userBg addSubview:self.headView];
        [self.userBg addSubview:self.nickName];
        [self.userBg addSubview:self.userText];
        [self addSubview:self.cancelBtn];
        [self addSubview:self.affirmBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(20));
        make.centerX.equalTo(self);
        make.height.mas_equalTo(SCALES(28));
    }];
    [self.textHint mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(SCALES(13));
        make.height.mas_equalTo(SCALES(24));
        make.centerX.equalTo(self);
    }];
    [self.userBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textHint.mas_bottom).offset(SCALES(13));
        make.left.mas_equalTo(SCALES(15));
        make.right.offset(SCALES(-15));
        make.height.mas_equalTo(SCALES(70));
    }];
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userBg);
        make.left.mas_equalTo(SCALES(6));
        make.height.width.mas_equalTo(SCALES(62));
    }];
    [self.nickName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_right).offset(SCALES(14));
        make.top.equalTo(self.headView).offset(SCALES(9));
        make.height.mas_equalTo(SCALES(24));
    }];
    [self.userText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickName);
        make.top.equalTo(self.nickName.mas_bottom).offset(SCALES(3));
        make.height.mas_equalTo(SCALES(18));
    }];
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userBg.mas_bottom).offset(SCALES(23));
        make.left.mas_equalTo(SCALES(26));
        make.height.mas_equalTo(SCALES(50));
    }];
    [self.affirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.cancelBtn);
        make.left.equalTo(self.cancelBtn.mas_right).offset(SCALES(13));
        make.right.offset(SCALES(-26));
    }];
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.text = @"设置视频秀";
        _title.textColor = TITLE_COLOR;
        _title.font = TEXT_MEDIUM(18);
    }
    return _title;
}

- (UILabel *)textHint {
    if (!_textHint) {
        _textHint = [[UILabel alloc]init];
        _textHint.textColor = MAIN_COLOR;
        _textHint.font = TEXT_FONT_15;
        //富文本设置
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:@"视频来电曝光率提升10倍！"];
        //设置部分字体颜色
        [attributed addAttribute:NSForegroundColorAttributeName
                                value:TEXT_COLOR
                                range:NSMakeRange(0, 7)];
        [_textHint setAttributedText:attributed];
    }
    return _textHint;
}

- (UIView *)userBg {
    if (!_userBg) {
        _userBg = [[UIView alloc]init];
        _userBg.backgroundColor = UIColorRGB(0xF5F5F5);
        _userBg.layer.cornerRadius = SCALES(10);
    }
    return _userBg;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn setBackgroundColor:UIColorRGB(0xEEEEEE)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = TEXT_FONT_18;
        _cancelBtn.layer.cornerRadius = SCALES(25);
        [_cancelBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        _cancelBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
        }];
    }
    return _cancelBtn;
}

- (UIButton *)affirmBtn {
    if (!_affirmBtn) {
        _affirmBtn = [[UIButton alloc]init];
        _affirmBtn.titleLabel.font = TEXT_FONT_18;
        [_affirmBtn setTitle:@"去设置" forState:UIControlStateNormal];
        _affirmBtn.adjustsImageWhenHighlighted = NO;
        [_affirmBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        _affirmBtn.layer.masksToBounds = YES;
        _affirmBtn.layer.cornerRadius = SCALES(25);
        kWeakSelf(self);
        [[_affirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.affirmBlock) {
                [wself removeView];
                wself.affirmBlock();
            }
        }];
    }
    return _affirmBtn;
}

- (UIImageView *)headView {
    if (!_headView) {
        _headView = [[UIImageView alloc]init];
        [_headView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, USER_INFO.avatar]]];
        _headView.contentMode = UIViewContentModeScaleAspectFill;
        _headView.layer.masksToBounds = YES;
        _headView.layer.cornerRadius = SCALES(8);
    }
    return _headView;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc]init];
        _nickName.text = STRING(USER_INFO.nickname);
        _nickName.textColor = TITLE_COLOR;
        _nickName.font = TEXT_FONT_16;
    }
    return _nickName;
}

- (UILabel *)userText {
    if (!_userText) {
        _userText = [[UILabel alloc]init];
        _userText.font = TEXT_FONT_13;
        _userText.textColor = TITLE_COLOR;
        _userText.text = @"等待有缘人！";
    }
    return _userText;
}

- (void)removeView {
    [self removeFromSuperview];
}
@end
