//
//  ASSignInModel.h
//  AS
//
//  Created by SA on 2025/4/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASSignInGiftModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *title_new;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, assign) NSInteger time_second;
@property (nonatomic, assign) NSInteger money;
@property (nonatomic, assign) NSInteger gift_id;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isChatCard;
@property (nonatomic, assign) NSInteger number;
@end

@interface ASSignInListModel : NSObject
@property (nonatomic, strong) NSArray<ASSignInGiftModel *> *list;
@property (nonatomic, assign) BOOL now_day;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, assign) NSInteger label;
@end

@interface ASSignInModel : NSObject
@property (nonatomic, strong) NSArray<ASSignInListModel *> *today;
@property (nonatomic, assign) BOOL today_status;
@property (nonatomic, assign) NSInteger today_count;
@end

NS_ASSUME_NONNULL_END
