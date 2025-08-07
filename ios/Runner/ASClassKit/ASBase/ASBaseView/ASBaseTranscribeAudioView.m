//
//  ASBaseTranscribeAudioView.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASBaseTranscribeAudioView.h"

@interface ASBaseTranscribeAudioView ()<NIMMediaManagerDelegate>
@property (nonatomic, strong) UIButton *recordBtn;//录制按钮
@property (nonatomic, strong) UILabel *second;//录制时间
@property (nonatomic, strong) UILabel *recordHint;//录制提示
@property (nonatomic, strong) ASCircleView *circleView;//录制音频圆环
@property (nonatomic, strong) UIButton *closeBtn;//取消
@property (nonatomic, strong) UIButton *saveBtn;//完成
@property (nonatomic, strong) UILabel *closeText;//取消
@property (nonatomic, strong) UILabel *saveText;//完成
/**数据**/
@property (nonatomic, assign) int timers;//计时时间15s
@property (nonatomic, strong) RACDisposable *timerDisposable;
@property (nonatomic, assign) BOOL isComplete;//是否录制完成
@property (nonatomic, copy) NSString *path;//音频保存地址
@property (nonatomic, copy) NSString *recordHintText;//提示文案
@property (nonatomic, assign) NSInteger voiceTime;//录音时长
@property (nonatomic, strong) RACDisposable *playerDisposable;//播放定时
@property (nonatomic, assign) int playTime;//播放时间
@end

@implementation ASBaseTranscribeAudioView

- (void)dealloc {
    [self.timerDisposable dispose];
    [self.playerDisposable dispose];
    [[NIMSDK sharedSDK].mediaManager stopPlay];
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
    [[NIMSDK sharedSDK].mediaManager removeDelegate:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [[NIMSDK sharedSDK].mediaManager addDelegate:self];
        [self addSubview:self.recordBtn];
        [self addSubview:self.second];
        [self addSubview:self.recordHint];
        [self addSubview:self.closeBtn];
        [self addSubview:self.saveBtn];
        [self addSubview:self.closeText];
        [self addSubview:self.saveText];
        
        [self.second mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self);
            make.height.mas_equalTo(SCALES(36));
        }];
        
        [self.recordHint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.second.mas_bottom).offset(SCALES(4));
            make.centerX.equalTo(self);
            make.height.mas_equalTo(SCALES(20));
        }];
        
        [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.recordHint.mas_bottom).offset(SCALES(14));
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCALES(85), SCALES(85)));
        }];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.recordBtn);
            make.right.equalTo(self.recordBtn.mas_left).offset(SCALES(-36));
            make.size.mas_equalTo(CGSizeMake(SCALES(51), SCALES(51)));
        }];
        
        [self.closeText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.closeBtn);
            make.top.equalTo(self.closeBtn.mas_bottom).offset(SCALES(8));
            make.height.mas_equalTo(SCALES(20));
        }];
        
        [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.recordBtn);
            make.left.equalTo(self.recordBtn.mas_right).offset(SCALES(36));
            make.size.mas_equalTo(CGSizeMake(SCALES(51), SCALES(51)));
        }];
        
        [self.saveText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.saveBtn);
            make.top.equalTo(self.saveBtn.mas_bottom).offset(SCALES(8));
            make.height.mas_equalTo(SCALES(20));
        }];
        
        //1.创建圆环
        ASCircleViewConfigure *configure = [[ASCircleViewConfigure alloc]init];
        configure.lineColor = UIColor.clearColor;//圆环背景色
        configure.circleLineWidth = SCALES(3);//圆环宽度
        configure.isClockwise = YES;//设置顺时针方向画圆
        configure.startPoint = CGPointMake(SCALES(85) / 2, 0);
        configure.endPoint = CGPointMake(SCALES(85) / 2 , SCALES(85));//渐变色分布方向
        //渐变色的颜色
        configure.colorArr = @[(id)UIColorRGB(0xFD6E6A).CGColor,
                               (id)UIColorRGB(0xF55E15).CGColor,
                               (id)UIColorRGB(0xF55E15).CGColor];
        //每个颜色区域值
        configure.colorSize = @[@0.0, @0.3, @0.8];
        ASCircleView *circleView = [[ASCircleView alloc]initWithFrame:CGRectMake(0, 0, SCALES(85), SCALES(85)) configure:configure];
        circleView.userInteractionEnabled = NO;
        circleView.hidden = YES;
        [self.recordBtn addSubview:circleView];
        self.circleView = circleView;
    }
    return self;
}

