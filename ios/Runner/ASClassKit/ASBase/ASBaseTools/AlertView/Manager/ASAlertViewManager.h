//
//  ASAlertViewManager.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>
#import "zhPopupController.h"
#import "ASIMSystemNotifyModel.h"
#import "ASSignInModel.h"
#import "ASIMIntimateUserModel.h"
#import "ASSendGiftView.h"
#import "ASRTCAnchorPriceModel.h"
#import "ASPayGoodsDataModel.h"
#import "ASSendVipModel.h"
#import "ASCenterNotifyModel.h"
#import "ASFirstPayDataModel.h"
#import "ASRecommendUserModel.h"
#import "ASNewUserGiftModel.h"
#import "ASGoodAnchorModel.h"
#import "ASUserVideoPopModel.h"
#import "ASUMShareAlertView.h"
#import "ASFateHelperStatusModel.h"
#import "ASWebJsBodyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASAlertViewManager : NSObject

//默认通用弹窗
+ (void)defaultPopTitle:(NSString *)title
                content:(NSString *)content
                   left:(NSString *)left
                  right:(NSString *)right
           affirmAction:(VoidBlock)affirmAction
           cancelAction:(VoidBlock)cancelAction;
//底部弹出弹窗
+ (void)bottomPopTitles:(NSArray *)titles
            indexAction:(IndexNameBlock)indexAction
           cancelAction:(VoidBlock)cancelAction;
//协议弹窗
+ (zhPopupController *)protocolPopTitle:(NSString *)title
                             cancelText:(NSString *)cancelText
                             cancelFont:(nullable UIFont *)cancelFont
                   dismissOnMaskTouched:(BOOL)dismissOnMaskTouched
                             attributed:(NSMutableAttributedString *)attributed
                           affirmAction:(VoidBlock)affirmAction
                           cancelAction:(VoidBlock)cancelAction;
//美颜协议弹窗
+ (void)popFaceunityProtocolWithAction:(VoidBlock)affirmAction;
//触发人脸比对
+ (void)popFaceVerificationView;
//亲密度升级提示框
+ (void)popIntimacyUpgradeWithModel:(ASIMSystemNotifyModel *)model;
//签到弹窗
+ (void)popDaySignIn:(ASSignInGiftModel *)model;
//签到列表弹窗
+ (void)popSignInList:(ASSignInModel *)model affirmAction:(VoidBlock)affirmAction;
//关闭青少年模式弹窗
+ (void)popCloseTeengaerWithAction:(VoidBlock)closeAction forgetPwdAction:(VoidBlock)forgetPwdAction;
//开启青少年模式弹窗提醒
+ (zhPopupController *)popOpenTeengaerWithVc:(UIViewController *)vc cancelAction:(VoidBlock)cancelAction openAction:(VoidBlock)openAction;
//textView输入文本弹窗
+ (void)popTextViewWithTitle:(NSString *)title
                     content:(NSString *)content
                 placeholder:(NSString *)titleplaceholder
                      length:(NSInteger)length
                  affirmText:(NSString *)affirmText
                affirmAction:(TextBlock)affirmAction
                cancelAction:(VoidBlock)cancelAction;
//textField输入文本弹窗
+ (void)popTextFieldWithTitle:(NSString *)title
                      content:(NSString *)content
                  placeholder:(NSString *)titleplaceholder
                       length:(NSInteger)length
                   affirmText:(NSString *)affirmText
                       remark:(NSString *)remark//备注内容，如果字符串为空就不显示
                     isNumber:(BOOL)isNumber//是否显示数字
                      isEmpty:(BOOL)isEmpty
                 affirmAction:(TextBlock)affirmAction
                 cancelAction:(VoidBlock)cancelAction;
//个人视频秀弹出设置
+ (void)popVideoShowSetWithModel:(ASVideoShowDataModel *)model
                          action:(VoidBlock)affirmAction;
//视频秀赞赏
+ (void)popVideoShowGiftWithModel:(ASVideoShowDataModel *)model;
//首次弹出防诈骗弹窗
+ (void)popPreventFraudAlertViewWithVc:(UIViewController *)vc cancel:(VoidBlock)cancelAction;
//亲密度详情弹窗
+ (void)popIntimacyDetailsWithModel:(ASIMIntimateUserModel *)model;
//赠送礼物弹窗
+ (void)popGiftViewWithTitles:(NSArray *)titles
                     toUserID:(NSString *)toUserID
                     giftType:(ASGiftType)giftType
                    sendBlock:(void(^)(NSString * giftID, NSInteger giftCount, NSString * giftTypeID))sendBlock;
