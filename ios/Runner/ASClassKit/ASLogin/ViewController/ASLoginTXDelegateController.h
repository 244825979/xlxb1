//
//  ASLoginTXDelegateController.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//TX的代理控制器载体
@interface ASLoginTXDelegateController : UIViewController
//是否点击协议
@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, assign) BOOL isPop;
//腾讯点击协议回调block
@property (nonatomic, copy) void (^txProtocolBlock)(BOOL isChecked);
@end

NS_ASSUME_NONNULL_END
