//
//  ASRecommendUserModel.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASRecommendUserModel.h"

@implementation ASRecommendUserModel

@end

@implementation ASRecommendUserListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : [ASRecommendUserModel class]};
}
@end
