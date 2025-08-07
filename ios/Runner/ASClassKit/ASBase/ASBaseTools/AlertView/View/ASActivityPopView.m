//
//  ASActivityPopView.m
//  AS
//
//  Created by SA on 2025/7/28.
//

#import "ASActivityPopView.h"

@implementation ASActivityPopView

- (instancetype)initActivityPopWithModel:(ASBannerModel *)model {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor clearColor];
        self.size = CGSizeMake(SCALES(model.popup_image_width), SCALES(model.popup_image_height) + SCALES(50));
        UIImageView *activityImage = [[UIImageView alloc]init];
        [activityImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.popup_image]]];
        activityImage.userInteractionEnabled = YES;
        activityImage.layer.cornerRadius = SCALES(8);
        activityImage.layer.masksToBounds = YES;
        activityImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:activityImage];
        [activityImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.equalTo(self);
            make.bottom.equalTo(self).offset(SCALES(-50));
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [activityImage addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.affirmBlock) {
                wself.affirmBlock();
                [wself removeFromSuperview];
            }
        }];
        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"close4"] forState:UIControlStateNormal];
        closeBtn.adjustsImageWhenHighlighted = NO;
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
                [wself removeFromSuperview];
            }
        }];
        [self addSubview:closeBtn];
        [closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(activityImage.mas_bottom).offset(SCALES(20));
            make.centerX.equalTo(self);
            make.width.height.mas_equalTo(SCALES(24));
        }];
    }
    return self;
}

@end
