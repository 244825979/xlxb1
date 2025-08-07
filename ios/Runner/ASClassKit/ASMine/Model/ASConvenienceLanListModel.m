//
//  ASConvenienceLanListModel.m
//  AS
//
//  Created by SA on 2025/5/21.
//

#import "ASConvenienceLanListModel.h"

@implementation ASConvenienceLanListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

- (CGFloat)cellHeight {
    CGFloat height = SCALES(52) + SCALES(24) + SCALES(16);
    if (!kStringIsEmpty(self.file)) {
        height += SCALES(72) + SCALES(8);
    }
    if (!kStringIsEmpty(self.voice_file)) {
        height += SCALES(28) + SCALES(8);
    }
    if (!kStringIsEmpty(self.title)) {
        //获取文本内容宽度，计算展示全部文本所需高度
        CGFloat textMaxLayoutWidth = SCREEN_WIDTH - SCALES(64);
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        [style setLineSpacing: SCALES(4.0)];//行间距
        CGRect contentRect = [self.title
                              boundingRectWithSize:CGSizeMake(textMaxLayoutWidth, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                              attributes:@{NSFontAttributeName: TEXT_FONT_14, NSParagraphStyleAttributeName: style}
                              context:nil];
        height += contentRect.size.height < 18 ? (SCALES(24) + SCALES(8)) : (contentRect.size.height + SCALES(8));
    }
    return height;
}
@end
