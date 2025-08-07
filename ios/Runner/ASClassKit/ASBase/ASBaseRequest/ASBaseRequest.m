//
//  ASBaseRequest.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASBaseRequest.h"
#import "ASBaseResultModel.h"
#import "ASAESUtil.h"
#import <AdSupport/ASIdentifierManager.h>
#import "KeychainTool.h"
#import "ASConvenienceLanListController.h"
#import "ASLoginBindPhoneController.h"

//任务数组
static NSMutableArray *tasks;
static AFHTTPSessionManager *manager;

@implementation ASBaseRequest

//单例
+ (ASBaseRequest *)shared {
    static ASBaseRequest *handler = nil;
    static dispatch_once_t onceToken;
    //实例化一次
    dispatch_once(&onceToken, ^{
        handler =[[ASBaseRequest alloc]init];
    });
    return handler;
}

//任务数组
+ (NSMutableArray *)tasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tasks = [[NSMutableArray alloc] init];
    });
    return tasks;
}

//获取AFHTTPSessionManager
+ (AFHTTPSessionManager *)sharedHTTPSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//初始化一次
        manager = [AFHTTPSessionManager manager];
        // 声明获取到的数据格式
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        if ([ASConfigConst shared].serverType == kServerPublish) {
            manager.responseSerializer = [AFCompoundResponseSerializer serializer];
        }
        // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = REQUEST_TIME_OUT;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        /** 声明支持的Content-Types */
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml",@"image/*",@"text/plain",nil];
    });
    return manager;
}

#pragma makr - 开始监听网络连接
+ (void)startMonitoring {
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                ASLog(@"未知网络");
                [ASBaseRequest shared].networkStats = kStatusUnknown;
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                ASLog(@"没有网络");
                [ASBaseRequest shared].networkStats = kStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                ASLog(@"手机自带网络");
                [ASBaseRequest shared].networkStats = kStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                [ASBaseRequest shared].networkStats = kStatusReachableViaWIFI;
                ASLog(@"WIFI--%d",[ASBaseRequest shared].networkStats);
                break;
        }
    }];
    [manager startMonitoring];
}

//调用get请求
+ (URLSessionTask *)getWithUrl:(NSString *)url
                        params:(NSDictionary *)params
                       success:(ResponseSuccess)success
                          fail:(ResponseFail)fail
                       showHUD:(BOOL)showHUD {
    
    //请求地址拼接
    NSString *urls = nil;
    if (![url containsString:@"http"]) {
        urls = [NSString stringWithFormat:@"%@%@",SERVER_URL, url];
    }else {
        urls = url;
    }
    //封装的请求函数 type=1表示get =2表示post
    return [self baseRequestWithType:1 url:urls params:params success:success fail:fail showHUD:showHUD];
}

//调用post请求
+ (URLSessionTask *)postWithUrl:(NSString *)url
                         params:(id)params
                        success:(ResponseSuccess)success
                           fail:(ResponseFail)fail
                        showHUD:(BOOL)showHUD{
    //请求地址拼接
    NSString *urls = nil;
    if (![url containsString:@"http"]) {
        urls = [NSString stringWithFormat:@"%@%@",SERVER_URL, url];
    }else {
        urls = url;
    }
    //封装的请求函数 type=1表示get =2表示post
    return [self baseRequestWithType:2 url:urls params:params success:success fail:fail showHUD:showHUD];
}

/**
 *  网络请求封装，用的是AFNetWorking 3.1.0
 *  (NSUInteger)type， type=1 get请求 type=2 post请求
 */
