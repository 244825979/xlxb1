//
//  ASWebJsBodyModel.m
//  AS
//
//  Created by SA on 2025/7/25.
//

#import "ASWebJsBodyModel.h"

@implementation ASWebPosterListModel

@end

@implementation ASShareDataModel

@end

@implementation ASWebJsBodyModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"posterList" : [ASWebPosterListModel class]};
}

@end
