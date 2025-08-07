//
//  ASSVGAAnimationManager.h
//  AS
//
//  Created by SA on 2025/5/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ASSVGAAnimationManager;
@protocol ASSVGAAnimationDelegate <NSObject>
@optional;
- (void)SVGAAnimationManager:(ASSVGAAnimationManager *)svgaAnimationManager showSVGAAnimation:(NSString *)animationUrl;
@end

@interface ASSVGAAnimationManager : NSObject
@property (nonatomic, strong) YYThreadSafeArray *svgaAnimationArray;
@property (nonatomic, assign) BOOL isShowSVGAAnimation;
@property (nonatomic, weak) id <ASSVGAAnimationDelegate> delegate;
- (void)addSvgaAnimation;
- (void)destroy;
@end

NS_ASSUME_NONNULL_END
