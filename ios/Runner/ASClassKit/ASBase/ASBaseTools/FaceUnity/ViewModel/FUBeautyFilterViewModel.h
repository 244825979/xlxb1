//
//  FUBeautyFilterViewModel.h
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/7/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FUBeautyFilterModel;

NS_ASSUME_NONNULL_BEGIN

@interface FUBeautyFilterViewModel : NSObject

@property (nonatomic, copy, readonly) NSArray<FUBeautyFilterModel *> *beautyFilters;
/// 选中滤镜索引
@property (nonatomic, assign) NSInteger selectedIndex;

/// 设置滤镜程度
/// @param value 程度值
- (void)setFilterValue:(double)value;

/// 保存滤镜数据到本地
- (void)saveFitersPersistently;

/// 设置当前滤镜
- (void)setCurrentFilter;

@end

NS_ASSUME_NONNULL_END
