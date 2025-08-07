//
//  ASSystemIndexDataModel.m
//  AS
//
//  Created by SA on 2025/4/10.
//

#import "ASSystemIndexDataModel.h"

@implementation ASGoodAnchorConfig

@end

@implementation ASSystemIndexDataModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"is_year_icon": @"new_year_icon"};
}
@end