- (void)setType:(NSInteger)type {
    _type = type;
    if (type == 0) {
        self.recordHintText = @"录制5~15秒的语音";
    } else {
        self.recordHintText = @"请录制5秒以上的语音";
    }
    self.recordHint.text = self.recordHintText;
}

#pragma mark - NIMMediaManagerDelegate
//录制音频完成后的回调
- (void)recordAudio:(nullable NSString *)filePath didCompletedWithError:(nullable NSError *)error {
    if (error == nil) {
        self.path = filePath;
    } else {
        kShowToast(@"录制失败，请重试！");
        [self.timerDisposable dispose];
        self.isTranscribe = NO;
        self.isComplete = NO;
        self.circleView.hidden = YES;
        self.second.text = @"0s";
        self.timers = 0;
        self.circleView.progress = 0.0;
        //重新录制样式
        [self.recordBtn setBackgroundImage:[UIImage imageNamed:@"signature_start"] forState:UIControlStateNormal];
        self.recordHint.text = self.recordHintText;
        self.closeBtn.hidden = YES;
        self.closeText.hidden = YES;
        self.saveBtn.hidden = YES;
        self.saveText.hidden = YES;
        [[NIMSDK sharedSDK].mediaManager cancelRecord];//取消录音
    }
}

//停止播放音频的回调
- (void)stopPlayAudio:(NSString *)filePath didCompletedWithError:(nullable NSError *)error {
    /* 关闭计时器 */
    [self.playerDisposable dispose];
    [self.recordBtn setBackgroundImage:[UIImage imageNamed:@"signature_play"] forState:UIControlStateNormal];
    self.recordHint.text = @"点击试听";
}

//播放完音频的回调
- (void)playAudio:(NSString *)filePath didCompletedWithError:(nullable NSError *)error {
    /* 关闭计时器 */
    [self.playerDisposable dispose];
    [self.recordBtn setBackgroundImage:[UIImage imageNamed:@"signature_play"] forState:UIControlStateNormal];
    self.recordHint.text = @"点击试听";
}

