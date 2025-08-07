//
//  ASReportDetailsReplenishView.h
//  AS
//
//  Created by SA on 2025/4/22.
//

#import <UIKit/UIKit.h>
#import "ASReportListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASReportDetailsReplenishView : UIView
@property (nonatomic, strong) ASReportListModel *model;
@property (nonatomic, copy) void (^backBlock)(NSString *content, NSArray *images);
@end

NS_ASSUME_NONNULL_END
