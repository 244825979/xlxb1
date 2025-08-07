//
//  ASDataSelectManager.h
//  AS
//
//  Created by SA on 2025/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//单选类型
typedef NS_ENUM(NSInteger, OneSelectViewType){
    kOneSelectViewAge = 0,//年龄
    kOneSelectViewStature = 1,//身高
    kOneSelectViewWeight = 2,//体重
    kOneSelectViewIncome = 3,//收入
    kOneSelectViewEducation = 4,//学历
    kOneSelectViewCollectFee = 6,//收费设置
};

//多选类型
typedef NS_ENUM(NSInteger, MoreSelectViewType){
    kMoreSelectViewHometown = 0,//家乡
    kMoreSelectViewOccupation = 1,//职业
    kMoreSelectViewTime = 2,//时间筛选
    kMoreSelectViewAddress = 3,//所在地
};

@interface ASDataSelectManager : NSObject

//单选
- (void)selectViewOneDataWithType:(OneSelectViewType)type
                            value:(NSString *)value
                        listArray:(NSArray *)listArray
                           action:(SelectBlock)selectAction;

//多选
- (void)selectViewMoreDataWithType:(MoreSelectViewType)type
                         listArray:(NSArray *)listArray
                            action:(MoreSelectBlock)selectAction;
@end

NS_ASSUME_NONNULL_END