+ (URLSessionTask *)baseRequestWithType:(NSUInteger)type
                                    url:(NSString *)url
                                 params:(id)params
                                success:(ResponseSuccess)success
                                   fail:(ResponseFail)fail
                                showHUD:(BOOL)showHUD {
    kWeakSelf(self);
    //检查url参数
    if (kStringIsEmpty(url)) {
        return nil;
    }
    //显示loading
    if (showHUD) {
        [ASMsgTool showLoading];
    }
    
    //检查地址中是否有中文
    AFHTTPSessionManager *manager = [self sharedHTTPSession];
    //manager stary
    URLSessionTask *sessionTask = nil;
    //再次设置请求头
    [self sharedHTTPSession].requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:STRING(USER_INFO.token) forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:APP_CHANNEL forHTTPHeaderField:@"channel"];//渠道号
    [manager.requestSerializer setValue:STRING([KeychainTool getDeviceIDInKeychain]) forHTTPHeaderField:@"oaid"];
    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"source-id"];//2为IOS
    [manager.requestSerializer setValue:STRING([KeychainTool getDeviceIDInKeychain]) forHTTPHeaderField:@"uuid"];
    [manager.requestSerializer setValue:@"fdqn-white" forHTTPHeaderField:@"theme"];//默认
    NSString *verCode = [STRING(kAppVersion) stringByReplacingOccurrencesOfString:@"." withString:@""];
    [manager.requestSerializer setValue:STRING(verCode) forHTTPHeaderField:@"ver-code"];//版本号
    [manager.requestSerializer setValue:STRING(kAppVersion) forHTTPHeaderField:@"version"];//版本名称
    [manager.requestSerializer setValue:STRING([ASCommonFunc getPhoneName]) forHTTPHeaderField:@"phone-brand"];//手机品牌
    [manager.requestSerializer setValue:kAppBundleID forHTTPHeaderField:@"package-name"];
    [manager.requestSerializer setValue:@"AS" forHTTPHeaderField:@"signature"];
    [manager.requestSerializer setValue:STRING(IDFV) forHTTPHeaderField:@"idfv"];
    
    if (@available(iOS 14, *)) {
        NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
        [manager.requestSerializer setValue:STRING(idfa) forHTTPHeaderField:@"idfa"];
    } else {
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            [manager.requestSerializer setValue:STRING(idfa) forHTTPHeaderField:@"idfa"];
        } else {
            [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"idfa"];
        }
    }
    ASLog(@"******************** 请求参数 ***************************");
    ASLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",[self sharedHTTPSession].requestSerializer.HTTPRequestHeaders, @(type),url, params);
    ASLog(@"******************************************************");
    if (type == 1) {//get
        sessionTask = [manager GET:url
                        parameters:params
                           headers:nil
                          progress:nil
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            ASBaseResultModel *result = [[ASBaseResultModel alloc]init];
            if ([ASConfigConst shared].serverType == kServerPublish) {
                NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSString *jsonStr = [ASAESUtil AES128Encrypt:resultStr];
                ASLog(@"请求URL: %@\n请求结果=%@", url, [ASCommonFunc convertJsonStringToNSDictionary: jsonStr]);
                result = [ASBaseResultModel mj_objectWithKeyValues: [ASCommonFunc convertJsonStringToNSDictionary: jsonStr]];
            } else {
                ASLog(@"请求URL: %@\n请求结果=%@",url,responseObject);
                result = [ASBaseResultModel mj_objectWithKeyValues: responseObject];
            }
            if (result.code == 0) { //请求成功
                success(result.data);
            } else {
                //特殊的错误状态码处理
                [wself requestFailWithUrl:url params:params result:result];
                //返回错误码和错误信息给上一层
                fail(result.code, STRING(result.message));
            }
            [[wself tasks] removeObject:sessionTask];
            //如果有loading就隐藏
            if (showHUD == YES) {
                [ASMsgTool hideMsg];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            ASLog(@"error=%@",error);
            //错误提示
            kShowToast(NET_ERROR);
            //请求失败
            if (fail) {
                fail([[error valueForKey:@"code"] intValue], NET_ERROR);
            }
            [[wself tasks] removeObject:sessionTask];
            if (showHUD == YES) {
                [ASMsgTool hideMsg];
            }
        }];
    } else {//post
        sessionTask = [manager POST:url
                         parameters:params
                            headers:nil
                           progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            ASBaseResultModel *result = [[ASBaseResultModel alloc]init];
            if ([ASConfigConst shared].serverType == kServerPublish) {//正式环境
                NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSString *jsonStr = [ASAESUtil AES128Decrypt:resultStr];
                ASLog(@"请求URL: %@\n请求结果=%@", url, [ASCommonFunc convertJsonStringToNSDictionary: jsonStr]);
                result = [ASBaseResultModel mj_objectWithKeyValues: [ASCommonFunc convertJsonStringToNSDictionary: jsonStr]];
            } else {
                ASLog(@"请求URL: %@\n请求结果=%@",url,responseObject);
                result = [ASBaseResultModel mj_objectWithKeyValues: responseObject];
            }
            if (result.code == 0) {//请求成功返回数据
                success(result.data);
            } else {//请求失败返回
                //特殊的错误状态码处理
                [wself requestFailWithUrl:url params:params result:result];
                //返回错误码
                fail(result.code, STRING(result.message));
            }
            [[wself tasks] removeObject:sessionTask];
            if (showHUD == YES) {
                [ASMsgTool hideMsg];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            ASLog(@"error=%@",error);
            //错误提示
            kShowToast(NET_ERROR);
            //错误提示
            fail([[error valueForKey:@"code"] intValue], NET_ERROR);
            [[wself tasks] removeObject:sessionTask];
            if (showHUD == YES) {//关闭加载提示
                [ASMsgTool hideMsg];
            }
        }];
    }
    //添加任务
    if (sessionTask) {
        [[wself tasks] addObject:sessionTask];
    }
    return sessionTask;
}

