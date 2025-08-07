//
//  ASPersonalRequest.h
//  AS
//
//  Created by SA on 2025/5/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASPersonalRequest : NSObject
//用户主页
+ (void)requestPersonalDataWithUserID:(NSString *)userID
                              success:(ResponseSuccess)successBack
                            errorBack:(ResponseFail)errorBack;
@end

NS_ASSUME_NONNULL_END
