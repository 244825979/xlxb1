//
//  图片选择上传管理

#import <Foundation/Foundation.h>
#import <GKPhotoBrowser/GKPhotoBrowser.h>
@class GKPhoto;
NS_ASSUME_NONNULL_BEGIN

typedef void (^DidFinishPickingPhotosHandle)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto);
typedef void (^DidFinishPickingVideoHandle)(UIImage *coverImage, PHAsset *asset);

@interface ASUploadImageManager : NSObject

// 用户模型单例
+ (ASUploadImageManager *)shared;

//在相册选择图片
- (void)selectImagePickerWithMaxCount:(NSInteger)maxCount//数量
                       isSelfieCamera:(BOOL)isSelfieCamera//是否是自拍
                       viewController:(UIViewController *)vc
                            didFinish:(DidFinishPickingPhotosHandle)didFinish;
//在相册选择视频，视频秀
- (void)selectVideoShowPickerWithViewController:(UIViewController *)vc
                                      didFinish:(DidFinishPickingVideoHandle)didFinish;
//获取阿里云鉴权初始化
- (void)requestAliOSSInitWithType:(NSString *)type
                          success:(ResponseSuccess)success
                             fail:(void(^)(void))fail;
//单图上传
- (void)oneImageUpdateWithAliOSSType:(NSString *)type 
                               imgae:(UIImage *)image
                             success:(ResponseSuccess)success
                                fail:(void(^)(void))fail;
//多图上传
- (void)imagesUpdateWithAliOSSType:(NSString *)type
                            imgaes:(NSArray<UIImage*>*)images
                           success:(ResponseSuccess)success
                              fail:(void(^)(void))fail;
//音频文件上传
- (void)audioUpdateWithType:(NSString *)type
                   filePath:(NSString *)path
                    success:(ResponseSuccess)success
                       fail:(void(^)(void))fail;
//查看图片
- (void)showMediaWithPhotos:(NSArray<GKPhoto *> *)photos index:(NSInteger)index viewController:(UIViewController *)vc;
//查看图片可定义按钮及返回点击事件
- (void)showMediaWithPhotos:(NSArray<GKPhoto *> *)photos
                      index:(NSInteger)index
                    btnText:(NSString *)btnText
             viewController:(UIViewController *)vc
                  backBlock:(void(^)(NSInteger index, GKPhotoBrowser *browser))backBlock;
@end

NS_ASSUME_NONNULL_END
