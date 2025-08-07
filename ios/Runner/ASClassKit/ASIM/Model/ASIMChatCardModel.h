//
//  ASIMChatCardModel.h
//  AS
//
//  Created by SA on 2025/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface ASIMCardAuthModel : NSObject
@property (nonatomic, assign) NSInteger real_auth_status;
@property (nonatomic, assign) NSInteger auth_status;
@property (nonatomic, copy) NSString *real_auth_msg;
@property (nonatomic, copy) NSString *auth_msg;
@end

@interface ASIMAlbumListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, assign) NSInteger rate;
@property (nonatomic, assign) NSInteger is_read;
@property (nonatomic, copy) NSString *admin_id;
@property (nonatomic, assign) NSInteger audit_time;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, assign) NSInteger low_show;
@property (nonatomic, assign) NSInteger is_machine_audit;
@end

@interface ASIMChatCardModel : NSObject
@property (nonatomic, strong) ASIMCardAuthModel *auth;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *base_info;
@property (nonatomic, copy) NSString *login_ip_addr;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, strong) NSArray *chat_label;
@property (nonatomic, strong) NSArray *chat_label_new;
@property (nonatomic, copy) NSString *cover_img_url;
@property (nonatomic, copy) NSString *video_url;
@property (nonatomic, copy) NSString *video_id;
@property (nonatomic, copy) NSString *subjectTask;
@property (nonatomic, strong) NSArray<ASIMAlbumListModel *> *albumList;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger is_follow;
@property (nonatomic, assign) CGFloat viewHeight;
@end

NS_ASSUME_NONNULL_END
