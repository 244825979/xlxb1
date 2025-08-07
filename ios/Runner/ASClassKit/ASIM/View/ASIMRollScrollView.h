//
//  ASIMRollScrollView.h
//  AS
//
//  Created by SA on 2025/5/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASIMRollScrollView : UIView
- (void)invTimer;
@end

@interface ASIMRollScrollPageView : UIView<UIScrollViewDelegate>
@property (nonatomic, assign) CGFloat bgHeight;
@property (nonatomic, strong) NSMutableArray *textArr;
@property (nonatomic, strong) UIScrollView *textScrollview;
@property (nonatomic, assign) NSInteger scrMaxW;
@property (nonatomic, assign) NSInteger scrX;
@property (nonatomic, strong, readwrite) RACDisposable *disposable;
@property (nonatomic, strong) UIColor *textColor;
- (void)invTimer;
@end

NS_ASSUME_NONNULL_END
