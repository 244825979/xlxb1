//
//  ASMineTopView.m
//  AS
//
//  Created by SA on 2025/4/18.
//

#import "ASMineTopView.h"
#import "ASMineVipView.h"
#import "ASMineAccountView.h"
#import <SVGAImageView.h>

@interface ASMineTopView ()
@property (nonatomic, strong) ASMineVipView *vipView;
@property (nonatomic, strong) ASMineAccountView *accountView;
@property (nonatomic, strong) UIImageView *topBg;
@property (nonatomic, strong) UIImageView *header;//头像
@property (nonatomic, strong) UILabel *nickName;//昵称
@property (nonatomic, strong) UILabel *userCode;//用户号
@property (nonatomic, strong) UIButton *codeCopy;//复制
@property (nonatomic, strong) UIView *editView;//编辑
@property (nonatomic, strong) SVGAImageView *editSvga;//编辑的svga显示
@property (nonatomic, strong) UIView *userAcountBg;//用户数据背景
@property (nonatomic, strong) NSArray *userAcountTitles;
@end

@implementation ASMineTopView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.topBg];
        [self addSubview:self.header];
        [self addSubview:self.nickName];
        [self addSubview:self.userCode];
        [self addSubview:self.codeCopy];
        [self addSubview:self.editView];
        [self.editView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(SCALES(-14));
            make.top.mas_equalTo(STATUS_BAR_HEIGHT + SCALES(10));
            make.width.mas_equalTo(SCALES(76));
            make.height.mas_equalTo(SCALES(28));
        }];
        [self addSubview:self.editSvga];
        [self.editSvga mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.editView).offset(SCALES(6));
            make.centerY.equalTo(self.editView);
            make.width.mas_equalTo(SCALES(23));
            make.height.mas_equalTo(SCALES(19));
        }];
        [self addSubview:self.userAcountBg];
        [self.userAcountBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(SCALES(11));
            make.right.offset(SCALES(-11));
            make.top.mas_equalTo(STATUS_BAR_HEIGHT + SCALES(91));
            make.height.mas_equalTo(SCALES(76));
        }];
        CGFloat btnW = (SCREEN_WIDTH - SCALES(22))/4;
        self.userAcountTitles = @[@"关注", @"粉丝", @"看过", @"访客"];
        for (int i = 0; i < self.userAcountTitles.count; i++) {
            UIView *item = [self createBtn:@"0" andTitle:self.userAcountTitles[i]];
            item.frame = CGRectMake(i*btnW, 0, btnW, SCALES(76));
            [self.userAcountBg addSubview:item];
        }
        [self addSubview:self.vipView];
        [self addSubview:self.accountView];
        [self.vipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(14));
            make.right.equalTo(self.mas_right).offset(SCALES(-14));
            make.top.mas_equalTo(SCALES(169) + STATUS_BAR_HEIGHT);
            make.height.mas_equalTo(SCALES(80));
        }];
        //半圆角
        self.accountView.frame = CGRectMake(SCALES(14), STATUS_BAR_HEIGHT + SCALES(245), SCREEN_WIDTH - SCALES(28), SCALES(70));
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.accountView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(SCALES(12), SCALES(12))];
         CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.accountView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.accountView.layer.mask = maskLayer;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.topBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.height.mas_equalTo(SCALES(217)+STATUS_BAR_HEIGHT);
    }];
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.top.mas_equalTo(SCALES(8) + STATUS_BAR_HEIGHT);
        make.width.height.mas_equalTo(SCALES(84));
    }];
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.header.mas_right).offset(SCALES(12));
        make.right.equalTo(self.mas_right).offset(SCALES(-16));
        make.height.mas_equalTo(SCALES(26));
        make.centerY.equalTo(self.header);
    }];
    [self.userCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickName);
        make.height.mas_equalTo(SCALES(26));
        make.bottom.equalTo(self.header);
    }];
    [self.codeCopy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userCode.mas_right).offset(SCALES(5));
        make.centerY.equalTo(self.userCode);
        make.size.mas_equalTo(CGSizeMake(SCALES(28), SCALES(14)));
    }];
}

