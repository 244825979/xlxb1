//
//  ASDataSelectModel.m
//  AS
//
//  Created by SA on 2025/4/15.
//

#import "ASDataSelectModel.h"

@implementation ASCollectFeeSelectModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end

//职业
@implementation ASOccupationListModel

@end

//省市
@implementation ASProvinceCitysListModel
// 转换返回参数冲突关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"child" : [ASProvinceCitysListModel class]};
}
@end

@implementation ASDataSelectModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"occupation" : [ASOccupationListModel class]};
}
@end
