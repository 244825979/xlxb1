//
//  ASBasePhotoCell.h
//  AS
//
//  Created by SA on 2025/4/21.
//  图片显示Cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASBasePhotoCell : UICollectionViewCell
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *state;//默认隐藏
@property (nonatomic, assign) BOOL isHidenDel;//是否可删除按钮
@property (nonatomic, copy) void (^delBlock)(void);
@end

NS_ASSUME_NONNULL_END
