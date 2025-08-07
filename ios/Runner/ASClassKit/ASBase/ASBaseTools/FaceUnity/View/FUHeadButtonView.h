//
//  FUHeadButtonView.h
//  huanliao
//
//  Created by quxing on 2023/9/4.
//

#import <UIKit/UIKit.h>

@protocol FUHeadButtonViewDelegate <NSObject>

@optional
/* 点击事件 */
-(void)headButtonViewBackAction:(UIButton *_Nullable)btn;
-(void)headButtonViewSwitchAction:(UIButton *_Nullable)btn;
-(void)headButtonViewDefaultAction:(UIButton *_Nullable)btn;

@end

NS_ASSUME_NONNULL_BEGIN

@interface FUHeadButtonView : UIView
@property (nonatomic, assign) BOOL shouldRender;
@property (strong, nonatomic) UIButton *defaultButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *backButton;
@property (weak, nonatomic) id <FUHeadButtonViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
