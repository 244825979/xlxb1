//
//  ASSendVipPopView.h
//  AS
//
//  Created by SA on 2025/5/20.
//

#import <UIKit/UIKit.h>
#import "ASSendVipModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASSendVipPopView : UIView
@property (nonatomic, copy) VoidBlock cancelBlock;
@property (nonatomic, copy) NSString *toUserID;
@property (nonatomic, strong) ASSendVipModel *sendVipModel;
@end

@interface ASSendVipOpenItemView : UIView
@property (nonatomic, strong) ASSendVipGoodListModel *model;
@property (nonatomic, copy) void (^itemClikedBlock)(ASSendVipOpenItemView *view);
@property (nonatomic, assign) BOOL isSelect;
@end


NS_ASSUME_NONNULL_END
