//
//  ASAlertViewManager.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASAlertViewManager.h"
#import "ASDefaultAlertView.h"
#import "ASProtocolAlertView.h"
#import "ASBottomAlertView.h"
#import "ASFaceunityProtocolAlertView.h"
#import "ASMyFaceAuthVerifyView.h"
#import "ASIntimacyUpgradeAlertView.h"
#import "ASDaySignInAlertView.h"
#import "ASTextViewAlertView.h"
#import "ASTextFieldAlertView.h"
#import "ASTeengaerAlertView.h"
#import "ASVideoShowSetPopView.h"
#import "ASVideoShowSendGiftView.h"
#import "ASPreventFraudAlertView.h"
#import "ASIntimacyDetailsAlertView.h"
#import "ASCallAlertView.h"
#import "ASBalanceDeficiencyAlertView.h"
#import "ASSendVipPopView.h"
#import "ASOpenHidingVipView.h"
#import "ASVipDetailsController.h"
#import "ASCenterNotifyWebPopView.h"
#import "ASWithdrawHintView.h"
#import "ASReceiveGiftPopView.h"
#import "ASVipUnlockAlertView.h"
#import "ASFirstPayAlertView.h"
#import "ASDayRecommendAlertView.h"
#import "ASVersionUpgradeAlertView.h"
#import "ASNewUserPopView.h"
#import "ASGoodAnchorPopView.h"
#import "ASCallVideoAlertView.h"
#import "ASHeadPopRemindView.h"
#import "ASVideoShowRemindPopView.h"
#import "ASMatchHelperPopView.h"
#import "ASBindPhoneAlertView.h"
#import "ASBindWechatAlertView.h"
#import "ASInvitePosterAlertView.h"
#import "ASActivityPopView.h"
#import "ASIMDemonstrationPopView.h"

@implementation ASAlertViewManager

//默认通用弹窗
+ (void)defaultPopTitle:(NSString *)title
                content:(NSString *)content
                   left:(NSString *)left
                  right:(NSString *)right
              isTouched:(BOOL)isTouched
           affirmAction:(VoidBlock)affirmAction
           cancelAction:(VoidBlock)cancelAction {
    ASDefaultAlertView *alertView = [[ASDefaultAlertView alloc]initWithTitle:title message:content affirmText:left cancelText:right];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleTransform;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    popupController.dismissOnMaskTouched = isTouched;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^{
        affirmAction();
        [wPopupController dismiss];
    };
    alertView.cancelBlock = ^{
        cancelAction();
        [wPopupController dismiss];
    };
}

+ (void)bottomPopTitles:(NSArray *)titles
            indexAction:(IndexNameBlock)indexAction
           cancelAction:(VoidBlock)cancelAction {
    if (titles.count == 0 || kObjectIsEmpty(titles)) {
        return;
    }
    ASBottomAlertView * alertView = [[ASBottomAlertView alloc]initWithTitles:titles];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    popupController.layoutType = zhPopupLayoutTypeBottom;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.indexBlock = ^(NSString *indexName) {
        indexAction(indexName);
        [wPopupController dismiss];
    };
    alertView.cancelBlock = ^{
        cancelAction();
        [wPopupController dismiss];
    };
}

+ (zhPopupController *)protocolPopTitle:(NSString *)title
                             cancelText:(NSString *)cancelText
                             cancelFont:(nullable UIFont *)cancelFont
                   dismissOnMaskTouched:(BOOL)dismissOnMaskTouched
                             attributed:(NSMutableAttributedString *)attributed
                           affirmAction:(VoidBlock)affirmAction
                           cancelAction:(VoidBlock)cancelAction {
    ASProtocolAlertView *alertView = [[ASProtocolAlertView alloc]initWithTitle:title cancelFont:cancelFont cancelText:cancelText attributed:attributed];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleTransform;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    popupController.dismissOnMaskTouched = dismissOnMaskTouched;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^{
        affirmAction();
        [wPopupController dismiss];
    };
    alertView.cancelBlock = ^{
        cancelAction();
        [wPopupController dismiss];
    };
    return popupController;
}

