//
//  ASHomeTopView.h
//  AS
//
//  Created by SA on 2025/4/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASHomeTopView : UIView
@property (nonatomic, copy) IndexBlock indexBlock;
@property (nonatomic, copy) VoidBlock actionBlock;
@property (nonatomic, strong) NSArray *likes;
@property (nonatomic, strong) NSArray *banners;
@end
NS_ASSUME_NONNULL_END
