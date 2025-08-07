//
//  ASWithdrawRequestModel.h
//  AS
//
//  Created by SA on 2025/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASWithdrawRequestModel : NSObject
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *receive_money;
@property (nonatomic, copy) NSString *withdraw_money;
@property (nonatomic, assign) BOOL isPopProtocol;
@end

NS_ASSUME_NONNULL_END
