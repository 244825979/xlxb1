//
//  ASPopViewManager.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASPopViewManager.h"
#import "ASSetTeenagerPwdController.h"
#import "ASSetRequest.h"
#import "ASSetTeenagerForgetPwdController.h"
#import "ASSetTeenagerHomeController.h"
#import "ASHomeRequest.h"
#import "ASFirstPayDataModel.h"
#import "ASRecommendUserModel.h"
#import "ASNewUserGiftModel.h"
#import "ASUserVideoPopModel.h"
#import "ASMineController.h"//个人首页
#import "ASIMListController.h"//消息首页
#import "ASDynamicController.h"//动态首页
#import "ASVideoShowRequest.h"
#import "ASVideoShowDemonstrationController.h"
#import "ASEditDataController.h"
#import "ASMineRequest.h"
#import "ASBaseAlertViewController.h"

@interface ASPopViewManager ()
@property (nonatomic, strong) zhPopupController *userVideoPushPopView;//用户来电弹窗
@property (nonatomic, strong) zhPopupController *goodAnchorPopView;//优质用户弹窗
/**数据**/
@property (nonatomic, strong) RACDisposable *goodAnchorDisposable;//优质用户弹窗计时器
@property (nonatomic, assign) NSInteger goodAnchorTimes;//优质用户弹窗倒计时时间
@property (nonatomic, assign) BOOL isDisposable;//是否在进行倒计时
@end

@implementation ASPopViewManager

+ (ASPopViewManager *)shared {
    static dispatch_once_t onceToken;
    static ASPopViewManager *shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

//删除所有弹窗
- (void)removePopView {
    if (self.userVideoPushPopView != nil) {
        [self.userVideoPushPopView dismiss];
    }
    if (self.goodAnchorPopView != nil) {
        [self.goodAnchorPopView dismiss];
    }
    [self.goodAnchorDisposable dispose];
    self.isDisposable = NO;
    self.popGoodAnchorState = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"goodAnchorConfigNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//首页弹窗管理
- (void)homePopViewWithVc:(UIViewController *)vc complete:(VoidBlock)complete {
    ASBaseAlertViewController *alertVc = [[ASBaseAlertViewController alloc] init];
    ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:alertVc];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen; //覆盖全屏
    [vc presentViewController:nav animated:NO completion:nil];
    [alertVc homePopViewWithComplete:^{
        complete();
        [[ASPopViewManager shared] requestGoodAnchorWithIsFirst:YES complete:^{//优质女用户
            
        }];
    }];
}

//我的页面进行有序弹窗
- (void)minePopViewWithVc:(UIViewController *)vc complete:(VoidBlock)complete {
    //我的页面的弹窗管理控制器
    ASBaseAlertViewController *alertVc = [[ASBaseAlertViewController alloc] init];
    ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:alertVc];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen; //覆盖全屏
    [vc presentViewController:nav animated:NO completion:nil];
    [alertVc minePopViewWithComplete:^{
        complete();
    }];
}

