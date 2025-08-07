//
//  ASBaseResultModel.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASBaseResultModel.h"

@implementation ASBaseResultModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (oldValue == [NSNull null]) {
        if ([oldValue isKindOfClass:[NSArray class]]) {
            return @[];
        } else if ([oldValue isKindOfClass:[NSDictionary class]]) {
            return @{};
        } else {
            return @{};
        }
    }
    return oldValue;
}
@end
