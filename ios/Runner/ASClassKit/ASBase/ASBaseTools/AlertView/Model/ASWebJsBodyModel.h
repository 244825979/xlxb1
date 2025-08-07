//
//  ASWebJsBodyModel.h
//  AS
//
//  Created by SA on 2025/7/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface ASWebPosterListModel : NSObject
@property (nonatomic, copy) NSString *posterPicUrl;
@property (nonatomic, copy) NSString *bottomColor;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *contentColor;
@property (nonatomic, copy) NSString *qCodeContent;
@property (nonatomic, copy) NSString *buttonStartColor;
@property (nonatomic, copy) NSString *buttonEndColor;
@property (nonatomic, copy) NSString *buttonText;
@end

@interface ASShareDataModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *linkUrl;
@property (nonatomic, copy) NSString *thumbUrl;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *userCode;
@end

@interface ASWebJsBodyModel : NSObject
@property (nonatomic, strong) ASShareDataModel *shareData;
@property (nonatomic, strong) NSArray<ASWebPosterListModel *> *posterList;
@end

NS_ASSUME_NONNULL_END
