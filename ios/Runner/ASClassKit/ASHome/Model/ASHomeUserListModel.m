//
//  ASHomeUserListModel.m
//  AS
//
//  Created by SA on 2025/4/16.
//

#import "ASHomeUserListModel.h"

@implementation ASHomeUserListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

- (void)setHeight:(NSString *)height {
    _height = height;
    if ([height isEqualToString:@"0cm"] || kStringIsEmpty(height)) {
        self.isHeight = NO;
    } else {
        self.isHeight = YES;
    }
}

- (void)setWeight:(NSString *)weight {
    _weight = weight;
    if ([weight isEqualToString:@"0kg"] || kStringIsEmpty(weight)) {
        self.isWeight = NO;
    } else {
        self.isWeight = YES;
    }
}

@end

@implementation ASHomeUserModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [ASHomeUserListModel class]};
}
@end
