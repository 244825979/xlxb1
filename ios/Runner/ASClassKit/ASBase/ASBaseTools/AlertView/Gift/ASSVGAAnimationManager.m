//
//  ASSVGAAnimationManager.m
//  AS
//
//  Created by SA on 2025/5/16.
//

#import "ASSVGAAnimationManager.h"

@implementation ASSVGAAnimationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addQueueSVGAAnimation:) name:@"addAnimation" object:nil];//监听一个发送礼物的通知，来模拟socket消息
    }
    return self;
}

- (void)addQueueSVGAAnimation:(NSNotification *)noti {
    if ([noti.object isKindOfClass:[NSString class]]) {
        [self.svgaAnimationArray addObject:noti.object];
        [self addSvgaAnimation];
    }
}

- (void)addSvgaAnimation {
    if (!_isShowSVGAAnimation) {
        if (self.svgaAnimationArray.count == 0) return;
        if ([self.delegate respondsToSelector:@selector(SVGAAnimationManager:showSVGAAnimation:)]) {
            [self.delegate SVGAAnimationManager:self showSVGAAnimation:self.svgaAnimationArray.firstObject];
            [self.svgaAnimationArray removeFirstObject];
        }
    }
}

- (YYThreadSafeArray *)svgaAnimationArray {
    if (!_svgaAnimationArray) {
        _svgaAnimationArray = [YYThreadSafeArray array];
    }
    return _svgaAnimationArray;
}

- (void)destroy {
    [self.svgaAnimationArray removeAllObjects];
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