//开启青少年模式弹窗
- (void)isOpenTeenagerPopWithVc:(UIViewController *)vc complete:(VoidBlock)complete {
    kWeakSelf(self);
    [ASSetRequest requestTeenagerStateWithSuccess:^(NSDictionary * _Nullable data) {
        NSNumber *isSetAdoblescent = data[@"is_set_adolescent"];
        //YES表示开启了未成年模式
        if (isSetAdoblescent.boolValue == YES) {
            [wself closeTeenagerPop];
        } else {
            //弹窗提示用户开启未成年弹窗
            NSNumber *is_open_first_pop = data[@"is_open_first_pop"];//后台开启了引导青少年开启弹窗
            if (is_open_first_pop.integerValue == 1) {
                //保存状态，是否弹窗状态。
                NSString *isLoginPopAlert = [ASUserDefaults valueForKey:[NSString stringWithFormat:@"%@_%@", STRING(USER_INFO.user_id), kIsPopLoginTeenagerView]];
                if (isLoginPopAlert.integerValue == 0 || kStringIsEmpty(isLoginPopAlert)) {//如果是刚登录，就弹窗
                    [ASAlertViewManager popOpenTeengaerWithVc:vc cancelAction:^{
                        complete();
                    } openAction:^{
                        ASSetTeenagerHomeController *setVc = [[ASSetTeenagerHomeController alloc] init];
                        [vc.navigationController pushViewController:setVc animated:YES];
                    }];
                } else {
                    complete();
                }
            } else {
                complete();
            }
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        complete();
    }];
}

- (void)closeTeenagerPop {
    kWeakSelf(self);
    [ASAlertViewManager popCloseTeengaerWithAction:^{
        ASSetTeenagerPwdController *vc = [[ASSetTeenagerPwdController alloc] init];
        vc.type = kTeenagerPwdClose;
        vc.backBlock = ^(BOOL isClose) {
            if (isClose == NO) {
                [wself closeTeenagerPop];
            }
        };
        [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
    } forgetPwdAction:^{//忘记密码
        ASSetTeenagerForgetPwdController *vc = [[ASSetTeenagerForgetPwdController alloc] init];
        vc.closeBlock = ^(BOOL isClose) {
            if (isClose == NO) {
                [wself closeTeenagerPop];
            }
        };
        [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
    }];
}

//视频来电推送
- (void)requestUserVideoPush {
    kWeakSelf(self);
    [ASCommonRequest requestUserVideoPopPushSuccess:^(id  _Nullable data) {
        ASUserVideoPopModel *model = data;
        if (model.is_show == NO) {
            return;
        }
        //储存当前视频推送弹窗的时间，同时加上下次可弹秒数
        NSString *timeStr = [ASCommonFunc currentTimeStr];
        NSInteger time = timeStr.integerValue + model.time_limit;
        [ASUserDefaults setValue:[NSString stringWithFormat:@"%zd", time] forKey:@"userVideoPushPopViewTime"];
        //弹出确定是否是指定的页面
        if ([[ASCommonFunc currentVc] isKindOfClass: [ASMineController class]] ||
            [[ASCommonFunc currentVc] isKindOfClass: [ASIMListController class]] ||
            [[ASCommonFunc currentVc] isKindOfClass: [ASDynamicController class]]) {
            wself.userVideoPushPopView = [ASAlertViewManager popCallVideoPushViewWithModel:model cancelAction:^{
                
            }];
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

//更新弹窗
- (void)requestAppVersionPopViewWithVc:(UIViewController *)vc complete:(VoidBlock)complete {
    [ASCommonRequest requestAppVersionSuccess:^(id _Nullable data) {
        ASVersionModel *vsersionModel = data;
        NSInteger isPop = [ASCommonFunc compareVersion:vsersionModel.newversion toVersion:STRING(kAppVersion)];
        if (isPop && !kStringIsEmpty(vsersionModel.newversion)) {
            [ASAlertViewManager popAppVersionWithModel:vsersionModel vc:vc cancelAction:^{
                complete();
            }];
        } else {
            complete();
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        complete();
    }];
}

//缘分推荐
- (void)requestRecommendUserWithVc:(UIViewController *)vc complete:(VoidBlock)complete {
    if (USER_INFO.gender == 1) {
        complete();
        return;
    }
    [ASCommonRequest requestRecommendUserWithScene:0 isHUD:NO success:^(id _Nullable data) {
        ASRecommendUserListModel *model = data;
        NSArray *list = model.list;
        if (list.count > 0) {
            [ASAlertViewManager popDayRecommendViewWithModel:model vc:vc cancelAction:^{
                complete();
            }];
        } else {
            complete();
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        complete();
    }];
}

//首充
- (void)firstPayViewPop {
    [ASHomeRequest requestFirstPayData:YES success:^(id  _Nullable data) {
        ASFirstPayDataModel *model = data;
        if (model.list.count > 0) {
            [ASAlertViewManager popFirstPayViewWithModel:model cancelAction:^{
                
            }];
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

//优质女用户
- (void)requestGoodAnchorWithIsFirst:(BOOL)isFirst complete:(VoidBlock)complete {
    kWeakSelf(self);
    if (USER_INFO.gender == 1) {
        complete();
        return;
    }
    if (kAppType == 1) {
        complete();
        return;
    }
    if (USER_INFO.systemIndexModel.goodAnchorConfig.isValid == 0) {
        complete();
        return;
    }
    if (isFirst) {
        //监听优质用户弹窗
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodAnchorConfigNotification:) name:@"goodAnchorConfigNotification" object:nil];
        self.popGoodAnchorState = 0;
        //延迟执行获取未读消息数据
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, USER_INFO.systemIndexModel.goodAnchorConfig.afterFirstLoginTime * NSEC_PER_SEC);
        dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
            if (USER_INFO.isLogin == NO) {
                complete();
                return;
            }
            if ([ASMyAppCommonFunc isTabHomeViewController] == NO) {
                wself.popGoodAnchorState = 1;//倒计时结束了，但是没弹出
                complete();
                return;
            }
            [ASCommonRequest requestGoodAnchorIndexSuccess:^(ASGoodAnchorModel * _Nullable data) {
                if (!kStringIsEmpty(data.uid)) {
                    if ([ASMyAppCommonFunc isTabHomeViewController] == YES) {
                        wself.popGoodAnchorState = 2;//倒计时结束了，进行了首次弹出
                        wself.goodAnchorPopView = [ASAlertViewManager popGoodAnchorWithModel:data];
                    }
                }
                complete();
            } errorBack:^(NSInteger code, NSString *msg) {
                complete();
            }];
        });
    } else {
        [ASCommonRequest requestGoodAnchorIndexSuccess:^(ASGoodAnchorModel * _Nullable data) {
            if (!kStringIsEmpty(data.uid)) {
                if ([ASMyAppCommonFunc isTabHomeViewController] == YES) {
                    wself.popGoodAnchorState = 2;
                    wself.goodAnchorPopView = [ASAlertViewManager popGoodAnchorWithModel:data];
                }
            }
            complete();
        } errorBack:^(NSInteger code, NSString *msg) {
            complete();
        }];
    }
}

- (void)goodAnchorConfigNotification:(NSNotification *)notification {
    kWeakSelf(self);
    if (self.popGoodAnchorState == 1) {
        //进行弹窗
        [[ASPopViewManager shared] requestGoodAnchorWithIsFirst:NO complete:^{
            
        }];
    } else if (self.popGoodAnchorState == 2) {
        if (USER_INFO.gender == 1) {
            return;
        }
        if (kAppType == 1) {
            return;
        }
        if (USER_INFO.systemIndexModel.goodAnchorConfig.isValid == 0) {
            return;
        }
        //B面且为男用户且有优质弹窗
        if (self.isDisposable == NO && USER_INFO.systemIndexModel.goodAnchorConfig.onlineEveryTimes > 0) {
            self.isDisposable = YES;
            self.goodAnchorTimes = USER_INFO.systemIndexModel.goodAnchorConfig.onlineEveryTimes;
            self.goodAnchorDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
                wself.goodAnchorTimes--;
                if ([ASMyAppCommonFunc isTabHomeViewController] == NO) {
                    /* 关闭计时器 */
                    [wself.goodAnchorDisposable dispose];
                    wself.isDisposable = NO;
                }
                if (USER_INFO.isLogin == NO) {
                    /* 关闭计时器 */
                    [wself.goodAnchorDisposable dispose];
                    wself.isDisposable = NO;
                }
                if (wself.goodAnchorTimes == 0) {
                    /* 关闭计时器 */
                    [wself.goodAnchorDisposable dispose];
                    wself.isDisposable = NO;
                    //进行弹窗
                    [[ASPopViewManager shared] requestGoodAnchorWithIsFirst:NO complete:^{
                        
                    }];
                }
            }];
        }
    }
}

//新人礼包
- (void)requestNewUserGiftWithVc:(UIViewController *)vc complete:(VoidBlock)complete {
    if (USER_INFO.gender == 2) {
        complete();
        return;
    }
    [ASLoginRequest requestNewUserGiftBagSuccess:^(id _Nullable data) {
        ASNewUserGiftModel *model = data;
        if (kObjectIsEmpty(model) || model.list.count == 0) {
            complete();
        } else {
            [ASAlertViewManager newUserGiftWithModel:model vc:vc closeAction:^{
                complete();
            }];
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        complete();
    }];
}

//活动配置弹窗 此弹窗始终在最后一层
- (void)activityPopWithPlacement:(NSInteger)placement
                              vc:(UIViewController *)vc
                     isPopWindow:(BOOL)isPopWindow
                    affirmAction:(VoidBlock)affirmAction
                     cancelBlock:(VoidBlock)cancelBlock {
    [ASCommonRequest requestActivityPopupWithPlacement:placement success:^(ASBannerModel *model) {
        if (!kStringIsEmpty(model.link_url)) {
            [ASAlertViewManager popActivityWithModel:model vc:vc isPopWindow:isPopWindow affirmAction:^{
                [ASMyAppCommonFunc activityPopStatisticsWithUrl:model.link_url eventType:3 placement:placement];
                [ASMyAppCommonFunc bannerClikedWithBannerModel:model viewController:vc action:^(id  _Nonnull data) {
                    
                }];
                affirmAction();
            } cancelBlock:^{
                cancelBlock();
                [ASMyAppCommonFunc activityPopStatisticsWithUrl:model.link_url eventType:2 placement:placement];
            }];
        } else {
            cancelBlock();
        }
    } errorBack:^(NSInteger code, NSString * _Nonnull message) {
        cancelBlock();
    }];
}

//我的页面：视频秀发布引导提示
- (void)requestVideoShowRemindWithVc:(UIViewController *)vc complete:(VoidBlock)complete {
    if (USER_INFO.gender == 2) {
        complete();
        return;
    }
    NSString *home = NSHomeDirectory();
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"videoShowPopData.plist"];
    //获取是否弹出用户的字典数据
    NSMutableDictionary *videoShowPopDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    NSString *saveDay = videoShowPopDict[STRING(USER_INFO.user_id)];//保存到数据库的时间
    NSString *today = [ASCommonFunc getTimeWithFormat:@"YYYY-MM-dd"];//今天时间
    if ([STRING(today) isEqualToString:STRING(saveDay)] && !kStringIsEmpty(today)) {//今天如果时间一致，就不再请求
        complete();
        return;
    }
    //视频秀提醒框，需要判断是否当天执行
    [ASVideoShowRequest requestVideoShowRemindSuccess:^(id  _Nullable data) {
        NSNumber *remind = data;
        if (remind.boolValue == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ASAlertViewManager popVideoShowRemindPopViewWithVc:vc affirmAction:^{
                    ASVideoShowDemonstrationController *videoShowVc = [[ASVideoShowDemonstrationController alloc]init];
                    [vc.navigationController pushViewController:videoShowVc animated:YES];
                } cancelBlock:^{
                    complete();
                }];
            });
        } else {
            complete();
        }
        //保存更新plist数据库存储的时间信息
        NSString *key = STRING(USER_INFO.user_id);
        NSString *value = STRING(today);
        if (kObjectIsEmpty(videoShowPopDict)) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:value forKey:key];//新增覆盖当天数据
            [dict writeToFile:filePath atomically:YES];//写入到plist数据库
        } else {
            [videoShowPopDict setValue:value forKey:key];//新增覆盖当天数据
            [videoShowPopDict writeToFile:filePath atomically:YES];//写入到plist数据库
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        complete();
    }];
}

//我的页面：头像引导提醒
- (void)headerPopRemindWithVc:(UIViewController *)vc complete:(VoidBlock)complete {
    //男用户头像是否完成引导用户
    if (USER_INFO.gender == 1 || USER_INFO.is_avatar_task_finish == 1) {
        complete();
        return;
    }
    //获取上次弹出头像引导弹窗时间
    NSString *home = NSHomeDirectory();
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"headerPopRemindData.plist"];//存储头像引导时间的plist
    //获取是否弹出用户的字典数据
    NSMutableDictionary *headerPopPopDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    NSString *saveDay = headerPopPopDict[STRING(USER_INFO.user_id)];//获取之前保存到数据库的时间
    NSString *today = [ASCommonFunc getTimeWithFormat:@"YYYY-MM-dd"];//拿到当前时间
    if ([STRING(today) isEqualToString:STRING(saveDay)] && !kStringIsEmpty(today)) {//今天如果时间一致，就不再执行
        complete();
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [ASAlertViewManager popHeadViewWithCoin:USER_INFO.avatar_task_reward_coin vc:vc affirmAction:^{
            ASEditDataController *edictVc = [[ASEditDataController alloc] init];
            [vc.navigationController pushViewController:edictVc animated:YES];
        } cancelAction:^{
            complete();
        }];
    });
    //弹窗后，进行今天的数据保存到本地覆盖
    NSString *key = STRING(USER_INFO.user_id);
    NSString *value = STRING(today);
    if (kObjectIsEmpty(headerPopPopDict)) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:value forKey:key];//新增覆盖当天数据
        [dict writeToFile:filePath atomically:YES];//写入到plist数据库
    } else {
        [headerPopPopDict setValue:value forKey:key];//新增覆盖当天数据
        [headerPopPopDict writeToFile:filePath atomically:YES];//写入到plist数据库
    }
}