+ (void)popFaceunityProtocolWithAction:(VoidBlock)affirmAction {
    ASFaceunityProtocolAlertView *alertView = [[ASFaceunityProtocolAlertView alloc] initFaceunityProtocolPopView];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^{
        [wPopupController dismiss];
        affirmAction();
    };
}

+ (void)popFaceVerificationView {
    ASMyFaceAuthVerifyView *alertView = [[ASMyFaceAuthVerifyView alloc] init];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    popupController.layoutType = zhPopupLayoutTypeBottom;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.cancelBlock = ^() {
        [wPopupController dismiss];
    };
}

+ (void)popIntimacyUpgradeWithModel:(ASIMSystemNotifyModel *)model {
    ASIntimacyUpgradeAlertView *alertView = [[ASIntimacyUpgradeAlertView alloc] initIntimacyUpgradeWithModel:model];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleTransform;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    popupController.dismissOnMaskTouched = NO;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock  = ^{
        [wPopupController dismiss];
    };
}

+ (void)popDaySignIn:(ASSignInGiftModel *)model {
    ASDaySignInAlertView *alertView = [[ASDaySignInAlertView alloc]initWithDaySignInModel:model];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleTransform;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    popupController.dismissOnMaskTouched = NO;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^{
        [wPopupController dismiss];
    };
}

+ (void)popSignInList:(ASSignInModel *)model affirmAction:(VoidBlock)affirmAction {
    ASDaySignInAlertView *alertView = [[ASDaySignInAlertView alloc]initWithSignInListModel:model];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleTransform;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^{
        if (model.today_status == NO) {
            affirmAction();
        }
        [wPopupController dismiss];
    };
}

+ (void)popCloseTeengaerWithAction:(VoidBlock)closeAction forgetPwdAction:(VoidBlock)forgetPwdAction {
    ASTeengaerAlertView *alertView = [[ASTeengaerAlertView alloc] initWithCloseTeengaer];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    popupController.dismissOnMaskTouched = NO;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.closeBlock = ^{
        [wPopupController dismiss];
        closeAction();
    };
    alertView.forgetPwdBlock = ^{
        [wPopupController dismiss];
        forgetPwdAction();
    };
}

+ (zhPopupController *)popOpenTeengaerWithVc:(UIViewController *)vc cancelAction:(VoidBlock)cancelAction openAction:(VoidBlock)openAction {
    ASTeengaerAlertView *alertView = [[ASTeengaerAlertView alloc] initWithOpenTeengaer];
    //只要弹了青少年弹窗。就保存弹窗的状态为1
    [ASUserDefaults setValue:@"1" forKey:[NSString stringWithFormat:@"%@_%@", STRING(USER_INFO.user_id), kIsPopLoginTeenagerView]];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    popupController.dismissOnMaskTouched = NO;
    [popupController showInView:vc.view completion:NULL];
    popupController.didDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        //关闭弹窗的时候调用
        cancelAction();
    };
    __weak typeof(popupController) wPopupController = popupController;
    alertView.closeBlock = ^{//关闭弹窗的时候回调
        [wPopupController dismiss];
    };
    alertView.forgetPwdBlock = ^{
        [wPopupController dismiss];
        openAction();
    };
    return popupController;
}

+ (void)popTextViewWithTitle:(NSString *)title
                     content:(NSString *)content
                 placeholder:(NSString *)titleplaceholder
                      length:(NSInteger)length
                  affirmText:(NSString *)affirmText
                affirmAction:(TextBlock)affirmAction
                cancelAction:(VoidBlock)cancelAction {
    ASTextViewAlertView *alertView = [[ASTextViewAlertView alloc]initTextViewWithTitle:title content:content placeholder:titleplaceholder length:length affirm:affirmText];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    popupController.layoutType = zhPopupLayoutTypeBottom;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^(NSString * _Nonnull text) {
        affirmAction(text);
        [wPopupController dismiss];
    };
    alertView.cancelBlock = ^{
        cancelAction();
        [wPopupController dismiss];
    };
    __weak typeof(alertView) walertView = alertView;
    alertView.keyboardHeight = ^(CGFloat height, CGFloat duration) {
        [UIView animateWithDuration:duration animations:^{
            walertView.y = SCREEN_HEIGHT - height - walertView.height;
            [walertView layoutIfNeeded];
        }];
    };
}

