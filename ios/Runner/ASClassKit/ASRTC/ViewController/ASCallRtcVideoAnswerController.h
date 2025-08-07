//
//  ASCallRtcVideoAnswerController.h
//  AS
//
//  Created by SA on 2025/5/19.
//

#import "ASBaseViewController.h"
#import "ASCallRtcDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASCallRtcVideoAnswerController : ASBaseViewController
@property (nonatomic, strong) ASCallRtcDataModel *callModel;
@property (nonatomic, copy) NSString *moneyText;
@end

NS_ASSUME_NONNULL_END
