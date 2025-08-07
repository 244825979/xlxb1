//
//  ASVersionUpgradeAlertView.m
//  AS
//
//  Created by SA on 2025/6/11.
//

#import "ASVersionUpgradeAlertView.h"

@interface ASVersionUpgradeAlertView ()

@end

@implementation ASVersionUpgradeAlertView

- (instancetype)initAppVersionViewWithModel:(ASVersionModel *)model {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = SCALES(12);
        self.layer.masksToBounds = YES;
        kWeakSelf(self);
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = UIColor.whiteColor;
        bgView.layer.cornerRadius = SCALES(12);
        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(210));
            make.left.right.bottom.equalTo(self);
        }];
        UIImageView *headImage = [[UIImageView alloc] init];
        headImage.image = [UIImage imageNamed:@"version_pop"];
        [self addSubview:headImage];
        [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(SCALES(233));
        }];
        UILabel *title = [[UILabel alloc] init];
        title.textColor = TITLE_COLOR;
        title.font = TEXT_FONT_18;
        title.text = @"发现新版本";
        [bgView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(40));
            make.height.offset(SCALES(24));
            make.centerX.equalTo(bgView);
        }];
        UILabel *contentTitle = [[UILabel alloc] init];
        contentTitle.textColor = TEXT_COLOR;
        contentTitle.font = TEXT_FONT_14;
        contentTitle.text = @"更新说明";
        [bgView addSubview:contentTitle];
        [contentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(SCALES(16));
            make.left.mas_equalTo(SCALES(16));
            make.height.mas_equalTo(SCALES(24));
        }];
        UILabel *versionText = [[UILabel alloc] init];
        versionText.textColor = TEXT_COLOR;
        versionText.font = TEXT_FONT_14;
        versionText.text = [NSString stringWithFormat:@"版本：%@",model.newversion];
        [bgView addSubview:versionText];
        [versionText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(SCALES(16));
            make.right.equalTo(bgView).offset(SCALES(-16));
            make.height.mas_equalTo(SCALES(24));
        }];
        CGFloat contentHeight = SCALES(319);//顶部距离
        if (!kStringIsEmpty(model.upgradetext)) {
            CGFloat titleHeight = [ASCommonFunc getSizeWithText:STRING(model.upgradetext) maxLayoutWidth:SCALES(279) lineSpacing:SCALES(4.0) font:TEXT_FONT_14];
            UILabel *content = [[UILabel alloc]init];
            content.font = TEXT_FONT_14;
            content.attributedText = [ASCommonFunc attributedWithString:model.upgradetext lineSpacing:SCALES(4.0)];
            content.numberOfLines = 0;
            content.textColor = TEXT_COLOR;
            [bgView addSubview:content];
            [content mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(versionText.mas_bottom).offset(SCALES(12));
                make.left.mas_equalTo(SCALES(16));
                make.width.mas_equalTo(SCALES(279));
            }];
            contentHeight += SCALES(10);
            contentHeight += titleHeight;
        }
        if (model.enforce == NO) {
            UIButton *cancelBtn = [[UIButton alloc] init];
            [cancelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            cancelBtn.titleLabel.font = TEXT_FONT_18;
            [cancelBtn setBackgroundColor:UIColorRGB(0xCCCCCC)];
            cancelBtn.layer.masksToBounds = YES;
            cancelBtn.layer.cornerRadius = SCALES(24);
            [cancelBtn setTitle:@"下次再说" forState:UIControlStateNormal];
            [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (wself.cancelBlock) {
                    wself.cancelBlock();
                }
            }];
            [bgView addSubview:cancelBtn];
            [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(bgView.mas_bottom).offset(SCALES(-16));
                make.width.mas_equalTo(SCALES(132));
                make.height.mas_equalTo(SCALES(48));
                make.left.mas_equalTo(SCALES(16));
            }];
            UIButton *affirmBtn = [[UIButton alloc] init];
            affirmBtn.adjustsImageWhenHighlighted = NO;
            [affirmBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
            affirmBtn.titleLabel.font = TEXT_FONT_18;
            affirmBtn.layer.masksToBounds = YES;
            affirmBtn.layer.cornerRadius = SCALES(24);
            [[affirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (wself.affirmBlock) {
                    wself.affirmBlock();
                    [wself removeView];
                }
            }];
            [affirmBtn setTitle:@"立即升级" forState:UIControlStateNormal];
            [bgView addSubview:affirmBtn];
            [affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.width.height.equalTo(cancelBtn);
                make.right.offset(-SCALES(16));
            }];
        } else {
            UIButton *affirmBtn = [[UIButton alloc] init];
            affirmBtn.adjustsImageWhenHighlighted = NO;
            [affirmBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
            affirmBtn.titleLabel.font = TEXT_FONT_18;
            affirmBtn.layer.masksToBounds = YES;
            affirmBtn.layer.cornerRadius = SCALES(24);
            [[affirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (wself.affirmBlock) {
                    wself.affirmBlock();
                    [wself removeView];
                }
            }];
            [affirmBtn setTitle:@"立即升级" forState:UIControlStateNormal];
            [bgView addSubview:affirmBtn];
            [affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(bgView.mas_bottom).offset(SCALES(-16));
                make.left.mas_equalTo(SCALES(30));
                make.right.offset(-SCALES(30));
                make.height.mas_equalTo(SCALES(48));
            }];
        }
        contentHeight += SCALES(80);
        self.size = CGSizeMake(SCALES(311), contentHeight);
    }
    return self;
}

- (void)removeView {
    [self removeFromSuperview];
}
@end
