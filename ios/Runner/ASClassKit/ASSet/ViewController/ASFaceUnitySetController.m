#import "ASFaceUnitySetController.h"
#import "FaceUnityManager.h"
#import "FaceUnityRecorder.h"
#import <FURenderKit/FUCaptureCamera.h>
#import "FUHeadButtonView.h"

@interface ASFaceUnitySetController ()<FUHeadButtonViewDelegate>
@property (nonatomic, strong) FUGLDisplayView *renderView;
@property (nonatomic, strong) FUHeadButtonView *headButtonView;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *setBtn;
@property (nonatomic, strong) UIButton *cameraCut;
@property (nonatomic, strong) FUCaptureCamera *mCamera;
@property (nonatomic, strong) FaceUnityManager *FUManager;
@property (nonatomic, strong) UIButton *meiyanBgView;
@property (nonatomic, strong) NSNumber *isOpenFU;
@end

@implementation ASFaceUnitySetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    [self setUI];
    self.meiyanBgView.frame = self.view.bounds;
    [self.view addSubview:self.meiyanBgView];
    [FaceUnityManager setupFUSDK];
    [[FaceUnityManager shared] loadBeauty];
    [[FaceUnityManager shared] addFUViewToView:self.meiyanBgView originY:self.meiyanBgView.height - TAB_BAR_HEIGHT];
    [[FURenderKit shareRenderKit] startInternalCamera];
    [FURenderKit shareRenderKit].glDisplayView = self.renderView;
    NSNumber *isOpenFU = [ASUserDefaults valueForKey:@"isOpenFaceUnity"];
    self.isOpenFU = isOpenFU;
    if (kObjectIsEmpty(isOpenFU)) {//默认没有调整过美颜状态，就正常开启美颜
        [FURenderKit shareRenderKit].beauty.enable = YES;
    } else {
        [FURenderKit shareRenderKit].beauty.enable = isOpenFU.boolValue;
    }
    if (kAppType == 1) {//引导提醒
        kWeakSelf(self);
        [ASAlertViewManager popFaceunityProtocolWithAction:^{
            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
            vc.webUrl = @"https://www.faceunity.com/policy.html";
            [wself.navigationController pushViewController:vc animated:YES];
        }];
    }
}

- (void)setUI {
    kWeakSelf(self);
    [self.view addSubview:self.renderView];
    self.renderView.frame = self.view.bounds;
    [self.view addSubview:self.headButtonView];
    self.headButtonView.frame = CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, 88);
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveBtn setBackgroundImage:[UIImage imageNamed:@"meiyan_save"] forState:UIControlStateNormal];
    [[self.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        wself.saveBtn.userInteractionEnabled = NO;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
            wself.saveBtn.userInteractionEnabled = YES;
        });
        [[FaceUnityManager shared] saveBeauty];//保存更改的美颜数据
        [FaceUnityManager destory];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-TAB_BAR_MAGIN - 15);
        make.width.height.mas_equalTo(71);
    }];
    self.setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.setBtn setBackgroundImage:[UIImage imageNamed:@"meiyan_icon"] forState:UIControlStateNormal];
    self.setBtn.adjustsImageWhenHighlighted = NO;
    [[self.setBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        wself.setBtn.userInteractionEnabled = NO;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
            wself.setBtn.userInteractionEnabled = YES;
        });
        wself.meiyanBgView.hidden = NO;
    }];
    [self.view addSubview:self.setBtn];
    [self.setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.saveBtn);
        make.left.equalTo(self.view.mas_left).offset(38);
        make.width.height.mas_equalTo(70);
    }];
    self.cameraCut = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cameraCut setBackgroundImage:[UIImage imageNamed:@"meiyan_fanzhuan"] forState:UIControlStateNormal];
    [[self.cameraCut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        wself.cameraCut.userInteractionEnabled = NO;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
            wself.cameraCut.userInteractionEnabled = YES;
        });
        [FURenderKit shareRenderKit].internalCameraSetting.position = ([FURenderKit shareRenderKit].internalCameraSetting.position != AVCaptureDevicePositionFront) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    }];
    [self.view addSubview:self.cameraCut];
    [self.cameraCut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.saveBtn);
        make.right.equalTo(self.view.mas_right).offset(-38);
        make.width.height.mas_equalTo(70);
    }];
}

- (UIButton *)meiyanBgView {
    if (!_meiyanBgView) {
        _meiyanBgView = [[UIButton alloc]init];
        _meiyanBgView.userInteractionEnabled = YES;
        _meiyanBgView.backgroundColor = UIColor.clearColor;
        _meiyanBgView.hidden = YES;
        kWeakSelf(self);
        [[_meiyanBgView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            wself.meiyanBgView.hidden = YES;
        }];
    }
    return _meiyanBgView;
}

- (FUGLDisplayView *)renderView {
    if (!_renderView) {
        _renderView = [[FUGLDisplayView alloc] init];
    }
    return _renderView;
}

- (FUHeadButtonView *)headButtonView {
    if (!_headButtonView) {
        _headButtonView = [[FUHeadButtonView alloc] init];
        _headButtonView.delegate = self;
    }
    return _headButtonView;
}

#pragma mark - FUHeadButtonViewDelegate
//关闭美颜
- (void)headButtonViewSwitchAction:(UIButton *)btn {
    [ASUserDefaults setValue:@(!btn.selected) forKey:@"isOpenFaceUnity"];//记录是否开启美颜状态保存到本地
    [FURenderKit shareRenderKit].beauty.enable = !btn.selected;
}

//返回
- (void)headButtonViewBackAction:(UIButton *)btn {
    kWeakSelf(self);
    [ASAlertViewManager defaultPopTitle:@"确认保存？" content:@"" left:@"确认" right:@"取消" isTouched:YES affirmAction:^{
        [[FaceUnityManager shared] saveBeauty];
        [FaceUnityManager destory];
        [wself.navigationController popViewControllerAnimated:YES];
    } cancelAction:^{
        if (!kObjectIsEmpty(wself.isOpenFU)) {
            [ASUserDefaults setValue:wself.isOpenFU forKey:@"isOpenFaceUnity"];
        }
        [FaceUnityManager destory];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}

//恢复默认
- (void)headButtonViewDefaultAction:(UIButton *)btn {
    [ASAlertViewManager defaultPopTitle:@"提示" content:@"确认恢复默认设置吗？" left:@"确认" right:@"取消" isTouched:YES affirmAction:^{
        [[FaceUnityManager shared] resetFUConfig];
    } cancelAction:^{
    }];
}
@end
