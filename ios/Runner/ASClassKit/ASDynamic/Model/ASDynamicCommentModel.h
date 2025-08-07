//
//  ASDynamicCommentModel.h
//  AS
//
//  Created by SA on 2025/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASDynamicCommentModel : NSObject
@property (nonatomic, copy) NSString *ID;//评论id
@property (nonatomic, copy) NSString *nickname;//用户昵称
@property (nonatomic, copy) NSString *user_id;//用户ID
@property (nonatomic, copy) NSString *content;//评论内容
@property (nonatomic, copy) NSString *comment_user_id;//回复的id
@property (nonatomic, assign) NSInteger is_type;
@property (nonatomic, copy) NSString *create_time;//创建时间
@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, copy) NSString *comment_nickname;//评论对象昵称
@property (nonatomic, assign) NSInteger is_vip;

@property (nonatomic, strong) NSMutableAttributedString *nameAgreement;//昵称富文本
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) TextBlock clikedBlock;
@end

NS_ASSUME_NONNULL_END
