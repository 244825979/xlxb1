//
//  ASHomeRequest.m
//  AS
//
//  Created by SA on 2025/4/16.
//

#import "ASHomeRequest.h"
#import "ASHomeUserListModel.h"
#import "ASFirstPayDataModel.h"

@implementation ASHomeRequest

+ (void)requestHomeUserListWithPage:(NSInteger )page
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page": @(page),
                             @"limit": @(REQUEST_PAGE_NUMBER),
                             @"mtype": @"0"
    };
    [ASBaseRequest postWithUrl:API_HomeUserList params:params success:^(id  _Nonnull response) {
        ASHomeUserModel *model = [ASHomeUserModel mj_objectWithKeyValues:response[@"list"]];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestHomeNewUserListWithPage:(NSInteger)page
                               success:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page": @(page),
                             @"limit": @(REQUEST_PAGE_NUMBER),
                             @"mtype": @"0"
    };
    [ASBaseRequest postWithUrl:API_HomeNewUserList params:params success:^(id  _Nonnull response) {
        ASHomeUserModel *model = [ASHomeUserModel mj_objectWithKeyValues:response[@"list"]];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestFirstPayData:(BOOL)isLoading
                    success:(ResponseSuccess)successBack
                  errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_HomeFirstData params:@{} success:^(id  _Nonnull response) {
        ASFirstPayDataModel *model = [ASFirstPayDataModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:isLoading];
}

+ (void)requestHomeIndexInfoSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_HomeIndexInfo params:@{} success:^(id  _Nonnull response) {
        NSNumber *isInfo = response[@"is_info"];
        successBack(isInfo);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestHomeCallListWithPage:(NSInteger )page
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page":@(page),
                             @"pageSize": @(REQUEST_PAGE_NUMBER)
    };
    [ASBaseRequest postWithUrl:API_HomeGrabChatList params:params success:^(id  _Nonnull response) {
        NSArray *list = [ASHomeUserListModel mj_objectArrayWithKeyValuesArray:response];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestHomeSearchWithID:(NSString *)ID
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"search_name": STRING(ID)};
    [ASBaseRequest postWithUrl:API_HomeSearch params:params success:^(id  _Nonnull response) {
        ASHomeUserListModel *model = [ASHomeUserListModel mj_objectWithKeyValues:response[@"userInfo"]];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestLikeUserWithType:(NSString *)type
                            HUD:(BOOL)HUD
                        success:(ResponseSuccess)successBack
                      errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"type": STRING(type)};
    [ASBaseRequest postWithUrl:API_RecommendLike params:params success:^(id  _Nonnull response) {
        NSArray *list = [ASHomeUserListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:HUD];
}

//首页新人
+ (void)requestNewListWithPage:(NSInteger )page
                       success:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page": @(page),
                             @"limit": @(REQUEST_PAGE_NUMBER),
                             @"mtype": @"0"
    };
    [ASBaseRequest postWithUrl:API_HomeNewerList params:params success:^(id  _Nonnull response) {
        ASHomeUserModel *model = [ASHomeUserModel mj_objectWithKeyValues:response[@"list"]];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}
@end
