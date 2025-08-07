//
//  ASIMChatCardModel.m
//  AS
//
//  Created by SA on 2025/5/15.
//

#import "ASIMChatCardModel.h"

@implementation ASIMCardAuthModel

@end

@implementation ASIMAlbumListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end

@implementation ASIMChatCardModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"albumList" : [ASIMAlbumListModel class]};
}

- (CGFloat)viewHeight {
    CGFloat height = 32.0 + 28.0 + 28.0 + 8;
    if (self.chat_label_new.count >0) {
        height += 28.0;
    }
    if (self.albumList.count > 0) {
        height += 54.0;
    }
    CGFloat contentW = SCREEN_WIDTH - 62 - 26;
    CGRect contentRect = [self.subjectTask
                          boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                          attributes:@{NSFontAttributeName: TEXT_FONT_14}
                          context:nil];
    height += (contentRect.size.height <= 20 ? 20 : contentRect.size.height);
    return height;
}
@end
