//
//  ASFansOrFollowListCell.m
//  AS
//
//  Created by SA on 2025/5/15.
//

#import "ASFansOrFollowListCell.h"

@interface ASFansOrFollowListCell ()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIButton *followBtn;
@end

@implementation ASFansOrFollowListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.clearColor;
        self.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:self.header];
        [self.contentView addSubview:self.nickName];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.followBtn];
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
        make.left.equalTo(self.header.mas_right).offset(SCALES(12));
        make.top.equalTo(self.header.mas_top).offset(SCALES(4));
        make.height.mas_equalTo(SCALES(24));
        make.right.equalTo(self.contentView.mas_right).offset(SCALES(-80));
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickName.mas_left);
        make.bottom.equalTo(self.header).offset(SCALES(-6));
        make.height.mas_equalTo(SCALES(16));
        make.right.equalTo(self.contentView.mas_right).offset(SCALES(-80));
    }];
    [self.followBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(SCALES(-16));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(52), SCALES(24)));
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
    self.isFollow = model.is_follow;
    if (model.vip == 1) {
        self.nickName.textColor = RED_COLOR;
    } else {
        self.nickName.textColor = TITLE_COLOR;
    }
}

- (void)setType:(FansOrFollowType)type {
    _type = type;
}

- (void)setIsFollow:(NSInteger)isFollow {
    _isFollow = isFollow;
    if (isFollow == 1) {
        if (self.type == kFansCellType) {
            [self.followBtn setBackgroundColor:UIColorRGB(0xFFF3F5)];
            [self.followBtn setTitle:@"互关" forState:UIControlStateNormal];
        } else {
            [self.followBtn setBackgroundColor:UIColorRGB(0xFFF3F5)];
            [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        }
        [self.followBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    } else {
        [self.followBtn setBackgroundColor:MAIN_COLOR];
        if (self.type == kFansCellType) {
            [self.followBtn setTitle:@"回关" forState:UIControlStateNormal];
        } else {
            [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        }
        [self.followBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.contentMode = UIViewContentModeScaleAspectFill;
        _header.layer.cornerRadius = SCALES(30);
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
        _content.textColor = TEXT_SIMPLE_COLOR;
        _content.font = TEXT_FONT_14;
        _content.text = @"";
    }
    return _content;
}

- (UIButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [[UIButton alloc] init];
        _followBtn.adjustsImageWhenHighlighted = NO;
        _followBtn.titleLabel.font = TEXT_FONT_12;
        _followBtn.layer.cornerRadius = SCALES(12);
        _followBtn.layer.masksToBounds = YES;
        kWeakSelf(self);
        [[_followBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASMyAppCommonFunc followWithUserID:wself.model.userid action:^(id  _Nonnull data) {
                NSString *isFollow = data;
                if ([isFollow isEqualToString:@"add"]) {
                    wself.isFollow = 1;
                    wself.model.is_follow = 1;
                    kShowToast(@"已关注");
                } else if ([isFollow isEqualToString:@"delete"]) {
                    wself.isFollow = 0;
                    wself.model.is_follow = 0;
                    kShowToast(@"取消关注");
                }
            }];
        }];
    }
    return _followBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
