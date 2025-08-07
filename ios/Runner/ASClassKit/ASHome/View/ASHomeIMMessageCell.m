//
//  ASHomeIMMessageCell.m
//  AS
//
//  Created by SA on 2025/4/17.
//

#import "ASHomeIMMessageCell.h"
#import "心聊想伴-Swift.h"

@interface ASHomeIMMessageCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *content;
@end

@implementation ASHomeIMMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.bgView];
        self.bgView.frame = CGRectMake(0, 0, SCALES(118), SCALES(38));
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(SCALES(19), SCALES(19))];
         CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bgView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.bgView.layer.mask = maskLayer;
        
        [self.bgView addSubview:self.header];
        [self.bgView addSubview:self.name];
        [self.bgView addSubview:self.content];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(3));
        make.centerY.equalTo(self.bgView);
        make.width.height.mas_equalTo(SCALES(30));
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header).offset(SCALES(2));
        make.left.equalTo(self.header.mas_right).offset(SCALES(6));
        make.height.mas_equalTo(SCALES(14));
        make.right.offset(-SCALES(6));
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.name);
        make.top.equalTo(self.name.mas_bottom).offset(SCALES(2));
        make.height.mas_equalTo(SCALES(12));
    }];
}

- (void)setSession:(NIMRecentSession *)session {
    _session = session;
    NIMMessage *lastMessage = session.lastMessage;
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:lastMessage.from];
    self.name.text = STRING(lastMessage.senderName);
    self.content.text = [ASMyAppCommonFunc lastMessgeHint:lastMessage];
    if (kStringIsEmpty(user.userInfo.avatarUrl)) {//本地地址为空，从服务器中获取
        [[NIMSDK sharedSDK].userManager fetchUserInfos:@[STRING(lastMessage.from)] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
            if (users.count > 0) {
                NIMUser *userInfo = users[0];
                [self.header setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, STRING(userInfo.userInfo.avatarUrl)]] placeholder:nil];
            }
        }];
    } else {
        [self.header setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, STRING(user.userInfo.avatarUrl)]] placeholder:nil];
    }
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = CHANGE_BG_COLOR(UIColorRGB(0xFD6E6A), UIColorRGB(0xFFC600), SCALES(118), SCALES(38));
    }
    return _bgView;
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc] init];
        _header.contentMode = UIViewContentModeScaleAspectFill;
        _header.layer.cornerRadius = SCALES(15);
        _header.layer.masksToBounds = YES;
        _header.layer.borderColor = UIColor.whiteColor.CGColor;
        _header.layer.borderWidth = SCALES(1);
    }
    return _header;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.text = @"昵称";
        _name.textColor = UIColor.whiteColor;
        _name.font = TEXT_MEDIUM(12);
    }
    return _name;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.text = @"内容";
        _content.textColor = UIColor.whiteColor;
        _content.font = TEXT_FONT_10;
    }
    return _content;
}
@end
