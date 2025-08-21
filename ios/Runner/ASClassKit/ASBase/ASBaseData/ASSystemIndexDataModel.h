//
//  ASSystemIndexDataModel.h
//  AS
//
//  Created by SA on 2025/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASGoodAnchorConfig : NSObject
@property (nonatomic, assign) NSInteger afterFirstLoginTime;//首次登录5s后弹出
@property (nonatomic, assign) NSInteger onlineEveryTimes;//在线s后弹出
@property (nonatomic, assign) NSInteger isValid;//0关闭 1开启
@end

@interface ASSystemIndexDataModel : NSObject
@property (nonatomic, copy) NSString *customerOnline;//客服时间
@property (nonatomic, copy) NSString *clear_message_time;//清除IM消息清除间隔时长
@property (nonatomic, assign) NSInteger mtype;//环境 0正常，1A面
@property (nonatomic, assign) NSInteger is_first_pay;//是否开启首冲
@property (nonatomic, assign) NSInteger is_video_show;//是否有视频推送
@property (nonatomic, assign) NSInteger is_yd_check;//是否开启易盾
@property (nonatomic, assign) NSInteger is_year_icon;//是否新春Icon
@property (nonatomic, strong) ASGoodAnchorConfig *goodAnchorConfig;//优质用户
@property (nonatomic, copy) NSString *faceAuth;//实名认证
@property (nonatomic, copy) NSString *verifyAuth;//真人认证
@property (nonatomic, copy) NSString *matchAuth;//人脸对比
@property (nonatomic, assign) NSInteger recommendMsgBeautifyOpen;//是否开启显示IM列表消息前缀
@property (nonatomic, assign) NSInteger is_fate_helper_show;//是否开启小助手
@property (nonatomic, copy) NSString *touristUserId;//游客user_id
@property (nonatomic, copy) NSString *touristToken;//游客token
@property (nonatomic, assign) NSInteger foldVol;//限制男用户搭讪的最大数值
//启动APP优先使用哪些登录方式。1一键登录方式 2微信登录方式
@property (nonatomic, assign) NSInteger login_select_first;
//一键登录方式失败的处理策略。1失败跳转到手动输入手机号登录方式 2微信登录方式
@property (nonatomic, assign) NSInteger login_jump_page_status;
//手机号登录页面入口是否开启。1开启 0关闭（如微信登录页拉起一键登录按钮失败，入口未开启直接提示失败（提示:登录失败，请优先使用微信登录方式 ），如开启，直接跳转手机号码登录页。）
@property (nonatomic, assign) NSInteger mobile_login_status;
//手机号登录页面，验证码发送次数（sms_fail_wechat_retry_time）及验证码发送时间（sms_fail_wechat_retry_time）限制后，用户未输入验证码，提醒微信登录弹窗。 1开启 0关闭
@property (nonatomic, assign) NSInteger sms_fail_wechat_tips;
@property (nonatomic, assign) NSInteger sms_fail_wechat_retry_time;//微信验证码触发的条件：次数
@property (nonatomic, assign) NSInteger sms_fail_wechat_alert_seconds;//微信验证码触发的条件：秒
//手机号登录页的语音验证码功能是否开启 1=开启 0=关闭 开启状态触发条件验证码发送次数：sms_fail_voice_retry_time。验证码未输入倒计时：sms_fail_voice_alert_seconds
@property (nonatomic, assign) NSInteger sms_fail_voice_tips;
//绑定手机号页（如微信注册未绑定手机号引导进入的绑定手机号页）语音验证码功能是否开启 1=开启 0=关闭
@property (nonatomic, assign) NSInteger sms_fail_voice_tips_bind;
@property (nonatomic, assign) NSInteger sms_fail_voice_retry_time;//语音验证码触发的条件：次数
@property (nonatomic, assign) NSInteger sms_fail_voice_alert_seconds;//语音验证码触发的条件：秒
@property (nonatomic, assign) NSInteger you_like_switch_home;//猜你喜欢，首页
@property (nonatomic, assign) NSInteger you_like_switch_dynamic;//猜你喜欢，动态
@property (nonatomic, assign) NSInteger last_fate_helper_show_time;//小助手匹配列表过期时间，单位分钟
@property (nonatomic, copy) NSString *last_fate_helper_show_message;//小助手匹配列表过期消息内容
@property (nonatomic, assign) NSInteger day_number_logout;//注销时间
@end

NS_ASSUME_NONNULL_END
