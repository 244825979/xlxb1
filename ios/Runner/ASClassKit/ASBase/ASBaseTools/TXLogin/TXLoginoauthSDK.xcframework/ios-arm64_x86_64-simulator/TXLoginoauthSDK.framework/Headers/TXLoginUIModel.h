//
//  TXLoginUIModel.h
//  TXLoginoauthSDK
//
//  Created by zhouguanghui on 2020/9/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RICHPresentationDirection){
    RICHPresentationDirectionBottom = 0,  //底部  present默认效果
    RICHPresentationDirectionRight,       //右边  导航栏效果
    RICHPresentationDirectionTop,         //上面
    RICHPresentationDirectionLeft,        //左边
};

typedef NS_ENUM(NSUInteger, AuthLanguageType) {
    AuthLanguageSimplifiedChinese = 0,  //简体中文
    AuthLanguageTraditionalChinese,     //繁体中文
    AuthLanguageEnglish,                //英文
};

@interface TXLoginUIModel : NSObject

#pragma mark -----------------------------授权页面----------------------------------

#pragma mark - 自定义控件
/**授权页面是否需要弹出动画*/
@property (nonatomic, assign) BOOL presentAnimated;
/**授权页面弹出的动画效果：参考RichPresentationDirection枚举*/
@property (nonatomic, assign) RICHPresentationDirection presentType;
/**自定义view，需要根据屏幕位置传入相对应frame ,可添加多个*/
@property (nonatomic, strong) NSArray<UIView *> *customOtherLoginViews;
/**是否创建自定义登录方式view，如添加QQ，微信等 默认YES 如需创建则将ifCreateCustomView 设置为YES*/
@property (nonatomic, assign) BOOL ifCreateCustomView;
/**自定义顶部view，可自定义设计为导航栏样式*/
@property (nonatomic, strong) UIView *customTopLoginView;
/**自定义背景view 需要自定义背景图样式时使用，只在全屏模式下有效*/
@property (nonatomic, strong) UIView *customBackgroundView;
/**登入页面背景图片*/
@property (nonatomic, strong) UIImage *viewBackImg;
/**状态栏着色样式(隐藏导航栏时设置)*/
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;


#pragma mark - LOGO图片设置相关*
/**LOGO的图片设置*/
@property (nonatomic, strong) UIImage *iconImage;
/**LOGO图片frame*/
@property (nonatomic, assign) CGRect logoFrame;
/**LOGO图片是否隐藏,默认显示 NO*/
@property (nonatomic, assign) BOOL logoHidden;


#pragma mark - 号码框设置
/**号码栏Y偏移量（基于底部）*/
@property (nonatomic, strong) NSNumber* txMobliNumberOffsetY;
/**手机号码富文本属性 */
@property (nonatomic, strong) NSDictionary <NSAttributedStringKey,id> *numberTextAttributes;
/**号码栏X偏移量*/
@property (nonatomic, strong) NSNumber * numberOffsetX;


#pragma mark - 运营商提供服务文案--【中国移动/联通/电信提供认证服务】
/**认证服务文案颜色 */
@property (nonatomic, strong) UIColor *sloganTextColor;
/**认证服务文案Y偏移量(距离底部的位置) */
@property (nonatomic, assign) CGFloat sloganLabelOffsetY;
/**认证服务文案字体大小 */
@property (nonatomic, strong) UIFont *brandLabelTextSize;
/**认证服务文案是否隐藏,默认显示 NO*/
@property (nonatomic, assign) BOOL sloganHidden;


#pragma mark - 登录按钮
/**登录按钮文本*/
@property (nonatomic, strong)NSAttributedString *logBtnText;
/**登录按钮Y偏移量，距离底部的偏移量*/
@property (nonatomic, assign) CGFloat logBtnOffsetY;
/**登录按钮的左右边距 注意:按钮呈现的宽度在竖屏时必须大于屏幕的一半,横屏时必须大于屏幕的三分之一
 示例:@[@50,@70] 只能两个元素
 */
@property (nonatomic, strong) NSArray <NSNumber *> *logBtnOriginLR;
/**登录按钮高h 注意：必须大于40，若需单独修改登录按钮的高度，宽度logBtnWidth不传值或者传0即可*/
@property (nonatomic, assign) CGFloat logBtnHeight;
/**1登录按钮背景图片添加到数组(顺序如下)。不可设置圆角，用图片代替。
 @[激活状态的图片,失效状态的图片,高亮状态的图片]
*/
@property (nonatomic, strong)NSArray *loginBtnImgs;
/**@[激活状态的颜色对象,失效状态的颜色对象,高亮状态的颜色对象]*/
@property (nonatomic, strong)NSArray *loginBtnColors;


#pragma mark - 隐私条款勾选框
/**勾选框选中时图片*/
@property (nonatomic, strong) UIImage *checkedImg;
/**勾选框未选中时图片*/
@property (nonatomic, strong) UIImage *uncheckedImg;
/**勾选框大小（只能正方形）必须大于12*/
@property (nonatomic, assign) CGFloat checkBoxWH;
/**勾选框选X偏移量*/
@property (nonatomic, strong) NSNumber *checkboxOffsetX;
/**勾选框选Y偏移量，优先级高于checkboxOffsetY_B*/
@property (nonatomic, strong) NSNumber *checkboxOffsetY;
/**号勾选框选Y偏移量（基于底部）*/
@property (nonatomic, strong) NSNumber *checkboxOffsetY_B;
/**隐私条款check框状态 默认:NO */
@property (nonatomic, assign) BOOL privacyState;
/**忽略隐私条款check框状态，登陆按钮一直可点击 默认:NO(不忽略) */
@property (nonatomic, assign) BOOL ignorePrivacyState;