+ (void)popTextFieldWithTitle:(NSString *)title
                      content:(NSString *)content
                  placeholder:(NSString *)titleplaceholder
                       length:(NSInteger)length
                   affirmText:(NSString *)affirmText
                       remark:(NSString *)remark
                     isNumber:(BOOL)isNumber
                      isEmpty:(BOOL)isEmpty
                 affirmAction:(TextBlock)affirmAction
                 cancelAction:(VoidBlock)cancelAction {
    ASTextFieldAlertView *alertView = [[ASTextFieldAlertView alloc]initTextFieldViewWithTitle:title content:content placeholder:titleplaceholder length:length affirmText:affirmText remark:remark isNumber:isNumber isEmpty:isEmpty];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleTransform;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^(NSString * _Nonnull text) {
        affirmAction(text);
        [wPopupController dismiss];
    };
    alertView.cancelBlock = ^{
        cancelAction();
        [wPopupController dismiss];
    };
}

+ (void)popVideoShowSetWithModel:(ASVideoShowDataModel *)model
                          action:(VoidBlock)affirmAction {
    ASVideoShowSetPopView *alertView = [[ASVideoShowSetPopView alloc] init];
    alertView.model = model;
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    popupController.layoutType = zhPopupLayoutTypeBottom;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.delBlock = ^() {
        affirmAction();
        [wPopupController dismiss];
    };
    alertView.cancelBlock = ^{
        [wPopupController dismiss];
    };
}

+ (void)popVideoShowGiftWithModel:(ASVideoShowDataModel *)model {
    ASVideoShowSendGiftView *alertView = [[ASVideoShowSendGiftView alloc] init];
    alertView.model = model;
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    popupController.layoutType = zhPopupLayoutTypeBottom;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.cancelBlock = ^() {
        [wPopupController dismiss];
    };
}
+ (void)popPreventFraudAlertViewWithVc:(UIViewController *)vc cancel:(VoidBlock)cancelAction {
    ASPreventFraudAlertView *alertView = [[ASPreventFraudAlertView alloc] initPreventFraudView];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:vc.view completion:NULL];
    popupController.didDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        //关闭弹窗的时候调用，弹出其他的弹窗
        cancelAction();
    };
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^{
        [wPopupController dismiss];
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = [NSString stringWithFormat:@"%@%@", SERVER_AGREEMENT_URL, Web_URL_Fraud];
        [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
    };
}

+ (void)popIntimacyDetailsWithModel:(ASIMIntimateUserModel *)model {
    ASIntimacyDetailsAlertView *alertView = [[ASIntimacyDetailsAlertView alloc] initIntimacyDetailsWithModel:model];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleTransform;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
}

