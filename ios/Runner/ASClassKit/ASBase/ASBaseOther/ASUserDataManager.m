//
//  ASUserDataManager.m
//  AS
//
//  Created by SA on 2025/4/10.
//

#import "ASUserDataManager.h"
#import <UserNotifications/UserNotifications.h>
#import "心聊想伴-Swift.h"

@implementation ASUserDataManager

+ (ASUserDataManager *)shared {
    static dispatch_once_t onceToken;
    static ASUserDataManager *instance = nil;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[ASUserDataManager alloc] init];
        }
    });
    return instance;
}

/** 是否登录 */
- (BOOL)isLogin {
    if (!kStringIsEmpty(self.token) && !kStringIsEmpty(self.user_id)) {
        //资料完成了
        if (self.finish_status == 1) {
            return YES;
        }
    }
    return NO;
}

// 登录成功用户数据保存到本地
- (void)saveUserDataWithModel:(ASUserInfoModel *)userModel
                     complete:(VoidBlock)complete {
    self.usercode = userModel.usercode;
    self.nickname = userModel.nickname;
    self.sign = userModel.sign;
    self.type = userModel.type;
    self.mobile = userModel.mobile;
    self.avatar = userModel.avatar;
    self.gender = userModel.gender;
    self.age = userModel.age;
    self.birthday = userModel.birthday;
    self.city = userModel.city;
    self.finish_status = userModel.finish_status;
    self.invite_id = userModel.invite_id;
    self.im_token = userModel.im_token;
    self.is_anchor = userModel.is_anchor;
    self.voice = userModel.voice.voice;
    self.voice_time = userModel.voice.voice_time;
    self.is_auth = userModel.is_auth;
    self.is_rp_auth = userModel.is_rp_auth;
    self.vip_icon = userModel.vip_icon;
    self.vip = userModel.vip;
    self.token = userModel.token;
    self.user_id = userModel.user_id;
    [ASUserDefaults setValue:self.usercode forKey:@"userinfo_usercode"];
    [ASUserDefaults setValue:self.nickname forKey:@"userinfo_nickname"];
    [ASUserDefaults setValue:self.sign forKey:@"userinfo_sign"];
    [ASUserDefaults setValue:@(self.type) forKey:@"userinfo_type"];
    [ASUserDefaults setValue:self.mobile forKey:@"userinfo_mobile"];
    [ASUserDefaults setValue:self.avatar forKey:@"userinfo_avatar"];
    [ASUserDefaults setValue:@(self.gender) forKey:@"userinfo_gender"];
    [ASUserDefaults setValue:@(self.age) forKey:@"userinfo_age"];
    [ASUserDefaults setValue:self.birthday forKey:@"userinfo_birthday"];
    [ASUserDefaults setValue:self.city forKey:@"userinfo_city"];
    [ASUserDefaults setValue:@(self.finish_status) forKey:@"userinfo_finish_status"];
    [ASUserDefaults setValue:@(self.invite_id) forKey:@"userinfo_invite_id"];
    [ASUserDefaults setValue:self.im_token forKey:@"userinfo_im_token"];
    [ASUserDefaults setValue:@(self.is_anchor) forKey:@"userinfo_is_anchor"];
    [ASUserDefaults setValue:self.voice forKey:@"userinfo_voice"];
    [ASUserDefaults setValue:@(self.voice_time) forKey:@"userinfo_voice_time"];
    [ASUserDefaults setValue:@(self.is_auth) forKey:@"userinfo_is_auth"];
    [ASUserDefaults setValue:@(self.is_rp_auth) forKey:@"userinfo_is_rp_auth"];
    [ASUserDefaults setValue:self.vip_icon forKey:@"userinfo_vip_icon"];
    [ASUserDefaults setValue:@(self.vip) forKey:@"userinfo_vip"];
    [ASUserDefaults setValue:self.token forKey:@"userinfo_token"];
    [ASUserDefaults setValue:self.user_id forKey:@"userinfo_user_id"];
    //登录云信
    kWeakSelf(self);
    [[ASIMManager shared] NELoginWithAccount:kStringIsEmpty(USER_INFO.user_id) ? userModel.user_id : USER_INFO.user_id
                                       token:kStringIsEmpty(USER_INFO.im_token) ? userModel.im_token : USER_INFO.im_token succeed:^{
        //重新再获取一次system数据
        [wself requestSystemIndex:^(BOOL isSuccess, id  _Nullable data) {
            complete();
        }];
        //获取到配置数据
        [wself requestAppConfig:^(BOOL isSuccess, id  _Nullable data) {
            
        }];
    } fail:^{
        
    }];
}

