//
//  ASRechargeBeforeModel.h
//  AS
//
//  Created by SA on 2025/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASRechargeBeforeModel : NSObject
@property (nonatomic, assign) NSInteger isPopTeen;//是否弹青少年弹窗 1-是 0-否
@property (nonatomic, assign) NSInteger isPopGreen;//是否弹绿色弹窗 充值5次那个 1-是 0-否
@property (nonatomic, copy) NSString *greenText;//绿色弹窗内容
@property (nonatomic, assign) NSInteger isPopRechargeMax;//是否弹旧版充值限额弹窗 1-是 0-否
@property (nonatomic, copy) NSString *rechargeMaxText;//旧版充值限额内容
@end

NS_ASSUME_NONNULL_END
