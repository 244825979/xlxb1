//
//  ASSendVipModel.m
//  AS
//
//  Created by SA on 2025/5/20.
//

#import "ASSendVipModel.h"

@implementation ASSendVipPrivilegeList

@end

@implementation ASSendVipGoodListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end

@implementation ASSendVipModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"privilegeList" : [ASSendVipPrivilegeList class],
             @"goodList" : [ASSendVipGoodListModel class]
    };
}
@end
