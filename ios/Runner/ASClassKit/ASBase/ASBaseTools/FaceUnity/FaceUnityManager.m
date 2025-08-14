//
//  FaceUnityManager.m
//  FUDemo
//
//  Created by 项林平 on 2021/6/17.
//

#import "FaceUnityManager.h"
#import "FUBeautySkinView.h"
#import "FUBeautyShapeView.h"
#import "FUBeautyFilterView.h"
#import "FUSegmentBar.h"
#import "FUAlertManager.h"
#import "authpack.h"

@interface FaceUnityManager ()<FUSegmentBarDelegate>

/// 底部功能选择栏
@property (nonatomic, strong) FUSegmentBar *bottomBar;
/// 美肤功能视图
@property (nonatomic, strong) FUBeautySkinView *skinView;
/// 美型功能视图
@property (nonatomic, strong) FUBeautyShapeView *shapeView;
/// 滤镜功能视图
@property (nonatomic, strong) FUBeautyFilterView *filterView;

@property (nonatomic, strong) FUBeautySkinViewModel *beautySkinViewModel;
@property (nonatomic, strong) FUBeautyShapeViewModel *beautyShapeViewModel;
@property (nonatomic, strong) FUBeautyFilterViewModel *beautyFilterViewModel;

@property (nonatomic, strong) UIView *showingView;
/// 效果开关
@property (nonatomic, strong) UISwitch *renderSwitch;
/// 提示标签
@property (nonatomic, strong) UILabel *trackTipLabel;

@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, assign) CGFloat demoOriginY;

@property (nonatomic, assign) BOOL shouldRender;

@end

@implementation FaceUnityManager

static FaceUnityManager *FUManager = nil;
static dispatch_once_t onceToken;

+ (instancetype)shared {
    dispatch_once(&onceToken, ^{
        FUManager = [[FaceUnityManager alloc] init];
    });
    return FUManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shouldRender = YES;
    }
    return self;
}

+ (void)setupFUSDK {
    [FURenderKit setLogLevel:FU_LOG_LEVEL_INFO];
    FUSetupConfig *setupConfig = [[FUSetupConfig alloc] init];
    setupConfig.authPack = FUAuthPackMake(g_auth_package, sizeof(g_auth_package));
    // 初始化 FURenderKit
    [FURenderKit setupWithSetupConfig:setupConfig];
    // 加载人脸 AI 模型
    NSString *faceAIPath = [[NSBundle mainBundle] pathForResource:@"ai_face_processor" ofType:@"bundle"];
    [FUAIKit loadAIModeWithAIType:FUAITYPE_FACEPROCESSOR dataPath:faceAIPath];
    [FUAIKit shareKit].maxTrackFaces = 1;
    // 设置人脸算法质量
    [FUAIKit shareKit].faceProcessorFaceLandmarkQuality = [FURenderKit devicePerformanceLevel] >= FUDevicePerformanceLevelHigh ? FUFaceProcessorFaceLandmarkQualityHigh : FUFaceProcessorFaceLandmarkQualityMedium;
    // 设置小脸检测是否打开
    [FUAIKit shareKit].faceProcessorDetectSmallFace = [FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh;
    // 性能测试初始化
    [[FaceUnityRecorder shareRecorder] setupRecord];
    [self loadDefaultBeauty];
}

- (void)addFUViewToView:(UIView *)view originY:(CGFloat)originY {
    NSAssert(view, @"目标控制器不能为空");
    self.targetView = view;
    self.demoOriginY = originY;
    [view addSubview:self.bottomBar];
    [view addSubview:self.skinView];
    [view addSubview:self.shapeView];
    [view addSubview:self.filterView];
    [view addSubview:self.trackTipLabel];
    [view addSubview:self.renderSwitch];
    [self showFunctionView:self.skinView];
    self.showingView = self.skinView;
    [self.bottomBar selectItemAtIndex:0];
}

//重置默认的所有的美肤、美型设置
- (void)resetFUConfig {
    [self.beautySkinViewModel recoverAllSkinValuesToDefault];
    [self.skinView sliderChangeEnded];
    
    [self.beautyShapeViewModel recoverAllShapeValuesToDefault];
    [self.shapeView sliderChangeEnded];
}

- (void)loadBeauty {
    // 分别设置美肤、美型、滤镜
    [self.beautySkinViewModel setAllSkinValues];
    [self.beautyShapeViewModel setAllShapeValues];
    [self.beautyFilterViewModel setCurrentFilter];
}

- (void)saveBeauty {
    [self.beautySkinViewModel saveSkinsPersistently];
    [self.beautyShapeViewModel saveShapesPersistently];
    [self.beautyFilterViewModel saveFitersPersistently];
}

#pragma mark - Private methods
/// 显示功能视图
/// @param functionView 功能视图
- (void)showFunctionView:(UIView *)functionView {
    if (!functionView) {
        return;
    }
    functionView.hidden = NO;
    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        functionView.transform = CGAffineTransformMakeScale(1, 1);
        functionView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

/// 隐藏功能视图
/// @param functionView 功能视图
/// @param animated 是否需要动画（切换功能时先隐藏当前显示的视图不需要动画，直接隐藏时需要动画）
- (void)hideFunctionView:(UIView *)functionView animated:(BOOL)animated {
    if (!functionView) {
        return;
    }
    if (animated) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            functionView.transform = CGAffineTransformMakeScale(1, 0.001);
            functionView.alpha = 0;
        } completion:^(BOOL finished) {
            functionView.hidden = YES;
        }];
    } else {
        functionView.transform = CGAffineTransformMakeScale(1, 0.001);
        functionView.alpha = 0;
        functionView.hidden = YES;
    }
}

