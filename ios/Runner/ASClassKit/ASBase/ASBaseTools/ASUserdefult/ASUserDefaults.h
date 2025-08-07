//
//  ASUserDefaults.h
//  AS
//
//  Created by SA on 2025/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASUserDefaults : NSObject

/**
 *  setObject方法
 *
 *  @param value     设置的value
 *  @param defaultName  key名字
 */
+ (void)setObject:(id)value forKey:(NSString *)defaultName;

/**
 *  objectForKey方法
 *
 *  @param defaultName     获取key对于的值
 */
+ (id)objectForKey:(NSString *)defaultName;

/**
 *  setValue方法
 *
 *  @param value     设置的value
 *  @param defaultName  key名字
 */
+ (void)setValue:(id)value forKey:(NSString *)defaultName;

/**
 *  valueForKey方法
 *
 *  @param defaultName     获取key对于的值
 */
+ (id)valueForKey:(NSString *)defaultName;

/**
 *  removeObjectForKey方法
 *
 *  @param key     要移除的key
 */
+(void)removeObjectForKey:(NSString*)key;

/**
 *  清除所有的存储信息
 *
 */
+(void)clearAll;
@end

NS_ASSUME_NONNULL_END
