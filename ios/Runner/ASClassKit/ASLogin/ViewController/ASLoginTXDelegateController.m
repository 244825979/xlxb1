//
//  ASLoginTXDelegateController.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASLoginTXDelegateController.h"

@interface ASLoginTXDelegateController ()

@end

@implementation ASLoginTXDelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark -- UAFSDKLoginDelegate 腾讯一键登录SDK的事件监听，腾讯必须要一个控制器接收代理
//1、获取隐私协议的勾选框状态的回调方法：
- (void)authViewPrivacyCheckboxStateToggled:(BOOL)checked {
    self.isChecked = checked;
    if (self.txProtocolBlock) {
        self.txProtocolBlock(checked);
    }
}

//2、提供登录事件回调方法。需配合 ignorePrivacyState方法，实现用户未勾选隐私协议时，弹窗二次提醒用户同意登录的 需求。
- (void)authRequestWillStart:(void(^)(BOOL))loginEvent {
    if (self.isChecked == YES) {
        loginEvent(YES);
        return;
    }
    if (self.isPop == NO) {
        loginEvent(NO);
        if (self.txProtocolBlock) {
            self.txProtocolBlock(NO);
        }
        return;
    }
    NSMutableAttributedString *attributedString = [ASTextAttributedManager userProtocolPopAgreement:^{
        //用户协议
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_UserProtocol];
        ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationPageSheet;
        [[ASCommonFunc currentVc] presentViewController:nav animated:YES completion:nil];
    } privacyProtocol:^{
        //隐私协议
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Privacy];
        ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationPageSheet;
        [[ASCommonFunc currentVc] presentViewController:nav animated:YES completion:nil];
    }];
    [ASAlertViewManager protocolPopTitle:@"用户协议和隐私政策"
                              cancelText:@"不同意并退出"
                              cancelFont:nil
                    dismissOnMaskTouched:NO
                              attributed:attributedString
                            affirmAction:^{
        [ASMsgTool showLoading];
        loginEvent(YES);
    } cancelAction:^{
        loginEvent(NO);
        ASLog(@"-----不同意协议---");
    }];
    ASLog(@"提供登录事件回调方法。需配合 ignorePrivacyState方法，实现用户未勾选隐私协议时，弹窗二次提醒用户同意登录的需求。");
}

@end
