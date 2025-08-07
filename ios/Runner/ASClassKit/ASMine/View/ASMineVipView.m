//
//  ASMineVipView.m
//  AS
//
//  Created by SA on 2025/4/18.
//

#import "ASMineVipView.h"
#import "CustomButton.h"

@interface ASMineVipView()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UILabel *text1;
@property (nonatomic, strong) UILabel *text2;
@property (nonatomic, strong) CustomButton *openBtn;
@end

@implementation ASMineVipView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.text1];
        [self.bgView addSubview:self.text2];
        [self.bgView addSubview:self.openBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.text1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(83));
        make.top.mas_equalTo(SCALES(18));
        make.height.mas_equalTo(SCALES(24));
    }];
    [self.text2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.text1);
        make.top.equalTo(self.text1.mas_bottom).offset(SCALES(3));
        make.height.mas_equalTo(SCALES(18));
    }];
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(SCALES(76), SCALES(24)));
    }];
}

- (void)setModel:(ASMineUserModel *)model {
    _model = model;
    self.text2.text = STRING(model.userinfo.vip_des);
    if (model.userinfo.vip == 1) {
        [self.openBtn setTitle:@"   马上续费" forState:UIControlStateNormal];
    } else {
        [self.openBtn setTitle:@"   立即开通" forState:UIControlStateNormal];
    }
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
        _bgView.image = [UIImage imageNamed:@"mine_vip_bg"];
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_bgView addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.indexNameBlock) {
                wself.indexNameBlock(@"开通vip");
            }
        }];
    }
    return _bgView;
}

- (UILabel *)text1 {
    if (!_text1) {
        _text1 = [[UILabel alloc] init];
        _text1.textColor = UIColorRGB(0x4F0000);
        _text1.font = TEXT_MEDIUM(18);
        _text1.text = @"开通VIP会员";
    }
    return _text1;
}

- (UILabel *)text2 {
    if (!_text2) {
        _text2 = [[UILabel alloc] init];
        _text2.textColor = UIColorRGB(0x4F0000);
        _text2.font = TEXT_FONT_13;
        _text2.text = STRING(self.model.userinfo.vip_des);
    }
    return _text2;
}

- (CustomButton *)openBtn {
    if (!_openBtn) {
        _openBtn = [[CustomButton alloc]init];
        _openBtn.titleLabel.font = TEXT_MEDIUM(12);
        [_openBtn setTitle:@"   立即开通" forState:UIControlStateNormal];
        [_openBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_openBtn setImage:[UIImage imageNamed:@"cell_back1"] forState:UIControlStateNormal];
        _openBtn.userInteractionEnabled = NO;
    }
    return _openBtn;
}
@end
