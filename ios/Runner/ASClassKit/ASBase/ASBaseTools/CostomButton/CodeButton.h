
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CodeButton;
typedef NSString* _Nullable  (^CountDownChanging)(CodeButton *countDownButton,NSUInteger second);
typedef NSString* _Nullable  (^CountDownFinished)(CodeButton *countDownButton,NSUInteger second);
typedef void (^TouchedCountDownButtonHandler)(CodeButton *countDownButton,NSInteger tag);
typedef void (^CountDownChangeHandler)(CodeButton *countDownButton,NSUInteger second);

@interface CodeButton : UIButton

@property(nonatomic,strong) id userInfo;
///倒计时按钮点击回调
- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler;
//倒计时时间改变回调
- (void)countDownChanging:(CountDownChanging)countDownChanging;
//倒计时时间改变回调
- (void)countDownChangeHandler:(CountDownChangeHandler)countDownChangeHandler;
//倒计时结束回调
- (void)countDownFinished:(CountDownFinished)countDownFinished;
///开始倒计时
- (void)startCountDownWithSecond:(NSUInteger)second;
///停止倒计时
- (void)stopCountDown;
@end

NS_ASSUME_NONNULL_END
