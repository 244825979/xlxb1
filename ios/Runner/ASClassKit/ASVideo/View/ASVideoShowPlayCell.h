//
//  ASVideoShowPlayCell.h
//  AS
//
//  Created by SA on 2025/5/12.
//

#import <UIKit/UIKit.h>
#import "ASVideoShowMaskView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASVideoShowPlayCell : UITableViewCell<ASVideoShowMaskDelegate>
@property (nonatomic, assign) VideoPlayListType popType;
@property (nonatomic, strong) UIImageView *videoCoverView;
@property (nonatomic, strong) UIView *videoParentView;
@property (nonatomic, strong) UILabel *reviewLabel;
@property (nonatomic, strong) ASVideoShowMaskView *maskView;
@property (nonatomic, weak) id<ASVideoShowMaskDelegate> delegate;
@property (nonatomic, strong) ASVideoShowDataModel *model;
@property (nonatomic, assign) BOOL isSilence;//是否开启静音，默认NO不开启，YES表示开启
@property (nonatomic, assign) BOOL isFollow;//是否关注
@property (nonatomic, copy) NSString *notifictionAcount;
@end

NS_ASSUME_NONNULL_END
