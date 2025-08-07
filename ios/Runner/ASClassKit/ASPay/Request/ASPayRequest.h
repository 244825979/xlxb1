//
//  ASPayRequest.h
//  AS
//
//  Created by SA on 2025/6/26.
//

#import <Foundation/Foundation.h>
#import "ASBindAccountModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ASPayRequest : NSObject
//用户未成年弹窗-是否弹出接口
+ (void)requestIsPopAgreeWithSuccess:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack;
//用户未成年弹窗-同意
+ (void)requestAgreeUnderageWithSuccess:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack;
//点击充值按钮，5次提醒
+ (void)requestWalletRechargeBeforeWithSuccess:(ResponseSuccess)successBack
                                     errorBack:(ResponseFail)errorBack;
//收益列表：category = 2 or 收支记录：category = 1
+ (void)requestEarningsListWithPage:(NSInteger)page
                               date:(NSString *)date
                           category:(NSString *)category
                            newType:(NSString *)newType
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;
//退回退还详情
+ (void)requestGiftRefundDetailWithID:(NSString *)giftID
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//删除记录
+ (void)requestDelMoneyRecordWithRecordID:(NSString *)recordID
                                     type:(NSInteger)type
                                  success:(ResponseSuccess)successBack
                                errorBack:(ResponseFail)errorBack;
//提现数据
+ (void)requestWithdrawSuccess:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack;
//点击提现按钮，调用提现检测是否弹窗
+ (void)requestWalletIsNoticeWithSuccess:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack;
//提现数据
+ (void)requestWithdrawPriceDataWithMoney:(NSNumber *)money
                                  success:(ResponseSuccess)successBack
                                errorBack:(ResponseFail)errorBack;
//进行提现
+ (void)requestUserWithdrawNewWithMoney:(NSString *)money
                                success:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack;
//进行绑定
+ (void)requestAcountBindWithModel:(ASBindAccountModel *)model
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack;
//绑定获取信息
+ (void)requestAcountBindInfoWithID:(NSString *)ID
                           isMaster:(NSInteger)isMaster
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack;
//绑定支付账户列表
+ (void)requestAccountListWithSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
//提现记录
+ (void)requestCashoutRecordWithPage:(NSInteger)page
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack;
//vip详情数据
+ (void)requestVipNobleRechargeSuccess:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack;
//领取礼物
+ (void)requestReceiveAwardGiftSuccess:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack;
@end

NS_ASSUME_NONNULL_END
