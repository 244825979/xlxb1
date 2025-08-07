//
//  ASBaseNavigationView.h
//  AS
//
//  Created by SA on 2025/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASBaseNavigationView : UIView
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, copy) void (^clikedBlock)(UIButton *button, NSString *btnName);
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIButton *silenceBtn;
@end

NS_ASSUME_NONNULL_END