+ (void)popGiftViewWithTitles:(NSArray *)titles
                     toUserID:(NSString *)toUserID
                     giftType:(ASGiftType)giftType
                    sendBlock:(void(^)(NSString * giftID, NSInteger giftCount, NSString * giftTypeID))sendBlock {
    ASSendGiftView *alertView = [[ASSendGiftView alloc]init];
    alertView.titles = titles;
    alertView.userID = toUserID;
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    popupController.layoutType = zhPopupLayoutTypeBottom;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.cancelBlock = ^{
        [wPopupController dismiss];
    };
    alertView.sendBlock = ^(NSString * _Nonnull giftID, NSString * _Nonnull giftCount, NSString * _Nonnull giftTypeID, NSString * _Nonnull selectGiftSvga) {
        if (giftType == kSendGiftTypeCall) {//通话发送礼物
            sendBlock(giftID, giftCount.integerValue, giftTypeID);
            [wPopupController dismiss];
        } else {
            [ASCommonRequest requestGiveGiftWithGiftTypeID:giftTypeID
                                                  toUserID:toUserID
                                                    number:giftCount
                                                    giftID:giftID
                                                   success:^(id  _Nullable data) {
                NSString *svgaUrl = [NSString stringWithFormat:@"%@%@", SERVER_IMAGE_URL, selectGiftSvga];
                if (svgaUrl.length > 20) {
                    ASGiftSVGAPlayerController *vc = [[ASGiftSVGAPlayerController alloc] init];
                    vc.playerUrl = svgaUrl;
                    vc.view.backgroundColor = UIColor.clearColor;
                    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    [[ASCommonFunc currentVc] presentViewController:vc animated:NO completion:nil];
                }
                [wPopupController dismiss];
            } errorBack:^(NSInteger code, NSString *msg) {
                [wPopupController dismiss];
            }];
        }
    };
}

+ (void)popCallViewWithModel:(ASRtcAnchorPriceModel *)priceModel affirmAction:(void(^)(ASCallType type))affirmAction {
    ASCallAlertView *alertView = [[ASCallAlertView alloc]initCallViewWithModel:priceModel];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    popupController.layoutType = zhPopupLayoutTypeBottom;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^(ASCallType type) {
        affirmAction(type);
        [wPopupController dismiss];
    };
    alertView.cancelBlock = ^{
        [wPopupController dismiss];
    };
}

+ (void)balanceDeficiencyPopViewWithModel:(ASPayGoodsDataModel *)model
                                    scene:(NSString *)scene
                                   cancel:(VoidBlock)cancelAction {
    ASBalanceDeficiencyAlertView *alertView = [[ASBalanceDeficiencyAlertView alloc] initBalanceDeficiencyViewWithModel:model scene:scene];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    popupController.layoutType = zhPopupLayoutTypeBottom;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    popupController.maskAlpha = 0.75;
    popupController.didDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        //关闭弹窗的时候调用
        cancelAction();
    };
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.cancelBlock = ^{
        [wPopupController dismiss];
    };
}

//对ta隐身开通引导开启会员
+ (void)openHidingVipViewAction:(VoidBlock)affirmAction {
    ASOpenHidingVipView *alertView = [[ASOpenHidingVipView alloc] initOpenHidingVipView];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.cancelBlock = ^() {
        [wPopupController dismiss];
    };
    alertView.affirmBlock = ^{
        affirmAction();
        [wPopupController dismiss];
        ASVipDetailsController *vc = [[ASVipDetailsController alloc] init];
        vc.isRootPop = YES;
        [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
    };
}

//Vip解锁弹窗
+ (zhPopupController *)popVipUnlockWithAction:(VoidBlock)affirmAction cancelAction:(VoidBlock)cancelAction {
    ASVipUnlockAlertView *alertView = [[ASVipUnlockAlertView alloc] initVipUnlock];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleTransform;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    popupController.maskType = zhPopupMaskTypeLightBlur;
    [popupController showInView:kCurrentWindow completion:NULL];
    popupController.willDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        cancelAction();
    };
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^{
        [wPopupController dismiss];
        affirmAction();
    };
    return popupController;
}

//升级弹窗
+ (void)popAppVersionWithModel:(ASVersionModel *)model vc:(UIViewController *)vc cancelAction:(VoidBlock)cancelAction {
    ASVersionUpgradeAlertView *alertView = [[ASVersionUpgradeAlertView alloc] initAppVersionViewWithModel:model];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    if (model.enforce == YES) {
        popupController.dismissOnMaskTouched = NO;
    } else {
        popupController.dismissOnMaskTouched = YES;
    }
    popupController.didDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        //关闭弹窗的时候调用，弹出其他的弹窗
        cancelAction();
    };
    [popupController showInView:vc.view completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.cancelBlock = ^{
        [wPopupController dismiss];
    };
    if (model.enforce == YES) {//强制更新
        alertView.affirmBlock = ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:STRING(model.downloadurl)] options:@{} completionHandler:^(BOOL success) {
                        
            }];
        };
    } else {
        alertView.affirmBlock = ^{
            [wPopupController dismiss];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:STRING(model.downloadurl)] options:@{} completionHandler:^(BOOL success) {
                        
            }];
        };
    }
}

