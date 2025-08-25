//
//  ASIMRequest.m
//  AS
//
//  Created by SA on 2025/4/17.
//

#import "ASIMRequest.h"
#import "ASUsersHiddenDataModel.h"
#import "ASIMChatCardModel.h"
#import "ASUsersHiddenStateModel.h"
#import "ASIMIntimateUserModel.h"
#import "ASIMChatRemoteExtModel.h"
#import "ASIMChatSetModel.h"
#import "ASCallListModel.h"
#import "ASCallRecommendModel.h"
#import "ASFateHelperStatusModel.h"
#import "ASHelperListModel.h"
#import "ASSendImBatchListModel.h"
#import "ASGreetTpListModel.h"

@implementation ASIMRequest

+ (void)requestIntimateListWithIds:(NSString *)ids
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"ids": STRING(ids)};
    [ASBaseRequest postWithUrl:API_IntimateList params:kStringIsEmpty(ids) ? @{} : params success:^(id  _Nonnull response) {
        successBack(response[@"list"]);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}
+ (void)requestUsersHiddenWithSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_UsersHiddenMe params:@{} success:^(id  _Nonnull response) {
        ASUsersHiddenDataModel *model = [ASUsersHiddenDataModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}
+ (void)requestChatCardDataWithUserID:(NSString *)userID
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    if (kStringIsEmpty(userID)) {
        errorBack(9999, @"");
        return;
    }
    NSDictionary *params = @{@"user_id":STRING(userID)};
    [ASBaseRequest postWithUrl:API_ChatCardData params:params success:^(id  _Nonnull response) {
        ASIMChatCardModel *cartModel = [ASIMChatCardModel mj_objectWithKeyValues:response];
        successBack(cartModel);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}
+ (void)requestOpenHidingStateWithID:(NSString *)ID
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack {
    if (kStringIsEmpty(ID)) {
        errorBack(9999, @"");
        return;
    }
    NSDictionary *params = @{@"to_uid": STRING(ID)};
    [ASBaseRequest getWithUrl:API_OpenHidingState params:params success:^(id  _Nonnull response) {
        ASUsersHiddenStateModel *model = [ASUsersHiddenStateModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}
+ (void)requestSetHideVisitWithUserID:(NSString *)userID
                                isSet:(NSInteger)isSet
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"to_uid": STRING(userID),
                             @"status": @(isSet)};
    [ASBaseRequest postWithUrl:API_SetHideVisit params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}
+ (void)requestSetHidingWithUserID:(NSString *)userID
                             state:(BOOL)state
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack {
    if (kStringIsEmpty(userID)) {
        errorBack(9999, @"");
        return;
    }
    NSDictionary *params = @{@"to_uid": STRING(userID),
                             @"status": state == YES ? @1 : @0};
    [ASBaseRequest postWithUrl:API_SetHidingState params:params success:^(id  _Nonnull response) {
        successBack(response);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadUsersHidenListNotify" object:nil];
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestIMVideoShowWithUserID:(NSString *)userID
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack {
    if (kStringIsEmpty(userID)) {
        errorBack(9999, @"");
        return;
    }
    NSDictionary *params = @{@"user_id": STRING(userID)};
    [ASBaseRequest postWithUrl:API_IMHomeVideoShow params:params success:^(id  _Nonnull response) {
        ASVideoShowDataModel *model = [ASVideoShowDataModel mj_objectWithKeyValues:response[@"cover"]];
        if (!kObjectIsEmpty(model)) {
            successBack(model);
        } else {
            errorBack(9999, @"");
        }
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}
+ (void)requestUsefulExpressionsListWithScene:(NSInteger)scene
                                      isReply:(NSInteger)isReply
                                      success:(ResponseSuccess)successBack
                                    errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"scene":@(scene),
                             @"is_reply":@(isReply)
    };
    [ASBaseRequest postWithUrl:API_CommonWordList params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}
+ (void)requestAddUsefulExpressionsWithText:(NSString *)text
                                    success:(ResponseSuccess)successBack
                                  errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"word": STRING(text)};
    [ASBaseRequest postWithUrl:API_AddCommonWord params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}
+ (void)requestDelUsefulExpressionsWithID:(NSString *)ID
                                  success:(ResponseSuccess)successBack
                                errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"id": STRING(ID)};
    [ASBaseRequest postWithUrl:API_DelCommonWord params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}
+ (void)requestUserIntimateWithUserID:(NSString *)userID
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"user_id": STRING(userID)};
    [ASBaseRequest postWithUrl:API_UserIntimate params:params success:^(id  _Nonnull response) {
        ASIMIntimateUserModel *model = [ASIMIntimateUserModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}
+ (void)requestSendImWithType:(NSInteger)type
                        msgID:(NSString *)msgID
                      content:(NSString *)content
                     toUserID:(NSString *)toUserID
                        isTid:(NSInteger)isTid
                      success:(ResponseSuccess)successBack
                    errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"type":@(type),
                             @"msgId":STRING(msgID),
                             @"content":STRING(content),
                             @"to_uid":STRING(toUserID),
                             @"tid": @"",
                             @"is_tid": @(isTid)
    };
    [ASBaseRequest postWithUrl:API_VerifySendIM params:params success:^(id  _Nonnull response) {
        ASIMChatRemoteExtModel *extModel = [ASIMChatRemoteExtModel mj_objectWithKeyValues:response];
        successBack(extModel);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestChatSetWithUserID:(NSString *)userID
                         success:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"user_id": STRING(userID)};
    [ASBaseRequest postWithUrl:API_ChatSetting params:params success:^(id  _Nonnull response) {
        ASIMChatSetModel *model = [ASIMChatSetModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestCallListWithPage:(NSInteger)page
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page":@(page)};
    [ASBaseRequest postWithUrl:API_CallList params:params success:^(id  _Nonnull response) {
        NSArray *list = [ASCallListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestCallRecommendSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_CallRecommend params:@{} success:^(id  _Nonnull response) {
        NSArray *list = [ASCallRecommendModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestMatchHelperStateSuccess:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_MatchHelperState params:@{} success:^(id  _Nonnull response) {
        ASFateHelperStatusModel *model = [ASFateHelperStatusModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestMatchHelperListSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_MatchHelperList params:@{} success:^(id  _Nonnull response) {
        NSArray *list = [ASHelperListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestOneClickReplyWithParams:(id)params
                               success:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_SendImBatch params:params success:^(id  _Nonnull response) {
        NSArray *list = [ASSendImBatchListModel mj_objectArrayWithKeyValuesArray:response];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestGreetTplListSuccess:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_GreetTplList params:@{} success:^(id  _Nonnull response) {
        NSArray *list = [ASGreetTpListModel mj_objectArrayWithKeyValuesArray:response[@"greetList"]];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestIMChatActiveWithCateId:(NSString *)cateId
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"cateId":STRING(cateId)};
    [ASBaseRequest postWithUrl:API_ActiveConfig params:params success:^(id  _Nonnull response) {
        NSArray *list = [ASBannerModel mj_objectArrayWithKeyValuesArray:response[@"chat"]];
        if (list.count > 0) {
            successBack(list[0]);
        } else {
            errorBack(0, @"");
        }
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestIMChatPriceWithToUserId:(NSString *)userId
                               success:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"to_uid":STRING(userId)};
    [ASBaseRequest postWithUrl:API_ChatMsgPrice params:params success:^(id  _Nonnull response) {
        NSString *msgPriceTips = response[@"msgPriceTips"];
        successBack(STRING(msgPriceTips));
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}
@end
