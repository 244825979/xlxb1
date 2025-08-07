//
//  ASVideoShowSetPopView.h
//  AS
//
//  Created by SA on 2025/5/12.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ASVideoShowSetPopView : UIView
@property (nonatomic, strong) ASVideoShowDataModel *model;
@property (nonatomic, copy) VoidBlock delBlock;
@property (nonatomic, copy) VoidBlock cancelBlock;
@end

@interface ASVideoShowSetListView : UIView
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *selectIcon;
@property (nonatomic, copy) VoidBlock clikedBlock;
@end

NS_ASSUME_NONNULL_END
