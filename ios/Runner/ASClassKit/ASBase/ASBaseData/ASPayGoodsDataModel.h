//
//  ASPayGoodsDataModel.h
//  AS
//
//  Created by SA on 2025/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASGoodsListModel : NSObject
@property (nonatomic, copy) NSString *vip_describe;
@property (nonatomic, strong) NSArray *btn_text;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ios_product_id;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) NSInteger reward;
@property (nonatomic, copy) NSString *first_recharge;
@end

@interface ASPayGoodsDataModel : NSObject
@property (nonatomic, strong) NSArray<ASGoodsListModel *> *list;
@property (nonatomic, copy) NSString *coin;
@property (nonatomic, copy) NSString *income_money;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, assign) NSInteger is_yidun;
@end

NS_ASSUME_NONNULL_END
