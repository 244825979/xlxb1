//
//  ASProtocolAlertView.m
//  AS
//
//  Created by AS on 2025/4/11.
//

#import "ASProtocolAlertView.h"

@interface ASProtocolAlertView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) YYLabel *contentLabel;
@property (nonatomic, strong) UIButton *affirmBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@end

@implementation ASProtocolAlertView

- (instancetype)initWithTitle:(nullable NSString *)title
                   cancelFont:(nullable UIFont *)cancelFont
                   cancelText:(nullable NSString *)cancelText
                   attributed:(NSMutableAttributedString *)attributed {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = SCALES(12);
        self.clipsToBounds = NO;
        CGFloat contentHeight = SCALES(20);//顶部距离
        self.titleLabel = ({
            UILabel* label = [[UILabel alloc] init];
            label.textColor = TITLE_COLOR;
            label.font = TEXT_MEDIUM(18);
            label.text = STRING(title);
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            label;
        });
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(20));
            make.left.offset(SCALES(20));
            make.right.offset(SCALES(-20));
            make.height.mas_equalTo(SCALES(28));
        }];
        contentHeight += SCALES(28);//加上标题高度
    
        self.contentLabel = ({
            YYLabel* label = [[YYLabel alloc] init];
            label.attributedText = attributed;
            label.numberOfLines = 0;
            label.preferredMaxLayoutWidth = SCALES(260);
            [self addSubview:label];
            label;
        });
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(SCALES(20));
            make.left.offset(SCALES(24));
            make.right.offset(SCALES(-24));
        }];
        CGSize introSize = CGSizeMake(SCALES(260), CGFLOAT_MAX);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:attributed];
        contentHeight += SCALES(20);//加上间隙
        contentHeight += layout.textBoundingSize.height;//加上内容高度
        
        self.affirmBtn = ({
            UIButton* button = [[UIButton alloc] init];
            button.adjustsImageWhenHighlighted = NO;//去掉点击效果
            [button setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
            button.titleLabel.font = TEXT_MEDIUM(18);
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = SCALES(25);
            [button setTitle:@"同意" forState:UIControlStateNormal];
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (wself.affirmBlock) {
                    wself.affirmBlock();
                    [wself removeView];
                }
            }];
            [self addSubview:button];
            button;
        });
        [self.affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(SCALES(20));
            make.width.mas_equalTo(SCALES(228));
            make.height.mas_equalTo(SCALES(50));
            make.centerX.equalTo(self);
        }];
        contentHeight += SCALES(20);//加上间隙高度
        contentHeight += SCALES(50);//加上top按钮高度
    
        self.cancelBtn = ({
            UIButton* button = [[UIButton alloc] init];
            [button setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
            button.titleLabel.font = kObjectIsEmpty(cancelFont) ? TEXT_FONT_16 : cancelFont;
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
        contentHeight += SCALES(50);//底部取消按钮高度
        self.size = CGSizeMake(SCALES(308), contentHeight);
    }
    return self;
}

- (void)removeView {
    [self removeFromSuperview];
}
@end
