//
//  ASTextAttributedManager.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASTextAttributedManager : NSObject

//登录首页：我已阅读并同意《用户服务协议》和《隐私协议》
+ (NSMutableAttributedString *)loginHomeAgreement:(void(^)(void))selectAction
                                  serviceProtocol:(void(^)(void))serviceAction
                                  privacyProtocol:(void(^)(void))privacyAction;
//登录弹出协议弹窗富文本
+ (NSMutableAttributedString *)userProtocolPopAgreement:(void(^)(void))userAction
                                        privacyProtocol:(void(^)(void))privacyAction;
//登录提示：如遇问题，请联系人工客服
+ (NSMutableAttributedString *)contactUsAgreement:(void(^)(void))action;
//注销账号文案
+ (NSMutableAttributedString *)cancelAccountTextAgreement;
//提现说明
+ (NSMutableAttributedString *)withdrawExplainAgreement:(void(^)(void))action;
//充值页面的富文本
+ (NSMutableAttributedString *)goPayProtectAgreement:(void(^)(void))payAction
                                      teenagerAction:(void(^)(void))teenagerAction;
//首次启动弹窗文本
+ (NSMutableAttributedString *)firstAppProtocolAgreement:(void(^)(void))userAction
                                           privacyAction:(void(^)(void))privacyAction;
//首充弹窗协议
+ (NSMutableAttributedString *)firstPayProtectAgreement:(void(^)(void))payAction;
//相芯科技美颜协议提醒
+ (NSMutableAttributedString *)faceunityProtocolPopAgreement:(void(^)(void))faceunityAction;
//分享海报提示文案
+ (NSMutableAttributedString *)sharePosterTitleAgreement;
//视频秀赞赏协议
+ (NSMutableAttributedString *)videoShowGiftAwardAction:(void(^)(void))action;
//提现协议富文本
+ (NSMutableAttributedString *)withdrawProtocolPopAgreement:(void(^)(void))selectAction
                                                   protocol:(void(^)(void))protocolAction;
//提现绑定账号提示文案
+ (NSMutableAttributedString *)bindPayAccountHintAgreement;
//收费设置女神星级
+ (NSMutableAttributedString *)collectFeeSetAgreement:(void(^)(void))selectAction;
//发布动态的动态公约
+ (NSMutableAttributedString *)dynamicProtocolPopAExplainAction:(void(^)(void))explainAction
                                                 standardAction:(void(^)(void))standardAction;

+ (NSMutableAttributedString *)payPopProtectAgreement:(void(^)(void))payAction;
@end

NS_ASSUME_NONNULL_END
