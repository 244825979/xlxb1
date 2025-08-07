//
//  ASVisitorListCell.m
//  AS
//
//  Created by SA on 2025/6/30.
//

#import "ASVisitorListCell.h"

@interface ASVisitorListCell ()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UIButton *goChat;
@end

@implementation ASVisitorListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.header];
        [self.contentView addSubview:self.nickName];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.goChat];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(SCALES(60));
    }];
    [self.nickName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.header.mas_right).offset(SCALES(8));
        make.top.equalTo(self.header);
        make.height.mas_equalTo(SCALES(20));
        make.right.equalTo(self.contentView.mas_right).offset(SCALES(-70));
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickName.mas_bottom).offset(SCALES(4));
        make.left.right.equalTo(self.nickName);
        make.height.mas_equalTo(SCALES(16));
    }];
    [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content.mas_bottom).offset(SCALES(4));
        make.left.right.equalTo(self.nickName);
        make.height.mas_equalTo(SCALES(16));
    }];
    [self.goChat mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(SCALES(-14));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(51), SCALES(20)));
    }];
}

- (void)setModel:(ASUserInfoModel *)model {
    _model = model;
    [self.header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar]]];
    self.nickName.text = STRING(model.nickname);
    self.content.text = STRING(model.visitor_text);
    self.time.text = [NSString stringWithFormat:@"%@看过你", model.add_time];
    self.isBeckon = model.is_beckon;
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
    }
    return _content;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.textColor = TEXT_SIMPLE_COLOR;
        _time.font = TEXT_FONT_12;
    }
    return _time;
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
                    [wself.goChat setBackgroundImage:[UIImage imageNamed:@"home_chat"] forState:UIControlStateNormal];
                    wself.isBeckon = 1;
                }];
            } else {
                [ASMyAppCommonFunc chatWithUserID:wself.model.userid nickName:wself.model.nickname action:^(id  _Nonnull data) {
                    
                }];
            }
        }];
    }
    return _goChat;
}

@end