- (void)setModel:(ASMineUserModel *)model {
    _model = model;
    self.vipView.model = model;
    [self.header sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.userinfo.avatar]]];
    self.nickName.text = STRING(model.userinfo.nickname);
    self.userCode.text = [NSString stringWithFormat:@"用户号：%@",model.userinfo.usercode];
    kWeakSelf(self);
    [self.userAcountBg removeAllSubviews];
    CGFloat btnW = (SCREEN_WIDTH - SCALES(20))/4;
    NSArray *userCounts = @[[NSString stringWithFormat:@"%zd", model.usercount.follow_count],
                            [NSString stringWithFormat:@"%zd", model.usercount.fans_count],
                            [NSString stringWithFormat:@"%zd", model.usercount.viewer_count],
                            [NSString stringWithFormat:@"%zd", model.usercount.visitor_count]];
    for (int i = 0; i < self.userAcountTitles.count; i++) {
        UIView *item = [self createBtn:userCounts[i] andTitle:self.userAcountTitles[i]];
        item.frame = CGRectMake(i*btnW, 0, btnW, SCALES(76));
        [self.userAcountBg addSubview:item];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [item addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.indexNameBlock) {
                wself.indexNameBlock(wself.userAcountTitles[i]);
            }
        }];
    }
    self.nickName.textColor = (model.userinfo.vip == 1 ? RED_COLOR : TITLE_COLOR);
    if (model.is_show_red_packet == 1) {
        [self.editView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(SCALES(-14));
            make.top.mas_equalTo(STATUS_BAR_HEIGHT + SCALES(10));
            make.width.mas_equalTo(SCALES(96));
            make.height.mas_equalTo(SCALES(28));
        }];
        self.editSvga.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.editSvga startAnimation];
        });
    } else {
        self.editSvga.hidden = YES;
        [self.editView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(SCALES(-14));
            make.top.mas_equalTo(STATUS_BAR_HEIGHT + SCALES(10));
            make.width.mas_equalTo(SCALES(76));
            make.height.mas_equalTo(SCALES(28));
        }];
    }
}

- (void)setMoneyModel:(ASAccountMoneyModel *)moneyModel {
    _moneyModel = moneyModel;
    self.accountView.model = moneyModel;
}

- (UIImageView *)topBg {
    if (!_topBg) {
        _topBg = [[UIImageView alloc]init];
        _topBg.image = [UIImage imageNamed:@"mine_top"];
        _topBg.contentMode = UIViewContentModeScaleAspectFill;
        _topBg.userInteractionEnabled = YES;
    }
    return _topBg;
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.layer.cornerRadius = SCALES(42);
        _header.layer.masksToBounds = YES;
        _header.layer.borderWidth = SCALES(1);
        _header.layer.borderColor = UIColor.whiteColor.CGColor;
        _header.contentMode = UIViewContentModeScaleAspectFill;
        _header.userInteractionEnabled = YES;
        [_header sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, USER_INFO.avatar]]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_header addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.indexNameBlock) {
                wself.indexNameBlock(@"我的主页");
            }
        }];
    }
    return _header;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc] init];
        _nickName.font = TEXT_MEDIUM(20);
        _nickName.textColor = (USER_INFO.vip == 1 ? RED_COLOR : TITLE_COLOR);
        _nickName.text = USER_INFO.nickname;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_nickName addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.indexNameBlock) {
                wself.indexNameBlock(@"我的主页");
            }
        }];
    }
    return _nickName;
}

- (UILabel *)userCode {
    if (!_userCode) {
        _userCode = [[UILabel alloc]init];
        _userCode.text = [NSString stringWithFormat:@"用户号：%@",USER_INFO.usercode];
        _userCode.textColor = UIColorRGB(0x333333);
        _userCode.font = TEXT_FONT_14;
    }
    return _userCode;
}

