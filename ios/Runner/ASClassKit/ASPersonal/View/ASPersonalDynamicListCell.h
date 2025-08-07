//
//  ASPersonalDynamicListCell.h
//  AS
//
//  Created by SA on 2025/5/16.
//

#import <UIKit/UIKit.h>
#import "ASDynamicListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASPersonalDynamicListCell : UITableViewCell
@property (nonatomic, copy) IndexNameBlock clikedBlock;
@property (nonatomic, strong) ASDynamicListModel *model;
@end

@interface ASPersonalDynamicMediaView : UIView
@property (nonatomic, strong) ASDynamicListModel *model;
@property (nonatomic, copy) void (^imageBlock)(ASDynamicMediaType mediaType, NSInteger index, UIImage *image);
@end

NS_ASSUME_NONNULL_END
