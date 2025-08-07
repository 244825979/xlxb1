//
//  ASGreetTpListModel.m
//  AS
//
//  Created by SA on 2025/7/4.
//

#import "ASGreetTpListModel.h"

@implementation ASGreetTpBodyModel

@end

@implementation ASGreetTpListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"body" : [ASGreetTpBodyModel class]};
}
@end
