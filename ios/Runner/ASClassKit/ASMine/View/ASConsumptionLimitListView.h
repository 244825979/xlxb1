//
//  ASConsumptionLimitListView.h
//  AS
//
//  Created by SA on 2025/5/22.
//

#import <UIKit/UIKit.h>
#import "ASConsumptionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASConsumptionLimitListView : UIView
@property (nonatomic, strong) ASConsumptionModel *model;
@end

@interface ASConsumptionListView : UIView
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) ASConsumptionListModel *model;
@property (nonatomic, copy) VoidBlock actionBlock;
@property (nonatomic, assign) NSInteger is_auth;
@property (nonatomic, assign) NSInteger is_extra;//0未累计超额不显示，1可申请，2申请中，3成功
@property (nonatomic, strong) UIImageView *cliekIcon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *rightTitle;
@end
NS_ASSUME_NONNULL_END
