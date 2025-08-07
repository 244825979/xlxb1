//
//  ASManNameListModel.m
//  AS
//
//  Created by SA on 2025/4/15.
//

#import "ASManNameListModel.h"

@implementation ASManNameModel

@end

@implementation ASManNameListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"nickname" : [ASManNameModel class],
             @"avatar" : [NSString class]};
}
@end
