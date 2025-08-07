//
//  ASAddUsefulLanModel.m
//  AS
//
//  Created by SA on 2025/5/16.
//

#import "ASAddUsefulLanModel.h"

@implementation ASAddUsefulLanModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

- (CGFloat)cellHeight {
    CGFloat textMaxLayoutWidth = SCREEN_WIDTH - SCALES(110);
    CGFloat height = [ASCommonFunc getSizeWithText:self.word maxLayoutWidth:textMaxLayoutWidth lineSpacing:SCALES(3) font:TEXT_FONT_15];
    return (height < SCALES(20) ? SCALES(20) : height) + SCALES(30);
}
@end
