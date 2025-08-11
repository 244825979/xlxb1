//
//  ASFGIAPVerifyTransactionManager.m
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASFGIAPVerifyTransactionManager.h"
#import "ASMyAppRegister.h"

@implementation ASFGIAPVerifyTransactionManager

+ (void)goPayWithFilter:(FGIAPProductsFilter *)filter productID:(NSString *)productID orderNo:(NSString *)orderNo {
    if (kStringIsEmpty(productID)) {
        kShowToast(@"支付失败");
        return;
    }
    /// 2.获取商品信息
    [filter requestProductsWith:[NSSet setWithObject:STRING(productID)] completion:^(NSArray<SKProduct *> * _Nonnull products) {
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:products.firstObject];
        payment.applicationUsername = STRING(orderNo);
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        NSString *saveOrderNo = [ASUserDefaults valueForKey:[NSString stringWithFormat:@"payKey_%@", STRING(productID)]];
        if (kStringIsEmpty(saveOrderNo)) {//本地如果没有保存的支付产品的key就进行保存
            [ASUserDefaults setValue:STRING(orderNo) forKey:[NSString stringWithFormat:@"payKey_%@", STRING(productID)]];
        }
        /// 3.支付购买
        [[FGIAPManager shared].iap buyProduct:products.firstObject onCompletion:^(NSString * _Nonnull message, FGIAPManagerPurchaseRusult result) {
            ASLog(@"------------message = %@ === result = %ld",message, (long)result);
            switch (result) {
                case FGIAPManagerPurchaseRusultSuccess://成功
                {
                }
                    break;
                case FGIAPManagerPurchaseRusultHalfSuccess://苹果扣款成功，但是验签接口失败了
                {
                }
                    break;
                case FGIAPManagerPurchaseRusultFail://内购失败
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        kShowToast(@"提交购买失败");
                        [ASMsgTool hideMsg];
                    });
                }
                    break;
                case FGIAPManagerPurchaseRusultCancel://用户取消
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ASMsgTool hideMsg];
                    });
                }
                    break;
                default:
                    break;
            }
        }];
    }];
}

- (void)pushSuccessTradeReultToServer:(NSString *)receipt transaction:(SKPaymentTransaction *)transaction complete:(FGIAPVerifyTransactionPushCallBack)handler{
    NSString *transactionIdentifier = @"";
    if (transaction.transactionIdentifier.length > 0) {
        transactionIdentifier = transaction.transactionIdentifier;
    }
    ASLog(@"%s receipt: %@ = transactionIdentifier = %@", __func__ , receipt, transactionIdentifier);
    if (handler) {
        if (USER_INFO.isLogin == NO) {
            return;
        }
        NSString *orderNo = STRING(transaction.payment.applicationUsername);
        if (kStringIsEmpty(orderNo)) {
            orderNo = [ASUserDefaults valueForKey:[NSString stringWithFormat:@"payKey_%@", STRING(transaction.payment.productIdentifier)]];
        }
        [ASCommonRequest requestVerifyApplePayWithReceiptData:STRING(receipt)
                                                transactionId:STRING(transactionIdentifier)
                                                      orderNo:orderNo
                                                      success:^(id  _Nullable data) {
            NSString *productIdentifier = transaction.payment.productIdentifier;
            if ([productIdentifier containsString:@"vip"]) {
                //更新vip页面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateVipNotification" object:nil];
                kShowToast(@"开通成功~");
            } else {
                //更新余额及充值结束的处理
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBalanceNotification" object:nil];
                kShowToast(@"充值成功~");
            }
            handler(@"Success", nil);
            //删除保存到本地的订单号
            [ASUserDefaults removeObjectForKey:[NSString stringWithFormat:@"payKey_%@", STRING(transaction.payment.productIdentifier)]];
            [ASMsgTool hideMsg];
        } errorBack:^(NSInteger code, NSString *msg) {
            if (code == -10000 || code == 900) {
                NSString *productIdentifier = transaction.payment.productIdentifier;
                if ([productIdentifier containsString:@"vip"]) {
                    //更新vip页面
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateVipNotification" object:nil];
                } else {
                    //更新余额及充值结束的处理
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBalanceNotification" object:nil];
                }
                handler(@"Success", nil);
                //删除保存到本地的订单号
                [ASUserDefaults removeObjectForKey:[NSString stringWithFormat:@"payKey_%@", STRING(transaction.payment.productIdentifier)]];
            }
            [ASMsgTool hideMsg];
        }];
    }
}

- (void)pushServiceErrorLogStatistics:(NSDictionary *)logStatistics error:(FGIAPServiceErrorType)error {
    switch (error) {
        case FGIAPServiceErrorTypeTransactionIdentifierNotExist:
            [self showAlert:@"验证收据失败"];
            break;
        case FGIAPServiceErrorTypeReceiptNotExist:
            [self showAlert:@"未找到匹配的收据数据"];
            break;
        case FGIAPServiceErrorTypeVerifyTradeFail:
            [self showAlert:@"验证收据失败"];
            break;
        default:
            break;
    }
}

- (void)showAlert:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ASMsgTool hideMsg];
    }];
    [alertController addAction:action];
    [[ASMyAppRegister shared].window.rootViewController presentViewController:alertController animated:YES completion:nil];
}
@end
