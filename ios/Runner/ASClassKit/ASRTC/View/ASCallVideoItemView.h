//
//  ASCallVideoItemView.h
//  AS
//
//  Created by SA on 2025/5/19.
//

#import <UIKit/UIKit.h>
#import "ASCallItemView.h"
#import "ASCallGoPayView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASCallVideoItemView : UIView
@property (nonatomic, assign) ASCallItemType itemType;
@property (nonatomic, assign) BOOL isOpenCamera;//是否开启摄像头。默认开启
@property (nonatomic, assign) BOOL isOpenLoudspeaker;//是否开启扬声器。默认开启
@property (nonatomic, assign) BOOL isCutCamera;//是否切换摄像头。默认前置摄像头
@property (nonatomic, strong) ASCallItemView *cameraSwitch;//摄像头开关
@property (nonatomic, strong) ASCallGoPayView *goPayView;
@property (nonatomic, copy) BoolBlock cameraCutBlock;//摄像头切换
@property (nonatomic, copy) BoolBlock cameraSwitchBlock;//摄像头开关
@property (nonatomic, copy) BoolBlock closeBlock;//挂断或者取消。YES是拒绝或取消，NO是挂断
@property (nonatomic, copy) VoidBlock meiyanBlock;//美颜点击美颜按钮
@property (nonatomic, copy) VoidBlock answerBlock;//接听
@property (nonatomic, copy) VoidBlock sendGiftBlock;//送礼物
@property (nonatomic, strong) RACDisposable *callTimerDisposable;
@property (nonatomic, copy) NSString *moneyText;
@end

NS_ASSUME_NONNULL_END
