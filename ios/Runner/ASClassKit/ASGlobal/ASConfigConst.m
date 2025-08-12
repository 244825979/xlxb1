//
//  ASConfigConst.m
//  AS
//
//  Created by SA on 2025/4/9.
//

#import "ASConfigConst.h"

@implementation ASConfigConst

+ (ASConfigConst *)shared {
    static dispatch_once_t onceToken;
    static ASConfigConst *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

- (void)setServerType:(kServerType)serverType {
    _serverType = serverType;
//    self.bundleID = [[NSBundle mainBundle] bundleIdentifier];
//    self.bundleID = @"com.yuansheng.shouai";
    self.bundleID = @"com.aoyou.xinbo";
    //com.aoyou.xinbo //心聊想伴
    //守爱 :com.yuansheng.shouai
    // Ta爱 @"com.aoyou.zhuil"
#ifdef DEBUG
    self.NEIM_apns = NEIM_APNS_DEV;
    switch (serverType) {
        case kServerTest:
        {
            self.server_url =  @"http://testoeglngldnzfgs.ixyys.cn/";
            self.server_image_url = @"http://testasset.iyuanshen.cn/";
            self.server_h5_url = @"http://testh5.ixyys.cn/";
            self.server_im_env = @"test";
            self.server_name = @"测试环境";
        }
            break;
        case kServerPre:
        {
            self.server_url =  @"https://preapi.ixyys.cn/";
            self.server_image_url = @"https://asset.ixyys.cn/";
            self.server_h5_url = @"https://h5.ixyys.cn/";
            self.server_im_env = @"beta";
            self.server_name = @"预发环境";
        }
            break;
        case kServerPublish:
        {
            self.server_url =  @"https://api.tjaoyou.cn/";
            self.server_image_url = @"https://asset.tjaoyou.cn/";
            self.server_h5_url = @"https://h5.tjaoyou.cn/";
            self.server_im_env = @"";
            self.server_name = @"线上环境";
        }
            break;
        default:
            break;
    }
#else
    self.server_url =  @"https://api.tjaoyou.cn/";
    self.server_image_url = @"https://asset.tjaoyou.cn/";
    self.server_h5_url = @"https://h5.tjaoyou.cn/";
    self.server_im_env = @"";
    self.NEIM_apns = NEIM_APNS_Rel;
#endif
}
@end
