//
//  ASVipDetailsModel.m
//  AS
//
//  Created by SA on 2025/6/27.
//

#import "ASVipDetailsModel.h"

@implementation ASVipUserInfoModel

@end

@implementation ASVipGoodsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end

@implementation ASVipPrivilegesModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end

@implementation ASVipDetailsModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : [ASVipGoodsModel class],
             @"privilege" : [ASVipPrivilegesModel class]
    };
}
@end
