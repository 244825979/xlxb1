//
//  ASGreetTpListModel.h
//  AS
//
//  Created by SA on 2025/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASGreetTpBodyModel : NSObject
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *file;
@property (nonatomic, assign) NSInteger len;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, copy) NSString *md5;
@property (nonatomic, copy) NSString *ext;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger userBid;
@end

@interface ASGreetTpListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *word;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, assign) NSInteger is_system;
@property (nonatomic, assign) NSInteger is_greet;
@property (nonatomic, strong) NSArray<ASGreetTpBodyModel *> *body;
@end

NS_ASSUME_NONNULL_END