//今日缘分推荐弹窗
+ (void)popDayRecommendViewWithModel:(ASRecommendUserListModel *)model vc:(UIViewController *)vc cancelAction:(VoidBlock)cancelAction {
    ASDayRecommendAlertView *alertView = [[ASDayRecommendAlertView alloc] initDayRecommendViewWithModel:model];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    popupController.didDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        //关闭弹窗的时候调用，弹出其他的弹窗
        cancelAction();
    };
    [popupController showInView:vc.view completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.cancelBlock = ^{
        [wPopupController dismiss];
    };
}

//视频来电弹窗
+ (zhPopupController *)popCallVideoPushViewWithModel:(ASUserVideoPopModel *)model cancelAction:(VoidBlock)cancelAction {
    ASCallVideoAlertView *alertView = [[ASCallVideoAlertView alloc] initCallVideoViewWithModel:model];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    popupController.didDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        //关闭弹窗的时候调用，弹出其他的弹窗
        cancelAction();
    };
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.cancelBlock = ^{
        [wPopupController dismiss];
    };
    alertView.affirmBlock = ^{
        //拨打电话
        [ASMyAppCommonFunc callWithUserID:model.user_id
                                 callType:kCallTypeVideo
                                    scene:Call_Scene_Guide
                                     back:^(BOOL isSucceed) {
            if (isSucceed == YES) {//呼叫成功
                [wPopupController dismiss];
            }
        }];
    };
    return popupController;
}

//首冲弹窗
+ (void)popFirstPayViewWithModel:(ASFirstPayDataModel *)model cancelAction:(VoidBlock)cancelAction {
    ASFirstPayAlertView *alertView = [[ASFirstPayAlertView alloc] initFirstPayViewWithModel:model];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    popupController.didDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        //关闭弹窗的时候调用，弹出其他的弹窗
        cancelAction();
    };
    __weak typeof(popupController) wPopupController = popupController;
    alertView.cancelBlock = ^{
        [wPopupController dismiss];
    };
}

//头像引导弹窗
+ (void)popHeadViewWithCoin:(NSInteger)coin vc:(UIViewController *)vc affirmAction:(VoidBlock)affirmAction cancelAction:(VoidBlock)cancelAction {
    ASHeadPopRemindView *alertView = [[ASHeadPopRemindView alloc] initHeadPopViewWithCoin:coin];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:vc.view completion:NULL];
    popupController.didDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        //关闭弹窗的时候调用，弹出其他的弹窗
        cancelAction();
    };
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^{
        [wPopupController dismiss];
        affirmAction();
    };
}

//分享view
+ (void)popUMShareViewWithBody:(ASWebJsBodyModel *)bodyModel
                        action:(void(^)(UMSocialPlatformType platformType, id  _Nonnull value))affirmAction {
    ASUMShareAlertView *alertView = [[ASUMShareAlertView alloc] init];
    alertView.bodyModel = bodyModel;
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    popupController.layoutType = zhPopupLayoutTypeBottom;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^(UMSocialPlatformType platformType, id  _Nonnull value) {
        affirmAction(platformType, value);
        [wPopupController dismiss];
    };
    alertView.cancelBlock = ^{
        [wPopupController dismiss];
    };
}