#pragma mark - 隐私条款
/**隐私条款（包括check框）的左右边距*/
@property (nonatomic, strong) NSArray <NSNumber *> *appPrivacyOriginLR;
/**隐私协议标签Y偏移量
 该控件底部（bottom）相对于屏幕（safeArea）底部（bottom）的距离
 */
@property (nonatomic, assign) CGFloat privacyLabelOffsetY;
/**隐私的内容模板：
 1、全句可自定义但必须保留"&&默认&&"字段表明SDK默认协议,否则设置不生效
 2、协议1和协议2的名称要与数组 str1 和 str2 ... 里的名称 一样
 3、必设置项（参考SDK的demo）
 appPrivacieDemo设置内容：登录并同意&&默认&&和&&百度协议&&、&&京东协议2&&登录并支持一键登录
 展示：   登录并同意中国移动条款协议和百度协议1、京东协议2登录并支持一键登录
 */
@property (nonatomic, copy) NSAttributedString *appPrivacyDemo;
/**隐私条款名称颜色（协议）统一设置 */
@property(nonatomic, strong)UIColor *privacyColor;
/**隐私条款默认协议是否开启书名号 */
@property (nonatomic, assign) BOOL privacySymbol;
/**隐私条款:数组（务必按顺序）要设置NSLinkAttributeName属性可以跳转协议
 对象举例：
 NSAttributedString *str1 = [[NSAttributedString alloc]initWithString:@"百度协议" attributes:@{NSLinkAttributeName:@"https://www.baidu.com"}];
 @[str1,str2,str3,...]
 */
@property (nonatomic, strong) NSArray <NSAttributedString *> *appPrivacy;


#pragma mark - 隐私条款跳转协议页面
/**web协议界面导航返回图标(尺寸根据图片大小)*/
@property (nonatomic, strong) UIImage *webNavReturnImg;
/**web协议界面导航标题字体属性设置
 默认值：@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:16]}
*/
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *webNavTitleAttrs;
/**web协议界面导航标题栏颜色*/
@property (nonatomic, strong) UIColor *webNavColor;


#pragma mark - Toast文案
/**未勾选隐私条款提示的自定义提示文案，提示功能默认关闭，该属性被合法赋值（非空，且最大长度为100的字符串）后打开提示功能。*/
@property (nonatomic, strong) NSString *checkTipText;
/**隐私条款增加抖动效果 默认:NO */
@property (nonatomic, assign) BOOL privacyUncheckAnimation;


#pragma mark ----------------------弹窗:(温馨提示:由于受屏幕影响，小屏幕（5S,5E,5）需要改动字体和另自适应和布局)--------------------
#pragma mark --------------------------窗口模式1（居中弹窗） 弹框模式需要配合自定义坐标属性使用可自适应-----------------------------------

//务必在设置控件位置时，自行查看各个机型模拟器是否正常
/**温馨提示:
 窗口1模式下，自动隐藏系统导航栏,并生成一个UILabel 其frame为（0,0,窗口宽*scaleW,44*scaleW）
 返回按钮的frame查看51属性备注,添加在UILabel的center.y位置
*/
/**窗口模式开关默认为no 全屏模式*/
@property (nonatomic, assign) BOOL authWindow;

/**窗口模式推出动画
 UIModalTransitionStyleCoverVertical, 下推
 UIModalTransitionStyleFlipHorizontal,翻转
 UIModalTransitionStyleCrossDissolve, 淡出
 */
@property (nonatomic, assign) UIModalTransitionStyle modalTransitionStyle;
/**自定义窗口弧度 默认是10*/
@property (nonatomic, assign) CGFloat cornerRadius;
/**自定义窗口宽-缩放系数(屏幕宽乘以系数) 默认是0.8*/
@property (nonatomic, assign) CGFloat scaleW;
/**自定义窗口高-缩放系数(屏幕高乘以系数) 默认是0.5*/
@property (nonatomic, assign) CGFloat scaleH;
/**弹窗背景透明度 默认0.3*/
@property (nonatomic, assign) CGFloat authWindowAlpha;


#pragma mark -----------窗口模式2（边缘弹窗） UIPresentationController（可配合UAPresentationDirection动画使用）-----------
/**此属性支持半弹框方式与authWindow不同（此方式为UIPresentationController）设置后自动隐藏切换按钮，该属性需要UIModalPresentationCustom（边缘弹窗模式下SDK默认设置）下生效*/
@property (nonatomic, assign) CGSize controllerSize;
/**横竖屏默认属性*/
@property (nonatomic, assign) BOOL faceOrientation;
/**模态展示样式设置属性*/
@property (nonatomic, assign) UIModalPresentationStyle modalPresentationStyle;
/**边缘弹窗模式开关默认为no 全屏模式*/
@property (nonatomic, assign) BOOL edgeWindow;


#pragma mark - 多语言配置
/**多语言配置：
 AuthLanguageSimplifiedChinese ,   //简体中文
 AuthLanguageTraditionalChinese,   //繁体中文
 AuthLanguageEnglish,                     //英文
 */
@property (nonatomic, assign) AuthLanguageType appLanguageType;


#pragma mark - 登录授权页登录加载view设置
/**
 是否显示默认加载loadingView,默认为YES;如需使用自定义LoadingView 请使用keywindow并添加 并在相关回调中取消
 */
@property (nonatomic, assign) BOOL isShowLoginLoadingView;
/**自定义加载View，需配合isShowLoginLoadingView一起使用，设置为NO 则添加自定义View*/
@property (nonatomic, strong) UIView *loginLoadingView;


@end

NS_ASSUME_NONNULL_END
