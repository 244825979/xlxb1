//
//  ASReportListModel.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASReportListModel.h"

@implementation ASReportDetailsMoreModel

- (CGFloat)textHeight {
    CGFloat textMaxLayoutWidth = SCREEN_WIDTH - SCALES(102);
    CGFloat contentW = textMaxLayoutWidth;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing: SCALES(4.0)];
    CGRect contentRect = [self.content
                          boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                          attributes:@{NSFontAttributeName: TEXT_FONT_14, NSParagraphStyleAttributeName: style}
                          context:nil];
    return ceilf(contentRect.size.height);
}

- (CGFloat)reasonHeight {
    CGFloat textMaxLayoutWidth = SCREEN_WIDTH - SCALES(102);
    CGFloat contentW = textMaxLayoutWidth;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing: SCALES(4.0)];
    CGRect contentRect = [self.reason
                          boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                          attributes:@{NSFontAttributeName: TEXT_FONT_14, NSParagraphStyleAttributeName: style}
                          context:nil];
    return ceilf(contentRect.size.height);
}

- (CGFloat)collectionHeight {
    CGFloat cellWH = ceilf((SCREEN_WIDTH - SCALES(48))/ 3);
    NSInteger cols = self.images.count % 3;
    NSInteger row = (cols == 0 ? (self.images.count / 3) : (self.images.count / 3 + 1));
    CGFloat gradeListViewHeight = (row * cellWH) + (row * SCALES(8));
    return ceilf(gradeListViewHeight);
}
@end

@implementation ASReportListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"more" : [ASReportDetailsMoreModel class]};
}

- (CGFloat)textHeight {
    CGFloat textMaxLayoutWidth = SCREEN_WIDTH - SCALES(102);
    CGFloat contentW = textMaxLayoutWidth;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing: SCALES(4.0)];
    CGRect contentRect = [self.content
                          boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                          attributes:@{NSFontAttributeName: TEXT_FONT_14, NSParagraphStyleAttributeName: style}
                          context:nil];
    return ceilf(contentRect.size.height);
}

- (CGFloat)reasonHeight {
    CGFloat textMaxLayoutWidth = SCREEN_WIDTH - SCALES(102);
    CGFloat contentW = textMaxLayoutWidth;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing: SCALES(4.0)];
    CGRect contentRect = [self.reason
                          boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                          attributes:@{NSFontAttributeName: TEXT_FONT_14, NSParagraphStyleAttributeName: style}
                          context:nil];
    return ceilf(contentRect.size.height);
}

- (CGFloat)collectionHeight {
    CGFloat cellWH = ceilf((SCREEN_WIDTH - SCALES(48))/ 3);
    NSInteger cols = self.images.count % 3;
    NSInteger row = (cols == 0 ? (self.images.count / 3) : (self.images.count / 3 + 1));
    CGFloat gradeListViewHeight = (row * cellWH) + (row * SCALES(8));
    return ceilf(gradeListViewHeight);
}

- (CGFloat)replenishCollectionHeight {
    CGFloat cellWH = ceilf((SCREEN_WIDTH - SCALES(48))/ 3);
    NSInteger cols = self.selectedPhotosCount % 3;
    NSInteger row = (cols == 0 ? (self.selectedPhotosCount / 3) : (self.selectedPhotosCount / 3 + 1));
    CGFloat gradeListViewHeight = (row * cellWH) + (row * SCALES(8));
    return ceilf(gradeListViewHeight);
}

@end
