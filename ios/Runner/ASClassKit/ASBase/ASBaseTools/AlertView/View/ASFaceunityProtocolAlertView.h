//
//  ASFaceunityProtocolAlertView.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASFaceunityProtocolAlertView : UIView
//确认
@property (nonatomic, copy) void (^affirmBlock)(void);
//构造方法
- (instancetype)initFaceunityProtocolPopView;
@end

NS_ASSUME_NONNULL_END
