//
//  ASUserInfoModel.m
//  AS
//
//  Created by SA on 2025/4/10.
//

#import "ASUserInfoModel.h"

@implementation ASBasicInfoDetailModel
@end

@implementation ASBasicInfoModel
@end

@implementation ASAlbumsModel
// 转换返回参数冲突关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end

@implementation ASDynamicDataModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end

@implementation ASSubTaskModel
@end

@implementation ASTaskModel
@end

@implementation ASOnlineModel
@end

@implementation ASVoiceModel
@end

@implementation ASTagsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end

@implementation ASUserInfoModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"albums_list" : [ASAlbumsModel class],
             @"albums" : [ASAlbumsModel class],
             @"dynamic" : [ASDynamicDataModel class],
             @"basic_info" : [ASBasicInfoModel class],
             @"label" : [ASTagsModel class],
             @"gifts": [ASGiftListModel class],
             @"video_show" : [ASVideoShowDataModel class]
    };
}

- (CGFloat)personalCardViewHeight {
    NSInteger corlmax = 2;
    CGFloat viewH = SCALES(30);
    NSInteger row = (self.basic_info.count-2)/corlmax;
    CGFloat y = viewH * row;
    return y + viewH - SCALES(10);
}

- (CGFloat)signTextHeight {
    CGFloat height = [ASCommonFunc getSizeWithText:self.sign maxLayoutWidth:SCREEN_WIDTH - SCALES(56) lineSpacing:SCALES(3.0) font:TEXT_FONT_14];
    height = height > SCALES(34) ? height : SCALES(34);
    return height + SCALES(24);
}
@end
