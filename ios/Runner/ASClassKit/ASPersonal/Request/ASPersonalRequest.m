//
//  ASPersonalRequest.m
//  AS
//
//  Created by SA on 2025/5/6.
//

#import "ASPersonalRequest.h"

@implementation ASPersonalRequest

+ (void)requestPersonalDataWithUserID:(NSString *)userID
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack {
    NSDictionary *params = @{@"user_id":STRING(userID)};
    [ASBaseRequest postWithUrl:API_UserIndex params:params success:^(id  _Nonnull response) {
        ASUserInfoModel *userInfo = [ASUserInfoModel mj_objectWithKeyValues:response];
        successBack(userInfo);
    } fail:^(NSInteger code, NSString *msg) {
        errorBack(code, msg);
    } showHUD:NO];
}
@end
