//
//  ASVoiceCodeView.h
//  AS
//
//  Created by SA on 2025/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASVoiceCodeView : UIView
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, copy) VoidBlock actionBlock;
@end

NS_ASSUME_NONNULL_END
