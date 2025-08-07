//
//  ASConsumptionModel.m
//  AS
//
//  Created by SA on 2025/5/22.
//

#import "ASConsumptionModel.h"

@implementation ASConsumptionListModel

@end

@implementation ASConsumptionModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"limit" : [ASConsumptionListModel class]};
}
@end
