//
//  ASGiftDataModel.m
//  AS
//
//  Created by SA on 2025/4/10.
//

#import "ASGiftDataModel.h"

@implementation ASGiftListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end

@implementation ASGiftDataModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"gift_list" : [ASGiftListModel class],
             @"list" : [ASGiftListModel class]};
}
@end
