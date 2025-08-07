//
//  ASVipDetailsModel.h
//  AS
//
//  Created by SA on 2025/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASVipUserInfoModel : NSObject
@property (nonatomic, assign) NSInteger vip_id;
@property (nonatomic, copy) NSString *expire_time;
@property (nonatomic, copy) NSString *usercode;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, strong) ASGiftListModel *gift;
@end

@interface ASVipGoodsModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger vip_id;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger old_price;
@property (nonatomic, assign) NSInteger renew_price;
@property (nonatomic, assign) NSInteger expire;
@property (nonatomic, assign) NSInteger platform;
@property (nonatomic, assign) NSInteger vip_suggest;
@property (nonatomic, copy) NSString *start_ios_product_id;
@property (nonatomic, copy) NSString *renew_ios_product_id;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *vip_duration;
@end

@interface ASVipPrivilegesModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger is_show;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, copy) NSString *img_has;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *show_img;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@end

@interface ASVipDetailsModel : NSObject
@property (nonatomic, strong) ASVipUserInfoModel *info;
@property (nonatomic, strong) NSArray<ASVipGoodsModel *> *list;
@property (nonatomic, strong) NSArray<ASVipPrivilegesModel *> *privilege;
@property (nonatomic, assign) NSInteger is_yidun;
@end

NS_ASSUME_NONNULL_END
