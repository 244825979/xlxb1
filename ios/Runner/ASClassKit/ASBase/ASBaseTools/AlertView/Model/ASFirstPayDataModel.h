//
//  ASFirstPayDataModel.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASFirstGiftModel : NSObject
@property (nonatomic, copy) NSString *gift_id;
@property (nonatomic, copy) NSString *img;//苹果支付id
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger money;//是否选中
@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger type;
@end

@interface ASFirstPayListModel : NSObject
@property (nonatomic, copy) NSString *reward_str;//赠送188金币
@property (nonatomic, assign) NSInteger amount;//900
@property (nonatomic, assign) NSInteger price;//9
@property (nonatomic, copy) NSString *ios_product_id;//苹果支付id
@property (nonatomic, assign) NSInteger account_type;//
@property (nonatomic, assign) NSInteger is_default;//是否选中
@property (nonatomic, assign) NSInteger activity_giving;
@property (nonatomic, assign) NSInteger filter_type;
@property (nonatomic, assign) NSString* ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *package_name;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, assign) NSInteger reward;
@property (nonatomic, assign) NSInteger reward_common;
@property (nonatomic, assign) NSInteger reward_num;
@property (nonatomic, assign) NSInteger sales_num;
@property (nonatomic, assign) NSInteger scene_type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSArray<ASFirstGiftModel *> *reward_gift;
@end

@interface ASFirstPayDataModel : NSObject
@property (nonatomic, strong) NSArray<ASFirstPayListModel *> *list;
@property (nonatomic, assign) NSInteger is_show;//显示右下角的图标
@property (nonatomic, assign) NSInteger time;//倒计时几秒钟后弹
@property (nonatomic, assign) NSInteger is_pop;//自动弹一次
@property (nonatomic, assign) NSInteger is_yidun;
@end

NS_ASSUME_NONNULL_END
