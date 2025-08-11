//
//  ASIMDemonstrationPopView.m
//  AS
//
//  Created by SA on 2025/8/6.
//

#import "ASIMDemonstrationPopView.h"

@implementation ASIMDemonstrationPopView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:USER_INFO.gender == 1 ? @"im_demonstration1" : @"im_demonstration"];
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(HEIGHT_NAVBAR + SCALES(100));
            make.size.mas_equalTo(CGSizeMake(SCALES(343), USER_INFO.gender == 2 ? SCALES(312) : SCALES(282)));
        }];
        kWeakSelf(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
                [wself removeFromSuperview];
            }
        }];
    }
    return self;
}

@end
