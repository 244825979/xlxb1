//
//  ASCallItemView.h
//  AS
//
//  Created by SA on 2025/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ASCallItemType) {
    kItemTypeCallNoCalling = 0,                     //拨打方，未接通
    kItemTypeAnswerNoCalling = 1,                   //接听方，未接通
    kItemTypeCallCalling = 2,                       //已接通（不区分拨打或者接听）
};

@interface ASCallItemView : UIView
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, copy) VoidBlock actionBlock;
@end

NS_ASSUME_NONNULL_END
