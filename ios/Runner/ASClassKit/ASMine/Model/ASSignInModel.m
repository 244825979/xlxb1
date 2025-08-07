//
//  ASSignInModel.m
//  AS
//
//  Created by SA on 2025/4/18.
//

#import "ASSignInModel.h"

@implementation ASSignInGiftModel

@end

@implementation ASSignInListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : [ASSignInGiftModel class]};
}
@end

@implementation ASSignInModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"today" : [ASSignInListModel class]};
}
@end
