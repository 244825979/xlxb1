//
//  ASIMActivityFloatingView.m
//  AS
//
//  Created by SA on 2025/7/29.
//

#import "ASIMActivityFloatingView.h"

@interface ASIMActivityFloatingView ()
@property (nonatomic, strong) UIImageView *activityImage;
@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation ASIMActivityFloatingView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.activityImage];
        [self addSubview:self.closeBtn];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self.activityImage addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
//            if (wself.clickBlock) {
//                wself.clickBlock();
//            }
            [ASMyAppCommonFunc bannerClikedWithBannerModel:wself.model viewController:[ASCommonFunc currentVc] action:^(id  _Nonnull data) {
                
            }];
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.activityImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-24);
    }];
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.activityImage);
        make.top.equalTo(self.activityImage.mas_bottom);
        make.height.width.mas_equalTo(24);
    }];
}

- (void)setModel:(ASBannerModel *)model {
    _model = model;
    [self.activityImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.img]]];
}

- (UIImageView *)activityImage {
    if (!_activityImage) {
        _activityImage = [[UIImageView alloc]init];
        _activityImage.contentMode = UIViewContentModeScaleAspectFill;
        _activityImage.userInteractionEnabled = YES;
    }
    return _activityImage;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"close6"] forState:UIControlStateNormal];
        _closeBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.closeBlock) {
                wself.closeBlock();
            }
        }];
    }
    return _closeBtn;
}

@end
