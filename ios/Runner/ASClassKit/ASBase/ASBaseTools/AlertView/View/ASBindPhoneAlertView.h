//
//  ASBindPhoneAlertView.h
//  AS
//
//  Created by SA on 2025/7/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASBindPhoneAlertView : UIView
@property (nonatomic, copy) VoidBlock affirmBlock;
@property (nonatomic, copy) VoidBlock closeBlock;

- (instancetype)initBindPhonePopWithContent:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