//获取是否弹出须知弹窗
- (void)requestXuzhiPopWithVc:(UIViewController *)vc complete:(VoidBlock)complete {
    [ASMineRequest requestIsPopNoticeWithSuccess:^(id _Nullable model) {
        ASCenterNotifyModel *notifyModel = model;
        if (notifyModel.isPop == 1) {
            [ASAlertViewManager centerPopNoticeViewWithModel:model vc:vc cancelBlock:^{
                complete();
            }];
        } else {
            complete();
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        complete();
    }];
}

//弹出绑定提醒
- (void)requestPopBindWithVc:(UIViewController *)vc complete:(VoidBlock)complete {
    //是否弹出绑定弹窗
    [ASMineRequest requestIsPopBindAlertWithSuccess:^(id  _Nonnull response) {
        NSNumber *wechatStatus = response[@"wechat_status"];
        NSNumber *mobileStatus = response[@"mobile_status"];
        if (wechatStatus.intValue == 1) {
            [ASAlertViewManager popWXBindAlertViewWithVc:vc affirmAction:^{
                [[ASLoginManager shared] weChatBindWithSuccess:^(id  _Nonnull response) {
                    kShowToast(@"绑定成功，可直接用微信号登录此账号");
                }];
            } cancelBlock:^{
                complete();
            }];
        }
        if (mobileStatus.intValue == 1) {
            [[ASLoginManager shared] TX_BindPhonePopViewWithController:vc isPopWindow:NO close:^{
                complete();
            }];
        }
        if (wechatStatus.intValue == 0 && mobileStatus.intValue == 0) {
            complete();
        }
    } errorBack:^(NSInteger code, NSString * _Nonnull message) {
        complete();
    }];
}
@end
