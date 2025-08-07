//
//  ASMyFaceAuthVerifyView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASMyFaceAuthVerifyView.h"

@interface ASMyFaceAuthVerifyView ()
@property (nonatomic, strong) UIImageView *bgIcon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIButton *commit;
@end

@implementation ASMyFaceAuthVerifyView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = UIColor.whiteColor;
        self.size = CGSizeMake(SCREEN_WIDTH, (SCALES(310)) + TAB_BAR_MAGIN);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(SCALES(12), SCALES(12))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        [self addSubview:self.bgIcon];
        [self addSubview:self.title];
        [self addSubview:self.content];
        [self addSubview:self.commit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(28));
        make.centerX.equalTo(self);
        make.height.width.mas_equalTo(SCALES(94));
    }];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgIcon.mas_bottom).offset(SCALES(12));
        make.height.mas_equalTo(SCALES(22));
        make.centerX.equalTo(self.bgIcon);
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(SCALES(17));
        make.left.mas_equalTo(SCALES(34));
        make.right.offset(SCALES(-34));
    }];
    [self.commit mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content.mas_bottom).offset(SCALES(25));
        make.centerX.equalTo(self.bgIcon);
        make.width.mas_equalTo(SCALES(255));
        make.height.mas_equalTo(SCALES(49));
    }];
}

- (UIImageView *)bgIcon {
    if (!_bgIcon) {
        _bgIcon = [[UIImageView alloc]init];
        _bgIcon.image = [UIImage imageNamed:@"zhenren_heyan"];
    }
    return _bgIcon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.text = @"真人核验";
        _title.textColor = TITLE_COLOR;
        _title.font = TEXT_FONT_18;
    }
    return _title;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.attributedText = [ASCommonFunc attributedWithString:@"智能风控系统检测到您的账号涉嫌安全风险，需要核对真人认证，方可解除风险提醒。" lineSpacing:SCALES(4.0)];
        _content.textColor = UIColorRGB(0x333333);
        _content.font = TEXT_FONT_14;
        _content.numberOfLines = 0;
        _content.textAlignment = NSTextAlignmentCenter;
    }
    return _content;
}

- (UIButton *)commit {
    if (!_commit) {
        _commit = [[UIButton alloc]init];
        [_commit setTitle:@"立即核验" forState:UIControlStateNormal];
        [_commit setBackgroundColor:GRDUAL_CHANGE_BG_COLOR(SCALES(255), SCALES(50))];
        _commit.titleLabel.font = TEXT_FONT_18;
        _commit.layer.cornerRadius = SCALES(25);
        _commit.layer.masksToBounds = YES;
        kWeakSelf(self);
        [[_commit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
                [wself removeView];
            }
            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
            vc.webUrl = USER_INFO.systemIndexModel.matchAuth;
            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
        }];
    }
    return _commit;
}

- (void)removeView {
    [self removeFromSuperview];
}

@end
