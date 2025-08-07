//
//  ASSendVipModel.h
//  AS
//
//  Created by SA on 2025/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASSendVipPrivilegeList : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *banner;
@end

@interface ASSendVipGoodListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *expire;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *old_price;
@property (nonatomic, assign) NSInteger is_checked;
@property (nonatomic, copy) NSString *start_ios_product_id;
@property (nonatomic, copy) NSString *recommend_txt;
@property (nonatomic, copy) NSString *diff;
@end

@interface ASSendVipModel : NSObject
@property (nonatomic, strong) NSArray<ASSendVipPrivilegeList *> *privilegeList;
@property (nonatomic, strong) NSArray<ASSendVipGoodListModel *> *goodList;
@property (nonatomic, assign) NSInteger isVip;
@property (nonatomic, assign) NSInteger is_yidun;
@end

NS_ASSUME_NONNULL_END
