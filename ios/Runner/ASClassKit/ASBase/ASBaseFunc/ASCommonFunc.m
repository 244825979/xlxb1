//
//  ASCommonFunc.m
//  AS
//
//  Created by SA on 2025/4/9.
//

#import "ASCommonFunc.h"
#import <sys/utsname.h>
#import <sys/mount.h>
#import <WKWebView+AFNetworking.h>
#import <SDImageCache.h>
#import <YYImageCache.h>

@implementation ASCommonFunc

/**颜色转图片*/
+ (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)getGradientImageFromColors:(NSArray*)colors imgSize:(CGSize)imgSize {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    if (imgSize.width == 0 || imgSize.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    start = CGPointMake(0.0, 0.0);
    end = CGPointMake(imgSize.width, 0.0);
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

/*解析数据 如果为空就改为空字符串*/
+ (NSString*)jsonDataChange:(NSString*)args{
    if ((args) == nil || [[NSString stringWithFormat:@"%@",args] isEqualToString:@"<null>"] ||  [[NSString stringWithFormat:@"%@",args] isEqualToString:@"(null)"] || [args isKindOfClass:[NSNull class]]) { //判断数据是否为空
        return @"";
    }else{ //转化字符串
        args  = [NSString stringWithFormat:@"%@",args];
    }
    return args;
}

/*身份证 */
+ (BOOL)isValidateIdCard:(NSString*)idCard {
    BOOL flag;
    if (idCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [identityCardPredicate evaluateWithObject:idCard];
}

/*座机号码 */
+(BOOL)isValidateTelPhone:(NSString*)telPhone {
    NSString *carRegex = @"^(\\d{3,4}-)\\d{7,8}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:telPhone];
}

/*纯数字 */
+(BOOL)isValidateNumber:(NSString*)number {
    NSString *carRegex = @"^[0-9]*$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:number];
}

/*纯字母 */
+(BOOL)isValidateAlphabet:(NSString*)alphabet {
    NSString *carRegex = @"^[a-zA-Z]*$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:alphabet];
}

/* 输入中文 */
+ (BOOL)deptNameInputShouldChinese:(NSString*)chinese {
    NSString *carRegex = @"^[\u4e00-\u9fa5]$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [pred evaluateWithObject:chinese];
}

//密码校验
+ (BOOL)isValidatePassword:(NSString *)passWord {
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    //只能输入数字和字母组合
    //NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
//邮箱
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//姓名
+ (BOOL)isValidateUserName:(NSString *)name {
    NSString *nameRegex = @"^[\u4E00-\u9FA5]{2,6}$";
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    return [namePredicate evaluateWithObject:name];
}
//昵称
+ (BOOL)isValidateNickname:(NSString *)nickname {
    NSString *nicknameRegex = @"^[\u4E00-\u9FA5A-Za-z]{2,16}";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    
    return [passWordPredicate evaluateWithObject:nickname];
}

//判断是否银行卡
+ (BOOL)isCheckCardNo:(NSString*) cardNumber {
    if(cardNumber.length == 0) {
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++) {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c)) {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--) {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo) {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

//手机号码正则
+ (BOOL)isPhoneNumberByRegex:(NSString *)phoneNum{
    //一般情况下我们只要验证手机号码为11位，且以1开头。
    NSString *phoneRegex = @"^1[0-9]{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phoneNum];
}

//获取当前时间戳
+ (NSTimeInterval)currentTime {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    return time;
}

//获取当前时间戳字符串
+ (NSString *)currentTimeStr {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

// NSDictionary 转 jsonString
+ (NSString *)convertNSDictionaryToJsonString:(NSDictionary *)json {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

// jsonString 转 NSDictionary
+ (NSDictionary *)convertJsonStringToNSDictionary:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return nil;
    }
    return json;
}

//当前时间戳转时间字符串 format为格式: @"YYYY-MM-dd hh:mm:ss"
+ (NSString *)getTimeWithFormat:(NSString *)format {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:format];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    return dateString;
}

//计算文本的高度
+ (CGFloat)getSizeWithText:(NSString*)text
            maxLayoutWidth:(CGFloat)width
               lineSpacing:(CGFloat)lineSpacing
                      font:(UIFont *)font {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing: lineSpacing];//行间距
    CGRect contentRect = [text
                          boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                          attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: style}
                          context:nil];
    return contentRect.size.height;
}

//计算文本的宽度
+ (CGFloat)getSizeWithText:(NSString*)text
           maxLayoutHeight:(CGFloat)height
                      font:(UIFont *)font {
    CGRect contentRect = [text
                          boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                          attributes:@{NSFontAttributeName: font}
                          context:nil];
    return contentRect.size.width;
}

//给文本增加行间距
+ (NSAttributedString *)attributedWithString:(NSString *)content lineSpacing:(CGFloat)lineSpacing {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:STRING(content)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    return attributedStr;
}

//获取当前控制器
+ (UIViewController *)currentVc {
    UIWindow *getKeyWindow = [self getKeyWindow];
    UIViewController *controller = [self currentViewControllerWithRootViewController: getKeyWindow.rootViewController];
    return controller;
}

+ (UIViewController*)currentViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self currentViewControllerWithRootViewController:presentedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self currentViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self currentViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else {
        return rootViewController;
    }
}

//获取KeyWindow
+ (UIWindow *)getKeyWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                        break;
                    }
                }
            }
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

