//
//  ASCommonRequest.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASCommonRequest.h"
#import "ASAliOSSModel.h"
#import "ASGiftTitleDataModel.h"
#import "ASSendVipModel.h"
#import "ASConsumptionModel.h"
#import "ASRecommendUserModel.h"
#import "ASGoodAnchorModel.h"
#import "ASUserVideoPopModel.h"

@implementation ASCommonRequest

+ (void)requestAppOnlineStatusWithState:(NSInteger)state
                                success:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack {
    if (USER_INFO.isLogin == NO) {
        return;
    }
    NSDictionary *params = @{@"status": @(state)};
    [ASBaseRequest postWithUrl:API_AppStatus params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestAliOSSWithType:(NSString *)type
                      success:(ResponseSuccess)successBack
                    errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"type": STRING(type)};
    [ASBaseRequest postWithUrl:API_AliOSSData params:params success:^(id  _Nonnull response) {
        ASAliOSSModel *model = [ASAliOSSModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestAppConfigSuccess:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_AppConfig params:@{} success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestAppSystemIndexIsLoading:(BOOL)isLoading
                               success:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_AppSystemIndex params:@{} success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:isLoading];
}

+ (void)requestActivateIndexWithSuccess:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_ActivateIndex params:@{} success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestCallRiskWithSuccess:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_CallRiskLabel params:@{} success:^(id  _Nonnull response) {
        ASCallAnswerRiskModel *model = [ASCallAnswerRiskModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestAuthStateWithIsRequest:(BOOL)isRequest
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    if (isRequest == YES) {
        //没有实名认证、真人认证、且是女性才进行获取认证状态
        if ((USER_INFO.is_auth == 1 && USER_INFO.is_rp_auth == 1 && USER_INFO.gender == 1) ||
            (USER_INFO.is_auth == 1 && USER_INFO.gender == 2)) {
            return;
        }
    }
    [ASBaseRequest postWithUrl:API_UserIsAuth params:@{} success:^(id  _Nonnull response) {
        //更新实名认证状态
        NSNumber *is_auth = response[@"is_auth"];
        USER_INFO.is_auth = is_auth.integerValue;
        [ASUserDefaults setValue:is_auth forKey:@"userinfo_is_auth"];
        //更新真人认证状态
        NSNumber *is_rp_auth = response[@"is_rp_auth"];
        USER_INFO.is_rp_auth = is_rp_auth.integerValue;
        [ASUserDefaults setValue:is_rp_auth forKey:@"userinfo_is_rp_auth"];
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestIndexConfigWithSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_AppIndexConfig params:@{} success:^(id  _Nonnull response) {
        NSNumber *isFaceCheck = response[@"isFaceCheck"];
        successBack(isFaceCheck);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestProvinceCitysSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_ProvinceCitys params:@{} success:^(id  _Nonnull response) {
        NSArray *array = [ASProvinceCitysListModel mj_objectArrayWithKeyValuesArray:response];
        successBack(array);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestCityOptionsSuccess:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_CityOptions params:@{} success:^(id  _Nonnull response) {
        NSArray *array = [ASProvinceCitysListModel mj_objectArrayWithKeyValuesArray:response];
        successBack(array);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestSelectListSuccess:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_SelectData params:@{} success:^(id  _Nonnull response) {
        ASDataSelectModel *model = [ASDataSelectModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestDaZhaohuWithUserID:(NSString *)userID
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"user_ids":[NSString stringWithFormat:@"[%@]",STRING(userID)]};
    [ASBaseRequest postWithUrl:API_BeckonSend params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestFollowWithUserID:(NSString *)userID
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"follow_uid": STRING(userID)};
    [ASBaseRequest postWithUrl:API_Follow params:params success:^(id  _Nonnull response) {
        NSString *state = response[@"action"];
        successBack(STRING(state));
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestGiftTitleSuccess:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_GiftTitle params:@{} success:^(id  _Nonnull response) {
        NSArray *list = [ASGiftTitleDataModel mj_objectArrayWithKeyValuesArray:response];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestGiftListWithType:(NSInteger)type
                        success:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"gift_type": @(type)};
    [ASBaseRequest postWithUrl:API_GiftList params:params success:^(id  _Nonnull response) {
        ASGiftDataModel *model = [ASGiftDataModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestGiveGiftWithGiftTypeID:(NSString *)giftTypeID
                             toUserID:(NSString *)toUserID
                               number:(NSString *)number
                               giftID:(NSString *)giftID
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"live_id": @"0",
                             @"gift_type_id": STRING(giftTypeID),
                             @"to_uid": STRING(toUserID),
                             @"num": STRING(number),
                             @"gift_id": STRING(giftID),
                             @"type": @"2",
    };
    [ASBaseRequest postWithUrl:API_SendGift params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestGoodsListWithScene:(NSString *)scene
                          showHUD:(BOOL)showHUD
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"type": @"4",
                             @"rechargeScene": STRING(scene),
                             @"examine": @(1)
    };
    [ASBaseRequest postWithUrl:API_PayGoodsList params:params success:^(id  _Nonnull response) {
        ASPayGoodsDataModel *model = [ASPayGoodsDataModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:showHUD];
}

+ (void)requestApplePayWithParams:(NSDictionary *)params
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_AppleRecharge params:params success:^(id  _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            successBack(response);
        });
    } fail:^(NSInteger code, NSString *msg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ASMsgTool hideMsg];
            if (code != 1013) {
                [ASAlertViewManager defaultPopTitle:@"温馨提示" content:STRING(msg) left:@"联系客服" right:@"取消" isTouched:YES affirmAction:^{
                    ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                    vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Customer];
                    [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                } cancelAction:^{
                    
                }];
            }
            errorBack(code, msg);
        });
    } showHUD:NO];
}

+ (void)requestSendVipDataWithUserID:(NSString *)userID
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"to_uid": STRING(userID)};
    [ASBaseRequest postWithUrl:API_SendVipGoods params:params success:^(id  _Nonnull response) {
        ASSendVipModel *model = [ASSendVipModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestMyConsumeInfoSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_MyConsumeInfo params:@{} success:^(id  _Nonnull response) {
        ASConsumptionModel *model = [ASConsumptionModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestSetConsumeWithIsExtra:(BOOL)isExtra
                               value:(NSString *)value
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack {
    NSDictionary *params;
    if (isExtra == YES) {
        params = @{@"extra": STRING(value)};
    } else {
        params = @{@"day": STRING(value)};
    }
    [ASBaseRequest postWithUrl:API_SetConsume params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestVerifyApplePayWithReceiptData:(NSString *)receiptData
                               transactionId:(NSString *)tranQWctionId
                                     orderNo:(NSString *)orderNo
                                     success:(ResponseSuccess)successBack
                                   errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"receipt-data": receiptData,
                             @"original_tranQWction_id": STRING(tranQWctionId),
                             @"order_no": STRING(orderNo)
    };
    [ASBaseRequest postWithUrl:API_VerifyApplePay params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestChangeCoinWithMoney:(NSString *)money
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"moneys": STRING(money)
    };
    [ASBaseRequest postWithUrl:API_ChangeCoin params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestRecommendUserWithScene:(NSInteger)scene
                                isHUD:(BOOL)isHUD
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"scene": @(scene)};
    [ASBaseRequest postWithUrl:API_RecommendUserPop params:params success:^(id  _Nonnull response) {
        ASRecommendUserListModel *model = [ASRecommendUserListModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:isHUD];
}

+ (void)requestRecommendBeckonWithUserIds:(NSString *)userIds
                                 zhaohuyu:(NSString *)zhaohuyu
                                  success:(ResponseSuccess)successBack
                                errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"user_ids": STRING(userIds),
                             @"word": STRING(zhaohuyu)};
    [ASBaseRequest postWithUrl:API_RecommendReckon params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestRecommendRandCommonWordSuccess:(ResponseSuccess)successBack
                                    errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_RecommendRandCommonWord params:@{} success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestRecommendStatusdSuccess:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_RecommendStatus params:@{} success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestAppVersionSuccess:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"update": @"update"};
    [ASBaseRequest postWithUrl:API_AppSystem params:params success:^(id  _Nonnull response) {
        ASVersionModel *model = [ASVersionModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestGoodAnchorIndexSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_GoodAnchorIndex params:@{} success:^(id  _Nonnull response) {
        ASGoodAnchorModel *model = [ASGoodAnchorModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestGoodAnchorClickSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_GoodAnchorClick params:@{} success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestUserVideoPopPushSuccess:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_UserVideoPopPush params:@{} success:^(id  _Nonnull response) {
        ASUserVideoPopModel *model = [ASUserVideoPopModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

//点击事件统计处理
+ (void)requestBehaviorStatsWithType:(NSInteger)type
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"content_id": @"0",
                             @"type": @(type),
                             @"behavior_type": @(2)};
    [ASBaseRequest postWithUrl:API_BehaviorStats params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

//APP启动次数上报
+ (void)requestReportAppOpenSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_ReportAppOpen params:@{} success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

//活动弹窗行为上报
+ (void)requestTrackingPopupWithUrl:(NSString *)linkUrl
                          eventType:(NSInteger)eventType
                          placement:(NSInteger)placement
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"link_url": STRING(linkUrl),
                             @"event_type": @(eventType),
                             @"placement": @(placement)};
    [ASBaseRequest postWithUrl:API_PopupTracking params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

//获取活动弹窗配置
+ (void)requestActivityPopupWithPlacement:(NSInteger)placement
                                  success:(ResponseSuccess)successBack
                                errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"placement": @(placement)};
    [ASBaseRequest postWithUrl:API_ActivityPopup params:params success:^(id  _Nonnull response) {
        ASBannerModel *model = [ASBannerModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}
@end
