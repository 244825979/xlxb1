//
//  ASIMHelperDataManager.h
//  AS
//
//  Created by SA on 2025/7/7.
//  IM的小助手数据及折叠数据本地管理

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASIMHelperDataManager : NSObject
//用户模型单例
+ (ASIMHelperDataManager *)shared;
@property (nonatomic, strong) NSMutableArray *helperList;//女用户，本地保存的小助手列表数据
@property (nonatomic, strong) NSMutableArray *dashanList;//搭讪列表
@property (nonatomic, assign) NSInteger dashanAmount;//搭讪数量
@end

NS_ASSUME_NONNULL_END