//请求完成响应，请求失败对应错误码返回错误码处理
+ (void)requestFailWithUrl:(NSString *)url params:(NSDictionary *)params result:(ASBaseResultModel *)result {
    switch (result.code) {
        case 1001://登录状态丢失处理
        {
            //调用退出登录方法清除用户数据
            [USER_INFO removeUserData:^{
                
            }];
        }
            break;
        case 1009://封号处理
        {
            [ASAlertViewManager defaultPopTitle:@"无法登录" content:STRING(result.message) left:@"退出心聊想伴" right:@"联系客服" affirmAction:^{
                //关闭app
                exit(0);
            } cancelAction:^{
                ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Customer];
                [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
            }];
        }
            break;
        case 1010://进行人脸核验弹出窗
        {
            [ASAlertViewManager popFaceVerificationView];
        }
            break;
        case 1012://理性消费提示弹窗
        {
            [ASAlertViewManager defaultPopTitle:@"理性消费提示" content:STRING(result.message) left:@"确定" right:@"" affirmAction:^{
                
            } cancelAction:^{
                
            }];
        }
            break;
        case 1002:
        case 1003://余额不足
        {
            if ([url containsString:API_CheckCallMoney]) {//校验接听接口不执行余额不足弹窗
                return;
            }
            NSString *scene = Pay_Scene_PayCenter; //默认给到充值中心充值
            if ([url containsString:API_BeckonSend]) {//打招呼
                scene = Pay_Scene_SayHello;
            }
            if ([url containsString:API_VerifySendIM]) {//校验发送IM消息
                scene = Pay_Scene_Chat;
            }
            if ([url containsString:API_CallNew]) {//获取房间号。视频0 or 语音1
                NSNumber *type = [params objectForKey:@"type"];
                scene = type.integerValue == 0 ? Pay_Scene_VideoCalling : Pay_Scene_VoiceCalling;
            }
            if ([url containsString:API_SendGift]) {//聊天赠送礼物
                scene = Pay_Scene_ChatGift;
            }
            [ASMyAppCommonFunc balanceDeficiencyPopViewWithPayScene:scene cancel:^{
                
            }];
        }
            break;
        case 1011://未设置快捷用语
        {
            [ASAlertViewManager defaultPopTitle:@"温馨提示" content:STRING(result.message) left:@"去设置" right:@"取消" affirmAction:^{
                ASConvenienceLanListController *vc = [[ASConvenienceLanListController alloc] init];
                [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
            } cancelAction:^{ }];
        }
            break;
        case 1013:
        {
            if ([url containsString:API_AppleRecharge]) {
                [ASAlertViewManager popPhoneBindAlertViewWithVc:[ASCommonFunc currentVc] content:STRING(result.message) isPopWindow:YES affirmAction:^{
                    ASLoginBindPhoneController *vc = [[ASLoginBindPhoneController alloc] init];
                    [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                } cancelBlock:^{
                }];
            }
        }
            break;
        default:
        {
            //过滤提示toast
            //动态详情接口，删除操作就不显示提示文本。
            if ([url containsString:API_DynamicDetail] && result.code == 60001) {
                return;
            }
            //统计
            if ([url containsString:API_BehaviorStats] ||
                [url containsString:API_PopupTracking] ||
                [url containsString:API_ReportAppOpen]) {
                return;
            }
            //用户主页封号或者注销状态
            if ([url containsString:API_UserIndex] && (result.code == 3001 || result.code == 3002)) {
                return;
            }
            //错误提示
            kShowToast(result.message);
        }
            break;
    }
}

/** 上传文件(图片) 单张*/
+ (URLSessionTask *)updataWithUrl:(NSString *)url
                           params:(NSDictionary *)dict
                         fileData:(NSData *)imageData
                          fileKey:(NSString *)fileKey
                         fileName:(NSString *)fileName
                     successBlock:(ResponseSuccess)success
                      failurBlock:(ResponseFail)fail
                   upLoadProgress:(UploadProgress)progress {
    
    if (url == nil || fileName == nil) {
        ASLog(@"url参数不能为空");
        return nil;
    }
    URLSessionTask *sessionTask = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:STRING(USER_INFO.token) forHTTPHeaderField:@"token"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/json", @"text/javascript",@"text/html",@"text/xml",nil];
    ASLog(@"******************** 请求参数 ***************************");
    ASLog(@"请求头: %@\n请求方式: POST \n请求URL: %@\n请求param: %@\n\n",[self sharedHTTPSession].requestSerializer.HTTPRequestHeaders,url, dict);
    ASLog(@"******************************************************");
    kWeakSelf(self);
    sessionTask = [manager POST:url
                     parameters:dict
                        headers:nil
      constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:fileKey fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ASLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ASLog(@"上传图片成功 = %@",responseObject);
        ASBaseResultModel *result = [ASBaseResultModel mj_objectWithKeyValues: responseObject];
        if (result.code == 0) {//请求成功返回数据
            success(result.data);
        } else {//请求失败返回
            [wself requestFailWithUrl:url params:dict result:result];
            fail(result.code, STRING(result.message));
        }
        [ASMsgTool hideMsg];
        [[wself tasks] removeObject:sessionTask];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ASLog(@"上传失败 = %@",error);
        kShowToast(NET_ERROR);
        if (fail) {
            fail([[error valueForKey:@"code"] intValue], NET_ERROR);
        }
        [[wself tasks] removeObject:sessionTask];
    }];
    if (sessionTask) {
        [[wself tasks] addObject:sessionTask];
    }
    return sessionTask;
}

#pragma mark - 取消 Http 请求
/*!
 *  取消所有 Http 请求
 */
+ (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self tasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self tasks] removeAllObjects];
    }
}
@end
