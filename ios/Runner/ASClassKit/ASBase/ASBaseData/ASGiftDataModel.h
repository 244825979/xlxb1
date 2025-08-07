//
//  ASGiftDataModel.h
//  AS
//
//  Created by SA on 2025/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASGiftListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *svga;
@property (nonatomic, copy) NSString *md5_string;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, copy) NSString *p_type;//聊天卡类型
@property (nonatomic, copy) NSString *expire;//聊天卡数量
@property (nonatomic, copy) NSString *img;//图片
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger is_reward;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, copy) NSString *sign;
@end

@interface ASGiftDataModel : NSObject
@property (nonatomic, copy) NSString *coin;
@property (nonatomic, strong) NSArray<ASGiftListModel*> *gift_list;
@property (nonatomic, strong) NSArray<ASGiftListModel *> *list;
@end

NS_ASSUME_NONNULL_END
