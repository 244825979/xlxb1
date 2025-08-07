//
//  UITextField+Extension.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

- (NSRange)selectedRange {
    UITextPosition* beginning = self.beginningOfDocument;
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void)setSelectedRange:(NSRange)range {
    UITextPosition* beginning = self.beginningOfDocument;
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

- (void)insertWhitSpaceInsertPosition:(NSArray *)insertPosition replacementString:(NSString *)string textlength:(NSInteger)length {
    [self insertWhitSpaceInsertPosition:insertPosition replacementString:string textlength:length character:@" "];
}

/**
 *  设置空格插入的位置
 *
 *  @param insertPosition insertPosition description
 */
- (void)insertWhitSpaceInsertPosition:(NSArray *)insertPosition replacementString:(NSString *)string textlength:(NSInteger)length character:(NSString *)character {
    if ([string isEqualToString:@""]) {
        [self deleteBackward];
    }
    if (self.text.length > length) {
        return;
    }
    if (![string isEqualToString:@""]) {
        [self insertText:string];
    }
    
    // 判断光标位置
    NSRange range = [self selectedRange];
    NSUInteger targetCursorPosition = range.location;
    // 移除空格
    NSString *removeNonDigits = [self removeWhitespaceCharacter:self.text andPreserveCursorPosition:&targetCursorPosition character:character];
    // 插入空格
    NSString *phoneNumberWithSpaces = [self insertWhitespaceCharacter:removeNonDigits andPreserveCursorPosition:&targetCursorPosition insertPosition:insertPosition character:(NSString *)character];
    // 重新赋值
    self.text = phoneNumberWithSpaces;
    // 设置光标位置
    NSRange sRange = NSMakeRange(targetCursorPosition, range.length);
    [self setSelectedRange:sRange];
}

/**
 *  插入空格
 *
 *  @param string         string description
 *  @param insertPosition 分隔位置，数组全部传递数字

 */
- (NSString *)insertWhitespaceCharacter:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition insertPosition:(NSArray *)insertPosition character:(NSString *)character {
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    for (NSUInteger i = 0; i < string.length; i++) {
        [insertPosition enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (i == [obj integerValue]) {
                //                [stringWithAddedSpaces appendString:@" "];
                [stringWithAddedSpaces appendString:character];
                if(i<cursorPositionInSpacelessString) {
                    (*cursorPosition)++;
                }
            }
        }];
        
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    return stringWithAddedSpaces;
}

/**
 *  移除空格
 */
- (NSString *)removeWhitespaceCharacter:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition character:(NSString *)character {
    NSUInteger originalCursorPosition =*cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i = 0; i < string.length; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        //        if(![[NSCharacterSet whitespaceCharacterSet] characterIsMember:characterToAdd]) {
        if(![[NSCharacterSet characterSetWithCharactersInString:character] characterIsMember:characterToAdd]) {
            NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if(i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    return digitsOnlyString;
}
@end
