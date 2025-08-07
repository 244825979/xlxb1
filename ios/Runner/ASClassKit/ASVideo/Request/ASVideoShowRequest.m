//
//  ASVideoShowRequest.m
//  AS
//
//  Created by SA on 2025/5/12.
//

#import "ASVideoShowRequest.h"
#import "ASVideoShowNotifyModel.h"

@implementation ASVideoShowRequest

+ (void)requestVideoShowCallWithVideoID:(NSString *)videoID
                                success:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"id": STRING(videoID)};
    [ASBaseRequest postWithUrl:API_VideoShowCall params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestVideoShowZanWithVideoID:(NSString *)videoID
                               success:(ResponseSuccess)successBack
                             errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"id": STRING(videoID)};
    [ASBaseRequest postWithUrl:API_VideoShowLike params:params success:^(id  _Nonnull response) {
        NSNumber *state = response[@"like"];
        successBack(state);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestVideoShowDashanWithUserID:(NSString *)userID
                             videoShowID:(NSString *)videoShowID
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"user_id": STRING(userID),
                             @"video_show_id": STRING(videoShowID)};
    [ASBaseRequest postWithUrl:API_VideoShowDashan params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestVideoShowFollowWithUserID:(NSString *)userID
                             videoShowID:(NSString *)videoShowID
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"follow_uid": STRING(userID),
                             @"video_show_id": STRING(videoShowID)};
    [ASBaseRequest postWithUrl:API_Follow params:params success:^(id  _Nonnull response) {
        NSString *state = response[@"action"];//delete取消关注，add进行关注
        successBack(STRING(state));
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestVideoShowNotifySuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_VideoShowHome params:@{} success:^(id _Nonnull response) {
        NSNumber *unReadRecord = response[@"un_read_record"];
        successBack(unReadRecord);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestMyPlayerVideoShowWithVideoID:(NSString *)videoID
                                     userID:(NSString *)userID
                                       page:(NSInteger)page
                                    success:(ResponseSuccess)successBack
                                  errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"id":STRING(videoID),
                             @"user_id":STRING(userID),
                             @"page":@(page),
                             @"pageSize":@(15)
    };
    [ASBaseRequest postWithUrl:API_MyVideoShowList params:params success:^(id _Nonnull response) {
        NSArray *listArray = [ASVideoShowDataModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(listArray);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestPlayerVideoShowListWithPage:(NSInteger)page
                                   success:(ResponseSuccess)successBack
                                 errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page":@(page),
                             @"pageSize":@(15)
    };
    [ASBaseRequest postWithUrl:API_VideoShowIndex params:params success:^(id _Nonnull response) {
        NSArray *listArray = [ASVideoShowDataModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(listArray);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestVideoShowAddPlayNumWithVideoID:(NSString *)videoID
                                  completeNum:(NSString *)completeNum
                                     stopLong:(NSInteger)stopLong
                                      success:(ResponseSuccess)successBack
                                    errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"id": STRING(videoID),
                             @"complete_num": STRING(completeNum),
                             @"stop_long": @(stopLong)};
    [ASBaseRequest postWithUrl:API_AddPlayNum params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestVideoShowCheckDayAcountSuccess:(ResponseSuccess)successBack
                                    errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_VideoShowCheck params:@{} success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestSetStateVideoShowWithVideoID:(NSString *)videoID
                                 showStatus:(NSString *)showStatus
                                    success:(ResponseSuccess)successBack
                                  errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"id": STRING(videoID),
                             @"show_status": STRING(showStatus)};
    [ASBaseRequest postWithUrl:API_VideoShowSetStatus params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestSetVideoShowCoverWithVideoID:(NSString *)videoID
                                    success:(ResponseSuccess)successBack
                                  errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"id": STRING(videoID)};
    [ASBaseRequest postWithUrl:API_VideoShowSetCover params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestDelVideoShowCoverWithVideoID:(NSString *)videoID
                                    success:(ResponseSuccess)successBack
                                  errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"id": STRING(videoID)};
    [ASBaseRequest postWithUrl:API_VideoShowDel params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestVideoShowSignSuccess:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_VideoShowSign params:@{} success:^(id  _Nonnull response) {
        NSString *signature = response[@"signature"];
        successBack(signature);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestPublishVideoShowWithImageUrl:(NSString *)imageUrl
                                 showStatus:(BOOL)showStatus
                                      title:(NSString *)title
                                   videoUrl:(NSString *)videoUrl
                                    success:(ResponseSuccess)successBack
                                  errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"cover_img_url":STRING(imageUrl),
                             @"show_status":@(showStatus),
                             @"title":STRING(title),
                             @"video_url":STRING(videoUrl),
    };
    [ASBaseRequest postWithUrl:API_VideoShowPublish params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestVideoShowListWithPage:(NSInteger)page
                             success:(ResponseSuccess)successBack
                           errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"user_id":STRING(USER_INFO.user_id),
                             @"page":@(page),
                             @"pageSize":@(15)
    };
    [ASBaseRequest postWithUrl:API_VideoShowList params:params success:^(id  _Nonnull response) {
        NSArray *lists = [ASVideoShowDataModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(lists);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestVideoShowAwardListSuccess:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_VideoShowGiftList params:@{} success:^(id  _Nonnull response) {
        ASGiftDataModel *model = [ASGiftDataModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestVideoShowSendGiftWithType:(NSInteger)type
                                  showID:(NSString *)showID
                                   toUID:(NSString *)toUID
                                  giftID:(NSString *)giftID
                              giftTypeID:(NSString *)giftTypeID
                                  liveID:(NSString *)liveID
                                 success:(ResponseSuccess)successBack
                               errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"type": @(type),
                             @"show_id": STRING(showID),
                             @"to_uid": STRING(toUID),
                             @"gift_id": STRING(giftID),
                             @"gift_type_id": STRING(giftTypeID),
                             @"live_id": STRING(liveID),
                             @"num": @(1),
    };
    [ASBaseRequest postWithUrl:API_SendGift params:params success:^(id  _Nonnull response) {
        NSString *coin = response[@"coin"];
        successBack(coin);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestVideoShowNotifyListWithPage:(NSInteger)page
                                   success:(ResponseSuccess)successBack
                                 errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"page": @(page)};
    [ASBaseRequest postWithUrl:API_VideoShowRecord params:params success:^(id  _Nonnull response) {
        NSArray *lists = [ASVideoShowNotifyModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        successBack(lists);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}

+ (void)requestVideoShowRemindSuccess:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    [ASBaseRequest postWithUrl:API_VideoShowRemind params:@{} success:^(id  _Nonnull response) {
        NSNumber *remind = response[@"remind"];
        successBack(remind);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}
@end
