//
//  ASLookListCell.m
//  AS
//
//  Created by SA on 2025/6/30.
//

#import "ASLookListCell.h"
#import "ASIMRequest.h"

@interface ASLookListCell ()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIButton *goChat;
@property (nonatomic, strong) UIButton *stealthAccess;//隐身访问
@property (nonatomic, assign) BOOL isOpenHidden;//是否开启隐身
@end

@implementation ASLookListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:self.header];
        [self.contentView addSubview:self.nickName];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.goChat];
        [self.contentView addSubview:self.stealthAccess];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(SCALES(60));
    }];
    [self.nickName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.header.mas_right).offset(SCALES(8));
        make.top.equalTo(self.header.mas_top).offset(SCALES(6));
        make.height.mas_equalTo(SCALES(20));
        make.right.equalTo(self.contentView.mas_right).offset(SCALES(-140));
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickName.mas_left);
        make.bottom.equalTo(self.header).offset(SCALES(-6));
        make.height.mas_equalTo(SCALES(16));
        make.right.equalTo(self.contentView.mas_right).offset(SCALES(-140));
    }];
    [self.stealthAccess mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(SCALES(-16));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(61), SCALES(20)));
    }];
    [self.goChat mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.stealthAccess.mas_left).offset(SCALES(-8));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(51), SCALES(20)));
    }];
}

- (void)setModel:(ASUserInfoModel *)model {
    _model = model;
    [self.header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar]]];
    self.nickName.text = STRING(model.nickname);
    self.content.text = [NSString stringWithFormat:@"%zd岁", model.age];
    if (!kStringIsEmpty(model.height) && kStringIsEmpty(model.occupation)) {
        self.content.text = [NSString stringWithFormat:@"%zd岁·%@", model.age, model.height];
    } else if (!kStringIsEmpty(model.height) && !kStringIsEmpty(model.occupation)) {
        self.content.text = [NSString stringWithFormat:@"%zd岁·%@·%@", model.age, model.height, model.occupation];
    } else if (kStringIsEmpty(model.height) && !kStringIsEmpty(model.occupation)) {
        self.content.text = [NSString stringWithFormat:@"%zd岁·%@", model.age, model.occupation];
    }
    self.isBeckon = model.is_beckon;
    self.isOpenHidden = model.is_hidden;
    if (model.vip == 1) {
        self.nickName.textColor = UIColor.redColor;
    } else {
        self.nickName.textColor = TITLE_COLOR;
    }
}

- (void)setIsBeckon:(BOOL)isBeckon {
    _isBeckon = isBeckon;
    if (isBeckon == 1) {
        [self.goChat setBackgroundImage:[UIImage imageNamed:@"sixin_icon"] forState:UIControlStateNormal];
    } else {
        [self.goChat setBackgroundImage:[UIImage imageNamed:@"dashan_icon"] forState:UIControlStateNormal];
    }
}

- (void)setIsOpenHidden:(BOOL)isOpenHidden {
    _isOpenHidden = isOpenHidden;
    self.stealthAccess.hidden = NO;
    if (isOpenHidden == 1) {
        [self.stealthAccess setBackgroundImage:[UIImage imageNamed:@"yins_list1"] forState:UIControlStateNormal];
    } else {
        [self.stealthAccess setBackgroundImage:[UIImage imageNamed:@"yins_list"] forState:UIControlStateNormal];
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

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc] init];
        _nickName.textColor = TITLE_COLOR;
        _nickName.font = TEXT_FONT_16;
        _nickName.text = @"昵称";
    }
    return _nickName;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = TITLE_COLOR;
        _content.font = TEXT_FONT_12;
        _content.text = @"";
    }
    return _content;
}

- (UIButton *)goChat {
    if (!_goChat) {
        _goChat = [[UIButton alloc] init];
        _goChat.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_goChat rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.model.is_beckon == 0) {
                [ASMyAppCommonFunc greetWithUserID:wself.model.userid action:^(id  _Nonnull data) {
                    wself.model.is_beckon = 1;
                    wself.isBeckon = 1;
                    [wself.goChat setBackgroundImage:[UIImage imageNamed:@"home_chat"] forState:UIControlStateNormal];
                }];
            } else {
                [ASMyAppCommonFunc chatWithUserID:wself.model.userid nickName:wself.model.nickname action:^(id  _Nonnull data) {
                    
                }];
            }
        }];
    }
    return _goChat;
}

- (UIButton *)stealthAccess {
    if (!_stealthAccess) {
        _stealthAccess = [[UIButton alloc]init];
        _stealthAccess.adjustsImageWhenHighlighted = NO;
        _stealthAccess.hidden = YES;
        kWeakSelf(self);
        [[_stealthAccess rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.model.is_hidden == 0) {
                if (USER_INFO.vip == 0) {
                    [ASMyAppCommonFunc openHidingClikedVipAction:^{
                        
                    }];
                    return;
                }
            }
            [ASIMRequest requestSetHideVisitWithUserID:wself.model.userid isSet:!wself.isOpenHidden success:^(id  _Nullable data) {
                wself.isOpenHidden = !wself.isOpenHidden;
                wself.model.is_hidden = !wself.isOpenHidden;
            } errorBack:^(NSInteger code, NSString *msg) {
            }];
        }];
    }
    return _stealthAccess;
}
@end
