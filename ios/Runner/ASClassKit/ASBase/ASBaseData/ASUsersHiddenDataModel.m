//
//  ASUsersHiddenDataModel.m
//  AS
//
//  Created by SA on 2025/4/10.
//

#import "ASUsersHiddenDataModel.h"

@implementation ASUserHiddenListModel

@end

@implementation ASUsersHiddenDataModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"hidden_me_user" : [ASUserHiddenListModel class],
             @"hidden_to_user" : [ASUserHiddenListModel class]
    };
}
@end

