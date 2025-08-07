//
//  ASDynamicCommentModel.m
//  AS
//
//  Created by SA on 2025/5/8.
//

#import "ASDynamicCommentModel.h"

@implementation ASDynamicCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

- (NSMutableAttributedString *)nameAgreement {
    if (!kStringIsEmpty(self.comment_nickname)) {
        kWeakSelf(self);
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.nickname];
        attributedText.font = TEXT_FONT_14;
        [attributedText setTextHighlightRange:NSMakeRange(0, attributedText.length) color:TEXT_SIMPLE_COLOR backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (wself.clikedBlock) {
                wself.clikedBlock(wself.user_id);
            }
        }];
        NSMutableAttributedString *attributedText1 = [[NSMutableAttributedString alloc] initWithString:@" 回复 "];
        attributedText1.color = MAIN_COLOR;
        attributedText1.font = TEXT_FONT_14;
        [attributedText appendAttributedString:attributedText1];
        NSMutableAttributedString *attributedText2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.comment_nickname]];
        attributedText2.font = TEXT_FONT_14;
        [attributedText2 setTextHighlightRange:NSMakeRange(0, attributedText2.length) color:TEXT_SIMPLE_COLOR backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (wself.clikedBlock) {
                wself.clikedBlock(wself.comment_user_id);
            }
        }];
        [attributedText appendAttributedString:attributedText2];
        return attributedText;
    } else {
        return nil;
    }
}

- (CGFloat)cellHeight {
    CGFloat textMaxLayoutWidth = floorf(SCREEN_WIDTH-SCALES(172));
    CGFloat contentH = [ASCommonFunc getSizeWithText:self.content maxLayoutWidth:textMaxLayoutWidth lineSpacing:SCALES(3.0) font:TEXT_FONT_14];
    return contentH + SCALES(16)+SCALES(14)+SCALES(12);
}
@end
