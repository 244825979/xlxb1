//
//  ASFateHelperStatusModel.h
//  AS
//
//  Created by SA on 2025/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASFateHelperStatusModel : NSObject
@property (nonatomic, assign) NSInteger fateHelperStatus;
@property (nonatomic, assign) NSInteger waitReplyNum;
@property (nonatomic, copy) NSString *helperTitle;
@property (nonatomic, copy) NSString *helperTips;
@end

NS_ASSUME_NONNULL_END
