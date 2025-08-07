//
//  ASHomeUserListModel.h
//  AS
//
//  Created by SA on 2025/4/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASHomeUserListModel : NSObject
@property (nonatomic, copy) NSString *ID;//用户ID
@property (nonatomic, copy) NSString *usercode;//用户code
@property (nonatomic, copy) NSString *nickname;//用户昵称
@property (nonatomic, assign) NSInteger gender;//1女 2男
@property (nonatomic, copy) NSString *sign;//个性签名
@property (nonatomic, assign) NSInteger age;//年龄
@property (nonatomic, copy) NSString *city;//城市
@property (nonatomic, copy) NSString *height;//身高
@property (nonatomic, copy) NSString *weight;//体重
@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, copy) NSString *occupation;//职业
@property (nonatomic, assign) NSInteger is_auth;//是否实名认证
@property (nonatomic, assign) NSInteger is_rp_auth;//是否真人认证
@property (nonatomic, assign) NSInteger is_beckon;//是否是打招呼 0是打招呼，1私聊
@property (nonatomic, assign) NSInteger is_online; //1是空闲，2是忙了，其他隐藏
@property (nonatomic, assign) NSInteger isOnline; //1是空闲，2是忙了，其他隐藏
@property (nonatomic, assign) NSInteger is_vip;
@property (nonatomic, copy) NSString *user_id;//用户ID
@property (nonatomic, assign) NSInteger is_video_show;
@property (nonatomic, copy) NSString *mp3;//语音链接
@property (nonatomic, assign) NSInteger mp3_second;//语音时长
@property (nonatomic, strong) NSArray *user_album;//照片墙
@property (nonatomic, copy) NSString *education;//学历
@property (nonatomic, copy) NSString *price;//通话金额
@property (nonatomic, copy) NSString *location;//位置信息
//自定义字段
@property (nonatomic, assign) BOOL isHeight;//是否有身高数据
@property (nonatomic, assign) BOOL isWeight;//是否有体重数据
@end

@interface ASHomeUserModel : NSObject
@property (nonatomic, strong) NSArray<ASHomeUserListModel *> *list;
@property (nonatomic, assign) NSInteger total_page;
@end

NS_ASSUME_NONNULL_END
