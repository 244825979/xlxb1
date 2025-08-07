//
//  ASSetCancelAccountController.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASSetCancelAccountController.h"

@interface ASSetCancelAccountController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *agreementBtn;
@property (nonatomic, strong) UIButton *submitBtn;
@end

@implementation ASSetCancelAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"《注销账号协议》";
    [self createUI];
}

- (void)createUI {
    kWeakSelf(self);
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HEIGHT_NAVBAR);

    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH - SCALES(40), CGFLOAT_MAX) text: [ASTextAttributedManager cancelAccountTextAgreement]];
    YYLabel *agreementView = [[YYLabel alloc] init];
    agreementView.attributedText = [ASTextAttributedManager cancelAccountTextAgreement];
    agreementView.preferredMaxLayoutWidth = SCREEN_WIDTH - SCALES(40);
    [self.scrollView addSubview:agreementView];
    [agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(20));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(40));
        make.top.mas_equalTo(SCALES(12));
    }];
    agreementView.numberOfLines = 0;
    
    self.submitBtn = ({
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateSelected];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [button setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;//去掉点击效果
        button.userInteractionEnabled = NO;
        button.titleLabel.font = TEXT_FONT_18;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = SCALES(25);
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.agreementBtn.isSelected == YES) {
                [ASAlertViewManager defaultPopTitle:@"提示" content:@"您确定要注销账号吗？" left:@"确定" right:@"取消" affirmAction:^{
                    [ASLoginRequest requestCancelAccountSuccess:^(id  _Nullable data) {

                    } errorBack:^(NSInteger code, NSString *msg) {

                    }];
                } cancelAction:^{
                    
                }];
            }
        }];
        [self.scrollView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(agreementView.mas_bottom).offset(SCALES(15));
            make.centerX.equalTo(self.scrollView);
            make.size.mas_equalTo(CGSizeMake(SCALES(319), SCALES(50)));
        }];
        button;
    });
    
    UIButton *agreementText = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreementText setTitle:@"我已阅读以上信息无异议" forState:UIControlStateNormal];
    agreementText.titleLabel.font = TEXT_FONT_13;
    [agreementText setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [self.scrollView addSubview:agreementText];
    [agreementText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitBtn.mas_bottom).offset(SCALES(14));
        make.height.mas_equalTo(SCALES(20));
        make.centerX.equalTo(self.scrollView).offset(SCALES(8));
    }];
    [[agreementText rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        wself.agreementBtn.selected = ! wself.agreementBtn.selected;
        if (wself.agreementBtn.isSelected == YES) {
            wself.submitBtn.selected = YES;
            wself.submitBtn.userInteractionEnabled = YES;
        } else {
            wself.submitBtn.selected = NO;
            wself.submitBtn.userInteractionEnabled = NO;
        }
    }];

    UIButton *agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreementButton setImage:[UIImage imageNamed:@"login_agree2"] forState:UIControlStateNormal];
    [agreementButton setImage:[UIImage imageNamed:@"login_agree"] forState:UIControlStateSelected];
    agreementButton.adjustsImageWhenHighlighted = NO;
    [self.scrollView addSubview:agreementButton];
    [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(agreementText.mas_left).offset(SCALES(-5));
        make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
        make.centerY.equalTo(agreementText);
    }];
    [[agreementButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        wself.agreementBtn.selected = ! wself.agreementBtn.selected;
        if (wself.agreementBtn.isSelected == YES) {
            wself.submitBtn.selected = YES;
            wself.submitBtn.userInteractionEnabled = YES;
        } else {
            wself.submitBtn.selected = NO;
            wself.submitBtn.userInteractionEnabled = NO;
        }
    }];
    self.agreementBtn = agreementButton;
    self.scrollView.contentSize = CGSizeMake(0, (layout.textBoundingSize.height + SCALES(160)));
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = UIColor.whiteColor;
        _scrollView.scrollEnabled = YES;
    }
    return _scrollView;
}
@end
