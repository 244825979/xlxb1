//
//  ASVideoShowManager.m
//  AS
//
//  Created by SA on 2025/5/12.
//

#import "ASVideoShowManager.h"
#import <TXLiteAVSDK_UGC/TXLiteAVSDK.h>
#import "UGCKit.h"
#import "ASVideoShowPublishController.h"

@implementation ASVideoShowManager

+ (void)popPublishVideoShowWithAssets:(PHAsset *)asset {
    if (asset.duration > 16.0) {
        PHVideoRequestOptions *optionForCache = [[PHVideoRequestOptions alloc]init];
        optionForCache.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:optionForCache resultHandler:^(AVAsset * _Nullable avasset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (kObjectIsEmpty(avasset)) {
                    kShowToast(@"获取视频失败，请重试！");
                    return;
                }
                UGCKitMedia *media = [UGCKitMedia mediaWithAVAsset:avasset];
                media.imageCount = floorf(asset.duration);
                UGCKitCutViewController *cutViewController = [[UGCKitCutViewController alloc] initWithMedia:media theme:nil];
                cutViewController.shouldNavigationBarHidden = YES;
                cutViewController.completion = ^(UGCKitResult *result, int rotation) {
                    if ([result isCancelled]) {
                        [[ASCommonFunc currentVc].navigationController popViewControllerAnimated:YES];
                    } else {
                        CMTime backTime = result.media.videoAsset.duration;
                        int backSeconds = floorf(backTime.value/backTime.timescale);
                        NSMutableArray *images = [[NSMutableArray alloc] init];
                        [TXVideoInfoReader getSampleImages:backSeconds videoAsset:result.media.videoAsset progress:^BOOL(int number, UIImage *image) {
                            dispatch_async(dispatch_get_main_queue(), ^{@autoreleasepool {
                                [images addObject:image];
                            }});
                            if (number == backSeconds) {//数量达到了最大视频帧数
                                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
                                dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
                                    [[ASCommonFunc currentVc].navigationController popViewControllerAnimated:NO];
                                    ASVideoShowPublishController *vc = [[ASVideoShowPublishController alloc] init];
                                    vc.media = result.media;
                                    vc.images = images;
                                    [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                                });
                                return NO;
                            }
                            return YES;
                        }];
                    }
                };
                [[ASCommonFunc currentVc].navigationController pushViewController:cutViewController animated:YES];
            });
        }];
    } else {
        PHVideoRequestOptions *optionForCache = [[PHVideoRequestOptions alloc]init];
        optionForCache.networkAccessAllowed = YES;//设置网络视频的优先级
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:optionForCache resultHandler:^(AVAsset * _Nullable avasset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (kObjectIsEmpty(avasset)) {
                    kShowToast(@"获取视频失败，请重试！");
                    return;
                }
                [ASMsgTool showLoading: @"视频生成中..."];
            });
            UGCKitMedia *media = [UGCKitMedia mediaWithAVAsset:avasset];
            NSString *videoOutputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"outputCut.mp4"];
            NSFileManager *fm = [[NSFileManager alloc] init];
            NSString *rename = [videoOutputPath stringByAppendingString:@"-tmp.mp4"];
            [fm removeItemAtPath:rename error:nil];
            [fm moveItemAtPath:videoOutputPath toPath:rename error:nil];
            
            AVAssetExportSession *session;
            NSString *exportPreset = AVAssetExportPreset1280x720;
            session = [[AVAssetExportSession alloc] initWithAsset:media.videoAsset presetName:exportPreset];
            session.outputURL = [NSURL fileURLWithPath:rename];
            session.shouldOptimizeForNetworkUse = true;
            session.outputFileType = AVFileTypeMPEG4;
            [session exportAsynchronouslyWithCompletionHandler:^{
                if ([session status] == AVAssetExportSessionStatusCompleted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        media.videoPath = [session.outputURL path];
                        NSMutableArray* images = [[NSMutableArray alloc] init];
                        [TXVideoInfoReader getSampleImages:floorf(asset.duration) videoAsset:avasset progress:^BOOL(int number, UIImage *image) {
                            dispatch_async(dispatch_get_main_queue(), ^{@autoreleasepool {
                                [images addObject:image];
                            }});
                            if (number == floorf(asset.duration)) {
                                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
                                dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
                                    [ASMsgTool hideMsg];
                                    ASVideoShowPublishController *vc = [[ASVideoShowPublishController alloc] init];
                                    vc.media = media;
                                    vc.images = images;
                                    [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                                });
                                return NO;
                            }
                            return YES;
                        }];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ASMsgTool hideMsg];
                        kShowToast(@"视频生成失败");
                    });
                }
            }];
        }];
    }
}
@end