//音频录制进度更新回调
- (void)recordAudioProgress:(NSTimeInterval)currentTime {
    self.voiceTime = currentTime;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [[UIButton alloc]init];
        [_recordBtn setBackgroundImage:[UIImage imageNamed:@"signature_start"] forState:UIControlStateNormal];
        _recordBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_recordBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASMyAppCommonFunc verifyMicrophonePermissionBlock:^{
                if (wself.isTranscribe == NO && wself.isComplete == NO) {//如果没有录音，且没有完成录音
                    wself.isTranscribe = YES;
                    wself.closeBtn.hidden = YES;
                    wself.closeText.hidden = YES;
                    wself.saveBtn.hidden = YES;
                    wself.saveText.hidden = YES;
                    wself.circleView.hidden = NO;
                    [wself.recordBtn setBackgroundImage:[UIImage imageNamed:@"signature_recording"] forState:UIControlStateNormal];
                    wself.recordHint.text = @"录音中";
                    [[NIMSDK sharedSDK].mediaManager recordForDuration:15];//开始录制
                    /* 定义计时器监听 */
                    wself.timerDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
                        wself.timers++;
                        wself.circleView.progress = wself.timers/15.00;
                        NSString * timerStr;
                        if (wself.timers > 9) {
                            timerStr = [NSString stringWithFormat:@"%d",wself.timers];
                        } else {
                            timerStr = [NSString stringWithFormat:@"0%d",wself.timers];
                        }
                        wself.second.text = [NSString stringWithFormat:@"00:%@",timerStr];
                        if (wself.timers == 15) {
                            wself.timers = 0;
                            wself.circleView.progress = 0.0;
                            /* 关闭计时器 */
                            [wself.timerDisposable dispose];
                            wself.isTranscribe = NO;
                            wself.isComplete = YES;
                            //录制完成的样式
                            [wself.recordBtn setBackgroundImage:[UIImage imageNamed:@"signature_play"] forState:UIControlStateNormal];
                            wself.circleView.hidden = YES;
                            wself.recordHint.text = @"点击播放";
                            wself.closeBtn.hidden = NO;
                            wself.closeText.hidden = NO;
                            wself.saveBtn.hidden = NO;
                            wself.saveText.hidden = NO;
                            [[NIMSDK sharedSDK].mediaManager stopRecord];//完成录制，录音结束
                        }
                    }];
                } else {
                    if (wself.isComplete == YES) {//录制完成点击
                        [wself.recordBtn setBackgroundImage:[UIImage imageNamed:@"signature_stop"] forState:UIControlStateNormal];
                        if ([NIMSDK sharedSDK].mediaManager.isPlaying) {//如果正在播放，点击就进行暂停
                            [wself.playerDisposable dispose];
                            wself.recordHint.text = @"点击试听";
                            [[NIMSDK sharedSDK].mediaManager stopPlay];//停止播放
                            NSString *timerStr;
                            if (wself.voiceTime > 9) {
                                timerStr = [NSString stringWithFormat:@"%zd",wself.voiceTime];
                            } else {
                                timerStr = [NSString stringWithFormat:@"0%zd",wself.voiceTime];
                            }
                            wself.second.text = [NSString stringWithFormat:@"00:%@",timerStr];
                            
                        } else {//如果未播放，进行播放
                            wself.recordHint.text = @"播放中";
                            [[NIMSDK sharedSDK].mediaManager play:wself.path];
                            wself.playTime = 0;
                            wself.playerDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
                                wself.playTime++;
                                NSString *timerStr;
                                if (wself.playTime > 9) {
                                    timerStr = [NSString stringWithFormat:@"%d",wself.playTime];
                                } else {
                                    timerStr = [NSString stringWithFormat:@"0%d",wself.playTime];
                                }
                                wself.second.text = [NSString stringWithFormat:@"00:%@",timerStr];
                            }];
                        }
                    } else {
                        if (wself.timers < 5) {
                            kShowToast(@"至少录制5秒");
                            [wself.timerDisposable dispose];
                            wself.isTranscribe = NO;
                            wself.isComplete = NO;
                            wself.circleView.hidden = YES;
                            wself.second.text = @"00:00";
                            wself.timers = 0;
                            wself.circleView.progress = 0.0;
                            //重新录制样式
                            [wself.recordBtn setBackgroundImage:[UIImage imageNamed:@"signature_start"] forState:UIControlStateNormal];
                            wself.recordHint.text = self.recordHintText;
                            wself.closeBtn.hidden = YES;
                            wself.closeText.hidden = YES;
                            wself.saveBtn.hidden = YES;
                            wself.saveText.hidden = YES;
                            [[NIMSDK sharedSDK].mediaManager cancelRecord];//取消录音
                        } else {
                            /* 关闭计时器 */
                            [wself.timerDisposable dispose];
                            wself.isTranscribe = NO;
                            wself.isComplete = YES;
                            wself.circleView.hidden = YES;
                            wself.timers = 0;
                            wself.circleView.progress = 0.0;
                            //录制完成的样式
                            [wself.recordBtn setBackgroundImage:[UIImage imageNamed:@"signature_play"] forState:UIControlStateNormal];
                            wself.recordHint.text = @"点击播放";
                            wself.closeBtn.hidden = NO;
                            wself.closeText.hidden = NO;
                            wself.saveBtn.hidden = NO;
                            wself.saveText.hidden = NO;
                            [[NIMSDK sharedSDK].mediaManager stopRecord];//完成录制，录音结束
                        }
                    }
                }
            }];
        }];
    }
    return _recordBtn;
}

