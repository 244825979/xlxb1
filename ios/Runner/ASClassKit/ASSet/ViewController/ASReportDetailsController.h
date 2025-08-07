//
//  ASReportDetailsController.h
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASBaseViewController.h"
#import "ASReportListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASReportDetailsController : ASBaseViewController
@property (nonatomic, strong) ASReportListModel *model;
@property (nonatomic, copy) IndexBlock backBlock;
@end

NS_ASSUME_NONNULL_END
