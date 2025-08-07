//
//  ASCallAnswerRiskModel.h
//  AS
//
//  Created by SA on 2025/4/10.
//  通话风控提示

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASCallAnswerRiskModel : NSObject
@property (nonatomic, strong) NSArray *labelList;
@property (nonatomic, strong) NSArray *chatLabelList;
@property (nonatomic, strong) NSArray *rechargeLabelList;
@property (nonatomic, assign) NSInteger showTime;
@property (nonatomic, assign) NSInteger waitTime;
@end

NS_ASSUME_NONNULL_END