- (UILabel *)second {
    if (!_second) {
        _second = [[UILabel alloc]init];
        _second.font = TEXT_MEDIUM(28);
        _second.textColor = TITLE_COLOR;
        _second.text = @"00:00";
        _second.textAlignment = NSTextAlignmentCenter;
    }
    return _second;
}

- (UILabel *)recordHint {
    if (!_recordHint) {
        _recordHint = [[UILabel alloc]init];
        _recordHint.font = TEXT_FONT_14;
        _recordHint.textColor = TEXT_SIMPLE_COLOR;
        _recordHint.textAlignment = NSTextAlignmentCenter;
    }
    return _recordHint;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"signature_reset"] forState:UIControlStateNormal];
        _closeBtn.adjustsImageWhenHighlighted = NO;
        _closeBtn.hidden = YES;
        kWeakSelf(self);
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            wself.timers = 0;
            [wself.timerDisposable dispose];
            wself.isTranscribe = NO;
            wself.isComplete = NO;
            wself.circleView.hidden = YES;
            wself.second.text = @"00:00";
            wself.circleView.progress = 0.0;
            [[NIMSDK sharedSDK].mediaManager stopPlay];//停止播放
            
            //重新录制样式
            [wself.recordBtn setBackgroundImage:[UIImage imageNamed:@"signature_start"] forState:UIControlStateNormal];
            wself.recordHint.text = self.recordHintText;
            wself.closeBtn.hidden = YES;
            wself.closeText.hidden = YES;
            wself.saveBtn.hidden = YES;
            wself.saveText.hidden = YES;
            if (wself.closeBlock) {
                wself.closeBlock();
            }
        }];
    }
    return _closeBtn;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc]init];
        [_saveBtn setBackgroundImage:[UIImage imageNamed:@"signature_save"] forState:UIControlStateNormal];
        _saveBtn.adjustsImageWhenHighlighted = NO;
        _saveBtn.hidden = YES;
        kWeakSelf(self);
        [[_saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [[NIMSDK sharedSDK].mediaManager stopPlay];//停止播放
            //回传音频路径
            if (wself.saveBlock) {
                wself.saveBlock(wself.path, wself.voiceTime);
            }
            //隐藏保存按钮
            if (wself.type == 0) {
                wself.saveBtn.hidden = YES;
                wself.saveText.hidden = YES;
            }
        }];
    }
    return _saveBtn;
}

- (UILabel *)closeText {
    if (!_closeText) {
        _closeText = [[UILabel alloc]init];
        _closeText.textColor = TEXT_SIMPLE_COLOR;
        _closeText.text = @"重录";
        _closeText.font = TEXT_FONT_14;
        _closeText.hidden = YES;
    }
    return _closeText;
}

- (UILabel *)saveText {
    if (!_saveText) {
        _saveText = [[UILabel alloc]init];
        _saveText.textColor = TEXT_SIMPLE_COLOR;
        _saveText.text = @"保存";
        _saveText.font = TEXT_FONT_14;
        _saveText.hidden = YES;
    }
    return _saveText;
}
@end

@interface ASCircleView()
@property (nonatomic, strong) ASDrawCircleView *circleView;
@property (nonatomic, strong) ASCircleViewConfigure *configure;
@end

@implementation ASCircleView

- (instancetype)initWithFrame:(CGRect)frame configure:(ASCircleViewConfigure *)configure {
    self = [super initWithFrame:frame];
    if (self) {
        //保存配置
        self.configure = configure;
        //绘制背景圆
        [self drawBackCircleView];
        //添加圆环
        [self addTYDrawCircleView];
        
    }
    return self;
}

- (void)addTYDrawCircleView {
    ASDrawCircleView *circleView = [[ASDrawCircleView alloc]initWithFrame:self.bounds];
    self.circleView = circleView;
    self.circleView.configure = self.configure;
    [self addSubview:circleView];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.circleView.progress = progress;
    [self.circleView setNeedsDisplay];
}

