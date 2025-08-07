//
//  ASBindAccountSubView.h
//  AS
//
//  Created by SA on 2025/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ASBindAccountViewType){
    kBindAccountViewDefault = 0,         //默认文本
    kBindAccountViewAcount = 1,          //账号显示
    kBindAccountViewTextField = 2,       //文本输入类型
};

@interface ASBindAccountSubView : UIView
@property (nonatomic, strong) UILabel *leftTitle;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, assign) ASBindAccountViewType type;
@property (nonatomic, copy) TextBlock inputClickBlock;
@end

NS_ASSUME_NONNULL_END