//转换成分秒
+ (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = totalSeconds / 60;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

// 去除字符串中指定字符
+ (NSString *)removeCharWithString:(NSString *)string chars:(NSArray *)chars {
    __block NSString *str = string;
    [chars enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        str = [str stringByReplacingOccurrencesOfString:obj withString:@""];
    }];
    return str;
}

+ (NSString *)getCacheSize {
    //路径地址
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    CGFloat documentCacheSize = [self getCacheSizeWithFilePath:documents];
    NSString *library = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    CGFloat libraryCacheSize = [self getCacheSizeWithFilePath:library];
    return [NSString stringWithFormat:@"%.2fMB", documentCacheSize + libraryCacheSize];
    
    //Documents：可用于保存应用运行时生成的需要持久化的数据，开发中一般会将需要持久化存储的东西存这里，比如数据库文件。iTunes会自动备份该目录。
    //NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    //Library/Caches：可用于存储缓存文件，例如图片视频等，著名的SDWebImage框架就将缓存的图片放在这个地方。iTunes不会备份该目录。
    //NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    
    //Library/Preferences：保存应用程序的所有偏好设置iOS的Settings(设置)。不应该直接在这里创建文件，而是需要通过NSUserDefault这个类来访问，换句话说，NSUserDefault类存储的文件会被写进这个文件夹。iTunes会自动备份该文件目录下的内容。
    //NSString *path = [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) firstObject];
    
    //tmp：临时文件目录，当应用程序未运行时，系统可能会清除此目录，一般用于保存应用程序再次启动时不需要的信息。
    //NSString *path = NSTemporaryDirectory();
}

+ (void)clearAppCache {
    //清除webView缓存
    if(@available(iOS 9.0, *)) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    } else {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[NSURLCache sharedURLCache] setDiskCapacity:0];
        [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    }
    //清除 sdImageCache
    [[SDImageCache sharedImageCache].diskCache removeAllData];
    [[YYImageCache sharedCache].diskCache removeAllObjects];
    //清除视频秀缓存
    [self clearCacheWithFilePath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/txcache"]];
    NSString *library = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    [self clearCacheWithFilePath:library];
}

+ (CGFloat)getCacheSizeWithFilePath:(NSString *)path {
    //计算结果
    float totalSize = 0.00;
    // 1.获得文件夹管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 2.检测路径的合理性
    BOOL dir = NO;
    BOOL exits = [mgr fileExistsAtPath:path isDirectory:&dir];
    if (!exits) return 0;
    // 3.判断是否为文件夹
    if (dir) { //文件夹, 遍历文件夹里面的所有文件
        //这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径),包括子文件夹下面的所有文件及文件夹
        NSArray *subPaths = [mgr subpathsAtPath:path];
        //遍历所有子路径
        for (NSString *subPath in subPaths) {
            //拼成全路径
            NSString *fullSubPath = [path stringByAppendingPathComponent:subPath];
            BOOL dir = NO;
            [mgr fileExistsAtPath:fullSubPath isDirectory:&dir];
            if (!dir) { //子路径是个文件
                //如果是数据库文件，不加入计算
                if ([subPath isEqualToString:@"mySql.sqlite"]) {
                    continue;
                }
                NSDictionary *attrs = [mgr attributesOfItemAtPath:fullSubPath error:nil];
                totalSize += [attrs[NSFileSize] floatValue];
            }
        }
        totalSize = totalSize / 1000.00 / 1000.00;//单位M
        return totalSize;
    } else { //文件
        NSDictionary *attrs = [mgr attributesOfItemAtPath:path error:nil];
        totalSize = [attrs[NSFileSize] intValue] / 1000.00 / 1000.00;//单位M
        return totalSize;
    }
}

+ (void)clearCacheWithFilePath:(NSString *)path {
    //清理结果的信息
    NSString *message = nil;//提示文字
    BOOL clearSuccess = YES;//是否删除成功
    NSError *error = nil;//错误信息
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString *subPath in subPathArray) {
        //如果是数据库文件，不做操作
        if ([subPath isEqualToString:@"mySql.sqlite"]) {
            continue;
        }
        NSString *filePath = [path stringByAppendingPathComponent:subPath];
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            message = [NSString stringWithFormat:@"%@这个路径的文件夹删除失败了",filePath];
            clearSuccess = NO;
        } else {
            message = @"成功了";
        }
    }
}

