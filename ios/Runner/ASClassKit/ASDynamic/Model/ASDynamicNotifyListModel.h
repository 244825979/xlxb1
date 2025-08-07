//
//  ASDynamicNotifyListModel.h
//  AS
//
//  Created by SA on 2025/5/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASDynamicNotifyListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *from_user_id;
@property (nonatomic, copy) NSString *dynamic_id;
@property (nonatomic, assign) NSInteger is_type;
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger is_delete;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *from_user_nickname;
@property (nonatomic, copy) NSString *video_url;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, assign) NSInteger dynamic_type;
@property (nonatomic, copy) NSString *from_user_avatar;
@property (nonatomic, strong) NSMutableAttributedString *textAgreement;
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
