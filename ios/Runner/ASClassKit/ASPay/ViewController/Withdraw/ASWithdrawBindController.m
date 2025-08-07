//
//  ASWithdrawBindController.m
//  AS
//
//  Created by SA on 2025/6/27.
//

#import "ASWithdrawBindController.h"
#import "ASBindAccountModel.h"
#import "ASBindAccountSubView.h"
#import "ASPayRequest.h"
#import "ASWithdrawBindStateController.h"

@interface ASWithdrawBindController ()
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) ASBindAccountSubView *nameView;
@property (nonatomic, strong) ASBindAccountSubView *IDCardView;
@property (nonatomic, strong) ASBindAccountSubView *textFieldView;
@property (nonatomic, strong) ASBindAccountSubView *accountView;
@property (nonatomic, strong) ASBindAccountModel *model;
@property (nonatomic, copy) NSString *accountText;
@end

@implementation ASWithdrawBindController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"绑定提现账号";
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self createUI];
    [self requestData];
}

- (void)createUI {
    kWeakSelf(self);
    UIView *hintBg = [[UIView alloc] init];
    hintBg.backgroundColor = UIColor.whiteColor;
    hintBg.layer.borderColor = UIColorRGB(0xFF3C35).CGColor;
    hintBg.layer.borderWidth = SCALES(1);
    hintBg.layer.cornerRadius = SCALES(12);
    hintBg.layer.masksToBounds = YES;
    [self.view addSubview:hintBg];
    [hintBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.mas_equalTo(SCALES(12));
        make.height.mas_equalTo(SCALES(48));
        make.right.equalTo(self.view).offset(SCALES(-16));
    }];
    UIImageView *hintIcon = [[UIImageView alloc] init];
    hintIcon.image = [UIImage imageNamed:@"hint_icon"];
    [hintBg addSubview:hintIcon];
    [hintIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(12));
        make.centerY.equalTo(hintBg);
        make.height.width.mas_equalTo(SCALES(15));
    }];
    UILabel *hintText = [[UILabel alloc]init];
    hintText.text = @"请绑定与实名信息一致的账号信息";
    hintText.textColor = UIColorRGB(0xFF3C35);
    hintText.font = TEXT_FONT_14;
    [hintBg addSubview:hintText];
    [hintText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(44));
        make.centerY.equalTo(hintBg);
    }];
    UIView *userDataBgView = [[UIView alloc]init];
    userDataBgView.backgroundColor = UIColor.whiteColor;
    userDataBgView.layer.cornerRadius = SCALES(12);
    [self.view addSubview:userDataBgView];
    [userDataBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintBg.mas_bottom).offset(SCALES(12));
        make.left.right.equalTo(hintBg);
        make.height.mas_equalTo(SCALES(100));
    }];
    [userDataBgView addSubview:self.nameView];
    [self.nameView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(userDataBgView);
        make.height.mas_equalTo(SCALES(50));
    }];
    [userDataBgView addSubview:self.IDCardView];
    [self.IDCardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.nameView);
        make.top.equalTo(self.nameView.mas_bottom);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LINE_COLOR;
    line.alpha = 0.3;
    [userDataBgView addSubview:line];
    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.mas_equalTo(SCALES(49.5));
        make.height.mas_equalTo(SCALES(1));
        make.right.equalTo(userDataBgView).offset(SCALES(-16));
    }];
    
    UIView *accountDataBgView = [[UIView alloc]init];
    accountDataBgView.backgroundColor = UIColor.whiteColor;
    accountDataBgView.layer.cornerRadius = SCALES(12);
    [self.view addSubview:accountDataBgView];
    [accountDataBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(hintBg);
        make.top.equalTo(userDataBgView.mas_bottom).offset(SCALES(12));
        make.height.mas_equalTo(SCALES(100));
    }];
    ASBindAccountSubView *accountView = [[ASBindAccountSubView alloc]init];
    accountView.leftTitle.text = @"账号类型";
    accountView.content.text = STRING(USER_INFO.configModel.config.baozhifu_text);
    accountView.type = kBindAccountViewAcount;
    [accountDataBgView addSubview:accountView];
    [accountView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(accountDataBgView);
        make.height.mas_equalTo(SCALES(50));
    }];
    self.accountView = accountView;
    [accountDataBgView addSubview:self.textFieldView];
    [self.textFieldView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(accountView);
        make.top.equalTo(accountView.mas_bottom);
    }];
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = LINE_COLOR;
    line1.alpha = 0.3;
    [accountDataBgView addSubview:line1];
    [line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.mas_equalTo(SCALES(49.5));
        make.height.mas_equalTo(SCALES(1));
        make.right.equalTo(accountDataBgView).offset(SCALES(-16));
    }];
    
    UILabel *hintTitle = [[UILabel alloc]init];
    hintTitle.text = @"温馨提示";
    hintTitle.textColor = TITLE_COLOR;
    hintTitle.font = TEXT_FONT_16;
    [self.view addSubview:hintTitle];
    [hintTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hintBg);
        make.top.equalTo(accountDataBgView.mas_bottom).offset(SCALES(14));
        make.height.mas_equalTo(SCALES(22));
    }];
    YYLabel *agreementView = [[YYLabel alloc] init];
    agreementView.numberOfLines = 0;
    agreementView.attributedText = [ASTextAttributedManager bindPayAccountHintAgreement];
    agreementView.preferredMaxLayoutWidth = SCREEN_WIDTH - SCALES(28);
    [self.view addSubview:agreementView];
    [agreementView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintTitle.mas_bottom).offset(SCALES(14));
        make.left.equalTo(hintBg);
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(32));
    }];
    
    UIButton *nextBtn = [[UIButton alloc] init];
    [nextBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
    [nextBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
    nextBtn.adjustsImageWhenHighlighted = NO;
    nextBtn.userInteractionEnabled = NO;
    nextBtn.titleLabel.font = TEXT_FONT_18;
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = SCALES(25);
    [self.view addSubview:nextBtn];
    [nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SCALES(30) - TAB_BAR_MAGIN);
        make.height.mas_equalTo(SCALES(50));
        make.width.mas_equalTo(SCALES(319));
    }];
    [[nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        wself.model.card_account = wself.accountText;
        [ASPayRequest requestAcountBindWithModel:wself.model success:^(id  _Nullable data) {
            if (wself.model.is_h5_verify == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:STRING(wself.model.h5Url)] options:@{} completionHandler:nil];
            } else {
                ASWithdrawBindStateController *vc = [[ASWithdrawBindStateController alloc] init];
                vc.isSucceed = YES;
                vc.hintText = @"已提交，等待审核";
                [wself.navigationController pushViewController:vc animated:YES];
            }
        } errorBack:^(NSInteger code, NSString *msg) {

        }];
    }];
    self.nextBtn = nextBtn;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [self.textFieldView.accountTextField becomeFirstResponder];
}

