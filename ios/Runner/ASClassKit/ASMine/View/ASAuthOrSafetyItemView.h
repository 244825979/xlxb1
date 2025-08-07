//
//  ASAuthOrSafetyItemView.h
//  AS
//
//  Created by SA on 2025/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, AuthOrSafetyItemType){
    kAuthItemType = 0,       //认证样式
    kSafetyItemType = 1,     //安全中心样式
};

@interface ASAuthOrSafetyItemView : UIView
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *state;
@property (nonatomic, strong) UIButton *goAuth;
@property (nonatomic, copy) VoidBlock actionBlock;
@property (nonatomic, assign) NSInteger stateValue;//1、通过。2、审核中
@property (nonatomic, assign) AuthOrSafetyItemType itemType;
@end

NS_ASSUME_NONNULL_END
