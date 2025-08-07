//
//  FaceUnityManager.h
//  FUDemo
//
//  Created by 项林平 on 2021/6/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "FaceUnityRecorder.h"
#import "FUDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaceUnityManager : NSObject

/// 开关状态
@property (nonatomic, assign, readonly) BOOL shouldRender;

+ (instancetype)shared;

/// 初始化FURenderKit
+ (void)setupFUSDK;

/// 注销FURenderKit和单例
+ (void)destory;

/// 加载美颜效果
- (void)loadBeauty;

//重置默认的所有的美颜设置
- (void)resetFUConfig;

/// 保存当前美颜数据到本地
- (void)saveBeauty;

/// 重置检测结果
+ (void)resetTrackedResult;

/// 更新美颜磨皮效果（根据人脸检测置信度设置不同磨皮效果）
+ (void)updateBeautyBlurEffect;

/// 添加视图到指定父视图
/// @param view 父视图
/// @param originY 视图在父视图上的Y坐标（底部功能选择栏的Y坐标，X坐标默认为0）
- (void)addFUViewToView:(UIView *)view originY:(CGFloat)originY;

@end

NS_ASSUME_NONNULL_END
