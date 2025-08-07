//
//  ASBottomAlertView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASBottomAlertView.h"

@implementation ASBottomAlertView
//构造方法
- (instancetype)initWithTitles:(NSArray *)titles {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor whiteColor];
        CGFloat contentHeight = titles.count *SCALES(44);
        self.size = CGSizeMake(SCREEN_WIDTH, contentHeight + SCALES(14) + SCALES(5) + SCALES(44) + TAB_BAR_MAGIN);
        
        for (int i = 0; i < titles.count; i++) {
            UIButton* button = [[UIButton alloc] init];
            button.titleLabel.font = TEXT_FONT_16;
            [button setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
            button.frame = CGRectMake(0, SCALES(14) + i*SCALES(44), SCREEN_WIDTH, SCALES(44));
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (wself.indexBlock) {
                    [wself removeView];
                    wself.indexBlock(titles[i]);
                }
            }];
            [self addSubview:button];
        }
        
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(0, contentHeight + SCALES(14), SCREEN_WIDTH, SCALES(5));
        line.backgroundColor = BACKGROUNDCOLOR;
        [self addSubview:line];

        UIButton *closeBtn = [[UIButton alloc] init];
        closeBtn.frame = CGRectMake(0, line.bottom, SCREEN_WIDTH, SCALES(44));
        closeBtn.titleLabel.font = TEXT_FONT_16;
        [closeBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
        }];
        [self addSubview:closeBtn];
        //半圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(SCALES(10), SCALES(10))];
         CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
    return self;
}

- (void)removeView {
    [self removeFromSuperview];
}
@end
