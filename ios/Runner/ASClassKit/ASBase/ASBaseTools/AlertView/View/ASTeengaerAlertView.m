//
//  ASTeengaerOpenAlertView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASTeengaerAlertView.h"
#import "CustomButton.h"

@implementation ASTeengaerAlertView

//构造方法
- (instancetype)initWithCloseTeengaer {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = SCALES(12);
        self.clipsToBounds = NO;
        self.size = CGSizeMake(SCALES(307), SCALES(372));
        UILabel *text = [[UILabel alloc]init];
        text.font = TEXT_MEDIUM(18);
        text.text = @"青少年模式";
        text.textAlignment = NSTextAlignmentCenter;
        text.textColor = TITLE_COLOR;
        [self addSubview:text];
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(20));
            make.height.mas_equalTo(SCALES(28));
            make.centerX.equalTo(self);
        }];
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"teenager"];
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(SCALES(68));
            make.size.mas_equalTo(CGSizeMake(SCALES(135), SCALES(118)));
        }];
        UILabel *title = [[UILabel alloc]init];
        title.font = TEXT_FONT_15;
        title.numberOfLines = 2;
        title.attributedText = [ASCommonFunc attributedWithString: @"您已开启未成年模式\n所有功能关闭" lineSpacing:SCALES(4.0)];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = TEXT_COLOR;
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(icon.mas_bottom).offset(SCALES(20));
            make.centerX.equalTo(self);
        }];
        UIButton* closeBtn = [[UIButton alloc] init];
        closeBtn.adjustsImageWhenHighlighted = NO;//去掉点击效果
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        closeBtn.titleLabel.font = TEXT_FONT_18;
        closeBtn.layer.masksToBounds = YES;
        closeBtn.layer.cornerRadius = SCALES(25);
        [closeBtn setTitle:@"关闭未成年模式" forState:UIControlStateNormal];
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.closeBlock) {
                [wself removeView];
                wself.closeBlock();
            }
        }];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(SCALES(20));
            make.width.mas_equalTo(SCALES(227));
            make.height.mas_equalTo(SCALES(50));
            make.centerX.equalTo(self);
        }];
        CustomButton *forgetPwdBtn = [[CustomButton alloc] init];
        [forgetPwdBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        forgetPwdBtn.titleLabel.font = TEXT_FONT_15;
        [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [forgetPwdBtn setImage:[UIImage imageNamed:@"cell_back"] forState:UIControlStateNormal];
        [[forgetPwdBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.forgetPwdBlock) {
                [wself removeView];
                wself.forgetPwdBlock();
            }
        }];
        [self addSubview:forgetPwdBtn];
        [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(closeBtn.mas_bottom).offset(SCALES(7));
            make.height.mas_equalTo(SCALES(30));
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

//构造方法 未成年弹窗提醒
- (instancetype)initWithOpenTeengaer {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = SCALES(16);
        self.clipsToBounds = NO;
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"teenager"];
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(SCALES(16));
            make.size.mas_equalTo(CGSizeMake(SCALES(135), SCALES(118)));
        }];
        UILabel *text = [[UILabel alloc]init];
        text.font = TEXT_FONT_18;
        text.text = @"青少年模式";
        text.textAlignment = NSTextAlignmentCenter;
        text.textColor = TITLE_COLOR;
        [self addSubview:text];
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(150));
            make.height.mas_equalTo(SCALES(24));
            make.centerX.equalTo(self);
        }];
        NSString *contentText = @"为呵护未成年人健康成长，心聊想伴特别推出青少年模式，该模式下部分功能无法正常使用。请监护人主动选择，并设置监护密码。";
        CGFloat textHeight = [ASCommonFunc getSizeWithText:contentText maxLayoutWidth:SCALES(279) lineSpacing:SCALES(4.0) font:TEXT_FONT_15];
        UILabel *content = [[UILabel alloc]init];
        content.font = TEXT_FONT_15;
        content.numberOfLines = 0;
        content.attributedText = [ASCommonFunc attributedWithString: contentText lineSpacing:SCALES(4.0)];
        content.textAlignment = NSTextAlignmentCenter;
        content.textColor = TEXT_COLOR;
        [self addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(text.mas_bottom).offset(SCALES(16));
            make.centerX.equalTo(self);
            make.width.mas_equalTo(SCALES(279));
        }];
        UIButton *affirmBtn = [[UIButton alloc] init];
        affirmBtn.adjustsImageWhenHighlighted = NO;
        [affirmBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        affirmBtn.titleLabel.font = TEXT_FONT_18;
        affirmBtn.layer.masksToBounds = YES;
        affirmBtn.layer.cornerRadius = SCALES(24);
        [affirmBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        [[affirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.closeBlock) {
                wself.closeBlock();
            }
        }];
        [self addSubview:affirmBtn];
        [affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(SCALES(-48));
            make.width.mas_equalTo(SCALES(247));
            make.height.mas_equalTo(SCALES(48));
            make.centerX.equalTo(self);
        }];
        CustomButton *openBtn = [[CustomButton alloc] init];
        [openBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        openBtn.titleLabel.font = TEXT_FONT_16;
        [openBtn setTitle:@"开启青少模式 " forState:UIControlStateNormal];
        [openBtn setImage:[UIImage imageNamed:@"teenager1"] forState:UIControlStateNormal];
        [[openBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.forgetPwdBlock) {
                [wself removeView];
                wself.forgetPwdBlock();
            }
        }];
        [self addSubview:openBtn];
        [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_equalTo(SCALES(48));
            make.centerX.equalTo(self);
        }];
        self.size = CGSizeMake(SCALES(311), SCALES(190) + textHeight + SCALES(112));
    }
    return self;
}

- (void)removeView {
    [self removeFromSuperview];
}
@end
