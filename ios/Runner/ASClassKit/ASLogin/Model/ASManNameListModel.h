//
//  ASManNameListModel.h
//  AS
//
//  Created by SA on 2025/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASManNameModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *key;
@end

@interface ASManNameListModel : NSObject
@property (nonatomic, strong) NSArray<ASManNameModel*> *nickname;
@property (nonatomic, strong) NSArray<NSString*> *avatar;
@end

NS_ASSUME_NONNULL_END
