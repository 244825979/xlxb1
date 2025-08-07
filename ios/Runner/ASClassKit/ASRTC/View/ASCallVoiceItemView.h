//
//  ASCallVoiceItemView.h
//  AS
//
//  Created by SA on 2025/5/19.
//

#import <UIKit/UIKit.h>
#import "ASCallItemView.h"
#import "ASCallGoPayView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ASCallVoiceItemView : UIView
@property (nonatomic, assign) ASCallItemType itemType;
@property (nonatomic, assign) BOOL isOpenMicrophone;
@property (nonatomic, assign) BOOL isOpenLoudspeaker;
@property (nonatomic, strong) ASCallGoPayView *goPayView;
@property (nonatomic, copy) BoolBlock closeBlock;//挂断或者取消。YES是拒绝或取消，NO是挂断
@property (nonatomic, copy) VoidBlock answerBlock;//接听
@property (nonatomic, copy) VoidBlock sendGiftBlock;//送礼物
@property (nonatomic, strong) RACDisposable *callTimerDisposable;
@property (nonatomic, copy) NSString *moneyText;
@end

NS_ASSUME_NONNULL_END
