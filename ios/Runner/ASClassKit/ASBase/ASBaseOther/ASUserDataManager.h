//
//  ASUserData.h
//  AS
//
//  Created by SA on 2025/4/10.
//

#import <Foundation/Foundation.h>
#import "ASAppConfigDataModel.h"
#import "ASSystemIndexDataModel.h"
#import "ASUsersHiddenDataModel.h"
#import "ASCallAnswerRiskModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASUserDataManager : NSObject
@property (nonatomic, copy) NSString *usercode;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger gender;//1女生 2男生
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, assign) NSInteger finish_status;
@property (nonatomic, assign) NSInteger invite_id;
@property (nonatomic, copy) NSString *im_token;
@property (nonatomic, assign) NSInteger is_anchor;
@property (nonatomic, copy) NSString *voice;
@property (nonatomic, assign) NSInteger voice_time;
@property (nonatomic, assign) NSInteger is_auth;
@property (nonatomic, assign) NSInteger is_rp_auth;
@property (nonatomic, copy) NSString *vip_icon;
@property (nonatomic, assign) NSInteger vip;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, assign) NSInteger createtime;
@property (nonatomic, assign) NSInteger expiretime;
@property (nonatomic, assign) NSInteger expires_in;
@property (nonatomic, strong) ASAppConfigDataModel *configModel;
@property (nonatomic, strong) ASSystemIndexDataModel *systemIndexModel;
@property (nonatomic, strong) ASUsersHiddenDataModel *usesHiddenListModel;
@property (nonatomic, strong) ASCallAnswerRiskModel *textRiskModel;

@property (nonatomic, assign) NSInteger avatar_task_reward_coin;//上传头像奖励的金额，保存到本地，给到我的页面头像弹窗使用
@property (nonatomic, assign) NSInteger is_avatar_task_finish;//上传头像是否完成，保存到本地，给到我的页面头像弹窗使用

//用户模型单例
+ (ASUserDataManager *)shared;
//是否登录
- (BOOL)isLogin;
//将用户数据保存到本地
- (void)saveUserDataWithModel:(ASUserInfoModel *)userModel complete:(VoidBlock)complete;;
//从本地读取数据
- (void)restartUserData;
//清空用户数据（被挤出、退出登陆时调用）
- (void)removeUserData:(VoidBlock)backBlock;
//获取app配置数据AppConfig
- (void)requestAppConfig:(DataBlock)backBlock;
//获取app配置数据SystemIndex
- (void)requestSystemIndex:(DataBlock)backBlock;
@end

NS_ASSUME_NONNULL_END
