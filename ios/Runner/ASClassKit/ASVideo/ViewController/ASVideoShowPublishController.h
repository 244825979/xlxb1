//
//  ASVideoShowPublishController.h
//  AS
//
//  Created by SA on 2025/5/12.
//

#import "ASBaseViewController.h"
#import "UGCKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASVideoShowPublishController : ASBaseViewController
@property (nonatomic, strong) UGCKitMedia *media;
@property (nonatomic, strong) NSArray<UIImage *> *images;
@end

NS_ASSUME_NONNULL_END
