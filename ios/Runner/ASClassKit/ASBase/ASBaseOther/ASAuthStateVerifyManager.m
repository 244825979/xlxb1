//
//  ASAuthStateVerifyManager.m
//  AS
//
//  Created by SA on 2025/4/21.
//

#import "ASAuthStateVerifyManager.h"
#import "ASCertificationOneController.h"
#import "ASAuthHomeController.h"

@implementation ASAuthStateVerifyManager

+ (ASAuthStateVerifyManager *)shared {
    static dispatch_once_t onceToken;
    static ASAuthStateVerifyManager *shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

- (void)isCertificationState:(AuthStateType)type succeed:(VoidBlock)succeed {
    [[ASCommonFunc currentVc].view endEditing:YES];
    if (kAppType == 1) {
        succeed();
        return;
    }
    if (USER_INFO.gender == 1) {//女用户执行
        if (USER_INFO.is_rp_auth != 1) {//真人认证审核中
            switch (type) {
                case kRpAuthDefaultPop:
                case kRpAuthPopBindAccount:
                {
                    if (USER_INFO.is_rp_auth == 2) {
                        [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"心聊想伴致力于提供一个真实陪聊平台，真人认证审核中，请耐心等待通过后再试~" left:@"催审" right:@"取消" affirmAction:^{
                            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                            vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Customer];
                            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                        } cancelAction:^{
                            
                        }];
                    } else {
                        [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"请完成真人认证~" left:@"去认证" right:@"暂不认证" affirmAction:^{
                            ASAuthHomeController *vc = [[ASAuthHomeController alloc]init];
                            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                        } cancelAction:^{
                            
                        }];
                    }
                }
                    break;
                case kRpAuthDaShanPop:
                {
                    if (USER_INFO.is_rp_auth == 2) {
                        [ASAlertViewManager defaultPopTitle:@"真人认证" content:@"心聊想伴提倡真实交友，等待【真人认证】通过后才可以搭讪~" left:@"催审" right:@"取消" affirmAction:^{
                            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                            vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Customer];
                            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                        } cancelAction:^{
                            
                        }];
                    } else {
                        [ASAlertViewManager defaultPopTitle:@"真人认证" content:@"心聊想伴提倡真实交友，完成【真人认证】后才可以搭讪~" left:@"去认证" right:@"暂不认证" affirmAction:^{
                            ASAuthHomeController *vc = [[ASAuthHomeController alloc]init];
                            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                        } cancelAction:^{
                            
                        }];
                    }
                }
                    break;
                case kRpAuthPopEarnings:
                case kRpAuthPopMakeFriends:
                {
                    if (USER_INFO.is_rp_auth == 2) {
                        [ASAlertViewManager defaultPopTitle:@"真人认证" content:@"心聊想伴提倡真实交友，通过【真人认证】后才可以心动交友哦~" left:@"催审" right:@"取消" affirmAction:^{
                            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                            vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Customer];
                            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                        } cancelAction:^{
                            
                        }];
                    } else {
                        [ASAlertViewManager defaultPopTitle:@"真人认证" content:@"心聊想伴提倡真实交友，完成【真人认证】后才可以心动交友哦~" left:@"去认证" right:@"暂不认证" affirmAction:^{
                            ASAuthHomeController *vc = [[ASAuthHomeController alloc]init];
                            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                        } cancelAction:^{
                            
                        }];
                    }
                }
                    break;
                case kRpAuthDefaultNotIDCard:
                {
                    if (USER_INFO.is_rp_auth == 2) {
                        [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"请等待真人认证审核结果，或者联系客服催审~" left:@"催审" right:@"取消" affirmAction:^{
                            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                            vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Customer];
                            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                        } cancelAction:^{
                            
                        }];
                    } else {
                        [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"请先完成真人认证~" left:@"去认证" right:@"暂不认证" affirmAction:^{
                            ASAuthHomeController *vc = [[ASAuthHomeController alloc]init];
                            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                        } cancelAction:^{
                            
                        }];
                    }
                }
                    break;
                case kRpAuthPopVideoShow:
                {
                    if (USER_INFO.is_rp_auth == 2) {
                        [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"请等待真人认证审核结果，或者联系客服催审~" left:@"催审" right:@"取消" affirmAction:^{
                            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                            vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Customer];
                            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                        } cancelAction:^{
                            
                        }];
                    } else {
                        [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"请先完成真人认证，才可以上传视频秀哦~" left:@"去认证" right:@"暂不认证" affirmAction:^{
                            ASAuthHomeController *vc = [[ASAuthHomeController alloc]init];
                            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                        } cancelAction:^{
                            
                        }];
                    }
                }
                    break;
                case kRpAuthPopIDCard:
                {
                    if (USER_INFO.is_rp_auth == 2) {
                        [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"请等待真人认证审核结果，或者联系客服催审~" left:@"催审" right:@"取消" affirmAction:^{
                            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                            vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Customer];
                            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                        } cancelAction:^{
                            
                        }];
                    } else {
                        [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"请先完成真人认证~" left:@"去认证" right:@"暂不认证" affirmAction:^{
                            ASCertificationOneController *vc = [[ASCertificationOneController alloc]init];
                            vc.userAvatar = USER_INFO.avatar;
                            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                        } cancelAction:^{
                            
                        }];
                    }
                }
                default:
                    break;
            }
        } else {
            if (USER_INFO.is_auth != 1 &&
                type != kRpAuthDefaultNotIDCard &&
                type != kRpAuthPopEarnings &&
                type != kRpAuthPopVideoShow &&
                type != kRpAuthPopIDCard) {//如果未实名认证，且是在认证页点击
                [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"请完成实名认证~" left:@"立即认证" right:@"暂不认证" affirmAction:^{
                    ASAuthHomeController *vc = [[ASAuthHomeController alloc]init];
                    [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                } cancelAction:^{
                    
                }];
            } else {
                succeed();
            }
        }
    } else {
        if (USER_INFO.is_auth != 1 && type == kRpAuthPopBindAccount) {//如果未实名认证，且点击绑定账号
            [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"请完成实名认证~" left:@"立即认证" right:@"暂不认证" affirmAction:^{
                ASAuthHomeController *vc = [[ASAuthHomeController alloc]init];
                [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
            } cancelAction:^{
                
            }];
        } else {
            succeed();
        }
    }
}
@end
