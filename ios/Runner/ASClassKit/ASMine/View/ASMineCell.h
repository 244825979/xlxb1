//
//  ASMineCell.h
//  AS
//
//  Created by SA on 2025/4/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ASMineCellType){
    kMineCellDefault = 0,       //默认
    kMineCellInvite = 1,        //邀请
    kMineCellTask = 2,          //任务
    kMineCellService = 3,       //客服
    kMineCellConvenient = 4,    //便捷用语
    kMineCellMoney = 5,         //充值金币
};

@interface ASMineCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) ASMineCellType type;
@property (nonatomic, assign) BOOL isFirstCell;
@property (nonatomic, assign) BOOL isLastCell;
@property (nonatomic, strong) UILabel *rightLabel;
@end

NS_ASSUME_NONNULL_END
