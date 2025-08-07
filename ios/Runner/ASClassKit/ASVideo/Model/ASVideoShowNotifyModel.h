//
//  ASVideoShowNotifyModel.h
//  AS
//
//  Created by SA on 2025/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASVideoShowNotifyModel : NSObject
@property (nonatomic, copy) NSString *show_id;
@property (nonatomic, copy) NSString *from_uid;
@property (nonatomic, copy) NSString *fromAvatar;
@property (nonatomic, copy) NSString *fromNickname;
@property (nonatomic, assign) NSInteger fromGender;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, assign) NSInteger is_delete;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) NSInteger is_read;
@end

NS_ASSUME_NONNULL_END
