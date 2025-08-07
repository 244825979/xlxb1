//
//  ASIMChatRemoteExtModel.h
//  AS
//
//  Created by SA on 2025/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASIMChatRemoteExtModel : NSObject
@property (nonatomic, assign) NSInteger is_cut;
@property (nonatomic, assign) NSInteger cut_coin;
@property (nonatomic, copy) NSString* money;
@property (nonatomic, assign) NSInteger vip;
@property (nonatomic, assign) NSInteger coin;
@property (nonatomic, assign) NSInteger filter;
@property (nonatomic, assign) NSInteger is_chat_card;//是否是聊天卡消息
@property (nonatomic, copy) NSString* content;
@property (nonatomic, assign) NSInteger is_yd_check;
@property (nonatomic, copy) NSString* replace_content;
@property (nonatomic, assign) NSInteger is_beckon_un;//1搭讪消息 0其他消息
@property (nonatomic, assign) NSInteger is_fold;//1需要折叠 0不需要折叠
@property (nonatomic, assign) NSInteger is_pop;//消息是否显示悬浮

@end

NS_ASSUME_NONNULL_END
