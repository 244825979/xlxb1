//
//  ASPersonalBottomView.h
//  AS
//
//  Created by SA on 2025/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASPersonalBottomView : UIView
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, strong) ASUserInfoModel *model;
@property (nonatomic, assign) NSInteger isFollow;//是否关注
@property (nonatomic, copy) IndexNameBlock nameBlock;//1私聊。2通话。3打招呼回调。4关注 5取消关注
@end

NS_ASSUME_NONNULL_END
