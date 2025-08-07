//
//  ASRecommendUserModel.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASRecommendUserModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) NSInteger isOnline;
@end

@interface ASRecommendUserListModel : NSObject
@property (nonatomic, strong) NSArray<ASRecommendUserModel *> *list;
@property (nonatomic, assign) NSInteger is_recommend_free;
@property (nonatomic, assign) NSInteger is_beckon_free;//一键搭讪按钮 0=收费一键搭讪  1=免费搭讪
@property (nonatomic, assign) NSInteger coin;//价格>0显示价格
@property (nonatomic, assign) NSInteger freeBeckonTimes;//剩余搭讪次数
@end

NS_ASSUME_NONNULL_END
