//
//  ASDynamicListModel.m
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASDynamicListModel.h"

@implementation ASDynamicUserModel

@end

@implementation ASDynamicVideoModel

@end

@implementation ASDynamicPictureModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end

@implementation ASDynamicListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"images" : [ASDynamicPictureModel class]};
}

- (ASDynamicMediaType)mediaType {
    if (!kStringIsEmpty(self.cover_url)) {
        return kDynamicMediaVideo;
    } else {
        if (self.images.count == 0 || kObjectIsEmpty(self.images)) {
            return kDynamicMediaDefault;
        } else if (self.images.count == 1) {
            return kDynamicMediaImageOne;
        } else if (self.images.count == 2) {
            return kDynamicMediaImageTwo;
        } else {
            return kDynamicMediaImageMore;
        }
    }
}

- (CGFloat)mediaHeight {
    if (self.mediaType == kDynamicMediaDefault) {
        return 0.0;
    } else if (self.mediaType == kDynamicMediaImageOne || self.mediaType == kDynamicMediaVideo) {
        return SCALES(234);
    } else if (self.mediaType == kDynamicMediaImageTwo) {
        return SCALES(138);
    } else if (self.mediaType == kDynamicMediaImageMore) {
        CGFloat itemWH = floor((SCREEN_WIDTH - SCALES(90) - SCALES(12))/3);
        if (self.images.count == 3) {
            return itemWH;
        }
        if (self.images.count > 3 && self.images.count < 7) {
            return itemWH * 2 + SCALES(6);
        }
        return itemWH * 3 + SCALES(12);
    } else {
        return 0.0;
    }
}

- (CGFloat)cellHeight {
    CGFloat reviewViewHeight = self.status == 0 ? SCALES(34) : SCALES(8.0);
    CGFloat userHeight = SCALES(66);
    CGFloat textMaxLayoutWidth = floorf(SCREEN_WIDTH -  SCALES(90));
    CGFloat contentH = [ASCommonFunc getSizeWithText:self.content maxLayoutWidth:textMaxLayoutWidth lineSpacing:SCALES(4.0) font:TEXT_FONT_14] + SCALES(12);
    CGFloat bottomHeight = SCALES(72);
    return reviewViewHeight + userHeight + contentH + self.mediaHeight + bottomHeight;
}

- (CGFloat)mediaPersonalHeight {
    if (self.mediaType == kDynamicMediaDefault) {
        return 0.0;
    } else if (self.mediaType == kDynamicMediaImageOne || self.mediaType == kDynamicMediaVideo) {
        return SCALES(234);
    } else if (self.mediaType == kDynamicMediaImageTwo) {
        return floor((SCREEN_WIDTH - SCALES(32) - SCALES(10))/2);;
    } else if (self.mediaType == kDynamicMediaImageMore) {
        CGFloat itemWH = floor((SCREEN_WIDTH - SCALES(32) - SCALES(16))/3);
        if (self.images.count == 3) {
            return itemWH;
        }
        if (self.images.count > 3 && self.images.count < 7) {
            return itemWH*2 + SCALES(8);
        }
        return itemWH*3 + SCALES(16);
    } else {
        return 0.0;
    }
}

- (CGFloat)cellPersonalHeight {
    CGFloat textMaxLayoutWidth = floorf(SCREEN_WIDTH -  SCALES(32));
    CGFloat contentH = [ASCommonFunc getSizeWithText:self.content maxLayoutWidth:textMaxLayoutWidth lineSpacing:SCALES(4.0) font:TEXT_FONT_15] + SCALES(12);
    CGFloat bottomHeight = SCALES(56);
    return SCALES(16) + contentH + self.mediaPersonalHeight + bottomHeight;
}
@end
