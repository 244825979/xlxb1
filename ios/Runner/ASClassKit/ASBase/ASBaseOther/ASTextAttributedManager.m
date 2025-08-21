//
//  ASTextAttributedManager.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASTextAttributedManager.h"

@implementation ASTextAttributedManager

+ (NSMutableAttributedString *)loginHomeAgreement:(void(^)(void))selectAction
                                  serviceProtocol:(void(^)(void))serviceAction
                                  privacyProtocol:(void(^)(void))privacyAction {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"阅读并同意"];
    attributedText.font = TEXT_FONT_12;
    [attributedText setTextHighlightRange:NSMakeRange(0, attributedText.length) color:UIColorRGB(0xBABAC0) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //选中
        selectAction();
    }];
    
    NSMutableAttributedString *clickText1 = [[NSMutableAttributedString alloc] initWithString:@"《用户协议》"];
    clickText1.font = TEXT_MEDIUM(12);
    [clickText1 setTextHighlightRange:NSMakeRange(0, clickText1.length) color:UIColor.whiteColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //用户服务协议跳转
        serviceAction();
    }];
    [attributedText appendAttributedString:clickText1];
    NSMutableAttributedString *text2 = [[NSMutableAttributedString alloc] initWithString:@"和"];
    text2.font = TEXT_FONT_12;
    text2.color = UIColorRGB(0xBABAC0);
    [attributedText appendAttributedString:text2];
    NSMutableAttributedString *clickText2 = [[NSMutableAttributedString alloc] initWithString:@"《隐私协议》"];
    clickText2.font = TEXT_MEDIUM(12);
    [clickText2 setTextHighlightRange:NSMakeRange(0, clickText2.length) color:UIColor.whiteColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //隐私协议跳转
        privacyAction();
    }];
    [attributedText appendAttributedString:clickText2];
    attributedText.lineSpacing = 2.0;
    return attributedText;
}

//登录弹出协议弹窗富文本
+ (NSMutableAttributedString *)userProtocolPopAgreement:(void(^)(void))userAction
                                        privacyProtocol:(void(^)(void))privacyAction {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"欢迎您使用心聊想伴，注册登录前需您阅读并同意"];
    attributedText.font = TEXT_FONT_15;
    attributedText.color = TITLE_COLOR;
    
    NSMutableAttributedString *clickText1 = [[NSMutableAttributedString alloc] initWithString:@"《用户协议》"];
    clickText1.font = TEXT_FONT_15;
    [clickText1 setTextHighlightRange:NSMakeRange(0, clickText1.length) color:MAIN_COLOR backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //用户协议协议跳转
        userAction();
    }];
    [attributedText appendAttributedString:clickText1];
    
    NSMutableAttributedString *clickText2 = [[NSMutableAttributedString alloc] initWithString:@"《隐私协议》"];
    clickText2.font = TEXT_FONT_15;
    [clickText2 setTextHighlightRange:NSMakeRange(0, clickText2.length) color:MAIN_COLOR backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //隐私协议跳转
        privacyAction();
    }];
    [attributedText appendAttributedString:clickText2];
    
    NSMutableAttributedString *clickText3 = [[NSMutableAttributedString alloc] initWithString:@"，如您同意，请点击“同意”并接受我们的服务，感谢您的信任！"];
    clickText3.font = TEXT_FONT_15;
    clickText3.color = TITLE_COLOR;
    [attributedText appendAttributedString:clickText3];
    attributedText.lineSpacing = SCALES(4.0);
    return attributedText;
}

//登录提示：如遇问题，请联系人工客服
+ (NSMutableAttributedString *)contactUsAgreement:(void(^)(void))action {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"如遇问题，请联系"];
    attributedText.font = TEXT_FONT_12;
    attributedText.color = TEXT_COLOR;
    
    NSMutableAttributedString *clickText = [[NSMutableAttributedString alloc] initWithString:@"人工客服"];
    clickText.font = TEXT_FONT_12;
    [clickText setTextHighlightRange:NSMakeRange(0, clickText.length) color:MAIN_COLOR backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        action();
    }];
    [attributedText appendAttributedString:clickText];
    return attributedText;
}

