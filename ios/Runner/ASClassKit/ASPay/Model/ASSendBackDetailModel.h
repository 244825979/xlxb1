//
//  ASSendBackDetailModel.h
//  AS
//
//  Created by SA on 2025/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASSendBackDetailListModel : NSObject
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *value;
@end

@interface ASSendBackDetailModel : NSObject
@property (nonatomic, copy) NSArray<ASSendBackDetailListModel *> *list;
@property (nonatomic, copy) NSString *tips;
@end

NS_ASSUME_NONNULL_END
