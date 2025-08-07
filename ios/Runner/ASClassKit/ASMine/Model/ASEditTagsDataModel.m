//
//  ASEditTagsDataModel.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASEditTagsDataModel.h"

@implementation ASEditTagsDataModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"tag_list" : [ASTagsModel class],
             @"user_tag" : [ASTagsModel class]
    };
}
@end
