//
//  ASUserInfoModel.h
//  AS
//
//  Created by SA on 2025/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//主页用户资料
@interface ASBasicInfoDetailModel : NSObject
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *is_marriage;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *signs;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *education;
@property (nonatomic, copy) NSString *occupation;
@property (nonatomic, copy) NSString *annual_income;
@property (nonatomic, copy) NSString *usercode;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *hometown;
@end

@interface ASBasicInfoModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@end

@interface ASAlbumsModel : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger is_video;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger is_video_show;
@property (nonatomic, copy) NSString *video_show_id;
@property (nonatomic, copy) NSString *cover_img_url;
@property (nonatomic, copy) NSString *video_url;
@end

//主页的动态数据
@interface ASDynamicDataModel : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, copy) NSString *content;
@end

@interface ASSubTaskModel : NSObject
@property (nonatomic, copy) NSString *task_id;
@property (nonatomic, copy) NSString *des;//上传本人头像 +20金币
@property (nonatomic, assign) NSInteger is_show;//1显示，其他不显示
@end

//任务数据
@interface ASTaskModel : NSObject
@property (nonatomic, strong) ASSubTaskModel *avatar_task;//上传本人头像
@property (nonatomic, strong) ASSubTaskModel *sign_task;//完善自我介绍 +20金币
@property (nonatomic, strong) ASSubTaskModel *over_task;//完善资料 +20金币
@property (nonatomic, strong) ASSubTaskModel *album_task;//上传本人相册 +20金币
@property (nonatomic, strong) ASSubTaskModel *video_task;//上传本人视频 +20金币
@property (nonatomic, strong) ASSubTaskModel *voice_task;//上传语音签名
@end

//在线状态
@interface ASOnlineModel : NSObject
@property (nonatomic, copy) NSString *statusMsgNew;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger online_status;
@property (nonatomic, assign) NSInteger OnlineStatus;
@property (nonatomic, assign) NSInteger newStatus;
@end

//语音签名
@interface ASVoiceModel : NSObject
@property (nonatomic, copy) NSString *voice;
@property (nonatomic, assign) NSInteger voice_status;
@property (nonatomic, assign) NSInteger voice_time;
@end

//标签数据
@interface ASTagsModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger scene;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, assign) NSInteger system_status;
@end

@interface ASUserInfoModel : NSObject
/** 登录属性 **/
@property (nonatomic, copy) NSString *usercode;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *avatar_auth;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, assign) NSInteger finish_status;
@property (nonatomic, assign) NSInteger invite_id;
@property (nonatomic, copy) NSString *im_token;
@property (nonatomic, assign) NSInteger is_anchor;
@property (nonatomic, strong) ASVoiceModel *voice;
@property (nonatomic, assign) NSInteger is_auth;
@property (nonatomic, assign) NSInteger is_rp_auth;
@property (nonatomic, copy) NSString *vip_icon;
@property (nonatomic, assign) NSInteger vip;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger createtime;
@property (nonatomic, assign) NSInteger expiretime;
@property (nonatomic, assign) NSInteger expires_in;
@property (nonatomic, assign) BOOL is_beckon;//是否是打招呼
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, assign) BOOL is_black;//是否拉黑
@property (nonatomic, copy) NSString *user_remark;//备注名称
@property (nonatomic, copy) NSString *remark_name;//好友设置备注名称
@property (nonatomic, strong) ASOnlineModel *online;
@property (nonatomic, assign) BOOL is_hidden;//是否开启隐身访问
@property (nonatomic, assign) NSInteger avatar_auth_status;//头像审核状态 0待审核、1审核通过
@property (nonatomic, assign) NSInteger sign_state;//个性签名审核状态 0待审核、1审核通过
@property (nonatomic, assign) NSInteger nickname_state;//昵称审核状态 0待审核、1审核通过
/** 其他属性 **/
@property (nonatomic, strong) ASBasicInfoDetailModel *basic_info_detail;//选择编辑内容
@property (nonatomic, strong) NSArray<ASBasicInfoModel *> *basic_info;//卡片信息数组
@property (nonatomic, strong) NSArray<ASAlbumsModel *> *albums_list;//展示图片墙 不包含头像
@property (nonatomic, strong) NSArray<ASAlbumsModel *> *albums;//展示图片墙 包含头像
@property (nonatomic, assign) CGFloat labelsHeight;
@property (nonatomic, strong) NSArray<ASGiftListModel *> *gifts;//礼物墙
@property (nonatomic, strong) NSArray<ASDynamicDataModel *> *dynamic;//我的动态列表数据
@property (nonatomic, assign) NSInteger dynamic_num;//动态数据
@property (nonatomic, assign) NSInteger talkCount;//话题数据
@property (nonatomic, strong) ASTaskModel *task;
@property (nonatomic, strong) ASBasicInfoDetailModel *user_info;//昵称
@property (nonatomic, copy) NSString *height;//高度
@property (nonatomic, copy) NSString *occupation;//"产品经理"
@property (nonatomic, assign) NSInteger is_follow;//是否关注
@property (nonatomic, assign) NSInteger is_fans;//是否粉丝
@property (nonatomic, copy) NSString *visitor_text;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *vip_des;//会员到期时间
@property (nonatomic, copy) NSString *text_content;//打招呼提示
@property (nonatomic, assign) NSInteger is_video_show;//是否提示视频提醒
@property (nonatomic, strong) NSArray<ASTagsModel *> *label;//标签
@property (nonatomic, strong) NSArray<ASVideoShowDataModel *> *video_show;//视频秀列表
/** 自定义字段*/
@property (nonatomic, assign) CGFloat personalCardViewHeight;//自定义字段，个人主页卡片数据的高度
@property (nonatomic, assign) CGFloat signTextHeight;//自定义字段，个人主页个性签名文本高度
@end

NS_ASSUME_NONNULL_END