//注销账号文案
+ (NSMutableAttributedString *)cancelAccountTextAgreement {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"提交注销申请后，系统将注销心聊想伴账号并清除所有相关数据。 注销心聊想伴账号是不可恢复的操作，你应自行备份相关的信息和数据，操作之前，请确认与心聊想伴账号相关的所有服务均已妥善处理。\n请谨记:注销心聊想伴账号，你将无法再使用心聊想伴账号或找回你添加或绑定的任何内容或信息(即使你使用相同的手机号码再次注册并使用心聊想伴)，包括但不限于:\n1.你将无法登录、使用本心聊想伴账号，你的朋友(包括喜欢、好友等)将无法通过本心聊想伴账号联系你;\n2.你心聊想伴账号中的个人资料和历史信息(包括但不限于昵称、头像、财富值、收藏等)都将被永久全部清除，无法找回;\n3.你心聊想伴账号绑定的手机号、第三方账号、实名信息都将被解绑，解绑后可重新注册新账号;\n4.靓号将会被系统收回，并对平台其他用户开放申请;\n5.注销账号前，务必确认所有在心聊想伴内的收益已经提现，(相关无法提现的虚拟物品，你可以进行消费后再注销，或者直接舍弃)，账号注销后，账户内的金币，购买的会员权益视为自动放弃;\n6.请注意，注销你的心聊想伴账号并不代表本守账号注销前的账号行为和相关责任得到豁免或减轻;\n7.用户自申请注销操作日起，给予%zd天的注销冷静期，期间可正常登录恢复使用，如申请注销后%zd天内未登录，则完成注销，所有数据不可恢复。", USER_INFO.systemIndexModel.day_number_logout, USER_INFO.systemIndexModel.day_number_logout]];
    attributedText.font = TEXT_FONT_15;
    attributedText.color = TITLE_COLOR;
    attributedText.lineSpacing = SCALES(3.0);
    return attributedText;
}

//提现说明
+ (NSMutableAttributedString *)withdrawExplainWithText:(NSString *)text agreement:(void(^)(void))action {
    UIColor *normalColor = TEXT_SIMPLE_COLOR;
    UIColor *attColor = MAIN_COLOR;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:STRING(text)];
    attributedText.font = TEXT_FONT_12;
    attributedText.color = normalColor;
    [attributedText setTextHighlightRange:NSMakeRange(text.length - 8, 8) color:attColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //合作服务协议
        action();
    }];
    attributedText.lineSpacing = SCALES(3.0);
    return attributedText;
}

+ (NSMutableAttributedString *)intimacyStrategyTextAgreement {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"1、在你们私信聊天当中，每产生消耗金币的行为即可增加亲密度（消息、私聊送礼、音视频通话都包括在内）；\n2、1亲密度=10金币，不同等级可解锁不同特权奖励；\n3、奖励最终解释权归心聊想伴所有。"];
    attributedText.font = TEXT_FONT_12;
    attributedText.color = UIColorRGB(0x4F242A);
    attributedText.lineSpacing = SCALES(4.0);
    return attributedText;
}

+ (NSMutableAttributedString *)goPayProtectAgreement:(void(^)(void))payAction teenagerAction:(void(^)(void))teenagerAction {
    UIColor* normalColor = TEXT_SIMPLE_COLOR;
    UIColor* attColor = MAIN_COLOR;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"充值即代表你已阅读并同意"];
    attributedText.font = TEXT_FONT_12;
    attributedText.color = normalColor;
    NSMutableAttributedString *clickText = [[NSMutableAttributedString alloc] initWithString:@"《充值协议》"];
    clickText.font = TEXT_FONT_12;
    [clickText setTextHighlightRange:NSMakeRange(0, clickText.length) color:attColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        payAction();
    }];
    NSMutableAttributedString *attributedText1 = [[NSMutableAttributedString alloc] initWithString:@",禁止未成年人进行充值,点击详见"];
    attributedText1.font = TEXT_FONT_12;
    attributedText1.color = normalColor;
    NSMutableAttributedString *clickText1 = [[NSMutableAttributedString alloc] initWithString:@"《心聊想伴未成年人保护计划》"];
    clickText1.font = TEXT_FONT_12;
    [clickText1 setTextHighlightRange:NSMakeRange(0, clickText1.length) color:attColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        teenagerAction();
    }];
    [attributedText appendAttributedString:clickText];
    [attributedText appendAttributedString:attributedText1];
    [attributedText appendAttributedString:clickText1];
    attributedText.lineSpacing = SCALES(3.0);
    return attributedText;
}

