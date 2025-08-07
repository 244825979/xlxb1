//
//  ASVideoShowPlayButtonView.h
//  AS
//
//  Created by SA on 2025/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASVideoShowPlayButtonView : UIView
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, copy) void (^clikedBlock)(void);
@property (nonatomic, copy) NSString *textStr;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) NSString *normalIcon;
@property (nonatomic, copy) NSString *selectIcon;
@end

NS_ASSUME_NONNULL_END
