//
//  ASCenterNotifyModel.h
//  AS
//
//  Created by SA on 2025/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASCenterNotifyModel : NSObject
@property (nonatomic, assign) NSInteger isPop;//是否弹出
@property (nonatomic, copy) NSString *url;//地址
@property (nonatomic, copy) NSString *noticeLogId;//通知ID
@property (nonatomic, copy) NSString *title;//内容
@end

NS_ASSUME_NONNULL_END
