//
//  ASIMConversationListTopView.h
//  AS
//
//  Created by SA on 2025/5/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASIMConversationListTopView : UIView
@property (nonatomic, copy) IndexNameBlock indexBlock;
- (void)setHiddenRedWithType:(NSInteger)type;//1系统，2活动，0全部清理
@end

NS_ASSUME_NONNULL_END
