//
//  ASAppConfigDataModel.h
//  AS
//
//  Created by SA on 2025/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASWebUrlModel : NSObject
@property (nonatomic, copy) NSString *share;
@property (nonatomic, copy) NSString *publish;
@property (nonatomic, copy) NSString *taskCenter;
@property (nonatomic, copy) NSString *anchorStarlevel;
@property (nonatomic, copy) NSString *tv;
@property (nonatomic, copy) NSString *userProtocol;
@property (nonatomic, copy) NSString *teenagerProtocol;//未成人充值协议
@property (nonatomic, copy) NSString *customer;
@property (nonatomic, copy) NSString *recharge;//充值协议
@property (nonatomic, copy) NSString *chargeRule;//收费设置说明
@property (nonatomic, copy) NSString *likeProtocol;//赞赏须知
@property (nonatomic, copy) NSString *approveRule;//内容审核规则说明
@property (nonatomic, copy) NSString *operateRule;//内容发布运营规划
@end

@interface ASConfigModel : NSObject
@property (nonatomic, copy) NSString *sysId;
@property (nonatomic, copy) NSString *servId;
@property (nonatomic, copy) NSString *image_server;
@property (nonatomic, copy) NSString *baozhifu_text;
@end

@interface ASVersionModel : NSObject
@property (nonatomic, copy) NSString *downloadurl;
@property (nonatomic, assign) NSInteger enforce;//是否强制更新
@property (nonatomic, copy) NSString *newversion;
@property (nonatomic, copy) NSString *upgradetext;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *versioncode;
@end

@interface ASAppConfigDataModel : NSObject
@property (nonatomic, copy) NSString *rank_url;
@property (nonatomic, copy) NSString *rank_url_full;
@property (nonatomic, strong) ASWebUrlModel *webUrl;
@property (nonatomic, strong) ASConfigModel *config;
@property (nonatomic, strong) ASVersionModel *version;
@end

NS_ASSUME_NONNULL_END
