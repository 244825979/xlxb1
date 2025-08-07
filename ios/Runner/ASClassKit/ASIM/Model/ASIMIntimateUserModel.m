//
//  ASIMIntimateUserModel.m
//  AS
//
//  Created by SA on 2025/5/15.
//

#import "ASIMIntimateUserModel.h"

@implementation ASIntimateUserListModel
- (CGFloat)cellHeight {
    CGFloat textHeight = [ASCommonFunc getSizeWithText:self.des
                                        maxLayoutWidth:SCALES(194)
                                           lineSpacing:SCALES(3)
                                                  font:TEXT_FONT_12];
    if (textHeight > 20) {
        return SCALES(84);
    }
    return SCALES(68);
}
@end

@implementation ASIntimateUserHeadModel
@end

@implementation ASIMIntimateUserModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : [ASIntimateUserListModel class]};
}
@end
