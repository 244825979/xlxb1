//
//  ASNewUserGiftModel.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASNewUserGiftModel.h"

@implementation ASNewUserGiftListModel

@end

@implementation ASNewUserGiftModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : [ASNewUserGiftListModel class]};
}
@end
