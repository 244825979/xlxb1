//
//  ASFGIAPVerifyTransactionManager.h
//  AS
//
//  Created by SA on 2025/6/26.
//

#import <Foundation/Foundation.h>
#import <FGIAPVerifyTransaction.h>
#import <FGIAPService/FGIAPManager.h>
#import <FGIAPService/FGIAPProductsFilter.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASFGIAPVerifyTransactionManager : NSObject<FGIAPVerifyTransaction>
//去支付
+ (void)goPayWithFilter:(FGIAPProductsFilter *)filter productID:(NSString *)productID orderNo:(NSString *)orderNo;
@end

NS_ASSUME_NONNULL_END