//首次启动弹窗文本
+ (NSMutableAttributedString *)firstAppProtocolAgreement:(void(^)(void))userAction privacyAction:(void(^)(void))privacyAction {
    UIColor *normalColor = TEXT_COLOR;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"欢迎您使用心聊想伴APP!\n心聊想伴非常重视与保障您的个人信息，我们希望通过"];
    attributedText.font = TEXT_FONT_15;
    attributedText.color = normalColor;
    
    NSMutableAttributedString *clickText1 = [[NSMutableAttributedString alloc] initWithString:@"《用户服务协议》"];
    clickText1.font = TEXT_FONT_15;
    [clickText1 setTextHighlightRange:NSMakeRange(0, clickText1.length) color:MAIN_COLOR backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //用户协议协议跳转
        userAction();
    }];
    [attributedText appendAttributedString:clickText1];
    
    NSMutableAttributedString *clickText2 = [[NSMutableAttributedString alloc] initWithString:@"《用户隐私政策》"];
    clickText2.font = TEXT_FONT_15;
    [clickText2 setTextHighlightRange:NSMakeRange(0, clickText2.length) color:MAIN_COLOR backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //隐私协议跳转
        privacyAction();
    }];
    [attributedText appendAttributedString:clickText2];
    
    NSMutableAttributedString *clickText3 = [[NSMutableAttributedString alloc] initWithString:@"帮助您了解我们如何收集、使用您的相关信息。请您使用前充分阅读并理解。\n如您已充分阅读上述文件并点击“同意”按钮，代表您已同意上述协议及以下约定。\n1、在您浏览使用时，我们会收集您的设备信息、操作日志等用于平台安全风控。\n2、在您使用上传、沟通等服务时，我们需要获取您设备的摄像头、麦克风、相册，但该权限均需经您明示授权才会为实现功能或服务时使用。您可以在手机设置APP访问、修改、删除管理您的授权。详细信息请查看"];
    clickText3.font = TEXT_FONT_15;
    clickText3.color = normalColor;
    [attributedText appendAttributedString:clickText3];
    [attributedText appendAttributedString:clickText2];
    attributedText.lineSpacing = SCALES(4.0);
    return attributedText;
}

+ (NSMutableAttributedString *)firstPayProtectAgreement:(void(^)(void))payAction {
    UIColor* normalColor = TEXT_SIMPLE_COLOR;
    UIColor* attColor = MAIN_COLOR;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"严禁未成年充值，充值代表已阅读并同意"];
    attributedText.font = TEXT_FONT_11;
    attributedText.color = normalColor;
    
    NSMutableAttributedString *clickText = [[NSMutableAttributedString alloc] initWithString:@"《充值协议》"];
    clickText.font = TEXT_FONT_11;
    [clickText setTextHighlightRange:NSMakeRange(0, clickText.length) color:attColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //协议跳转
        payAction();
    }];
    [attributedText appendAttributedString:clickText];
    attributedText.lineSpacing = 2.0;
    return attributedText;
}

+ (NSMutableAttributedString *)payPopProtectAgreement:(void(^)(void))payAction {
    UIColor* normalColor = TITLE_COLOR;
    UIColor* attColor = MAIN_COLOR;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"为呵护未成年人健康成长，在您进行充值前，请确认已了解并同意我们的"];
    attributedText.font = TEXT_FONT_15;
    attributedText.color = normalColor;
    
    NSMutableAttributedString *clickText = [[NSMutableAttributedString alloc] initWithString:@"《心聊想伴未成年人保护计划》"];
    clickText.font = TEXT_FONT_15;
    [clickText setTextHighlightRange:NSMakeRange(0, clickText.length) color:attColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //协议跳转
        payAction();
    }];
    [attributedText appendAttributedString:clickText];
    attributedText.lineSpacing = SCALES(3.0);
    return attributedText;
}

+ (NSMutableAttributedString *)faceunityProtocolPopAgreement:(void(^)(void))faceunityAction {
    UIColor *normalColor = UIColorRGB(0x999999);
    UIColor *attColor = MAIN_COLOR;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"应用如何使用面部数据信息，点击详见："];
    attributedText.font = TEXT_FONT_16;
    attributedText.color = normalColor;
    
    NSMutableAttributedString *clickText1 = [[NSMutableAttributedString alloc] initWithString:@"《相芯科技隐私条款》"];
    clickText1.font = TEXT_FONT_16;
    [clickText1 setTextHighlightRange:NSMakeRange(0, clickText1.length) color:attColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //相芯科技隐私条款
        faceunityAction();
    }];
    [attributedText appendAttributedString:clickText1];
    attributedText.lineSpacing = SCALES(3);
    return attributedText;
}

