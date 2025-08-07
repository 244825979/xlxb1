//
//  ASGiftSVGAPlayerController.m
//  AS
//
//  Created by SA on 2025/5/16.
//

#import "ASGiftSVGAPlayerController.h"
#import "ASSVGAAnimationManager.h"
#import <SVGA.h>

static SVGAParser *parser;

@interface ASGiftSVGAPlayerController ()<SVGAPlayerDelegate, ASSVGAAnimationDelegate>
@property (nonatomic, strong) SVGAPlayer *aPlayer;
@property (nonatomic, strong) ASSVGAAnimationManager *svgaAnimationManager;
@property (nonatomic, strong) RACDisposable *timerDisposable;
@property (nonatomic, assign) NSInteger times;
@end

@implementation ASGiftSVGAPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.view.backgroundColor = [UIColor clearColor];
    [self createUI];
}

- (void)createUI {
    _svgaAnimationManager = [[ASSVGAAnimationManager alloc]init];
    _svgaAnimationManager.delegate = self;
    [self.view addSubview:self.aPlayer];
    self.aPlayer.delegate = self;
    self.aPlayer.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH);
    self.aPlayer.loops = 1;
    self.aPlayer.clearsAfterStop = YES;
    parser = [[SVGAParser alloc] init];
    if (kStringIsEmpty(self.playerUrl)) {
        [self dismissComtroller];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addAnimation" object:STRING(self.playerUrl)];
        kWeakSelf(self);
        self.timerDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
            wself.times--;
            if (wself.times == 0) {
                [wself dismissComtroller];
            }
        }];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.aPlayer.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)dismissComtroller {
    kWeakSelf(self);
    [self dismissViewControllerAnimated:YES completion:^{
        wself.svgaAnimationManager.isShowSVGAAnimation = NO;
        [wself.timerDisposable dispose];
    }];
}

- (void)SVGAAnimationManager:(ASSVGAAnimationManager *)svgaAnimationManager showSVGAAnimation:(NSString *)animationUrl {
    _svgaAnimationManager.isShowSVGAAnimation = YES;
    kWeakSelf(self);
    [parser parseWithURL:[NSURL URLWithString:animationUrl]
         completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        if (videoItem != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.aPlayer.videoItem = videoItem;
                [wself.aPlayer startAnimation];
            });
        } else {
            [wself dismissComtroller];
        }
    } failureBlock:nil];
}

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    [self dismissComtroller];
}

- (SVGAPlayer *)aPlayer {
    if (_aPlayer == nil) {
        _aPlayer = [[SVGAPlayer alloc] init];
    }
    return _aPlayer;
}
@end
