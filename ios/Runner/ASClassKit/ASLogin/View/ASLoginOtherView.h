//
//  ASLoginOtherView.h
//  AS
//
//  Created by SA on 2025/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, OtherLoginViewType){
    kWeChatType = 0,                 //微信
    kPhoneType = 1,                  //手机号码登录
};

@interface ASLoginOtherView : UIView
@property (nonatomic, assign) OtherLoginViewType type;
@property (nonatomic, copy) IndexNameBlock actionBlock;
@end

NS_ASSUME_NONNULL_END
