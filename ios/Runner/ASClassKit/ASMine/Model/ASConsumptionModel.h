//
//  ASConsumptionModel.h
//  AS
//
//  Created by SA on 2025/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASConsumptionListModel : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger defaultValue;
@property (nonatomic, copy) NSString *defaultText;
@property (nonatomic, assign) NSInteger is_show;
@end

@interface ASConsumptionModel : NSObject
@property (nonatomic, assign) NSInteger is_auth;
@property (nonatomic, copy) NSString *id_card_name;
@property (nonatomic, assign) NSInteger is_extra;//0未累计超额不显示，1可申请，2申请中，3成功
@property (nonatomic, assign) NSInteger today_extra;
@property (nonatomic, strong) NSArray<ASConsumptionListModel *> *limit;
@end

NS_ASSUME_NONNULL_END
