//
//  ASDataSelectModel.h
//  AS
//
//  Created by SA on 2025/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//价格
@interface ASCollectFeeSelectModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger star_grade;
@property (nonatomic, assign) NSInteger coins;
@property (nonatomic, assign) NSInteger status;
@end

//职业
@interface ASOccupationListModel : NSObject
@property (nonatomic, copy) NSString *key;//一级名称
@property (nonatomic, strong) NSArray *val;//二级列表
@end

//省市
@interface ASProvinceCitysListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;//名称
@property (nonatomic, copy) NSString *parent_id;//父类的id 省份无此id
@property (nonatomic, strong) NSArray<ASProvinceCitysListModel *> *child;//城市
@end

@interface ASDataSelectModel : NSObject
@property (nonatomic, strong) NSArray *height;//身高
@property (nonatomic, strong) NSArray *weight;//体重
@property (nonatomic, strong) NSArray *annual_income;//收入
@property (nonatomic, strong) NSArray *education;//学历
@property (nonatomic, strong) NSArray *is_marriage;//婚姻状况
@property (nonatomic, strong) NSArray<ASOccupationListModel *> *occupation;
@end

NS_ASSUME_NONNULL_END
