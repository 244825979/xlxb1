//
//  ASMineRequest.m
//  AS
//
//  Created by SA on 2025/4/18.
//

#import "ASMineRequest.h"
#import "ASSignInModel.h"
#import "ASMineUserModel.h"
#import "ASAccountMoneyModel.h"
#import "ASEditTagsDataModel.h"
#import "ASConvenienceLanListModel.h"
#import "ASSecurityCenterModel.h"

@implementation ASMineRequest

+ (void)requestTodaySignDataSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_TodaySign params:@{} success:^(id  _Nonnull response) {
        ASSignInModel *model = [ASSignInModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestMineHomeSuccess:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_MinUserHome params:@{} success:^(id  _Nonnull response) {
        ASMineUserModel *model = [ASMineUserModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestWalletIndexSuccess:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_WalletIndex params:@{} success:^(id  _Nonnull response) {
        ASAccountMoneyModel *model = [ASAccountMoneyModel mj_objectWithKeyValues:response[@"account"]];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestDaySignInSuccess:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_TodayActivity params:@{} success:^(id  _Nonnull response) {
        ASSignInGiftModel *model = [ASSignInGiftModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestBannerWithType:(NSString *)type
                      success:(ResponseSuccess)successBack
                    errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"cate_id":STRING(type),
                             @"type": @(1)
    };
    [ASBaseRequest postWithUrl:API_IndexBanner params:params success:^(id  _Nonnull response) {
        NSArray *banner = [ASBannerModel mj_objectArrayWithKeyValuesArray:response[@"banner"]];
        successBack(banner);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestUpdataAvatarWithURL:(NSString *)URL
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"avatar":STRING(URL)};
    [ASBaseRequest postWithUrl:API_UpdateAvatar params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestEditDataSuccess:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"user_id": STRING(USER_INFO.user_id)};
    [ASBaseRequest postWithUrl:API_EditUserInfo params:params success:^(id  _Nonnull response) {
        ASUserInfoModel *userInfo = [ASUserInfoModel mj_objectWithKeyValues:response];
        successBack(userInfo);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestEditSaveDataWithModel:(ASEditDataModel *)model
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"occupation":STRING(model.occupation),
                             @"albums":STRING(model.albums),
                             @"education": STRING(model.education),
                             @"signature": STRING(model.signature),
                             @"weight": STRING(model.weight),
                             @"cityId": STRING(model.cityId),
                             @"label": STRING(model.label),
                             @"avatar": STRING(model.avatar),
                             @"is_marriage": STRING(model.is_marriage),
                             @"user_id": STRING(model.user_id),
                             @"age": STRING(model.age),
                             @"height": STRING(model.height),
                             @"annual_income": STRING(model.annual_income),
                             @"nickname": STRING(model.nickname),
                             @"voice_time": @(model.voice_time),
                             @"voice": STRING(model.voice),
                             @"hometown": STRING(model.hometown)
    };
    [ASBaseRequest postWithUrl:API_SaveImporveData params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestVoiceTextListSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_SetVoiceList params:@{} success:^(id  _Nonnull response) {
        NSArray *array = [NSString mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(array);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestTagsListSuccess:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_UserTags params:@{} success:^(id  _Nonnull response) {
        ASEditTagsDataModel *model = [ASEditTagsDataModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestFollowListWithPage:(NSInteger)page
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page":@(page)};
    [ASBaseRequest postWithUrl:API_FollowList params:params success:^(id  _Nonnull response) {
        NSArray *list = [ASUserInfoModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestFansListWithPage:(NSInteger )page
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page":@(page)};
    [ASBaseRequest postWithUrl:API_FansList params:params success:^(id  _Nonnull response) {
        NSArray *list = [ASUserInfoModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestLookListWithPage:(NSInteger)page
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page":@(page)};
    [ASBaseRequest postWithUrl:API_ViewerList params:params success:^(id  _Nonnull response) {
        NSArray *list = [ASUserInfoModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestVisitorListWithPage:(NSInteger)page
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page":@(page)};
    [ASBaseRequest postWithUrl:API_VisitorList params:params success:^(id  _Nonnull response) {
        NSArray *list = [ASUserInfoModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestConvenienceLanListSuccess:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_GreetListsNew params:@{} success:^(id  _Nonnull response) {
        NSArray *array = [ASConvenienceLanListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(array);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestConvenienceLanSetNameWithName:(NSString *)name
                                          ID:(NSString *)ID
                                     success:(ResponseSuccess)successBack
                                   errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"id": STRING(ID),
                             @"name": STRING(name)
    };
    [ASBaseRequest postWithUrl:API_GreetSetName params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestDelConvenienceLanWithID:(NSString *)ID
                               success:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"id": STRING(ID)};
    [ASBaseRequest postWithUrl:API_GreetDel params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestSetDefaultConvenienceLanWithID:(NSString *)ID
                                      success:(ResponseSuccess)successBack
                                    errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"id": STRING(ID)};
    [ASBaseRequest postWithUrl:API_GreetSetDefault params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestAddConvenienceLanWithModel:(ASConvenienceLanAddModel *)model
                                  success:(ResponseSuccess)successBack
                                errorBack:(ResponseFail)errorBack {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:STRING(model.title) forKey:@"title"];
    [params setValue:@(1) forKey:@"is_multi"];
    [params setValue:STRING(model.file) forKey:@"file"];
    if (!kStringIsEmpty(model.voice_file)) {
        [params setValue:@(model.length) forKey:@"length"];
        [params setValue:STRING(model.voice_file) forKey:@"voice_file"];
    }
    [ASBaseRequest postWithUrl:API_GreetAdd params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestSecurityCenterWithSuccess:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_SecurityCenter params:@{} success:^(id  _Nonnull response) {
        NSArray *array = [ASSecurityCenterModel mj_objectArrayWithKeyValuesArray:response];
        successBack(array);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestNoticeAgreeWithID:(NSString *)ID
                         success:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"noticeLogId": STRING(ID)};
    [ASBaseRequest postWithUrl:API_NoticeAgree params:params success:^(id _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestIsPopNoticeWithSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_IsPopCenterNotice params:@{} success:^(id _Nonnull response) {
        ASCenterNotifyModel *model = [ASCenterNotifyModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

//我的页面是否弹出绑定微信弹窗或者绑定手机号弹窗
+ (void)requestIsPopBindAlertWithSuccess:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_IsPopBindAlert params:@{} success:^(id _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}
@end