+ (NSMutableAttributedString *)sharePosterTitleAgreement {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", @"你来我网，互动陪聊"]];
    attributedText.font = TEXT_MEDIUM(16);
    attributedText.color = TITLE_COLOR;
    
    NSMutableAttributedString *clickText1 = [[NSMutableAttributedString alloc] initWithString:@"相聚就在【心聊想伴】"];
    clickText1.font = TEXT_FONT_14;
    [attributedText appendAttributedString:clickText1];
    attributedText.lineSpacing = 4.0;
    return attributedText;
}

//视频秀赞赏协议
+ (NSMutableAttributedString *)videoShowGiftAwardAction:(void(^)(void))action {
    UIColor *normalColor = TEXT_COLOR;
    UIColor *attColor = MAIN_COLOR;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"赞赏代表阅读并同意"];
    attributedText.font = TEXT_FONT_12;
    attributedText.color = normalColor;
    
    NSMutableAttributedString *clickText = [[NSMutableAttributedString alloc] initWithString:@" 赞赏须知"];
    clickText.font = TEXT_FONT_12;
    [clickText setTextHighlightRange:NSMakeRange(0, clickText.length) color:attColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //协议跳转
        action();
    }];
    [attributedText appendAttributedString:clickText];
    attributedText.lineSpacing = 2.0;
    return attributedText;
}

+ (NSMutableAttributedString *)withdrawProtocolPopAgreement:(void(^)(void))selectAction
                                                   protocol:(void(^)(void))protocolAction {
    UIColor *normalColor = TEXT_COLOR;
    UIColor *attColor = MAIN_COLOR;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"勾选即同意"];
    attributedText.font = TEXT_FONT_14;
    [attributedText setTextHighlightRange:NSMakeRange(0, attributedText.length) color:normalColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //选中
        selectAction();
    }];
    
    NSMutableAttributedString *clickText1 = [[NSMutableAttributedString alloc] initWithString:@"《共享经济合作伙伴协议》"];
    clickText1.font = TEXT_FONT_14;
    [clickText1 setTextHighlightRange:NSMakeRange(0, clickText1.length) color:attColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //协议跳转
        protocolAction();
    }];
    [attributedText appendAttributedString:clickText1];
    return attributedText;
}

//提现绑定账号提示文案
+ (NSMutableAttributedString *)bindPayAccountHintAgreement {
    UIColor *normalColor = TEXT_SIMPLE_COLOR;
    UIColor *attColor = MAIN_COLOR;
    
    NSMutableAttributedString*attributedText = [[NSMutableAttributedString alloc] initWithString:@"为了保证您能快速提现，请认真阅读一下提示哦~\n1、请填写正确"];
    attributedText.color = normalColor;
    NSMutableAttributedString *clickText1 = [[NSMutableAttributedString alloc] initWithString:@"【基本信息】"];
    [clickText1 setTextHighlightRange:NSMakeRange(0, clickText1.length) color:attColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
    }];
    [attributedText appendAttributedString:clickText1];
    
    NSMutableAttributedString *clickText2 = [[NSMutableAttributedString alloc] initWithString:@"及"];
    [clickText2 setTextHighlightRange:NSMakeRange(0, clickText2.length) color:normalColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
    }];
    [attributedText appendAttributedString:clickText2];
    
    NSMutableAttributedString *clickText3 = [[NSMutableAttributedString alloc] initWithString:@"【账号信息】"];
    [clickText3 setTextHighlightRange:NSMakeRange(0, clickText3.length) color:attColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
    }];
    [attributedText appendAttributedString:clickText3];
    
    NSMutableAttributedString *clickText4 = [[NSMutableAttributedString alloc] initWithString:@"，保证账号的准确性；\n2、请确保"];
    [clickText4 setTextHighlightRange:NSMakeRange(0, clickText4.length) color:normalColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
    }];
    [attributedText appendAttributedString:clickText4];
    
    NSMutableAttributedString *clickText5 = [[NSMutableAttributedString alloc] initWithString:@"【基本信息】"];
    [clickText5 setTextHighlightRange:NSMakeRange(0, clickText5.length) color:attColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
    }];
    [attributedText appendAttributedString:clickText5];
    
    NSMutableAttributedString *clickText6 = [[NSMutableAttributedString alloc] initWithString:@"及"];
    [clickText6 setTextHighlightRange:NSMakeRange(0, clickText6.length) color:normalColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
    }];
    [attributedText appendAttributedString:clickText6];
    
    NSMutableAttributedString *clickText7 = [[NSMutableAttributedString alloc] initWithString:@"【账号信息】"];
    [clickText7 setTextHighlightRange:NSMakeRange(0, clickText7.length) color:attColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
    }];
    [attributedText appendAttributedString:clickText7];
    
    NSMutableAttributedString *clickText8 = [[NSMutableAttributedString alloc] initWithString:@"为同一人，否则会影响您的提现进度；\n3、如在提现过程中有任何疑问，请及时联系客服处理。"];
    [clickText8 setTextHighlightRange:NSMakeRange(0, clickText8.length) color:normalColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
    }];
    [attributedText appendAttributedString:clickText8];
    attributedText.font = TEXT_FONT_13;
    attributedText.lineSpacing = SCALES(4.0);
    return attributedText;
}