#pragma mark - Event response
- (void)renderSwitchAction:(UISwitch *)sender {
    self.shouldRender = sender.isOn;
}

#pragma mark - FUSegmentBarDelegate
- (void)segmentBar:(FUSegmentBar *)segmentBar didSelectItemAtIndex:(NSUInteger)index {
    [FUAIKit shareKit].maxTrackFaces = index == FUModuleTypeBody ? 1 : 4;
    UIView *needShowView = nil;
    switch (index) {
        case FUModuleTypeBeautySkin:{
            needShowView = self.skinView;
        }
            break;
        case FUModuleTypeBeautyShape:{
            needShowView = self.shapeView;
        }
            break;
        case FUModuleTypeBeautyFilter:{
            needShowView = self.filterView;
        }
            break;
    }
    if (needShowView && needShowView.hidden) {
        if (self.showingView) {
            // 先隐藏当前功能视图
            [self hideFunctionView:self.showingView animated:NO];
        }
        [self showFunctionView:needShowView];
        self.showingView = needShowView;
    }
}

#pragma mark - Getters
- (FUSegmentBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[FUSegmentBar alloc] initWithFrame:CGRectMake(0, self.demoOriginY, CGRectGetWidth(self.targetView.bounds), TAB_BAR_HEIGHT) titles:@[FULocalizedString(@"美肤"), FULocalizedString(@"美型"), FULocalizedString(@"滤镜")] configuration:[FUSegmentBarConfigurations new]];
        _bottomBar.delegate = self;
        _bottomBar.backgroundColor = UIColorRGB(0x333333);
    }
    return _bottomBar;
}

- (FUBeautySkinView *)skinView {
    if (!_skinView) {
        _skinView = [[FUBeautySkinView alloc] initWithFrame:CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight) viewModel:self.beautySkinViewModel];
        _skinView.layer.anchorPoint = CGPointMake(0.5, 1);
        // 设置了anchorPoint需要重新设置frame
        _skinView.frame = CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight);
        // 默认隐藏
        [self hideFunctionView:_skinView animated:NO];
    }
    return _skinView;
}

- (FUBeautyShapeView *)shapeView {
    if (!_shapeView) {
        _shapeView = [[FUBeautyShapeView alloc] initWithFrame:CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight) viewModel:self.beautyShapeViewModel];
        _shapeView.layer.anchorPoint = CGPointMake(0.5, 1);
        _shapeView.frame = CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight);
        // 默认隐藏
        [self hideFunctionView:_shapeView animated:NO];
    }
    return _shapeView;
}