//拨打选择类型弹窗
+ (void)popCallViewWithModel:(ASRtcAnchorPriceModel *)priceModel affirmAction:(void(^)(ASCallType type))affirmAction;
//余额不足弹窗
+ (void)balanceDeficiencyPopViewWithModel:(ASPayGoodsDataModel *)model
                                    scene:(NSString *)scene
                                   cancel:(VoidBlock)cancelAction;
//对ta隐身开通引导开启会员
+ (void)openHidingVipViewAction:(VoidBlock)affirmAction;
//Vip解锁弹窗
+ (zhPopupController *)popVipUnlockWithAction:(VoidBlock)affirmAction cancelAction:(VoidBlock)cancelAction;
//升级弹窗
+ (void)popAppVersionWithModel:(ASVersionModel *)model vc:(UIViewController *)vc cancelAction:(VoidBlock)cancelAction;
//今日缘分推荐弹窗
+ (void)popDayRecommendViewWithModel:(ASRecommendUserListModel *)model vc:(UIViewController *)vc cancelAction:(VoidBlock)cancelAction;
//视频来电弹窗
+ (zhPopupController *)popCallVideoPushViewWithModel:(ASUserVideoPopModel *)model cancelAction:(VoidBlock)cancelAction;
//首冲弹窗
+ (void)popFirstPayViewWithModel:(ASFirstPayDataModel *)model cancelAction:(VoidBlock)cancelAction;
//头像引导弹窗
+ (void)popHeadViewWithCoin:(NSInteger)coin vc:(UIViewController *)vc affirmAction:(VoidBlock)affirmAction cancelAction:(VoidBlock)cancelAction;
//分享view
+ (void)popUMShareViewWithBody:(ASWebJsBodyModel *)bodyModel
                        action:(void(^)(UMSocialPlatformType platformType, id  _Nonnull value))affirmAction;
//优质用户
+ (zhPopupController *)popGoodAnchorWithModel:(ASGoodAnchorModel *)model;
//小助手弹窗
+ (void)popMatchHelperListViewModel:(ASFateHelperStatusModel *)model refreshAction:(VoidBlock)refreshAction;
//视频秀发布提示
+ (void)popVideoShowRemindPopViewWithVc:(UIViewController *)vc affirmAction:(VoidBlock)affirmAction cancelBlock:(VoidBlock)cancelBlock;
//女用户领取礼物
+ (void)vipReceiveGiftPopWithModel:(ASGiftListModel *)model affirmAction:(VoidBlock)affirmAction;
//赠送vip弹窗
+ (void)sendVipPopViewWithModel:(ASSendVipModel *)model toUserID:(NSString *)toUserID;
//用户通知弹窗-是否弹出
+ (void)centerPopNoticeViewWithModel:(ASCenterNotifyModel *)model vc:(UIViewController *)vc cancelBlock:(VoidBlock)cancelBlock;
//提现弹窗
+ (void)popWithdrawHintViewWithContent:(NSString *)content isProtocol:(BOOL)isProtocol indexAction:(IndexNameBlock)indexAction;
//新人礼物
+ (void)newUserGiftWithModel:(ASNewUserGiftModel *)model vc:(UIViewController *)vc closeAction:(VoidBlock)closeAction;
//手机绑定弹窗
+ (void)popPhoneBindAlertViewWithVc:(UIViewController *)vc
                            content:(NSString *)content
                        isPopWindow:(BOOL)isPopWindow
                       affirmAction:(VoidBlock)affirmAction
                        cancelBlock:(VoidBlock)cancelBlock;
//微信绑定弹窗
+ (void)popWXBindAlertViewWithVc:(UIViewController *)vc affirmAction:(VoidBlock)affirmAction cancelBlock:(VoidBlock)cancelBlock;
//分享海报弹窗
+ (void)popInvitePosterViewWithBody:(ASWebJsBodyModel *)bodyModel affirmAction:(VoidBlock)affirmAction;
//活动弹窗
+ (void)popActivityWithModel:(ASBannerModel *)model
                          vc:(UIViewController *)vc
                 isPopWindow:(BOOL)isPopWindow
                affirmAction:(VoidBlock)affirmAction
                 cancelBlock:(VoidBlock)cancelBlock;
//IM搭讪引导
+ (void)imDashanDemonstrationPopViewWithVc:(UIViewController *)vc CancelBlock:(VoidBlock)cancelBlock;
@end

NS_ASSUME_NONNULL_END
