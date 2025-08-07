//
//  UIFont+Extension.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "UIFont+Extension.h"
#import <objc/runtime.h>

@implementation UIFont (Extension)

+ (void)load {
    // 获取替换后的类方法
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    // 获取替换前的类方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
    method_exchangeImplementations(newMethod, method);
    // 获取替换后的类方法
    Method newMeth = class_getClassMethod([self class], @selector(adjusString:font:));
    // 获取替换前的类方法
    Method meth = class_getClassMethod([self class], @selector(fontWithName:size:));
    // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
    method_exchangeImplementations(newMeth, meth);
    
}

//自己定义的systemFontOfSize方法
+ (UIFont *)adjustFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont adjustFont:fontSize * [UIScreen mainScreen].bounds.size.width/375];
    return newFont;
}

//自己定义的systemFontOfSize方法
+ (UIFont *)adjusString:(NSString *)str font:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont adjusString:str font:fontSize * [UIScreen mainScreen].bounds.size.width/375];
    return newFont;
}

/**
 注意:
 load方法只会走一次，利用runtime的method进行方法的替换
 替换的方法里面（把系统的方法替换成我们自己写的方法），这里要记住写自己的方法，不然会死循环
 之后凡是用到systemFontOfSize方法的地方，都会被替换成我们自己的方法，即可改字体大小了
 注意：此方法只能替换 纯代码 写的控件字号，如果你用xib创建的控件且在xib里面设置的字号，那么替换不了！你需要在xib的
 awakeFromNib方法里面手动设置下控件字体
 */

@end
