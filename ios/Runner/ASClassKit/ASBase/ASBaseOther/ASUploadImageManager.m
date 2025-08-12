
#import "ASUploadImageManager.h"
#import "TZImagePickerController.h"
#import <AliyunOSSiOS/OSSService.h>
#import "ASAliOSSModel.h"
#import "Runner-Swift.h"

@interface ASUploadImageManager ()<TZImagePickerControllerDelegate>
@property (nonatomic, strong) ASAliOSSModel *ossModel;
@property (nonatomic, strong) OSSClient *client;
@end

@implementation ASUploadImageManager

+ (ASUploadImageManager *)shared {
    static dispatch_once_t onceToken;
    static ASUploadImageManager *instance = nil;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[ASUploadImageManager alloc] init];
        }
    });
    return instance;
}

- (void)requestAliOSSInitWithType:(NSString *)type
                          success:(ResponseSuccess)success
                             fail:(void(^)(void))fail {
    kWeakSelf(self);
    [ASCommonRequest requestAliOSSWithType:type success:^(id  _Nullable data) {
        wself.ossModel = data;
        //初始化oss
        OSSStsTokenCredentialProvider *provider = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:wself.ossModel.AccessKeyId secretKeyId:wself.ossModel.AccessKeySecret securityToken:wself.ossModel.SecurityToken];
        wself.client = [[OSSClient alloc] initWithEndpoint:wself.ossModel.Endpoint credentialProvider:provider];
        //获取数据成功
        success(data);
    } errorBack:^(NSInteger code, NSString *msg) {
        fail();
    }];
}

- (void)selectImagePickerWithMaxCount:(NSInteger)maxCount//数量
                       isSelfieCamera:(BOOL)isSelfieCamera//是否是自拍
                       viewController:(UIViewController *)vc
                            didFinish:(DidFinishPickingPhotosHandle)didFinish {
    //弹出选择照片
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.sortAscendingByModificationDate = NO;//对照片排序，按修改时间升序默认为YES
    imagePickerVc.allowPickingOriginalPhoto = NO;//是否可以选择原图
    if (isSelfieCamera == YES) {
        imagePickerVc.allowCrop = YES;//允许裁剪,默认为YES，showSelectBtn为NO才生效
        imagePickerVc.cropRect = CGRectMake(0, SCREEN_HEIGHT/2 - SCREEN_WIDTH/2 - 20, SCREEN_WIDTH, SCREEN_WIDTH);
    } else {
        imagePickerVc.allowCrop = NO;//不是自拍，不允许裁剪
    }
    imagePickerVc.allowPickingVideo = NO;//默认为YES，如果设置为NO,用户将不能选择视频
    imagePickerVc.allowTakeVideo = NO;//默认为YES，如果设置为NO, 用户将不能拍摄视频
    imagePickerVc.isSelfieCamera = isSelfieCamera;//YES设置为自拍
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto) {
        didFinish(photos, assets, isSelectOriginalPhoto);
    }];
    [vc presentViewController:imagePickerVc animated:YES completion:nil];
}

//在相册选择视频，视频秀
- (void)selectVideoShowPickerWithViewController:(UIViewController *)vc
                                      didFinish:(DidFinishPickingVideoHandle)didFinish {
    //弹出选择照片
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.allowPickingImage = NO;
    imagePickerVc.videoMaximumDuration = 15;
    imagePickerVc.videoMinSelectDuration = 3;
    imagePickerVc.sortAscendingByModificationDate = NO;//对照片排序，按修改时间升序默认为YES
    imagePickerVc.allowPickingOriginalPhoto = NO;//是否可以选择原图
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickerVc.oKButtonTitleColorNormal = MAIN_COLOR;
    imagePickerVc.viewBackBlock = ^(NSInteger tag) {
        if (tag == 1) {
            kShowToast(@"视频时长不足3s");
        }
    };
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        didFinish(coverImage, asset);
    }];
    [vc presentViewController:imagePickerVc animated:YES completion:nil];
}

//单图上传
- (void)oneImageUpdateWithAliOSSType:(NSString *)type
                               imgae:(UIImage *)image
                             success:(ResponseSuccess)success
                                fail:(void(^)(void))fail {
    [ASMsgTool showLoading:@"正在上传中..."];
    kWeakSelf(self);
    [self requestAliOSSInitWithType:type success:^(id  _Nonnull response) {
        OSSPutObjectRequest * put = [[OSSPutObjectRequest alloc] init];
        // 填写Bucket名称，例如examplebucket。
        put.bucketName = wself.ossModel.BucketName;
        // 填写Object完整路径。Object完整路径中不能包含Bucket名称，例如exampledir/testdir/exampleobject.txt。
        NSInteger randomNum = arc4random_uniform(1000000);
        NSString *url = [NSString stringWithFormat:@"%@/%@%zd.jpg", wself.ossModel.dir, [ASCommonFunc currentTimeStr], randomNum];
        put.objectKey = url;
        // 直接上传NSData。
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        put.uploadingData = imageData;
        OSSTask *putTask = [wself.client putObject:put];
        [putTask continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                //上传成功
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ASMsgTool hideMsg];
                    success(url);
                });
            } else {
                //上传失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ASMsgTool hideMsg];
                    kShowToast(@"上传失败");
                    fail();
                });
            }
            return nil;
        }];
    } fail:^{
        //获取ali鉴权失败
        [ASMsgTool hideMsg];
        fail();
    }];
}

