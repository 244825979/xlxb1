//
//  ASEditDataModel.h
//  AS
//
//  Created by SA on 2025/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASEditDataModel : NSObject
@property (nonatomic, copy) NSString *is_marriage;//婚姻状态
@property (nonatomic, copy) NSString *occupation;//职业
@property (nonatomic, copy) NSString *education;//学历
@property (nonatomic, copy) NSString *user_id;//
@property (nonatomic, copy) NSString *weight;//体重
@property (nonatomic, copy) NSString *cityId;//所在地ID 显示or隐藏
@property (nonatomic, copy) NSString *hometown;//家乡
@property (nonatomic, copy) NSString *label;//标签，多个逗号隔开
@property (nonatomic, copy) NSString *age;//年龄
@property (nonatomic, copy) NSString *height;//身高
@property (nonatomic, copy) NSString *annual_income;//年收入
@property (nonatomic, copy) NSString *albums;//展示的照片，多张逗号隔开
@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, copy) NSString *signature;//个性签名
@property (nonatomic, copy) NSString *nickname;//昵称
@property (nonatomic, copy) NSString *voice;//声音链接
@property (nonatomic, assign) NSInteger voice_time;//声音长度
@end

NS_ASSUME_NONNULL_END
