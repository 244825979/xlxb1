//
//  ASConfigConst.h
//  AS
//
//  Created by SA on 2025/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, kServerType) {
    kServerTest = 0,        //测试
    kServerPre = 1,         //预发
    kServerPublish = 2,     //发布
};

@interface ASConfigConst : NSObject
+ (ASConfigConst *)shared;

@property (nonatomic, copy) NSString *server_name;//当前环境昵称
@property (nonatomic, copy) NSString *server_url;//服务器地址
@property (nonatomic, copy) NSString *server_image_url;
@property (nonatomic, copy) NSString *server_h5_url ;
@property (nonatomic, copy) NSString *server_im_env;
@property (nonatomic, copy) NSString *NEIM_apns;//网易推送字符串
@property (nonatomic, copy) NSString *bundleID;
@property (nonatomic, assign) kServerType serverType;//当前环境
@end

NS_ASSUME_NONNULL_END
