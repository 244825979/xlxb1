//
//  ASBindAccountModel.h
//  AS
//
//  Created by SA on 2025/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASBindDataModel: NSObject
@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger type;
@end

@interface ASBindAccountModel : NSObject
@property (nonatomic, copy) NSString *card_account;
@property (nonatomic, copy) NSString *card_name;
@property (nonatomic, copy) NSString *id_card;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) NSInteger card_type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger is_h5_verify;
@property (nonatomic, copy) NSString *card_icon;
@property (nonatomic, copy) NSString *h5Url;//校验地址
@property (nonatomic, strong) NSArray<ASBindDataModel*> *cardTypes;
@end

NS_ASSUME_NONNULL_END
