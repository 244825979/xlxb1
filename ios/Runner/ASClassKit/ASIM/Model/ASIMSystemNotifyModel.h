//
//  ASIMSystemNotifyModel.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASIMSystemNotifyDataModel : NSObject
@property (nonatomic, copy) NSString *from_uid;
@property (nonatomic, copy) NSString *from_nickname;
@property (nonatomic, copy) NSString *to_uid;
@property (nonatomic, copy) NSString *to_nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *to_avatar;
@property (nonatomic, copy) NSString *score;//亲密值
@property (nonatomic, assign) NSInteger grade;//等级
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *current_score;
@property (nonatomic, copy) NSString *current_sign;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, assign) NSInteger is_next;
@property (nonatomic, copy) NSString *des_next_score;
@property (nonatomic, copy) NSString *next_sign;
@property (nonatomic, assign) NSInteger next_grade;
@property (nonatomic, copy) NSString *grade_img;
@property (nonatomic, copy) NSString *msg2;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger type;//类型
@property (nonatomic, copy) NSString *company;
@property (nonatomic, assign) NSInteger task_id;//任务id
@property (nonatomic, assign) NSInteger is_auth;//是否实名
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger link_type;
@property (nonatomic, copy) NSString *link_url;//用户ID
@property (nonatomic, copy) NSString *msg;//消息内容
@property (nonatomic, copy) NSString *uid;//用户id
@property (nonatomic, assign) NSInteger status;//女用户小助手状态通知： 用户更新女用户小助手的匹配状态
@property (nonatomic, copy) NSString *helperTitle;//标题
@property (nonatomic, copy) NSString *helperTips;
@property (nonatomic, copy) NSString *man_id;//上线对方用户id
@property (nonatomic, copy) NSString *nickname;//上线提示语
@property (nonatomic, copy) NSString *label;//用户信息
@property (nonatomic, assign) NSInteger scene;//充值弹窗提醒
@property (nonatomic, assign) NSInteger end_time;
@property (nonatomic, assign) NSInteger amount;//金币
@property (nonatomic, copy) NSString *giftimg;//礼物图片
@property (nonatomic, copy) NSString *giftname;//礼物名称
@property (nonatomic, assign) NSInteger gifttotal;
@property (nonatomic, copy) NSString *toavatar;
@property (nonatomic, copy) NSString *tonickname;
@property (nonatomic, assign) NSInteger tovip;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger count;//视频秀通知数量
@property (nonatomic, copy) NSString *user_id;//用户ID
@property (nonatomic, assign) BOOL is_hidden;//是否对我设置了隐身
@end

@interface ASIMSystemNotifyModel : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) ASIMSystemNotifyDataModel *data;
@property (nonatomic, copy) NSString *sessionId;//消息ID
@property (nonatomic, copy) NSString *fromAccount;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSTimeInterval time;
@end

NS_ASSUME_NONNULL_END
