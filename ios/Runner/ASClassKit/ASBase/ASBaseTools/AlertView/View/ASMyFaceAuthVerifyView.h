//
//  ASMyFaceAuthVerifyView.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASMyFaceAuthVerifyView : UIView
@property (nonatomic, copy) void (^cancelBlock)(void);//取消
@end

NS_ASSUME_NONNULL_END
