//
//  ASBindAccountModel.m
//  AS
//
//  Created by SA on 2025/6/27.
//

#import "ASBindAccountModel.h"

@implementation ASBindDataModel

@end

@implementation ASBindAccountModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"cardTypes" : [ASBindDataModel class]};
}

@end
