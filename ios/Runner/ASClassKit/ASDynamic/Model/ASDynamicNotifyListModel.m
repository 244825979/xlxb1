//
//  ASDynamicNotifyListModel.m
//  AS
//
//  Created by SA on 2025/5/16.
//

#import "ASDynamicNotifyListModel.h"

@implementation ASDynamicNotifyListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

- (NSMutableAttributedString *)textAgreement {
    if (self.is_delete == 1) {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"评论已被删除"];
        attributedText.font = TEXT_FONT_14;
        attributedText.color = TEXT_SIMPLE_COLOR;
        return attributedText;
    } else {
        if (self.is_type == 1) {
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",self.from_user_nickname]];
            attributedText.font = TEXT_FONT_14;
            attributedText.color = TITLE_COLOR;
            NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:self.content];
            text1.font = TEXT_FONT_14;
            text1.color = TEXT_SIMPLE_COLOR;
            [attributedText appendAttributedString:text1];
            return attributedText;
        } else if (self.is_type == 2) {
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",self.from_user_nickname]];
            attributedText.font = TEXT_FONT_14;
            attributedText.color = TITLE_COLOR;
            NSMutableAttributedString *clickText1 = [[NSMutableAttributedString alloc] initWithString:@"回复了你："];
            clickText1.font = TEXT_FONT_14;
            clickText1.color = MAIN_COLOR;
            [attributedText appendAttributedString:clickText1];
            NSMutableAttributedString *clickText2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.content]];
            clickText2.font = TEXT_FONT_14;
            clickText2.color = TITLE_COLOR;
            [attributedText appendAttributedString:clickText2];
            attributedText.lineSpacing = SCALES(2.0);
            return attributedText;
        } else if (self.is_type == 3) {
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",self.from_user_nickname]];
            attributedText.font = TEXT_FONT_14;
            attributedText.color = TITLE_COLOR;
            NSMutableAttributedString *clickText1 = [[NSMutableAttributedString alloc] initWithString:@"评论了你："];
            clickText1.font = TEXT_FONT_14;
            clickText1.color = MAIN_COLOR;
            [attributedText appendAttributedString:clickText1];
            NSMutableAttributedString* clickText2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.content]];
            clickText2.font = TEXT_FONT_14;
            clickText2.color = TITLE_COLOR;
            [attributedText appendAttributedString:clickText2];
            attributedText.lineSpacing = SCALES(3.0);
            return attributedText;
        } else {
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.content];
            attributedText.font = TEXT_FONT_14;
            attributedText.color = TEXT_SIMPLE_COLOR;
            attributedText.lineSpacing = SCALES(2.0);
            return attributedText;
        }
    }
}

- (CGFloat)cellHeight {
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(floorf(SCREEN_WIDTH - SCALES(78)), CGFLOAT_MAX) text: self.textAgreement];
    CGFloat textHeighet = layout.textBoundingSize.height < SCALES(16) ? SCALES(16) : layout.textBoundingSize.height;
    return textHeighet + SCALES(20) + SCALES(8) + SCALES(16);
}
@end
