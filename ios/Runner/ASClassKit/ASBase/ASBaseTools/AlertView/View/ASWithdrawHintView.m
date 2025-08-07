//
//  ASWithdrawHintView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASWithdrawHintView.h"

@interface ASWithdrawHintView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation ASWithdrawHintView

- (instancetype)initDrawHintViewWithContent:(NSString *)content isProtocol:(BOOL)isProtocol {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = SCALES(12);
        self.clipsToBounds = NO;
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = TEXT_MEDIUM(18);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"申请提现";
        titleLabel.textColor = TITLE_COLOR;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(15));
            make.height.mas_equalTo(SCALES(25));
            make.centerX.equalTo(self);
        }];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.attributedText = [ASCommonFunc attributedWithString:STRING(content) lineSpacing:SCALES(4)];
        contentLabel.numberOfLines = 0;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.font = TEXT_FONT_15;
        contentLabel.textColor = TEXT_COLOR;
        contentLabel.preferredMaxLayoutWidth = SCALES(260);
        [self addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(20));
            make.right.equalTo(self.mas_right).offset(SCALES(-20));
            make.top.equalTo(titleLabel.mas_bottom).offset(SCALES(20));
        }];
        
        UIButton *agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [agreementButton setImage:[UIImage imageNamed:@"potocol1"] forState:UIControlStateNormal];
        [agreementButton setImage:[UIImage imageNamed:@"potocol"] forState:UIControlStateSelected];
        agreementButton.adjustsImageWhenHighlighted = NO;
        agreementButton.selected = isProtocol;
        [[agreementButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
             agreementButton.selected = !agreementButton.selected;
        }];
        [self addSubview:agreementButton];
        
        YYLabel *agreementView = [[YYLabel alloc] init];
        agreementView.attributedText = [ASTextAttributedManager withdrawProtocolPopAgreement:^{
            agreementButton.selected = !agreementButton.selected;
        } protocol:^{
            if (wself.affirmBlock) {
                [wself removeView];
                wself.affirmBlock(@"查看协议");
            }
        }];
        agreementView.numberOfLines = 0;
        agreementView.preferredMaxLayoutWidth = SCALES(260);
        [self addSubview:agreementView];
        [agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).offset(SCALES(20));
            make.centerX.equalTo(self).offset(SCALES(10));
        }];
        [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(agreementView.mas_left).offset(SCALES(8));
            make.size.mas_equalTo(CGSizeMake(SCALES(36), SCALES(36)));
            make.centerY.equalTo(agreementView);
        }];
        
        UIButton *affirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:affirmBtn];
        affirmBtn.titleLabel.font = TEXT_MEDIUM(18);
        [affirmBtn setTitle:@"提交" forState:UIControlStateNormal];
        affirmBtn.adjustsImageWhenHighlighted = NO;//去掉点击效果
        [affirmBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        affirmBtn.layer.masksToBounds = YES;
        affirmBtn.layer.cornerRadius = SCALES(24.5);
        [[affirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (!agreementButton.isSelected) {
                kShowToast(@"请勾选协议");
                return;
            }
            if (wself.affirmBlock) {
                [wself removeView];
                wself.affirmBlock(@"提现");
            }
        }];
        [affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(agreementView.mas_bottom).offset(SCALES(14));
            make.size.mas_equalTo(CGSizeMake(SCALES(248), SCALES(46)));
        }];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:cancelBtn];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = TEXT_FONT_16;
        [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
        }];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(affirmBtn.mas_bottom);
            make.centerX.equalTo(self);
            make.height.mas_equalTo(SCALES(50));
        }];
        
        self.size = CGSizeMake(SCALES(300), SCALES(250));
    }
    return self;
}

- (void)removeView {
    [self removeFromSuperview];
}

@end
