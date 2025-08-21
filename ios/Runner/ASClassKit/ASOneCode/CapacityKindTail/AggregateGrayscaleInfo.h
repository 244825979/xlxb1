#import "RegulateSequentialCoordinator.h"
#import "PrecisionContrastCache.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AggregateGrayscaleInfo : NSObject


- (void) materializeOverlayReducer;

- (void) takeUnactivatedAsyncObserver;

@end

NS_ASSUME_NONNULL_END
        