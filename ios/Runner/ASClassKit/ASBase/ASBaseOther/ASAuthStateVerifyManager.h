//
//  ASAuthStateVerifyManager.h
//  AS
//
//  Created by SA on 2025/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AuthStateType){
    kRpAuthDefaultPop = 0,        //未真人认证或审核中 默认提示双重认证
    kRpAuthDefaultNotIDCard = 1,  //未真人认证或审核中 默认提示，不需要校验实名认证
    kRpAuthDaShanPop = 2,         //未真人认证或审核中 搭讪私聊弹窗
    kRpAuthPopMakeFriends = 3,    //未真人认证或审核中 交友提示
    kRpAuthPopBindAccount = 5,    //未真人认证或审核中 点击绑定账号
    kRpAuthPopEarnings = 4,       //未真人认证或审核中 点击我的收益提示，不需要校验实名认证
    kRpAuthPopVideoShow = 6,      //未真人认证或审核中 点击上传视频秀，不需要校验实名认证
    kRpAuthPopIDCard = 7,         //未真人认证或审核中 认证中心进行实名认证提示，不需要校验实名认证
};

@interface ASAuthStateVerifyManager : NSObject
+ (ASAuthStateVerifyManager *)shared;
- (void)isCertificationState:(AuthStateType)type succeed:(VoidBlock)succeed;
@end

NS_ASSUME_NONNULL_END
