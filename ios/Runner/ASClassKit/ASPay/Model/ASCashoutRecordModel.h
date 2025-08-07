//
//  ASCashoutRecordModel.h
//  AS
//
//  Created by SA on 2025/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASCashoutRecordModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *card_account;
@property (nonatomic, copy) NSString *cash_money;
@property (nonatomic, copy) NSString *real_cash_money;
@property (nonatomic, copy) NSString *create_time_text;
@property (nonatomic, copy) NSString *status_text;
@property (nonatomic, copy) NSString *status_color;
@end

NS_ASSUME_NONNULL_END