//优质用户
+ (zhPopupController *)popGoodAnchorWithModel:(ASGoodAnchorModel *)model {
    ASGoodAnchorPopView *alertView = [[ASGoodAnchorPopView alloc] init];
    alertView.model = model;
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    popupController.dismissOnMaskTouched = NO;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    //监听到弹窗关闭以后，执行下次弹窗逻辑
    popupController.didDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        //弹窗结束后进行倒计时
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goodAnchorConfigNotification" object:nil];
    };
    alertView.cancelBlock = ^() {
        [wPopupController dismiss];
    };
    return popupController;
}

//小助手弹窗
+ (void)popMatchHelperListViewModel:(ASFateHelperStatusModel *)model refreshAction:(VoidBlock)refreshAction {
    ASMatchHelperPopView *alertView = [[ASMatchHelperPopView alloc] init];
    alertView.model = model;
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    popupController.layoutType = zhPopupLayoutTypeBottom;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.cancelBlock = ^() {
        [wPopupController dismiss];
    };
    //刷新
    alertView.refreshBlock = ^{
        refreshAction();
    };
}

+ (void)popVideoShowRemindPopViewWithVc:(UIViewController *)vc affirmAction:(VoidBlock)affirmAction cancelBlock:(VoidBlock)cancelBlock {
    ASVideoShowRemindPopView *alertView = [[ASVideoShowRemindPopView alloc] init];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:vc.view completion:NULL];
    popupController.didDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        //关闭弹窗的时候调用，弹出其他的弹窗
        cancelBlock();
    };
    __weak typeof(popupController) wPopupController = popupController;
    alertView.cancelBlock = ^() {
        [wPopupController dismiss];
    };
    alertView.affirmBlock = ^{
        affirmAction();
        [wPopupController dismiss];
    };
}

//女用户领取礼物
+ (void)vipReceiveGiftPopWithModel:(ASGiftListModel *)model affirmAction:(VoidBlock)affirmAction {
    ASReceiveGiftPopView *alertView = [[ASReceiveGiftPopView alloc] initReceiveGiftPopViewWithModel:model];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.cancelBlock = ^() {
        [wPopupController dismiss];
    };
    alertView.affirmBlock = ^{
        affirmAction();
        [wPopupController dismiss];
    };
}
//赠送vip弹窗
+ (void)sendVipPopViewWithModel:(ASSendVipModel *)model toUserID:(NSString *)toUserID {
    ASSendVipPopView *alertView = [[ASSendVipPopView alloc] init];
    alertView.sendVipModel = model;
    alertView.toUserID = toUserID;
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    popupController.layoutType = zhPopupLayoutTypeBottom;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.cancelBlock = ^() {
        [wPopupController dismiss];
    };
}

//用户通知弹窗-是否弹出
+ (void)centerPopNoticeViewWithModel:(ASCenterNotifyModel *)model vc:(UIViewController *)vc cancelBlock:(VoidBlock)cancelBlock {
    ASCenterNotifyWebPopView *alertView = [[ASCenterNotifyWebPopView alloc] initCenterNotifyWebWithModel:model];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    popupController.dismissOnMaskTouched = NO;
    [popupController showInView:vc.view completion:NULL];
    popupController.didDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        //关闭弹窗的时候调用，弹出其他的弹窗
        cancelBlock();
    };
    __weak typeof(popupController) wPopupController = popupController;
    alertView.closeBlock = ^{
        [wPopupController dismiss];
    };
}

//提现弹窗
+ (void)popWithdrawHintViewWithContent:(NSString *)content isProtocol:(BOOL)isProtocol indexAction:(IndexNameBlock)indexAction {
    ASWithdrawHintView *alertView = [[ASWithdrawHintView alloc] initDrawHintViewWithContent:content isProtocol:isProtocol];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    popupController.dismissOnMaskTouched = NO;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.cancelBlock = ^() {
        [wPopupController dismiss];
    };
    alertView.affirmBlock = ^(NSString * _Nonnull type) {
        indexAction(type);
        [wPopupController dismiss];
    };
}

