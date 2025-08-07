//
//  ASTextFieldAlertView.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASTextFieldAlertView : UIView
//确认
@property (nonatomic, copy) void (^affirmBlock)(NSString *text);
//取消
@property (nonatomic, copy) void (^cancelBlock)(void);

//构造方法 单行输入弹窗
- (instancetype)initTextFieldViewWithTitle:(NSString *)title
                                   content:(NSString *)content
                               placeholder:(NSString *)titleplaceholder
                                    length:(NSInteger)length
                                affirmText:(NSString *)affirmText
                                    remark:(NSString *)remark
                                  isNumber:(BOOL)isNumber//是否是纯数字
                                   isEmpty:(BOOL)isEmpty;//是否可以输入为空

@end

NS_ASSUME_NONNULL_END