- (void)requestData {
    kWeakSelf(self);
    [ASPayRequest requestAcountBindInfoWithID:@"0" isMaster:1 success:^(id  _Nullable data) {
        wself.model = data;
        wself.nameView.content.text = kStringIsEmpty(wself.model.card_name) ? @"请输入姓名" : wself.model.card_name;
        wself.IDCardView.content.text = kStringIsEmpty(wself.model.id_card) ? @"请输入身份证" : wself.model.id_card;
        [wself.accountView.icon sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, wself.model.card_icon]]];
        if (wself.model.is_h5_verify == 1) {
            [wself.nextBtn setTitle:[NSString stringWithFormat:@"%@授权认证", STRING(USER_INFO.configModel.config.baozhifu_text)] forState:UIControlStateNormal];
        } else {
            [wself.nextBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (ASBindAccountSubView *)nameView {
    if (!_nameView) {
        _nameView = [[ASBindAccountSubView alloc]init];
        _nameView.leftTitle.text = @"姓名";
        _nameView.type = kBindAccountViewDefault;
    }
    return _nameView;
}

- (ASBindAccountSubView *)IDCardView {
    if (!_IDCardView) {
        _IDCardView = [[ASBindAccountSubView alloc]init];
        _IDCardView.leftTitle.text = @"身份证号";
        _IDCardView.type = kBindAccountViewDefault;
    }
    return _IDCardView;
}

- (ASBindAccountSubView *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [[ASBindAccountSubView alloc]init];
        _textFieldView.leftTitle.text = @"提现账号";
        _textFieldView.type = kBindAccountViewTextField;
        kWeakSelf(self);
        _textFieldView.inputClickBlock = ^(NSString * _Nonnull text) {
            wself.accountText = text;
            if (text.length > 0) {
                [wself.nextBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
                [wself.nextBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
                wself.nextBtn.userInteractionEnabled = YES;
            } else {
                [wself.nextBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
                [wself.nextBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
                wself.nextBtn.userInteractionEnabled = NO;
            }
        };
    }
    return _textFieldView;
}

@end