//新人礼物
+ (void)newUserGiftWithModel:(ASNewUserGiftModel *)model vc:(UIViewController *)vc closeAction:(VoidBlock)closeAction {
    ASNewUserPopView *alertView = [[ASNewUserPopView alloc] initNewUserGiftViewWithModel:model];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:vc.view completion:NULL];
    popupController.didDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        //关闭弹窗的时候调用，弹出其他的弹窗
        closeAction();
    };
    __weak typeof(popupController) wPopupController = popupController;
    alertView.closeBlock = ^{
        [wPopupController dismiss];
    };
}

//手机绑定弹窗
+ (void)popPhoneBindAlertViewWithVc:(UIViewController *)vc
                            content:(NSString *)content
                        isPopWindow:(BOOL)isPopWindow
                       affirmAction:(VoidBlock)affirmAction
                        cancelBlock:(VoidBlock)cancelBlock {
    ASBindPhoneAlertView *alertView = [[ASBindPhoneAlertView alloc]initBindPhonePopWithContent:content];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:isPopWindow ? kCurrentWindow : vc.view completion:NULL];
    popupController.didDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        //关闭弹窗的时候调用，弹出其他的弹窗
        cancelBlock();
    };
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^{
        [wPopupController dismiss];
        affirmAction();
    };
    alertView.closeBlock = ^{
        [wPopupController dismiss];
    };
}

//微信绑定弹窗
+ (void)popWXBindAlertViewWithVc:(UIViewController *)vc affirmAction:(VoidBlock)affirmAction cancelBlock:(VoidBlock)cancelBlock {
    ASBindWechatAlertView *alertView = [[ASBindWechatAlertView alloc] init];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:vc.view completion:NULL];
    popupController.didDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        //关闭弹窗的时候调用，弹出其他的弹窗
        cancelBlock();
    };
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^{
        [wPopupController dismiss];
        affirmAction();
    };
    alertView.closeBlock = ^{
        [wPopupController dismiss];
    };
}

//分享海报弹窗
+ (void)popInvitePosterViewWithBody:(ASWebJsBodyModel *)bodyModel affirmAction:(VoidBlock)affirmAction {
    ASInvitePosterAlertView *alertView = [[ASInvitePosterAlertView alloc] init];
    alertView.bodyModel = bodyModel;
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:kCurrentWindow completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^{
        [wPopupController dismiss];
        affirmAction();
    };
    alertView.cancelBlock = ^{
        [wPopupController dismiss];
    };
}

//活动弹窗
+ (void)popActivityWithModel:(ASBannerModel *)model
                          vc:(UIViewController *)vc
                 isPopWindow:(BOOL)isPopWindow
                affirmAction:(VoidBlock)affirmAction
                 cancelBlock:(VoidBlock)cancelBlock {
    ASActivityPopView *alertView = [[ASActivityPopView alloc] initActivityPopWithModel:model];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    popupController.dismissOnMaskTouched = NO;
    [popupController showInView:isPopWindow ? kCurrentWindow : vc.view completion:NULL];
    __weak typeof(popupController) wPopupController = popupController;
    alertView.affirmBlock = ^{
        [wPopupController dismiss];
        affirmAction();
    };
    alertView.cancelBlock = ^{
        [wPopupController dismiss];
        cancelBlock();
    };
}

//IM搭讪引导
+ (void)imDashanDemonstrationPopViewWithVc:(UIViewController *)vc CancelBlock:(VoidBlock)cancelBlock {
    ASIMDemonstrationPopView *alertView = [[ASIMDemonstrationPopView alloc] init];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.presentationTransformScale = 1.25;
    popupController.dismissonTransformScale = 0.85;
    [popupController showInView:vc.view completion:NULL];
    popupController.didDismissBlock = ^(zhPopupController * _Nonnull popupController) {
        //关闭弹窗的时候调用，弹出其他的弹窗
        cancelBlock();
    };
    __weak typeof(popupController) wPopupController = popupController;
    alertView.cancelBlock = ^{
        [wPopupController dismiss];
    };
}
@end