//服务器版本号与当前系统版本对比
+ (NSInteger)compareVersion:(NSString *)serviceVersion toVersion:(NSString *)version {
    NSArray *serviceVersions = [serviceVersion componentsSeparatedByString:@"."];
    NSArray *versions = [version componentsSeparatedByString:@"."];
    for (int i = 0; i < serviceVersions.count || i < versions.count; i++) {
        NSInteger a = 0, b = 0;
        if (i < serviceVersions.count) {
            a = [serviceVersions[i] integerValue];
        }
        if (i < versions.count) {
            b = [versions[i] integerValue];
        }
        if (a > b) {
            return 1;//serviceVersion大于version
        } else if (a < b) {
            return -1;//serviceVersion小于version
        }
    }
    return 0;//serviceVersion等于version
}

//获取当前手机型号
+ (NSString *)getPhoneName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"])  return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])  return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])  return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])  return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])  return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])  return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])  return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])  return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])  return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])  return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])  return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])  return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])  return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"])  return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])  return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])  return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])  return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])  return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])  return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"])  return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])  return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"])  return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone12,8"]) return @"iPhone SE 2"; //(2nd generation)
    if ([platform isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
    if ([platform isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
    if ([platform isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";
    if ([platform isEqualToString:@"iPhone14,2"]) return @"iPhone 13 Pro";
    if ([platform isEqualToString:@"iPhone14,3"]) return @"iPhone 13 Pro Max";
    if ([platform isEqualToString:@"iPhone14,4"]) return @"iPhone 13 mini";
    if ([platform isEqualToString:@"iPhone14,5"]) return @"iPhone 13";
    if ([platform isEqualToString:@"iPhone14,6"]) return @"iPhone SE 3"; //(2nd generation)
    if ([platform isEqualToString:@"iPhone14,7"]) return @"iPhone 14";
    if ([platform isEqualToString:@"iPhone14,8"]) return @"iPhone 14 Plus";
    if ([platform isEqualToString:@"iPhone15,2"]) return @"iPhone 14 Pro";
    if ([platform isEqualToString:@"iPhone15,3"]) return @"iPhone 14 Pro Max";
    if ([platform isEqualToString:@"iPhone15,4"]) return @"iPhone 15";
    if ([platform isEqualToString:@"iPhone15,5"]) return @"iPhone 15 Plus";
    if ([platform isEqualToString:@"iPhone16,1"]) return @"iPhone 15 Pro";
    if ([platform isEqualToString:@"iPhone16,2"]) return @"iPhone 15 Pro Max";
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    return platform;
}

+ (UIColor *)changeColor:(NSString *)str {
    unsigned int red,green,blue;
    NSString * str1 = [str substringWithRange:NSMakeRange(0, 2)];
    NSString * str2 = [str substringWithRange:NSMakeRange(2, 2)];
    NSString * str3 = [str substringWithRange:NSMakeRange(4, 2)];
    NSScanner * canner = [NSScanner scannerWithString:str1];
    [canner scanHexInt:&red];
    canner = [NSScanner scannerWithString:str2];
    [canner scanHexInt:&green];
    canner = [NSScanner scannerWithString:str3];
    [canner scanHexInt:&blue];
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    return color;
}

//新增图片毛玻璃效果
+ (UIImage *)blurryImage:(UIImage *)image withblurLevel:(CGFloat)blur {
    // 1.创建CIImage
    CIImage * ciImage = [[CIImage alloc]initWithImage:image];
    // 2.添加滤镜
    CIFilter * blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    // 3.将图片输入到滤镜中
    [blurFilter setValue:ciImage forKey:kCIInputImageKey];
    // 4.设置模糊值（不模糊为0，模糊最大为100）
    [blurFilter setValue:[NSNumber numberWithFloat:blur] forKey:@"inputRadius"];
    // 5.将处理好的图片输出
    CIImage * outCiImage = [blurFilter valueForKey:kCIOutputImageKey];
    // 6.生成图片 CIContext（CIImage的操作句柄）nil表示默认有CPU渲染图片（如果让GPU渲染提高效率，则应设置contextWithOptions的字典数据）
    CIContext * context = [CIContext contextWithOptions:nil];
    // 7.获取CIImage句柄
    CGImageRef outCGImage = [context createCGImage:outCiImage fromRect:[outCiImage extent]];
    // 8.最终获取到图片
    UIImage * blurImage = [UIImage imageWithCGImage:outCGImage];
    // 9.释放句柄
    CGImageRelease(outCGImage);
    return blurImage;
}

/**
 根据字符串生成二维码
 @param string  普通字符串或URL字符串
 @param size    二维码图片大小
 @return        生成的二维码图片
 */
+ (UIImage *)createQRCodeImageWithString:(NSString *)string imageSize:(CGSize)size {
    //实例化滤镜，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复滤镜的默认属性（因为滤镜可能保存上一次的属性）
    [filter setDefaults];
    //将字符串转换为NSData
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    //获取滤镜图像(此时获取到的图像比较模糊)
    CIImage *outputImage = [filter outputImage];
    //返回高清二维码图片
    return [self createHDQRCodeImageWithCIImage:outputImage size:size];
}

/**
 根据滤镜图像创建高清二维码图片
 @param cImage  滤镜图像
 @param size    二维码图片大小
 @return        生成的高清二维码图片
 */
+ (UIImage *)createHDQRCodeImageWithCIImage:(CIImage *)cImage size:(CGSize)size {
    CGRect extentRect = CGRectIntegral(cImage.extent);
    CGFloat scale = [UIScreen mainScreen].scale;
    size_t width = CGRectGetWidth(extentRect) * scale;
    size_t height = CGRectGetHeight(extentRect) * scale;
    //创建bitmap
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:cImage fromRect:extentRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extentRect, bitmapImage);
    //保存bitmap图片
    CGImageRef scaleImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaleImage];
}

//截取view绘制成图片
+ (UIImage*)captureView:(UIView *)theView frame:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, NO,[UIScreen mainScreen].scale);
    if ([theView respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [theView drawViewHierarchyInRect:theView.bounds afterScreenUpdates:YES];
    } else {
        [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

//数值过万处理
+ (NSString *)changeNumberAcount:(NSInteger)acount {
    if (acount < 10000) {
        return [NSString stringWithFormat:@"%zd", acount];
    }
    //截取小数点1位
    NSString *floatAcount = [NSString stringWithFormat:@"%zd",acount];
    NSDecimalNumber *minNum = [NSDecimalNumber decimalNumberWithString:floatAcount];
    NSDecimalNumberHandler *round = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber * res = [minNum decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10000"] withBehavior:round];
    return [NSString stringWithFormat:@"%.1fw", res.doubleValue];
}

//富文本部分字体飘灰
+ (NSMutableAttributedString *)attributeString:(NSString *)text
                                 highlightText:(NSString *)highlightText
                                highlightColor:(UIColor *)color
                                 highlightFont:(UIFont *)font {
    NSRange hightlightTextRange = [text rangeOfString:highlightText];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    if (hightlightTextRange.length > 0) {
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:color
                             range:hightlightTextRange];
        [attributeStr addAttribute:NSFontAttributeName value:font range:hightlightTextRange];
        return attributeStr;
    } else {
        return [highlightText copy];
    }
}

/**时间显示处理，0分钟< 时间间隔<59分钟，
    显示**分钟前1小时≤时间间隔<24小时，
    显示**小时前24小时≤时间间隔<48小时，
    固定显示昨天48小时≤时间间隔<72小时，固定显示前天
    72小时≤时间间隔，显示日期(mm-dd，例如03-08)**/
+ (NSString *)getTimeStrWithTimeInterval:(NSTimeInterval)timeInterval {
    NSString *timeIntervalStr = [NSString stringWithFormat:@"%lld", (long long)(timeInterval*1000.0f)];
    int timestamp = [self getDateFormatByTimestamp: timeIntervalStr];
    NSInteger min = timestamp / 60;
    if (min < 60) {
        return [NSString stringWithFormat:@"%zd分钟前",min == 0 ? 1 : min];
    }
    NSInteger hour = timestamp / 60 / 60;
    if (hour >= 1 && hour < 24) {
        return [NSString stringWithFormat:@"%zd小时前",hour];
    } else if (hour >= 24 && hour < 48) {
        return @"昨天";
    } else if (hour >= 48 && hour < 72) {
        return @"前天";
    }
    return [self getDateTimeString: [NSDate dateWithTimeIntervalSince1970:timeInterval]];;
}

+ (int)getDateFormatByTimestamp:(NSString *)timestamp {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval nowTimestamp = [dat timeIntervalSince1970];
    double endTimeDouble  = [timestamp doubleValue]/1000.0f;
    NSTimeInterval value = fabs(endTimeDouble - nowTimestamp);
    return (int)value;
}

// YYYY-MM-dd
+ (NSString *)getDateTimeString:(NSDate *)date {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

//根据URL下载图片
+ (UIImage *)downloadImageSync:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url]; // 同步阻塞
    return [UIImage imageWithData:data];
}
@end
