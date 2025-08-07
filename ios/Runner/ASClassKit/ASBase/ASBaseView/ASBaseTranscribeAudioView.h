//
//  ASBaseTranscribeAudioView.h
//  AS
//
//  Created by SA on 2025/4/22.
//

#import <UIKit/UIKit.h>
@class ASCircleViewConfigure;
NS_ASSUME_NONNULL_BEGIN

@interface ASBaseTranscribeAudioView : UIView
@property (nonatomic, assign) NSInteger type;//0快捷用语。1声音展示
@property (nonatomic, assign) BOOL isTranscribe;
@property (nonatomic, copy) void (^saveBlock)(NSString *filePath, NSInteger voice);
@property (nonatomic, copy) VoidBlock closeBlock;
@end

@interface ASCircleView : UIView
@property (nonatomic, assign) CGFloat progress;
//创建含有圆环的实例View
- (instancetype)initWithFrame:(CGRect)frame configure:(ASCircleViewConfigure *)configure;
@end

//动态圆环
@interface ASDrawCircleView : UIView
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) ASCircleViewConfigure *configure;
@end

@interface ASCircleViewConfigure : NSObject
@property (nonatomic, assign) CGFloat circleLineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) BOOL isClockwise;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, strong) NSArray *colorArr;
@property (nonatomic, strong) NSArray *colorSize;
@end
NS_ASSUME_NONNULL_END
