//
//  ASSetRequest.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASSetRequest.h"
#import "ASReportListModel.h"
#import "ASReportModel.h"
#import "ASSetBindStateModel.h"

@implementation ASSetRequest

+ (void)requestBlackListWithPage:(NSInteger)page
                         success:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page":@(page)};
    [ASBaseRequest postWithUrl:API_UserBlackList params:params success:^(id  _Nonnull response) {
        NSArray *listArray = [ASUserInfoModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(listArray);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestSetBlackWithBlackID:(NSString *)blackID
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"black_uid": STRING(blackID)};
    [ASBaseRequest postWithUrl:API_SetUserBlack params:params success:^(id  _Nonnull response) {
        NSString *status = response[@"action"];
        if ([status isEqualToString:@"add"]) {
            successBack(@1);
        } else {
            successBack(@0);
        }
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestReportListWithPage:(NSInteger)page
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page": @(page),
                             @"limit": @(REQUEST_PAGE_NUMBER)};
    [ASBaseRequest postWithUrl:API_ReportList params:params success:^(id  _Nonnull response) {
        NSArray *listArray = [ASReportListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(listArray);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestReportDrawWithID:(NSInteger)ID
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"id": @(ID)};
    [ASBaseRequest postWithUrl:API_ReportWithdraw params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestReportDetailWithID:(NSInteger)ID
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"id": [NSString stringWithFormat:@"%zd",ID]};
    [ASBaseRequest postWithUrl:API_ReportDetail params:params success:^(id  _Nonnull response) {
        ASReportListModel *model = [ASReportListModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestFateMatchStateSuccess:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_FateMatch params:@{} success:^(id  _Nonnull response) {
        NSNumber *status = response[@"fate_match"];
        successBack(status);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestSetFateMatchWithState:(NSInteger)state
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"fate_match": @(state)};
    [ASBaseRequest postWithUrl:API_SetFateMatch params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestLikeStateSuccess:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_LikeNotiStatus params:@{} success:^(id  _Nonnull response) {
        NSNumber *status = response;
        successBack(status);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestSetLikeStateWithState:(NSString *)state
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"status": STRING(state)};
    [ASBaseRequest postWithUrl:API_SetLikeNotiStatus params:params success:^(id  _Nonnull response) {
        NSNumber *status = response;
        successBack(status);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestAnonymityStateSuccess:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_GiftWindowsSetting params:@{} success:^(id  _Nonnull response) {
        NSNumber *status = response[@"gift_windows_no_name"];
        successBack(status);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestSetAnonymityWithIsOpen:(NSInteger)isOpen
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"gift_windows_no_name": @(isOpen)};
    [ASBaseRequest postWithUrl:API_UserSetting params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestMyCollectFeeDataWithSuccess:(ResponseSuccess)successBack
                                 errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"anchor_id": STRING(USER_INFO.user_id)};
    [ASBaseRequest postWithUrl:API_GetMyPrice params:params success:^(id _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestCollectFeeSelectListWithSuccess:(ResponseSuccess)successBack
                                     errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_AnchorSetting params:@{} success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestSetCollectFeeWithModel:(ASCollectFeeSelectModel *)model
                                 type:(NSString *)type
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"skill_id": @(model.status),
                             @"type": STRING(type),
                             @"price_id": STRING(model.ID)
    };
    [ASBaseRequest postWithUrl:API_SetPrice params:params success:^(id _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestOpenTeenagerWithPwd:(NSString *)pwd
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"password":STRING(pwd)};
    [ASBaseRequest postWithUrl:API_OpenTeenager params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestCloseTeenagerWithPwd:(NSString *)pwd
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"password":STRING(pwd),
                             @"is_open": @0
    };
    [ASBaseRequest postWithUrl:API_CloseTeenager params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestTeenagerStateWithSuccess:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_TeenagerStatus params:@{} success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestForgetPwdTeenagerWithPhone:(NSString *)phone
                                     code:(NSString *)code
                                  success:(ResponseSuccess)successBack
                                errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"mobile":STRING(phone),
                             @"phone_code":STRING(code)
    };
    [ASBaseRequest postWithUrl:API_VerifyMobileCode params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestReportDataSuccess:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_ReportCate params:@{} success:^(id  _Nonnull response) {
        NSArray *array = [ASReportModel mj_objectArrayWithKeyValuesArray:response];
        successBack(array);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestReportWithType:(NSInteger)type
                       images:(NSString *)images
                      content:(NSString *)content
                    reportUid:(NSString *)reportUid
                       cateID:(NSString *)cateID
                      success:(ResponseSuccess)successBack
                    errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"report_uid": STRING(reportUid),
                             @"cate_id": STRING(cateID),//举报类目ID
                             @"type": @(type),//举报类型
                             @"content": STRING(content),
                             @"images": STRING(images)
    };
    [ASBaseRequest postWithUrl:API_UserReport params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestChangeUserRemarkWithName:(NSString *)name
                                 userID:(NSString *)userID
                                success:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"remark":STRING(name),
                             @"user_id":STRING(userID)
    };
    [ASBaseRequest postWithUrl:API_UserRemark params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}
//补充材料
+ (void)requestReplenishWithReportId:(NSInteger)reportId
                              images:(NSString *)images
                             content:(NSString *)content
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"reportId":@(reportId),
                             @"images":STRING(images),
                             @"content":STRING(content)
    };
    [ASBaseRequest postWithUrl:API_ReportMore params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}
//获取绑定状态
+ (void) requestBindStatusSuccess:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_BindState params:@{} success:^(id  _Nonnull response) {
        ASSetBindStateModel *model = [ASSetBindStateModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestSetRedStatusSuccess:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_SetRedState params:@{} success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestSetBindWxWithOpenid:(NSString *)openid
                             token:(NSString *)token
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:STRING(openid) forKey:@"openid"];
    [params setValue:STRING(token) forKey:@"access_token"];
    [params setValue:@"wechat" forKey:@"platform"];
    [ASBaseRequest postWithUrl:API_BindWX params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}
@end
