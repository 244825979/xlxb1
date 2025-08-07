//
//  ASAliOSSModel.h
//  AS
//
//  Created by SA on 2025/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASAliOSSModel : NSObject
@property (nonatomic, assign) NSInteger StatusCode;
@property (nonatomic, copy) NSString *AccessKeyId;
@property (nonatomic, copy) NSString *AccessKeySecret;
@property (nonatomic, copy) NSString *Expiration;
@property (nonatomic, copy) NSString *SecurityToken;
@property (nonatomic, copy) NSString *Endpoint;
@property (nonatomic, copy) NSString *BucketName;
@property (nonatomic, copy) NSString *dir;
@end

NS_ASSUME_NONNULL_END
