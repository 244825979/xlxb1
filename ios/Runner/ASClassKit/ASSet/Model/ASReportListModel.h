//
//  ASReportListModel.h
//  AS
//
//  Created by SA on 2025/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface ASReportDetailsMoreModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *reasonTime;

@property (nonatomic, assign) CGFloat collectionHeight;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat reasonHeight;
@end

@interface ASReportListModel : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *usercode;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *reasonTime;
@property (nonatomic, copy) NSString *cateName;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray<ASReportDetailsMoreModel *> *more;
@property (nonatomic, copy) NSString *toNickname;
@property (nonatomic, copy) NSString *toUserCode;

@property (nonatomic, assign) NSInteger selectedPhotosCount;//显示图片数量
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat reasonHeight;
@property (nonatomic, assign) CGFloat collectionHeight;
@property (nonatomic, assign) CGFloat replenishCollectionHeight;
@end

NS_ASSUME_NONNULL_END
