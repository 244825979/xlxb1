//
//  ASSendImBatchListModel.h
//  AS
//
//  Created by SA on 2025/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASSendImBatchListModel : NSObject
@property (nonatomic, assign) NSInteger is_cut;
@property (nonatomic, assign) NSInteger cut_coin;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, assign) NSInteger vip;
@property (nonatomic, assign) NSInteger coin;
@property (nonatomic, assign) NSInteger filter;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger is_yd_check;
@property (nonatomic, assign) NSInteger is_chat_card;
@property (nonatomic, strong) NSArray *account_code;
@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, copy) NSString *to_uid;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger is_push;
@property (nonatomic, assign) NSInteger is_beckon_un;// 1=搭讪消息   0=其他消息
@property (nonatomic, assign) NSInteger is_fold;//1=需要折叠    0=不需要折叠
@property (nonatomic, assign) NSInteger is_pop;//是否弹出悬浮
@end

NS_ASSUME_NONNULL_END