// 获取app配置数据AppConfig
- (void)requestAppConfig:(DataBlock)backBlock {
    kWeakSelf(self);
    [ASCommonRequest requestAppConfigSuccess:^(id  _Nullable data) {
        ASAppConfigDataModel *model = [ASAppConfigDataModel mj_objectWithKeyValues:data];
        wself.configModel = model;
        backBlock(YES, model);
    } errorBack:^(NSInteger code, NSString *msg) {
        backBlock(NO, nil);
    }];
    //获取IM的风控提示
    [ASCommonRequest requestCallRiskWithSuccess:^(id _Nullable data) {
        ASCallAnswerRiskModel *model = data;
        if (model.labelList.count > 0) {
            wself.textRiskModel = model;
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

// 获取app配置数据SystemIndex
- (void)requestSystemIndex:(DataBlock)backBlock {
    kWeakSelf(self);
    [ASCommonRequest requestAppSystemIndexIsLoading:NO success:^(id  _Nullable data) {
        ASSystemIndexDataModel *model = [ASSystemIndexDataModel mj_objectWithKeyValues:data];
        wself.systemIndexModel = model;
        //获取到状态后，更新云信的环境状态
        [ASIMDataConfig configAppLoginData];
        backBlock(YES, model);
    } errorBack:^(NSInteger code, NSString *msg) {
        if (kObjectIsEmpty(wself.systemIndexModel)) {
            wself.systemIndexModel = [[ASSystemIndexDataModel alloc] init];
        }
        backBlock(NO, nil);
    }];
    //上报参数
    NSString *isUpRequest = [ASUserDefaults valueForKey: kIsUploadParamRequest];
    if (isUpRequest.integerValue == 0 || kStringIsEmpty(isUpRequest)) {
        [ASCommonRequest requestActivateIndexWithSuccess:^(id  _Nonnull response) {
            [ASUserDefaults setValue:@"1" forKey:kIsUploadParamRequest];
        } errorBack:^(NSInteger code, NSString * _Nonnull message) {
            
        }];
    }
}

//从本地读取数据
- (void)restartUserData {
    self.usercode = [ASUserDefaults valueForKey:@"userinfo_usercode"];
    self.nickname = [ASUserDefaults valueForKey:@"userinfo_nickname"];
    self.sign = [ASUserDefaults valueForKey:@"userinfo_sign"];
    NSNumber *type = [ASUserDefaults valueForKey:@"userinfo_type"];
    self.type = type.integerValue;
    self.mobile = [ASUserDefaults valueForKey:@"userinfo_mobile"];
    self.avatar = [ASUserDefaults valueForKey:@"userinfo_avatar"];
    NSNumber *gender = [ASUserDefaults valueForKey:@"userinfo_gender"];
    self.gender = gender.integerValue;
    NSNumber *age = [ASUserDefaults valueForKey:@"userinfo_age"];
    self.age = age.integerValue;
    self.birthday = [ASUserDefaults valueForKey:@"userinfo_birthday"];
    self.city = [ASUserDefaults valueForKey:@"userinfo_city"];
    NSNumber *finish_status = [ASUserDefaults valueForKey:@"userinfo_finish_status"];
    self.finish_status = finish_status.integerValue;
    NSNumber *invite_id = [ASUserDefaults valueForKey:@"userinfo_invite_id"];
    self.invite_id = invite_id.integerValue;
    self.im_token = [ASUserDefaults valueForKey:@"userinfo_im_token"];
    NSNumber *is_anchor = [ASUserDefaults valueForKey:@"userinfo_is_anchor"];
    self.is_anchor = is_anchor.integerValue;
    self.voice = [ASUserDefaults valueForKey:@"userinfo_voice"];
    NSNumber *voice_time = [ASUserDefaults valueForKey:@"userinfo_voice_time"];
    self.voice_time = voice_time.integerValue;
    NSNumber *is_auth = [ASUserDefaults valueForKey:@"userinfo_is_auth"];
    self.is_auth = is_auth.integerValue;
    NSNumber *is_rp_auth = [ASUserDefaults valueForKey:@"userinfo_is_rp_auth"];
    self.is_rp_auth = is_rp_auth.integerValue;
    self.vip_icon = [ASUserDefaults valueForKey:@"userinfo_vip_icon"];
    NSNumber *vip = [ASUserDefaults valueForKey:@"userinfo_vip"];
    self.vip = vip.integerValue;
    self.token = [ASUserDefaults valueForKey:@"userinfo_token"];
    self.user_id = [ASUserDefaults valueForKey:@"userinfo_user_id"];
    //保存本地数据
//    [NSString stringWithFormat:@"%@_intimate_%@",USER_INFO.user_id, STRING(recentSession.session.sessionId)];
    [ASIMHelperDataManager shared].helperList = [NSMutableArray arrayWithArray:[ASUserDefaults valueForKey:[NSString stringWithFormat:@"userinfo_helper_list_%@",STRING(USER_INFO.user_id)]]];
    [ASIMHelperDataManager shared].dashanList = [NSMutableArray arrayWithArray:[ASUserDefaults valueForKey:[NSString stringWithFormat:@"userinfo_dashan_list_%@",STRING(USER_INFO.user_id)]]];
    NSNumber *amount = [ASUserDefaults valueForKey:[NSString stringWithFormat:@"userinfo_dashan_amount_%@",STRING(USER_INFO.user_id)]];
    [ASIMHelperDataManager shared].dashanAmount = amount.integerValue;
}

// 清空用户数据（被挤出、退出登陆时调用）
- (void)removeUserData:(VoidBlock)backBlock {
    self.usercode = @"";
    self.nickname = @"";
    self.sign = @"";
    self.type = 0;
    self.mobile = @"";
    self.avatar = @"";
    self.gender = 0;
    self.age = 0;
    self.birthday = @"";
    self.city = @"";
    self.finish_status = 0;
    self.invite_id = 0;
    self.im_token = @"";
    self.is_anchor = 0;
    self.voice = @"";
    self.voice_time = 0;
    self.is_auth = 0;
    self.is_rp_auth = 0;
    self.vip_icon = @"";
    self.vip = 0;
    self.token = @"";
    self.user_id = @"";
    [ASUserDefaults removeObjectForKey:@"userinfo_usercode"];
    [ASUserDefaults removeObjectForKey:@"userinfo_nickname"];
    [ASUserDefaults removeObjectForKey:@"userinfo_sign"];
    [ASUserDefaults removeObjectForKey:@"userinfo_type"];
    [ASUserDefaults removeObjectForKey:@"userinfo_mobile"];
    [ASUserDefaults removeObjectForKey:@"userinfo_avatar"];
    [ASUserDefaults removeObjectForKey:@"userinfo_gender"];
    [ASUserDefaults removeObjectForKey:@"userinfo_age"];
    [ASUserDefaults removeObjectForKey:@"userinfo_birthday"];
    [ASUserDefaults removeObjectForKey:@"userinfo_city"];
    [ASUserDefaults removeObjectForKey:@"userinfo_finish_status"];
    [ASUserDefaults removeObjectForKey:@"userinfo_invite_id"];
    [ASUserDefaults removeObjectForKey:@"userinfo_im_token"];
    [ASUserDefaults removeObjectForKey:@"userinfo_is_anchor"];
    [ASUserDefaults removeObjectForKey:@"userinfo_voice"];
    [ASUserDefaults removeObjectForKey:@"userinfo_voice_time"];
    [ASUserDefaults removeObjectForKey:@"userinfo_is_auth"];
    [ASUserDefaults removeObjectForKey:@"userinfo_is_rp_auth"];
    [ASUserDefaults removeObjectForKey:@"userinfo_vip_icon"];
    [ASUserDefaults removeObjectForKey:@"userinfo_vip"];
    [ASUserDefaults removeObjectForKey:@"userinfo_token"];
    [ASUserDefaults removeObjectForKey:@"userinfo_user_id"];
    [[ASIMHelperDataManager shared].helperList removeAllObjects];//清除数据
    [[ASIMHelperDataManager shared].dashanList removeAllObjects];//清除数据
    [ASIMHelperDataManager shared].dashanAmount = 0;
    [[ASPopViewManager shared] removePopView];
    [kCurrentWindow removeFromSuperview];//移除提示的view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeTabbarNotification" object:nil];
    //重新再获取一次system数据更新
    [self requestSystemIndex:^(BOOL isSuccess, id  _Nullable data) {
        [[ASLoginManager shared] verifyIsLoginWithBlock:^{
            [ASMsgTool hideMsg];
            backBlock();
        }];
    }];
    if ([[NIMSDK sharedSDK] loginManager].isLogined) {//云信登录状态
        [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
            if (!error) {
                ASLog(@"云信退出成功");
            }
        }];
    }
    //清除即将收到的推送通知
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    //清除已经收到的推送通知
    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
    //通知条数清空
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

@end
