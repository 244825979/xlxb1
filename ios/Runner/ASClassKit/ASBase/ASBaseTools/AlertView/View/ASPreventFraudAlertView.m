//
//  ASPreventFraudAlertView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASPreventFraudAlertView.h"

@implementation ASPreventFraudAlertView

- (instancetype)initPreventFraudView {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.size = CGSizeMake(SCALES(311), SCALES(572));
        kWeakSelf(self);
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"im_prevent"];
        icon.userInteractionEnabled = YES;
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [icon addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.affirmBlock) {
                wself.affirmBlock();
                [wself removeView];
            }
        }];
    }
    return self;
}

- (void)removeView {
    [self removeFromSuperview];
}
@end
