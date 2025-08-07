//
//  ASSearchBarView.h
//  AS
//
//  Created by SA on 2025/4/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASSearchBarView : UIView
@property (nonatomic, copy) TextBlock textBlock;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) UITextField *searchTextField;
@end

NS_ASSUME_NONNULL_END
