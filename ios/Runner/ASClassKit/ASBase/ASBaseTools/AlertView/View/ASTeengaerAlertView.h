//
//  ASTeengaerOpenAlertView.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASTeengaerAlertView : UIView
@property (nonatomic, copy) VoidBlock closeBlock;
@property (nonatomic, copy) VoidBlock forgetPwdBlock;
//构造方法 关闭未成年弹窗
- (instancetype)initWithCloseTeengaer;
//构造方法 开启未成年弹窗提醒
- (instancetype)initWithOpenTeengaer;
@end

NS_ASSUME_NONNULL_END
