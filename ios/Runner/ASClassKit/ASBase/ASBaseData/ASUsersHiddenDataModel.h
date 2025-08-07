//
//  ASUsersHiddenDataModel.h
//  AS
//
//  Created by SA on 2025/4/10.
//  用户隐身数据

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASUserHiddenListModel : NSObject
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, assign) NSInteger status;
@end

@interface ASUsersHiddenDataModel : NSObject
@property (nonatomic, strong) NSArray<ASUserHiddenListModel *> *hidden_me_user;//对方对我隐身所有用户
@property (nonatomic, strong) NSArray<ASUserHiddenListModel *> *hidden_to_user;//我对对方隐身所有用户
@property (nonatomic, strong) NSMutableArray *hiddenMeUsersID;//对方对我隐身所有用户ID
@property (nonatomic, strong) NSMutableArray *hiddenToUserID;//我对对方隐身所有用户ID
@end

NS_ASSUME_NONNULL_END
