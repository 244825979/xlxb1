//
//  ASBaseWebViewController.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASBaseWebViewController : ASBaseViewController
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, copy) void (^backBlock)(void);//点击按钮返回执行
@property (nonatomic, copy) NSString *showNavigationTitle;//是否需要手动创建导航
@property (nonatomic, copy) NSString *notifylogID;//须知是否同意，未同意提示底部view
@end

NS_ASSUME_NONNULL_END
