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
    self.bundleID = @"com.aoyou.xinbo";
#ifdef DEBUG
    switch (serverType) {
        case kServerTest:
        {
            self.server_url = @"http://testoeglngldnzfgs.ixyys.cn/api/";
            self.server_image_url = @"http://testasset.iyuanshen.cn/";
            self.server_h5_url = @"http://testh5.ixyys.cn/";
            self.server_im_env = @"test";
            self.server_name = @"测试环境";
        }
            break;
        case kServerPre:
        {
            self.server_url = @"https://preapi.ixyys.cn/api/";
            self.server_image_url = @"https://asset.ixyys.cn/";
            self.server_h5_url = @"https://h5.ixyys.cn/";
            self.server_im_env = @"beta";
            self.server_name = @"预发环境";
        }
            break;
        case kServerPublish:
        {
            self.server_url = @"https://api.xlxban.cn/api/";
            self.server_image_url = @"https://asset.xlxban.cn/";
            self.server_h5_url = @"https://xlxbh5.xlxban.cn/";
            self.server_im_env = @"";
            self.server_name = @"线上环境";
        }
            break;
        default:
            break;
    }
#else
    self.NEIM_apns = NEIM_APNS_Rel;
    self.server_url = @"https://api.xlxban.cn/api/";
    self.server_image_url = @"https://asset.xlxban.cn/";
    self.server_h5_url = @"https://xlxbh5.xlxban.cn/";
    self.server_im_env = @"";
    self.server_name = @"线上环境";
#endif

}
@end