- (UIButton *)codeCopy {
    if (!_codeCopy) {
        _codeCopy = [[UIButton alloc]init];
        _codeCopy.adjustsImageWhenHighlighted = NO;
        [_codeCopy setBackgroundImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
        [[_codeCopy rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            pab.string = STRING(USER_INFO.usercode);
            if (pab == nil) {
                kShowToast(@"复制失败");
            } else {
                kShowToast(@"复制成功");
            }
        }];
    }
    return _codeCopy;
}

- (UIView *)editView {
    if (!_editView) {
        _editView = [[UIButton alloc]init];
        _editView.backgroundColor = UIColor.whiteColor;
        _editView.layer.cornerRadius = SCALES(14);
        _editView.layer.masksToBounds = YES;
        _editView.layer.borderColor = RED_COLOR.CGColor;
        _editView.layer.borderWidth = SCALES(1);
        UILabel *editText = [[UILabel alloc] init];
        editText.text = @"编辑资料";
        editText.textColor = TITLE_COLOR;
        editText.font = TEXT_FONT_12;
        [_editView addSubview:editText];
        [editText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_editView.mas_right).offset(SCALES(-16));
            make.centerY.equalTo(_editView);
        }];
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"cell_back4"];
        [_editView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_editView.mas_right).offset(SCALES(-6));
            make.centerY.equalTo(_editView);
            make.size.mas_equalTo(CGSizeMake(SCALES(7), SCALES(10)));
        }];
        kWeakSelf(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_editView addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.indexNameBlock) {
                wself.indexNameBlock(@"编辑资料");
            }
        }];
    }
    return _editView;
}

- (SVGAImageView *)editSvga {
    if (!_editSvga) {
        _editSvga = [[SVGAImageView alloc]init];
        _editSvga.imageName = @"edit_data_red";
        _editSvga.hidden = YES;
    }
    return _editSvga;
}

- (UIView *)userAcountBg {
    if (!_userAcountBg) {
        _userAcountBg = [[UIView alloc]init];
    }
    return _userAcountBg;
}

- (ASMineVipView *)vipView {
    if (!_vipView) {
        _vipView = [[ASMineVipView alloc]init];
        kWeakSelf(self);
        _vipView.indexNameBlock = ^(NSString * _Nonnull indexName) {
            if (wself.indexNameBlock) {
                wself.indexNameBlock(indexName);
            }
        };
    }
    return _vipView;
}

- (ASMineAccountView *)accountView {
    if (!_accountView) {
        _accountView = [[ASMineAccountView alloc]init];
        kWeakSelf(self);
        _accountView.indexNameBlock = ^(NSString * _Nonnull indexName) {
            if (wself.indexNameBlock) {
                wself.indexNameBlock(indexName);
            }
        };
    }
    return _accountView;
}

- (UIView *)createBtn:(NSString *)acount andTitle:(NSString *)title {
    UIView *item = [[UIView alloc] init];
    UILabel *acountLabel = [[UILabel alloc] init];
    acountLabel.text = STRING(acount);
    acountLabel.textColor = TITLE_COLOR;
    acountLabel.font = TEXT_MEDIUM(18);
    acountLabel.textAlignment = NSTextAlignmentCenter;
    [item addSubview:acountLabel];
    [acountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(20));
        make.left.right.equalTo(item);
        make.height.mas_equalTo(SCALES(20));
     }];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = STRING(title);
    titleLabel.textColor = TITLE_COLOR;
    titleLabel.font = TEXT_FONT_12;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [item addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(acountLabel.mas_bottom).offset(SCALES(8));
        make.centerX.equalTo(acountLabel.mas_centerX);
        make.height.mas_equalTo(SCALES(16));
     }];
    return item;
}
@end
