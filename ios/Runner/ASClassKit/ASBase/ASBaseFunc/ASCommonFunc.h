//
//  ASCommonFunc.h
//  AS
//
//  Created by SA on 2025/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASCommonFunc : NSObject
/**颜色转图片*/
+ (UIImage *)createImageWithColor:(UIColor *)color;
/**渐变颜色转图片*/
+ (UIImage *)getGradientImageFromColors:(NSArray*)colors imgSize:(CGSize)imgSize;
/*解析数据 如果为空就改为空字符串*/
+ (NSString*)jsonDataChange:(NSString*)string;
/*手机号码正则表达式校验*/
+ (BOOL)isPhoneNumberByRegex:(NSString *)phoneNum;
/*身份证 */
+ (BOOL)isValidateIdCard:(NSString*)idCard;
/*座机号码 */
+ (BOOL)isValidateTelPhone:(NSString*)telPhone;
//纯数字
+ (BOOL)isValidateNumber:(NSString*)number;
/*纯字母 */
+ (BOOL)isValidateAlphabet:(NSString*)alphabet;
//密码校验
+ (BOOL)isValidatePassword:(NSString *)passWord;
/* 输入中文 */
+ (BOOL)deptNameInputShouldChinese:(NSString*)chinese;
//邮箱
+ (BOOL)isValidateEmail:(NSString *)email;
//用户名
+ (BOOL)isValidateUserName:(NSString *)name;
//昵称
+ (BOOL)isValidateNickname:(NSString *)nickname;
//判断是否银行卡
+ (BOOL)isCheckCardNo:(NSString*) cardNumber;
//获取当前时间戳
+ (NSTimeInterval)currentTime;
//获取当前时间戳字符串
+ (NSString *)currentTimeStr;
// NSDictionary 转 jsonString
+ (NSString *)convertNSDictionaryToJsonString:(NSDictionary *)json;
// jsonString 转 NSDictionary
+ (NSDictionary *)convertJsonStringToNSDictionary:(NSString *)jsonString;
//当前时间戳转时间字符串 format为格式: @"YYYY-MM-dd hh:mm:ss"
+ (NSString *)getTimeWithFormat:(NSString *)format;
//计算文本的高度
+ (CGFloat)getSizeWithText:(NSString*)text
            maxLayoutWidth:(CGFloat)width
               lineSpacing:(CGFloat)lineSpacing
                      font:(UIFont *)font;
//计算文本的宽度
+ (CGFloat)getSizeWithText:(NSString*)text
           maxLayoutHeight:(CGFloat)height
                      font:(UIFont *)font;
//给文本增加行间距
+ (NSAttributedString *)attributedWithString:(NSString *)content lineSpacing:(CGFloat)lineSpacing;
//获取当前控制器
+ (UIViewController *)currentVc;
//获取KeyWindow
+ (UIWindow *)getKeyWindow;
//时间转换成分秒
+ (NSString *)timeFormatted:(int)totalSeconds;
//去除字符串中指定字符
+ (NSString *)removeCharWithString:(NSString *)string chars:(NSArray *)chars;
//获取缓存
+ (NSString *)getCacheSize;
//清除缓存
+ (void)clearAppCache;
//服务器版本号与系统版本对比
+ (NSInteger)compareVersion:(NSString *)serviceVersion toVersion:(NSString *)version;
//获取当前手机型号
+ (NSString *)getPhoneName;
//颜色字符串设置
+ (UIColor *)changeColor:(NSString *)str;
//新增图片毛玻璃效果
+ (UIImage *)blurryImage:(UIImage *)image withblurLevel:(CGFloat)blur;
//字符串生成二维码
+ (UIImage *)createQRCodeImageWithString:(NSString *)string imageSize:(CGSize)size;
//截取view绘制成图片
+ (UIImage*)captureView:(UIView *)theView frame:(CGRect)frame;
//数值过万处理
+ (NSString *)changeNumberAcount:(NSInteger)acount;
//富文本部分字体飘灰
+ (NSMutableAttributedString *)attributeString:(NSString *)text
                                 highlightText:(NSString *)highlightText
                                highlightColor:(UIColor *)color
                                 highlightFont:(UIFont *)font;
/**时间显示处理，0分钟< 时间间隔<59分钟，
    显示**分钟前1小时≤时间间隔<24小时，
    显示**小时前24小时≤时间间隔<48小时，
    固定显示昨天48小时≤时间间隔<72小时，固定显示前天
    72小时≤时间间隔，显示日期(mm-dd，例如03-08)**/
+ (NSString *)getTimeStrWithTimeInterval:(NSTimeInterval)timeInterval;
//时间戳转为时间YYYY-MM-dd
+ (NSString *)getDateTimeString:(NSDate *)date;
//根据URL下载图片
+ (UIImage *)downloadImageSync:(NSString *)urlString;
@end

NS_ASSUME_NONNULL_END
