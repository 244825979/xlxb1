//
//  ASPayRequest.m
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASPayRequest.h"
#import "ASRechargeBeforeModel.h"
#import "ASEarningsListModel.h"
#import "ASSendBackDetailModel.h"
#import "ASWithdrawModel.h"
#import "ASCenterNotifyModel.h"
#import "ASWithdrawRequestModel.h"
#import "ASBindAccountListModel.h"
#import "ASCashoutRecordModel.h"
#import "ASVipDetailsModel.h"

@implementation ASPayRequest

+ (void)requestIsPopAgreeWithSuccess:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_WalletIsAgree params:@{} success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestAgreeUnderageWithSuccess:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_WalletAgreeUnderage params:@{} success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestWalletRechargeBeforeWithSuccess:(ResponseSuccess)successBack
                                     errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_WalletRechargeBefore params:@{} success:^(id  _Nonnull response) {
        ASRechargeBeforeModel *model = [ASRechargeBeforeModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestEarningsListWithPage:(NSInteger)page
                               date:(NSString *)date
                           category:(NSString *)category
                            newType:(NSString *)newType
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    //收益记录
    //收益tab  new_type=2  category=3
    //支出tab  new_type=2  category=4
    //退还tab  new_type=5  category=5
    
    //收支tab  new_type=1  category=1
    //退回tab  new_type=4  category=4
    NSDictionary *params = @{@"type": @"0",
                             @"cate_id": @"0",
                             @"category": STRING(category),
                             @"new_type": STRING(newType),
                             @"date":STRING(date),
                             @"page": @(page),
                             @"limit": @(REQUEST_PAGE_NUMBER),
    };
    [ASBaseRequest postWithUrl:API_WalletRecord params:params success:^(id  _Nonnull response) {
        NSArray *list = [ASEarningsListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestGiftRefundDetailWithID:(NSString *)giftID
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"user_gift_id": STRING(giftID)};
    [ASBaseRequest postWithUrl:API_GiftRefundDetail params:params success:^(id  _Nonnull response) {
        ASSendBackDetailModel *model = [ASSendBackDetailModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestDelMoneyRecordWithRecordID:(NSString *)recordID
                                     type:(NSInteger)type
                                  success:(ResponseSuccess)successBack
                                errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"type": @(type),
                             @"ids":STRING(recordID)};
    [ASBaseRequest postWithUrl:API_WalletRecordDel params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestWithdrawSuccess:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_WalletWithdraw params:@{} success:^(id  _Nonnull response) {
        ASWithdrawModel *model = [ASWithdrawModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestWalletIsNoticeWithSuccess:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_WalletIsNotice params:@{} success:^(id  _Nonnull response) {
        ASCenterNotifyModel *model = [ASCenterNotifyModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestWithdrawPriceDataWithMoney:(NSNumber *)money
                                  success:(ResponseSuccess)successBack
                                errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"money": money};
    [ASBaseRequest postWithUrl:API_WithdrawPriceData params:params success:^(id  _Nonnull response) {
        ASWithdrawRequestModel *model = [ASWithdrawRequestModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestUserWithdrawNewWithMoney:(NSString *)money
                                success:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"money": STRING(money)};
    [ASBaseRequest postWithUrl:API_WithdrawNew params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestAcountBindWithModel:(ASBindAccountModel *)model
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"card_account": STRING(model.card_account),
                             @"id_card": STRING(model.id_card),
                             @"id_card_name": STRING(model.card_name),
                             @"card_type": @(model.card_type),
                             @"is_master": @(1)
    };
    [ASBaseRequest postWithUrl:API_AccountSave params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestAcountBindInfoWithID:(NSString *)ID
                           isMaster:(NSInteger)isMaster
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"id": STRING(ID),
                             @"is_master": @(isMaster)
    };
    [ASBaseRequest postWithUrl:API_AccountInfo params:params success:^(id  _Nonnull response) {
        ASBindAccountModel *model = [ASBindAccountModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestAccountListWithSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_AccountBindList params:@{} success:^(id  _Nonnull response) {
        NSArray *list = [ASBindAccountListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestCashoutRecordWithPage:(NSInteger)page
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page": @(page)
    };
    [ASBaseRequest postWithUrl:API_WalletCashoutRecord params:params success:^(id  _Nonnull response) {
        NSArray *list = [ASCashoutRecordModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestVipNobleRechargeSuccess:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_VipNobleRecharge params:@{} success:^(id  _Nonnull response) {
        ASVipDetailsModel *model = [ASVipDetailsModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestReceiveAwardGiftSuccess:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_VipAward params:@{} success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}
@end
