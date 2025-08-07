//
//  ASIMHelperDataManager.m
//  AS
//
//  Created by SA on 2025/7/7.
//

#import "ASIMHelperDataManager.h"
#import "NSObject+YYModel.h"

@implementation ASIMHelperDataManager

+ (ASIMHelperDataManager *)shared {
    static dispatch_once_t onceToken;
    static ASIMHelperDataManager *instance = nil;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[ASIMHelperDataManager alloc] init];
        }
    });
    return instance;
}

- (void)setHelperList:(NSMutableArray *)helperList {
    _helperList = helperList;
    [ASUserDefaults setValue:helperList forKey:[NSString stringWithFormat:@"userinfo_helper_list_%@",STRING(USER_INFO.user_id)]];
}

- (void)setDashanList:(NSMutableArray *)dashanList {
    _dashanList = dashanList;
    [ASUserDefaults setValue:dashanList forKey:[NSString stringWithFormat:@"userinfo_dashan_list_%@",STRING(USER_INFO.user_id)]];
}

- (void)setDashanAmount:(NSInteger)dashanAmount {
    _dashanAmount = dashanAmount;
    [ASUserDefaults setValue:@(dashanAmount) forKey:[NSString stringWithFormat:@"userinfo_dashan_amount_%@",STRING(USER_INFO.user_id)]];
}
@end