//绘制背景圆
- (void)drawBackCircleView {
    //1.UIBezierPath创建一个圆环路径
    //圆心
    CGPoint arcCenter = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    //半径 , circleLineWidth = 圆环线条宽度
    CGFloat radius = (self.frame.size.width - self.configure.circleLineWidth)/2.0;
    //开始弧度:-M_PI_2,竖直向上; 结束弧度:-M_PI_2 + M_PI*2,一圈 clockwise:YES逆时针 NO顺时针
    //clockwise = NO时,若结束弧度 = -M_PI_2 + M_PI*2, 则圆环消失归零
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius  startAngle:-M_PI_2 endAngle:-M_PI_2 + M_PI*2 clockwise:YES];
    //2.创建一个ShapeLayer
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    bgLayer.fillColor = [UIColor clearColor].CGColor;//圆环路径填充颜色
    bgLayer.lineWidth = self.configure.circleLineWidth;//圆环宽度
    bgLayer.strokeColor = self.configure.lineColor.CGColor;//路径颜色
    bgLayer.strokeStart = 0.f;//路径开始位置
    bgLayer.strokeEnd = 1.f;//路径结束位置
    bgLayer.path = circle.CGPath;
    //3.把路径设置到layer上,换出背景圆环
    [self.layer addSublayer:bgLayer];
}
@end

@implementation ASDrawCircleView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.configure.startPoint = CGPointMake(self.frame.size.width / 2, 0);
        self.configure.endPoint = CGPointMake(self.frame.size.width / 2 , self.frame.size.height);
        self.configure.colorArr = @[[UIColor grayColor],[UIColor lightGrayColor]];
        self.configure.circleLineWidth = 12;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 1. 还是添加一个圆弧路径
    //获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置线的宽度
    CGContextSetLineWidth(ctx, self.configure.circleLineWidth);
    //设置圆环线条的两个端点做圆滑处理
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //设置画笔颜色
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    //设置圆心
    CGFloat originX = rect.size.width / 2;
    CGFloat originY = rect.size.height / 2;
    //计算半径
    CGFloat radius = MIN(originX, originY) - self.configure.circleLineWidth/2.0;
    //建立一个最小初始弧度制,避免进度progress为0或1时圆环消失
    CGFloat minAngle = M_PI/90 - self.progress * M_PI/80;
    //逆时针画一个圆弧
    if (self.configure.isClockwise) {
        CGContextAddArc(ctx, rect.size.width / 2, rect.size.height / 2, radius, -M_PI_2, -M_PI_2 + minAngle + (2 * M_PI)*self.progress, NO);
    } else {
        CGContextAddArc(ctx, rect.size.width / 2, rect.size.height / 2, radius, -M_PI_2, -M_PI_2 - minAngle + (2 * M_PI)*(1-self.progress), YES);
    }
    //2. 创建一个渐变色
    CGFloat locations[self.configure.colorSize.count];
    for (NSInteger index = 0; index < self.configure.colorSize.count; index++) {
        locations[index] = [self.configure.colorSize[index] floatValue];
    }
    //创建RGB色彩空间，创建这个以后，context里面用的颜色都是用RGB表示
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,(__bridge CFArrayRef _Nonnull)self.configure.colorArr, self.configure.colorSize.count==0?NULL:locations);
    //释放色彩空间
    CGColorSpaceRelease(colorSpace);
    colorSpace = NULL;
    //3.画出圆环路径
    CGContextReplacePathWithStrokedPath(ctx);
    //剪裁路径
    CGContextClip(ctx);
    //4.用渐变色填充,修改填充色的方向,_startPoint和_endPoint两个点的连线,就是颜色的分布方向
    CGContextDrawLinearGradient(ctx, gradient, self.configure.startPoint, self.configure.endPoint, 1);
    //释放渐变色
    CGGradientRelease(gradient);
}
@end

@implementation ASCircleViewConfigure

@end
