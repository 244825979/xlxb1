//
//  ASBannerModel.h
//  AS
//
//  Created by SA on 2025/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASBannerModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSInteger link_type;
@property (nonatomic, copy) NSString *link_url;
@property (nonatomic, copy) NSString *total_buy_money;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image_details;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger audit_show;
@property (nonatomic, assign) NSInteger gender_type;
@property (nonatomic, copy) NSString *userid;
//活动弹窗
@property (nonatomic, copy) NSString *popup_image;
@property (nonatomic, assign) CGFloat popup_image_width;
@property (nonatomic, assign) CGFloat popup_image_height;
@property (nonatomic, copy) NSString *close_button_image;
//IM悬浮
@property (nonatomic, copy) NSString *img;
@end

NS_ASSUME_NONNULL_END
