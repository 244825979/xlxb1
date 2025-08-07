//
//  ASNewUserGiftModel.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASNewUserGiftListModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *expire;
@property (nonatomic, copy) NSString *desc;
@end

@interface ASNewUserGiftModel : NSObject
@property (nonatomic, copy) NSString *icon_title;
@property (nonatomic, strong) NSArray<ASNewUserGiftListModel *> *list;
@end

NS_ASSUME_NONNULL_END
