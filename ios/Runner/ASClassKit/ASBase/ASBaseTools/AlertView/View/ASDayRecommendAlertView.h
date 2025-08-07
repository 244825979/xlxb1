//
//  ASDayRecommendAlertView.h
//  AS
//
//  Created by SA on 2025/4/18.
//  今日缘分弹窗

#import <UIKit/UIKit.h>
#import "ASRecommendUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASDayRecommendAlertView : UIView
@property (nonatomic, copy) VoidBlock cancelBlock;
- (instancetype)initDayRecommendViewWithModel:(ASRecommendUserListModel *)model;
@end

@interface ASDayRecommendZhaohuyuCell : UITableViewCell
@property (nonatomic, copy) NSString *zhaohuyuText;
@end

NS_ASSUME_NONNULL_END
