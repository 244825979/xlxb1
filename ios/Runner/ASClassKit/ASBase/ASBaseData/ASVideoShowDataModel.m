//
//  ASVideoShowDataModel.m
//  AS
//
//  Created by SA on 2025/4/10.
//

#import "ASVideoShowDataModel.h"

@implementation ASVideoShowDataModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

- (CGFloat)titleHeight {
    if (kStringIsEmpty(self.title)) {
        return 0.0;
    }
    CGFloat textMaxLayoutWidth = floorf(SCREEN_WIDTH -  SCALES(32));
    CGFloat titleHeight = [ASCommonFunc getSizeWithText:self.title maxLayoutWidth:textMaxLayoutWidth lineSpacing:SCALES(4.0) font:TEXT_FONT_15];
    return titleHeight;
}
@end
