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
    self.bundleID = [[NSBundle mainBundle] bundleIdentifier];
    self.server_url = @"https://api.xlxban.cn/api/";
    self.server_image_url = @"https://asset.xlxban.cn/";
    self.server_h5_url = @"https://xlxbh5.xlxban.cn/";
    self.server_im_env = @"";
    self.NEIM_apns = NEIM_APNS_Rel;
}
@end
