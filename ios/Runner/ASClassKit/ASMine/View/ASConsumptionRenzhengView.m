//
//  ASConsumptionRenzhengView.m
//  AS
//
//  Created by SA on 2025/5/22.
//

#import "ASConsumptionRenzhengView.h"

@interface ASConsumptionRenzhengView()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *titleIcon;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *goCertification;
@property (nonatomic, strong) UIImageView *goCertificationIcon;
@end

@implementation ASConsumptionRenzhengView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.title];
        [self.bgView addSubview:self.titleIcon];
        [self.bgView addSubview:self.content];
        [self.bgView addSubview:self.goCertification];
        [self.bgView addSubview:self.goCertificationIcon];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self.bgView addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.model.is_auth != 1) {
                if (wself.actionBlock) {
                    wself.actionBlock();
                }
            }
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.mas_equalTo(SCALES(20));
        make.height.mas_equalTo(SCALES(24));
    }];
    [self.titleIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title);
        make.left.equalTo(self.title.mas_right).offset(SCALES(8));
        make.height.width.mas_equalTo(SCALES(20));
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(SCALES(10));
        make.left.equalTo(self.title);
        make.height.mas_equalTo(SCALES(20));
    }];
    [self.goCertificationIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title);
        make.right.equalTo(self.mas_right).offset(SCALES(-12));
        make.height.width.mas_equalTo(SCALES(16));
    }];
    [self.goCertification mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title);
        make.right.equalTo(self.goCertificationIcon.mas_left).offset(SCALES(-2));
    }];
}

- (void)setModel:(ASConsumptionModel *)model {
    _model = model;
    if (model.is_auth == 1) {
        self.titleIcon.image = [UIImage imageNamed:@"consumption_renzhen"];
        self.goCertification.text = STRING(model.id_card_name);
        self.goCertificationIcon.hidden = YES;
    } else {
        self.titleIcon.image = [UIImage imageNamed:@"consumption_renzhen1"];
        self.goCertification.text = @"去认证";
        self.goCertificationIcon.hidden = NO;
    }
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
        _bgView.image = [UIImage imageNamed:@"consumption_renzhen_bg"];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = TITLE_COLOR;
        _title.font = TEXT_MEDIUM(16);
        _title.text = @"实名认证";
    }
    return _title;
}

- (UIImageView *)titleIcon {
    if (!_titleIcon) {
        _titleIcon = [[UIImageView alloc]init];
    }
    return _titleIcon;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = TEXT_SIMPLE_COLOR;
        _content.font = TEXT_FONT_14;
        _content.text = @"向您提供更好的安全保障";
    }
    return _content;
}

- (UILabel *)goCertification {
    if (!_goCertification) {
        _goCertification = [[UILabel alloc]init];
        _goCertification.font = TEXT_FONT_14;
        _goCertification.textColor = TEXT_SIMPLE_COLOR;
    }
    return _goCertification;
}

- (UIImageView *)goCertificationIcon {
    if (!_goCertificationIcon) {
        _goCertificationIcon = [[UIImageView alloc]init];
        _goCertificationIcon.image = [UIImage imageNamed:@"cell_back"];
    }
    return _goCertificationIcon;
}
@end
