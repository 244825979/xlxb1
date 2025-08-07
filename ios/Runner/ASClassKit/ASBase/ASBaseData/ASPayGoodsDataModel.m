//
//  ASPayGoodsDataModel.m
//  AS
//
//  Created by SA on 2025/5/20.
//

#import "ASPayGoodsDataModel.h"

@implementation ASGoodsListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end

@implementation ASPayGoodsDataModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : [ASGoodsListModel class]};
}
@end