//多图上传
- (void)imagesUpdateWithAliOSSType:(NSString *)type
                            imgaes:(NSArray<UIImage*>*)images
                           success:(ResponseSuccess)success
                              fail:(void(^)(void))fail {
    kWeakSelf(self);
    [self requestAliOSSInitWithType:type success:^(id  _Nonnull response) {
        ASUploadProgressView *updateProgressView = [[ASUploadProgressView alloc]init];
        [updateProgressView showWithTitle:@"正在上传图片" fromView:kCurrentWindow];
        NSMutableArray *urls = [[NSMutableArray alloc] init];
        //循环上传
        for (UIImage *img in images) {
            //单张上传
            [wself updatePhotoWithImage:img success:^(NSString * _Nullable url) {
                [urls addObject:url];
                //计算进度值
                CGFloat progress = (CGFloat)urls.count / (CGFloat)images.count;
                [updateProgressView setPhotoProgressWithText:[NSString stringWithFormat:@"%zd/%zd", urls.count, images.count] progress:(NSInteger)(progress*100)];
                //图片上传数量相同，表示成功，保存编辑信息
                if (urls.count == images.count) {
                    [updateProgressView dismiss];
                    success(urls);//返回上传完成的url数组
                }
            } error:^{
                [updateProgressView dismiss];
                kShowToast(@"上传中断！");
                fail();
                [ASMsgTool hideMsg];
            }];
        }
    } fail:^{
        //获取ali鉴权失败
        [ASMsgTool hideMsg];
        fail();
    }];
}

- (void)updatePhotoWithImage:(UIImage *)image
                     success:(nullable void (^)(id _Nullable  data))success
                       error:(nullable void (^)(void))error {
    OSSPutObjectRequest *put = [[OSSPutObjectRequest alloc] init];
    // 填写Bucket名称，例如examplebucket。
    put.bucketName = self.ossModel.BucketName;
    // 填写Object完整路径。Object完整路径中不能包含Bucket名称，例如exampledir/testdir/exampleobject.txt。
    NSInteger randomNum = arc4random_uniform(1000000);
    NSString *url = [NSString stringWithFormat:@"%@/%@%zd.jpg",self.ossModel.dir, [ASCommonFunc currentTimeStr], randomNum];
    put.objectKey = url;
    // 直接上传NSData。
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    put.uploadingData = imageData;
    // 进度
    OSSTask *putTask = [self.client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(url);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                error();
            });
        }
        return nil;
    }];
}

//音频文件上传
- (void)audioUpdateWithType:(NSString *)type
                   filePath:(NSString *)path
                    success:(ResponseSuccess)success
                       fail:(void(^)(void))fail {
    [ASMsgTool showLoading:@"音频上传中..."];
    kWeakSelf(self);
    [self requestAliOSSInitWithType:type success:^(id  _Nonnull response) {
        OSSPutObjectRequest * put = [[OSSPutObjectRequest alloc] init];
        // 填写Bucket名称，例如examplebucket。
        put.bucketName = wself.ossModel.BucketName;
        // 填写Object完整路径。Object完整路径中不能包含Bucket名称，例如exampledir/testdir/exampleobject.txt。
        NSInteger randomNum = arc4random_uniform(1000000);
        NSString *url = [NSString stringWithFormat:@"%@/%@%zd.mp3", wself.ossModel.dir, [ASCommonFunc currentTimeStr], randomNum];
        put.objectKey = url;
        // 直接上传NSData。
        NSData *mp3Data = [NSData dataWithContentsOfFile:path];
        put.uploadingData = mp3Data;
        OSSTask * putTask = [wself.client putObject:put];
        [putTask continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                //上传成功
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ASMsgTool hideMsg];
                    success(url);
                });
            } else {
                //上传失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ASMsgTool hideMsg];
                    kShowToast(@"上传失败");
                    fail();
                });
            }
            return nil;
        }];
    } fail:^{
        //获取ali鉴权失败
        [ASMsgTool hideMsg];
        fail();
    }];
}

//查看图片
- (void)showMediaWithPhotos:(NSArray<GKPhoto *> *)photos index:(NSInteger)index viewController:(UIViewController *)vc {
    GKPhotoBrowserConfigure *configure = GKPhotoBrowserConfigure.defaultConfig;
    configure.showStyle = GKPhotoBrowserShowStyleZoom;
    configure.isAdaptiveSafeArea = YES;
    configure.hidesPageControl = YES;
    configure.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex: index];
    browser.isStatusBarShow = YES;
    browser.configure = configure;
    [browser showFromVC:vc];
}

//查看图片可设置按钮文案和获取点击事件
- (void)showMediaWithPhotos:(NSArray<GKPhoto *> *)photos
                      index:(NSInteger)index
                    btnText:(NSString *)btnText
             viewController:(UIViewController *)vc
                  backBlock:(void(^)(NSInteger index, GKPhotoBrowser *browser))backBlock {
    
    GKPhotoBrowserConfigure *configure = GKPhotoBrowserConfigure.defaultConfig;
    configure.showStyle = GKPhotoBrowserShowStyleZoom;
    configure.isAdaptiveSafeArea = YES;
    configure.hidesPageControl = YES;
    configure.hidesSavedBtn = NO;//不隐藏按钮
    configure.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex: index];
    browser.configure = configure;
    browser.isStatusBarShow = YES;
    [browser.saveBtn setTitle:STRING(btnText) forState:UIControlStateNormal];
    __weak typeof(browser) wBrowser = browser;
    [[browser.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        backBlock(wBrowser.currentIndex, wBrowser);
    }];
    [browser showFromVC:vc];
}

@end
