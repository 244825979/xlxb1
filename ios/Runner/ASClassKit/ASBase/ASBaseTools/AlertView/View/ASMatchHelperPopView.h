//
//  ASMatchHelperPopView.h
//  AS
//
//  Created by SA on 2025/7/4.
//

#import <UIKit/UIKit.h>
#import "ASFateHelperStatusModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ASMatchHelperPopView : UIView
@property (nonatomic, copy) VoidBlock cancelBlock;
@property (nonatomic, copy) VoidBlock refreshBlock;
@property (nonatomic, strong) ASFateHelperStatusModel *model;
@end

@interface ASMatchHelperListCell : UITableViewCell
@property (nonatomic, copy) void (^selectBlock)(BOOL isSelect, NSString *userID);
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NIMRecentSession *session;
@end

NS_ASSUME_NONNULL_END
