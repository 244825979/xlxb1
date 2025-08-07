//
//  ASAppVersionModel.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASAppVersionModel : NSObject
@property (nonatomic, copy) NSString *upgradetext;//更新文案
@property (nonatomic, copy) NSString *downloadurl;//跳转地址
@property (nonatomic, copy) NSString *newversion;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, assign) NSInteger enforce;//是否强制更新
@end

NS_ASSUME_NONNULL_END
