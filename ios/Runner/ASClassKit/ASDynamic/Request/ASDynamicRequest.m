//
//  ASDynamicRequest.m
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASDynamicRequest.h"
#import "ASDynamicListModel.h"
#import "ASDynamicCommentModel.h"
#import "ASDynamicNotifyListModel.h"

@implementation ASDynamicRequest

+ (void)requestDynamicListWithPage:(NSInteger)page
                              type:(NSInteger)type
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack  {
    NSDictionary *params = @{@"type": @(type),//推荐1，关注2
                             @"page": @(page),
                             @"limit": @(REQUEST_PAGE_NUMBER),
                             @"gender": @(USER_INFO.gender),
                             @"city": STRING(USER_INFO.city)
    };
    [ASBaseRequest postWithUrl:API_DynamicList params:params success:^(id  _Nonnull response) {
        NSArray *list = [ASDynamicListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(list);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD: NO];
}

+ (void)requestDynamicDisLikeWithID:(NSString *)dynamicID
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"dynamic_id": STRING(dynamicID)};
    [ASBaseRequest postWithUrl:API_DynamicDisLike params:params success:^(id  _Nonnull response) {
        kShowToast(@"提交成功！");
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestLikeWithDynamicID:(NSString *)dynamicID
                            type:(NSInteger)type
                         success:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"type": @(type),
                             @"dynamic_id": STRING(dynamicID)
    };
    [ASBaseRequest postWithUrl:API_DynamicLike params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestDynamicDetailWithID:(NSString *)dynamicID
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"dynamic_id": STRING(dynamicID)};
    [ASBaseRequest postWithUrl:API_DynamicDetail params:params success:^(id  _Nonnull response) {
        ASDynamicListModel *model = [ASDynamicListModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestCommentWithID:(NSString *)dynamicID
                   commentID:(NSString *)commentID
                     content:(NSString *)content
                     success:(ResponseSuccess)successBack
                   errorBack:(ResponseFail)errorBack {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"content":STRING(content),
                                                                                  @"dynamic_id":STRING(dynamicID)
                                                                                }];
    if (!kStringIsEmpty(commentID)) {
        [params setValue:STRING(commentID) forKey:@"comment_id"];
    }
    [ASBaseRequest postWithUrl:API_DynamicComment params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestCommentListWithID:(NSString *)dynamicID
                            page:(NSInteger)page
                         success:(ResponseSuccess)successBack
                       errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page":@(page),
                             @"limit":@(REQUEST_PAGE_NUMBER),
                             @"dynamic_id": STRING(dynamicID)
    };
    [ASBaseRequest postWithUrl:API_DynamicCommentList params:params success:^(id  _Nonnull response) {
        NSArray *listArray = [ASDynamicCommentModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(listArray);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestDynamicDeleteWithID:(NSString *)dynamicID
                           success:(ResponseSuccess)successBack
                         errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"dynamic_id": STRING(dynamicID)};
    [ASBaseRequest postWithUrl:API_DeleteDynamic params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestPublishDynamicWithContent:(NSString *)content
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"content": STRING(content),
                             @"type": @(0),
                             @"no_hot": @(0)
    };
    [ASBaseRequest postWithUrl:API_PublishDynamic params:params success:^(id  _Nonnull response) {
        successBack(response[@"dynamic_id"]);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestPublishWithURL:(NSString *)URL
                    dynamicID:(NSString*)dynamicID
                      success:(ResponseSuccess)successBack
                    errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"images": STRING(URL),
                             @"dynamic_id": STRING(dynamicID)
    };
    [ASBaseRequest postWithUrl:API_PublishImage params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestDynamicNotifyListWithPage:(NSInteger)page
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page":@(page),
                             @"limit":@(REQUEST_PAGE_NUMBER)
    };
    [ASBaseRequest postWithUrl:API_DynamicNotify params:params success:^(id  _Nonnull response) {
        NSArray *lists = [ASDynamicNotifyListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(lists);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestUserDynamicListWithUserID:(NSString *)userID
                                    page:(NSInteger)page
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"user_id":STRING(userID),
                             @"page": @(page),
                             @"limit": @(REQUEST_PAGE_NUMBER),
    };
    [ASBaseRequest postWithUrl:API_UserDynamicList params:params success:^(id  _Nonnull response) {
        NSArray *lists = [ASDynamicListModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(lists);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestUnreadDynamicCountSuccess:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_DynamicNotifyCount params:@{} success:^(id  _Nonnull response) {
        NSNumber *count = response;
        successBack(count);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}
@end
