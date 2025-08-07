//
//  ASRegisterTextView.h
//  AS
//
//  Created by SA on 2025/4/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RegisterTextViewType){
    kTextViewName = 0,                  //昵称输入
    kTextViewSelectAge = 1,             //选择框
    kTextViewInvitation = 2,            //邀请人
};

@interface ASRegisterTextView : UIView
@property (nonatomic, assign) BOOL isMan;
@property (nonatomic, assign) RegisterTextViewType viewType;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) VoidBlock changeNameBlock;
@property (nonatomic, copy) void (^inputBlock)(NSString *text);
@end

NS_ASSUME_NONNULL_END