- (FUBeautyFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[FUBeautyFilterView alloc] initWithFrame:CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight) viewModel:self.beautyFilterViewModel];
        _filterView.layer.anchorPoint = CGPointMake(0.5, 1);
        _filterView.frame = CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight);
        // 默认隐藏
        [self hideFunctionView:_filterView animated:NO];
    }
    return _filterView;
}

- (FUBeautySkinViewModel *)beautySkinViewModel {
    if (!_beautySkinViewModel) {
        _beautySkinViewModel = [[FUBeautySkinViewModel alloc] init];
    }
    return _beautySkinViewModel;
}

- (FUBeautyShapeViewModel *)beautyShapeViewModel {
    if (!_beautyShapeViewModel) {
        _beautyShapeViewModel = [[FUBeautyShapeViewModel alloc] init];
    }
    return _beautyShapeViewModel;
}

- (FUBeautyFilterViewModel *)beautyFilterViewModel {
    if (!_beautyFilterViewModel) {
        _beautyFilterViewModel = [[FUBeautyFilterViewModel alloc] init];
    }
    return _beautyFilterViewModel;
}

- (UISwitch *)renderSwitch {
    if (!_renderSwitch) {
        _renderSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(self.bottomBar.frame) - 40, 80, 30)];
        [_renderSwitch addTarget:self action:@selector(renderSwitchAction:) forControlEvents:UIControlEventValueChanged];
        _renderSwitch.on = YES;
        _renderSwitch.hidden = YES;
    }
    return _renderSwitch;
}

- (UILabel *)trackTipLabel {
    if (!_trackTipLabel) {
        _trackTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.targetView.frame) - 70, CGRectGetMidY(self.targetView.frame) - 12, 140, 24)];
        _trackTipLabel.textColor = [UIColor whiteColor];
        _trackTipLabel.font = [UIFont systemFontOfSize:17];
        _trackTipLabel.textAlignment = NSTextAlignmentCenter;
        _trackTipLabel.hidden = YES;
    }
    return _trackTipLabel;
}

- (BOOL)shouldRender {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL should = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        should = self.renderSwitch.isOn;
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return should;
}

#pragma mark - Class methods

+ (void)destory {
    [FURenderKit clear];
    [FURenderKit destroy];
    onceToken = 0;
    FUManager = nil;
}

+ (void)resetTrackedResult {
    [FUAIKit resetTrackedResult];
}

+ (void)updateBeautyBlurEffect {
    if (![FURenderKit shareRenderKit].beauty || ![FURenderKit shareRenderKit].beauty.enable) {
        return;
    }
    if ([FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh) {
        // 根据人脸置信度设置不同磨皮效果
        CGFloat score = [FUAIKit fuFaceProcessorGetConfidenceScore:0];
        if (score > 0.95) {
            [FURenderKit shareRenderKit].beauty.blurType = 3;
            [FURenderKit shareRenderKit].beauty.blurUseMask = YES;
        } else {
            [FURenderKit shareRenderKit].beauty.blurType = 2;
            [FURenderKit shareRenderKit].beauty.blurUseMask = NO;
        }
    } else {
        // 设置精细磨皮效果
        [FURenderKit shareRenderKit].beauty.blurType = 2;
        [FURenderKit shareRenderKit].beauty.blurUseMask = NO;
    }
}

/// 加载默认美颜
+ (void)loadDefaultBeauty {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification" ofType:@"bundle"];
    FUBeauty *beauty = [[FUBeauty alloc] initWithPath:path name:@"FUBeauty"];
    beauty.heavyBlur = 0;
    // 默认均匀磨皮
    beauty.blurType = 3;
    // 默认精细变形
    beauty.faceShape = 4;
    // 高性能设备设置去黑眼圈、去法令纹、大眼、嘴型最新效果
    if ([FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh) {
        [beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemovePouchStrength];
        [beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemoveNasolabialFoldsStrength];
        [beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyEyeEnlarging];
        [beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyIntensityMouth];
    }
    [FURenderKit shareRenderKit].beauty = beauty;
}
@end
