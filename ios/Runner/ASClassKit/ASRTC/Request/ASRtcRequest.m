//
//  ASRTCRequest.m
//  AS
//
//  Created by SA on 2025/5/19.
//

#import "ASRtcRequest.h"
#import "ASRtcAnchorPriceModel.h"
#import "ASCallRtcDataModel.h"

@implementation ASRtcRequest

+ (void)requestGetPriceWithUserID:(NSString *)userID
                          success:(ResponseSuccess)successBack
                        errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"anchor_id": STRING(userID),
                             @"is_new": @(1)
    };
    [ASBaseRequest postWithUrl:API_RTCAnchorPrice params:params success:^(id  _Nonnull response) {
        ASRtcAnchorPriceModel *model = [ASRtcAnchorPriceModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestCallNewWithType:(NSInteger )type
                      toUserID:(NSString *)toUserID
                         scene:(NSString *)scene
                       success:(ResponseSuccess)successBack
                     errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"type": @(type),
                             @"to_uid": STRING(toUserID),
                             @"scene": STRING(scene)
    };
    [ASBaseRequest postWithUrl:API_CallNew params:params success:^(id  _Nonnull response) {
        ASCallRtcDataModel *model = [ASCallRtcDataModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestAnswerCallWithRoomID:(NSString *)roomID
                            success:(ResponseSuccess)successBack
                          errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"room_id": STRING(roomID)};
    [ASBaseRequest postWithUrl:API_RoomCall params:params success:^(id  _Nonnull response) {
        ASCallRtcDataModel *model = [ASCallRtcDataModel mj_objectWithKeyValues:response];
        successBack(model);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}

+ (void)requestCheckCallMoneyWithUserID:(NSString *)userID
                                success:(ResponseSuccess)successBack
                              errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"to_uid": STRING(userID)};
    [ASBaseRequest postWithUrl:API_CheckCallMoney params:params success:^(id  _Nonnull response) {
        successBack(response);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:YES];
}
@end
