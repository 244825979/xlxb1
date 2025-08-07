//
//  ASFirstPayDataModel.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASFirstPayDataModel.h"

@implementation ASFirstGiftModel

@end

@implementation ASFirstPayListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"reward_gift" : [ASFirstGiftModel class]};
}
@end

@implementation ASFirstPayDataModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : [ASFirstPayListModel class]};
}
@end
