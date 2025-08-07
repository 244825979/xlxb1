//
//  ASBaseTheme.h
//  AS
//
//  Created by SA on 2025/4/9.
//

#ifndef ASBaseTheme_h
#define ASBaseTheme_h
#pragma mark - 导航、tabar、宽高
//NavBar高度
#define NAVIGATION_BAR_HEIGHT 44.0f
//状态栏高度
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
//NavBar高度 + 状态栏高度
#define HEIGHT_NAVBAR (NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT)
//TabBar高度
#define TAB_BAR_HEIGHT (STATUS_BAR_HEIGHT > 20.0 ? 83.0 : 49.0)
//TabBar间距
#define TAB_BAR_MAGIN (STATUS_BAR_HEIGHT > 20.0 ? 34.0 : 0.0)
//TabBar底部预留20高度，x机型适配样式
#define TAB_BAR_MAGIN20 (STATUS_BAR_HEIGHT > 20.0 ? 20.0 : 0.0)
//头部和底部的高度和
#define HEAD_TABBAR_HEIGHT (HEIGHT_NAVBAR + TAB_BAR_HEIGHT)
//屏幕的bounds
#define SCREEN_RECT ([UIScreen mainScreen].bounds)
//屏幕宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#pragma mark - 颜色色值调用方法
//颜色RGB
#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//颜色RGB+透明度
#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
//随机颜色
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
//二进制颜色
#define UIColorRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//二进制颜色+透明度
#define UIColorRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
//渐变色背景色，主色调
#define GRDUAL_CHANGE_BG_COLOR(sizeW, sizeH) [UIColor colorWithPatternImage:GRDUAL_CHANGE_BG_IMAGE(sizeW, sizeH)]
//渐变色背景图片，主色调
#define GRDUAL_CHANGE_BG_IMAGE(sizeW, sizeH) [ASCommonFunc getGradientImageFromColors:@[UIColorRGB(0xFD6E6A), UIColorRGB(0xFFC600)] imgSize:CGSizeMake(sizeW, sizeH)]
//渐变色自定义颜色及坐标
#define CHANGE_BG_COLOR(color1, color2, sizeW, sizeH) [UIColor colorWithPatternImage:CHANGE_BG_IMAGE(color1, color2, sizeW, sizeH)]
//渐变色image自定义颜色及坐标
#define CHANGE_BG_IMAGE(color1, color2, sizeW, sizeH) [ASCommonFunc getGradientImageFromColors:@[color1, color2] imgSize:CGSizeMake(sizeW, sizeH)]

#pragma mark - 主题线条其他颜色
#define MAIN_COLOR UIColorRGB(0xFD6E6A)                                     //主题颜色
#define LINE_COLOR UIColorRGB(0xE7E7E7)                                     //线条颜色
#define BACKGROUNDCOLOR UIColorRGB(0xF8F8F8)                                //背景颜色
#define BUTTON_GRAY_COLOR UIColorRGB(0xD0D0D8)                              //按钮背景灰色颜色
#define RED_COLOR UIColorRGB(0xFF4167)                                      //红色

#pragma mark - 字体颜色
#define TITLE_COLOR UIColorRGB(0x000000)                                    //正文深黑色颜色
#define TEXT_COLOR UIColorRGB(0x666666)                                     //正文浅色颜色
#define TEXT_SIMPLE_COLOR UIColorRGB(0x999999)                              //浅色字体颜色
#define PLACEHOLDER_COLOR UIColorRGB(0xBABAC0)                              //占位提示颜色

#pragma mark - **************** 字体大小
#define TEXT_FONT_22 [UIFont systemFontOfSize:22]
#define TEXT_FONT_20 [UIFont systemFontOfSize:20]
#define TEXT_FONT_18 [UIFont systemFontOfSize:18]
#define TEXT_FONT_17 [UIFont systemFontOfSize:17]
#define TEXT_FONT_16 [UIFont systemFontOfSize:16]
#define TEXT_FONT_15 [UIFont systemFontOfSize:15]
#define TEXT_FONT_14 [UIFont systemFontOfSize:14]
#define TEXT_FONT_13 [UIFont systemFontOfSize:13]
#define TEXT_FONT_12 [UIFont systemFontOfSize:12]
#define TEXT_FONT_11 [UIFont systemFontOfSize:11]
#define TEXT_FONT_10 [UIFont systemFontOfSize:10]
#define TEXT_FONT_9  [UIFont systemFontOfSize:9]

#pragma mark - **************** 字体加粗及特殊字体
#define TEXT_REGULAR(a) [UIFont systemFontOfSize:a weight:UIFontWeightRegular]//常规
#define TEXT_MEDIUM(a) [UIFont systemFontOfSize:a weight:UIFontWeightMedium]//中黑
#define TEXT_SEMIBOLD(a) [UIFont systemFontOfSize:a weight:UIFontWeightSemibold]//中粗
#define TEXT_WEIGHTBOLD(a) [UIFont systemFontOfSize:a weight:UIFontWeightBold]//特粗

#pragma mark - **************** 适配
//比例值
#define SCALES(number) number * (SCREEN_WIDTH / 375)

#endif /* ASBaseTheme_h */
