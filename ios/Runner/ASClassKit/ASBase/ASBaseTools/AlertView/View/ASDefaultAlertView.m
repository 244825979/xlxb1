//
//  ASDefaultAlertView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASDefaultAlertView.h"

@interface ASDefaultAlertView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *affirmBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@end

@implementation ASDefaultAlertView

//构造方法
- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                   affirmText:(nullable NSString *)affirmText
                   cancelText:(nullable NSString *)cancelText {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = SCALES(12);
        self.clipsToBounds = NO;
        CGFloat contentHeight = SCALES(25);//顶部距离
        CGFloat titleHeight = [ASCommonFunc getSizeWithText:STRING(title) maxLayoutWidth:SCALES(307) - SCALES(40) lineSpacing:SCALES(4.0) font:TEXT_MEDIUM(18)];
        kWeakSelf(self);
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = TITLE_COLOR;
            label.numberOfLines = 0;
            label.font = TEXT_MEDIUM(18);
            label.attributedText = [ASCommonFunc attributedWithString:STRING(title) lineSpacing:SCALES(4.0)];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            label;
        });
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(25));
            make.left.offset(SCALES(20));
            make.right.offset(SCALES(-20));
        }];
        contentHeight += titleHeight;//加上标题高度
        
        if (message.length) {
            CGFloat messageHeight = [ASCommonFunc getSizeWithText:STRING(message) maxLayoutWidth:SCALES(307) - SCALES(50) lineSpacing:SCALES(4.0) font:TEXT_FONT_15];
            self.messageLabel = ({
                UILabel* label = [[UILabel alloc] init];
                label.textColor = TEXT_COLOR;
                label.numberOfLines = 0;
                label.font = TEXT_FONT_15;
                label.attributedText = [ASCommonFunc attributedWithString:STRING(message) lineSpacing:SCALES(4.0)];
                label.textAlignment = NSTextAlignmentCenter;
                [self addSubview:label];
                label;
            });
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(SCALES(20));
                make.left.offset(SCALES(25));
                make.right.offset(SCALES(-25));
            }];
            contentHeight += SCALES(20);//加上间隙
            contentHeight += messageHeight;//加上内容高度
        }
        
        self.affirmBtn = ({
            UIButton* button = [[UIButton alloc] init];
            button.adjustsImageWhenHighlighted = NO;//去掉点击效果
            [button setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
            button.titleLabel.font = TEXT_FONT_18;
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = SCALES(25);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (wself.affirmBlock) {
                    wself.affirmBlock();
                    [wself removeView];
                }
            }];
            [button setTitle:STRING(affirmText) forState:UIControlStateNormal];
            [self addSubview:button];
            button;
        });
        [self.affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (message.length) {
                make.top.equalTo(self.messageLabel.mas_bottom).offset(SCALES(20));
            } else {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(SCALES(20));
            }
            make.width.mas_equalTo(SCALES(228));
            make.height.mas_equalTo(SCALES(50));
            make.centerX.equalTo(self);
        }];
        if (message.length) {
            contentHeight += SCALES(20);//加上间隙高度
            contentHeight += SCALES(50);//加上top按钮高度
        } else {
            contentHeight += SCALES(20);//加上间隙高度
            contentHeight += SCALES(50);//加上top按钮高度
        }
        
        if (cancelText.length) {
            self.cancelBtn = ({
                UIButton* button = [[UIButton alloc] init];
                [button setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
                button.titleLabel.font = TEXT_FONT_15;
                [button setTitle:STRING(cancelText) forState:UIControlStateNormal];
                [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                    if (wself.cancelBlock) {
                        wself.cancelBlock();
                    }
                }];
                [self addSubview:button];
                button;
            });
            [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.affirmBtn.mas_bottom);
                make.width.mas_equalTo(SCALES(228));
                make.height.mas_equalTo(SCALES(44));
                make.centerX.equalTo(self);
            }];
            contentHeight += SCALES(50);//加上底部高度
        } else {
            contentHeight += SCALES(30);//加上底部间隙高度
        }
        
        self.size = CGSizeMake(SCALES(307), contentHeight);
    }
    return self;
}

- (void)removeView {
    [self removeFromSuperview];
}

@end
