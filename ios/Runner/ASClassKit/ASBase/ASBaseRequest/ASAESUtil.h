//
//  ASAESUtil.h
//  AS
//
//  Created by SA on 2025/4/11.
//  数据解密

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASAESUtil : NSObject

/**
 * AES加密
 * AESKey
 */
+ (NSString *)AES128Decrypt:(NSString *)str;

/**
 * AES解密
 */
+ (NSString *)AES128Encrypt:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
