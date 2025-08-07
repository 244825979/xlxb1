
#import "ASMsgTool.h"

#define kMsgTool [ASMsgTool shared]
static MBProgressHUD *_hud;

@interface ASMsgTool()
@property (nonatomic, strong) MBProgressHUD *showMessage;
@end

@implementation ASMsgTool

+ (instancetype)shared {
    static ASMsgTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[ASMsgTool alloc] init];
    });
    return tool;
}

+ (void)showTips:(NSString *)tips {
    [kMsgTool showMessage:tips toView:nil];
}

+ (void)showTips:(NSString *)tips toView:(UIView *)toView {
    [kMsgTool showMessage:tips toView:toView];
}

+ (void)showLoading:(nonnull NSString *)message {
    _hud = [self showLoadMessage:message toView:nil];
}

+ (void)showLoading {
    //    _hud = [self showLoadMessage:@"加载中..." toView:nil];
    _hud = [self showGif];//提示成功图标
}

+ (MBProgressHUD *)showGif {
    [kMsgTool showLoadGIFWithToView: nil];
    return kMsgTool.showMessage;
}

+ (void)showSuccess:(NSString *)success {
    [kMsgTool showMessage:success toView:nil imageName:@"dynamic_tabbar_un_select"];//提示成功图标
}

+ (void)showError:(NSString *)error {
    [kMsgTool showMessage:error toView:nil imageName:@"home_tabbar_un_select"];//提示失败图标
}

+ (void)showMessage:(NSString *)message toView:(UIView *)toView imageName:(NSString *)imageName {
    [self showMessage:message toView:toView imageName:imageName];
}

+ (MBProgressHUD *)showLoadMessage:(NSString *)message toView:(UIView *)toView {
    [kMsgTool showLoadMessage:message toView:toView canClick:YES];
    return kMsgTool.showMessage;
}

- (void)showMessage:(NSString *)message toView:(UIView *)toView {
    if (self.showMessage) [self.showMessage removeFromSuperview];
    
    if (!toView) toView = kCurrentWindow;
    // 创建指示器
    self.showMessage = [MBProgressHUD showHUDAddedTo:toView animated:YES];
    self.showMessage.mode = MBProgressHUDModeCustomView;
    self.showMessage.bezelView.color = kRGBColor(66, 66, 66);
    self.showMessage.bezelView.layer.cornerRadius = 10.0;
    self.showMessage.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    self.showMessage.detailsLabel.text = message;
    self.showMessage.detailsLabel.font = TEXT_FONT_15;
    self.showMessage.detailsLabel.textColor = UIColor.whiteColor;
    
    [self performSelectorOnMainThread:@selector(hideMessage) withObject:nil waitUntilDone:YES];
}

- (void)showMessage:(NSString *)message toView:(UIView *)toView imageName:(NSString *)imageName {
    if (self.showMessage) [self.showMessage removeFromSuperview];
    
    if (!toView) toView = kCurrentWindow;
    // 创建指示器
    self.showMessage = [MBProgressHUD showHUDAddedTo:toView animated:YES];
    self.showMessage.mode = MBProgressHUDModeCustomView;
    // 设置将要显示的图片
    UIImage *image = [UIImage imageNamed:imageName];
    // 设置自定义视图
    self.showMessage.customView = [[UIImageView alloc] initWithImage:image];
    self.showMessage.bezelView.color = kRGBColor(66, 66, 66);
    self.showMessage.bezelView.layer.cornerRadius = 10.0;
    self.showMessage.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.showMessage.label.text = message;
    self.showMessage.label.textColor = [UIColor whiteColor];
    [self performSelectorOnMainThread:@selector(hideMessage) withObject:nil waitUntilDone:YES];
}

- (void)showLoadMessage:(NSString *)message toView:(UIView *)toView canClick:(BOOL)canClick {
    if (self.showMessage) [self.showMessage removeFromSuperview];
    if (!toView) toView = kCurrentWindow;
    // 创建hud
    self.showMessage = [MBProgressHUD showHUDAddedTo:toView animated:YES];
    self.showMessage.mode = MBProgressHUDModeIndeterminate;
    self.showMessage.userInteractionEnabled = canClick;
    self.showMessage.contentColor = UIColor.whiteColor;
    // 设置背景颜色和圆角
    self.showMessage.bezelView.color = kRGBColor(66, 66, 66);
    self.showMessage.bezelView.layer.cornerRadius = 10.0;
    self.showMessage.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    // 设置文字内容和颜色
    self.showMessage.label.text = message;
    self.showMessage.label.textColor = [UIColor whiteColor];
}

- (void)showLoadGIFWithToView:(UIView *)toView {
    if (self.showMessage) [self.showMessage removeFromSuperview];
    if (!toView) toView = kCurrentWindow;
    // 创建指示器
    self.showMessage = [MBProgressHUD showHUDAddedTo:toView animated:YES];
    self.showMessage.mode = MBProgressHUDModeCustomView;
    // 设置将要显示的图片
    YYImage *image = [YYImage imageNamed:@"loading_gif"];
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    self.showMessage.customView = imageView;
}

//设置自定隐藏
- (void)hideMessage {
    [self.showMessage hideAnimated:YES afterDelay:2];
}

+ (void)hideMsg {
    [_hud hideAnimated:YES];
}

@end
