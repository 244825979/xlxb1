//
//  ASBaseRequest.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//网络状态
typedef enum {
    kStatusUnknown          = -1, //未知网络
    kStatusNotReachable     =  0, //没有网络
    kStatusReachableViaWWAN =  1, //手机自带网络
    kStatusReachableViaWIFI =  2  //WIFI
} NetworkStatus;

//上传进度
typedef void(^UploadProgress)(int64_t bytesProgress, int64_t totalBytesProgress);
//下载进度
typedef void(^DownloadProgress)(int64_t bytesProgress, int64_t totalBytesProgress);
/**
 *  方便管理请求任务。执行取消，暂停，继续等任务.
 *  - (void)cancel，取消任务
 *  - (void)suspend，暂停任务
 *  - (void)resume，继续任务
 */
typedef NSURLSessionTask URLSessionTask;

@interface ASBaseRequest : NSObject
@property (nonatomic, copy) NSString *netWorkStatus;//网络状态
@property (nonatomic,assign) NetworkStatus networkStats;//获取当前网络状态
+ (ASBaseRequest *_Nullable)shared;//Http单例
+ (void)startMonitoring;//开启网络监测
+ (void)cancelAllRequest;//取消所有 Http 请求

/**
 *  get请求方法,block回调
 *
 *  @param url     请求连接，根路径
 *  @param params  参数
 *  @param success 请求成功返回数据
 *  @param fail    请求失败
 *  @param showHUD 是否显示HUD
 */
+ (URLSessionTask *_Nullable)getWithUrl:(NSString *_Nullable)url
                                 params:(NSDictionary *_Nullable)params
                                success:(ResponseSuccess _Nullable )success
                                   fail:(ResponseFail _Nullable )fail
                                showHUD:(BOOL)showHUD;

/**
 *  post请求方法,block回调
 *
 *  @param url     请求连接，根路径
 *  @param params  参数
 *  @param success 请求成功返回数据
 *  @param fail    请求失败
 *  @param showHUD 是否显示HUD
 */
+ (URLSessionTask *_Nullable)postWithUrl:(NSString *_Nullable)url
                                  params:(NSDictionary *_Nullable)params
                                 success:(ResponseSuccess _Nullable )success
                                    fail:(ResponseFail _Nonnull )fail
                                 showHUD:(BOOL)showHUD;

/** 上传文件(图片) 单张*/
+ (URLSessionTask *_Nullable)updataWithUrl:(NSString *_Nullable)url
                                    params:(NSDictionary *_Nullable)dict
                                  fileData:(NSData *_Nullable)imageData
                                   fileKey:(NSString *_Nullable)fileKey
                                  fileName:(NSString *_Nullable)fileName
                              successBlock:(ResponseSuccess _Nullable )success
                               failurBlock:(ResponseFail _Nullable )fail
                            upLoadProgress:(UploadProgress _Nullable )progress;
@end

NS_ASSUME_NONNULL_END
