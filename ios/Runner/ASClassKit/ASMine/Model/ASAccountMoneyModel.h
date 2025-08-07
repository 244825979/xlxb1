//
//  ASAccountMoneyModel.h
//  AS
//
//  Created by SA on 2025/4/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASAccountMoneyModel : NSObject
@property (nonatomic, copy) NSString *income_coin_money;
@property (nonatomic, copy) NSString *hebdo_income;
@property (nonatomic, copy) NSString *today_income;
@property (nonatomic, copy) NSString *freeze_money;//冻结余额
@property (nonatomic, copy) NSString *total_buy_money;
@property (nonatomic, copy) NSString *income_money;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *coin;
@property (nonatomic, assign) NSInteger free_coin;
@property (nonatomic, assign) NSInteger income_coin;
@property (nonatomic, assign) NSInteger love_value;
@property (nonatomic, assign) NSInteger total_buy_coin;
@property (nonatomic, assign) NSInteger freeze_coin;
@property (nonatomic, assign) NSInteger wait_coin_show;//是否显示
@property (nonatomic, copy) NSString *wait_settle_coin;//待结算礼物余额
@property (nonatomic, copy) NSString *wait_coin_name;//待结算礼物余额标题
@property (nonatomic, copy) NSString *wait_coin_tips;//今日获得礼物收益，隔24小时系统自动结算

@end

NS_ASSUME_NONNULL_END
