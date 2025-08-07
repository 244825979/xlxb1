//
//  ASIMManager.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

//系统通知类型，后端返回
typedef NS_ENUM(NSInteger, IMSystemNotifyType) {
    kIMTVUpdata = 16,                   //上电视更新
    kIMIntimacyValueChange = 17,        //亲密值变化
    kIMIntimacyValuePromote = 18,       //亲密值提升弹窗
    kIMAwardRedPacket = 19,             //任务奖励红包通知
    kIMRealNameStatus = 20,             //实名认证状态变化通知
    kIMRecommendationSystem = 22,       //后台管理系统推送通知
    kIMDynamicNotify = 23,              //动态通知
    kIMFemaleUserAide = 25,             //女用户小助手状态变更通知
    kIMPopUpFriendReminder = 26,        //前端接收密友和关注好友的上线提醒
    kIMClearCache = 27,                 //清除缓存
    kIMConsumptionReminder = 29,        //消费提醒
    kIMToSetMeHiding = 30,              //设置为隐身/解除隐身+
    kIMGiftPiaoPing = 90,               //礼物飘屏
    kIMVideoShowNotifiction = 91,       //视频秀通知
    kIMNotBalancePop = 92,              //无余额触发充值弹窗
    kIMLittleHelperSendMsg = 1001,      //女用户小助手给男用户插入一条小助手提醒消息
};

@interface ASIMManager : NSObject
+ (ASIMManager *)shared;
//云信登录授权
- (void)NELoginWithAccount:(NSString *)account
                     token:(NSString *)token
                   succeed:(VoidBlock)succeed
                      fail:(VoidBlock)fail;
//发送一条系统消息type = 1001
- (void)sendLittleHelperWithMessage:(NIMMessage *)message;
//判断搭讪列表是否有未读消息，男用户
- (BOOL)dashanIsUnread;
//会话列表未读消息
- (void)updateUnreadCount;
//密友是否有未读消息
- (BOOL)miyouIsUnread;
//会话列表未读消息总数
- (NSInteger)conversationCount;
//系统通知新消息
- (BOOL)xitongIsUnread;
//活动小助手新消息
- (BOOL)huodongIsUnread;
@end

NS_ASSUME_NONNULL_END