+ (NSMutableAttributedString *)collectFeeSetAgreement:(void(^)(void))selectAction {
    UIColor *normalColor = TEXT_SIMPLE_COLOR;
    UIColor *attColor = MAIN_COLOR;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"收费设置说明：\n1.对方主动给你发文字消息或与你进行视频/语音通话，你的收费依据本页设置。\n2.星级越高，可设置的价格越高，查看"];
    attributedText.font = TEXT_FONT_14;
    attributedText.color = normalColor;
    
    NSMutableAttributedString *clickText = [[NSMutableAttributedString alloc] initWithString:@"如何提高星级。"];
    clickText.font = TEXT_FONT_14;
    [clickText setTextHighlightRange:NSMakeRange(0, clickText.length) color:attColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //如何提高星级
        selectAction();
    }];
    [attributedText appendAttributedString:clickText];
    attributedText.lineSpacing = SCALES(4.0);
    return attributedText;
}

//发布动态的动态公约
+ (NSMutableAttributedString *)dynamicProtocolPopAExplainAction:(void(^)(void))explainAction
                                                 standardAction:(void(^)(void))standardAction {
    UIColor *normalColor = TEXT_COLOR;
    UIColor *contentColor = TEXT_SIMPLE_COLOR;
    UIColor *attColor = UIColorRGB(0x5B89FF);
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"心聊想伴鼓励用户多发健康和谐有趣活泼的原创内容，遵循先审后发的基本规则，致力打造一个积极向上的社交平台。\n"];
    attributedText.font = TEXT_FONT_15;
    attributedText.color = normalColor;
    
    NSMutableAttributedString *attributedText1 = [[NSMutableAttributedString alloc] initWithString:@"\n1、禁止发布色情、性暗示等低俗内容\n2、禁止发布国家政治，暴恐暴乱等内容\n3、不可涉及第三方平台信息\n4、不可使用他人的图片或视频发布\n\n"];
    attributedText1.font = TEXT_FONT_13;
    attributedText1.color = contentColor;
    [attributedText appendAttributedString:attributedText1];
    
    NSMutableAttributedString *attributedText2 = [[NSMutableAttributedString alloc] initWithString:@"查看完整版"];
    attributedText2.font = TEXT_FONT_15;
    attributedText2.color = normalColor;
    [attributedText appendAttributedString:attributedText2];
    
    NSMutableAttributedString *clickText1 = [[NSMutableAttributedString alloc] initWithString:@"《心聊想伴内容审核规则说明》"];
    clickText1.font = TEXT_FONT_15;
    [clickText1 setTextHighlightRange:NSMakeRange(0, clickText1.length) color:attColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //规则说明
        explainAction();
    }];
    [attributedText appendAttributedString:clickText1];
    
    NSMutableAttributedString *attributedText3 = [[NSMutableAttributedString alloc] initWithString:@"和"];
    attributedText3.font = TEXT_FONT_15;
    attributedText3.color = normalColor;
    [attributedText appendAttributedString:attributedText3];
    
    NSMutableAttributedString* clickText2 = [[NSMutableAttributedString alloc] initWithString:@"《心聊想伴平台内容发布运营规范》"];
    clickText2.font = TEXT_FONT_15;
    [clickText2 setTextHighlightRange:NSMakeRange(0, clickText2.length) color:attColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //运营规范
        standardAction();
    }];
    [attributedText appendAttributedString:clickText2];
    attributedText.lineSpacing = SCALES(3.0);
    return attributedText;
}

@end
