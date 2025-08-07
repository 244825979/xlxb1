//
//  ASCallRtcExtendModel.h
//  AS
//
//  Created by SA on 2025/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASCallRtcExtendModel : NSObject
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, assign) BOOL isMatch;
@property (nonatomic, copy) NSString *fromUid;
@property (nonatomic, copy) NSString *fromName;
@end

NS_ASSUME_NONNULL_END
