//
//  ASWithdrawModel.h
//  AS
//
//  Created by SA on 2025/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASWithdrawModel : NSObject
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *income_money;
@property (nonatomic, assign) NSInteger min_money;
@property (nonatomic, assign) NSInteger isMonthLimit;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, assign) NSInteger card_type;
@property (nonatomic, copy) NSString *bank_code;
@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *alipay_account;
@property (nonatomic, assign) NSInteger alipay_status;
@property (nonatomic, copy) NSString *alipay_name;
@property (nonatomic, assign) NSInteger alipay_is_master;
@property (nonatomic, assign) NSInteger alipay_id;
@end

NS_ASSUME_NONNULL_END
