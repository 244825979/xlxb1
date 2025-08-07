//
//  ASWithdrawExchangeView.m
//  AS
//
//  Created by SA on 2025/6/27.
//

#import "ASWithdrawExchangeView.h"

@interface ASWithdrawExchangeView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *textBgView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *gold;
@property (nonatomic, strong) UIButton *submit;
@property (nonatomic, strong) UILabel *hintText;
@end


@implementation ASWithdrawExchangeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textBgView];
        [self.textBgView addSubview:self.title];
        [self.textBgView addSubview:self.textField];
        [self addSubview:self.gold];
        [self addSubview:self.submit];
        [self addSubview:self.hintText];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(SCALES(14));
        make.left.mas_equalTo(SCALES(14));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(28));
        make.height.mas_equalTo(SCALES(50));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textBgView);
        make.left.mas_equalTo(SCALES(14));
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title);
        make.left.equalTo(self.title.mas_right).offset(SCALES(3));
        make.right.equalTo(self.textBgView).offset(SCALES(-15));
    }];
    [self.hintText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textBgView.mas_bottom).offset(SCALES(14));
        make.left.equalTo(self.textBgView);
        make.height.mas_equalTo(SCALES(22));
    }];
    [self.gold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textBgView);
        make.top.equalTo(self.hintText.mas_bottom).offset(SCALES(14));
        make.height.mas_equalTo(SCALES(22));
    }];
    [self.submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gold.mas_bottom).offset(SCALES(50));
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(319), SCALES(50)));
    }];
}

- (void)setModel:(ASWithdrawModel *)model {
    _model = model;
}

//按钮输入监听
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.integerValue > self.model.income_money.integerValue) {
        if (self.model.income_money.integerValue == 0) {
            textField.text = @"";
        } else {
            textField.text = [NSString stringWithFormat:@"%zd",self.model.income_money.integerValue];
        }
    }
    //计算获取的金币
    self.gold.text = [NSString stringWithFormat:@"获得金币：%zd",textField.text.integerValue *100];
    if (textField.text.length > 0) {
        [self.submit setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [self.submit setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.submit.userInteractionEnabled = YES;
    } else {
        [self.submit setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
        [self.submit setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        self.submit.userInteractionEnabled = NO;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //限制只能输入 "0123456789"
    NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    BOOL res = YES;
    int i = 0;
    while (i < string.length) {
        NSString * strings = [string substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [strings rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return YES;
}

- (UIView *)textBgView {
    if (!_textBgView) {
        _textBgView = [[UIView alloc]init];
        _textBgView.backgroundColor = UIColorRGB(0xF5F5F5);
        _textBgView.layer.cornerRadius = SCALES(8);
        _textBgView.layer.masksToBounds = YES;
    }
    return _textBgView;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.text = @"兑换金额：";
        _title.textColor = TITLE_COLOR;
        _title.font = TEXT_FONT_16;
    }
    return _title;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.textColor = TITLE_COLOR;
        _textField.font = TEXT_FONT_14;
        _textField.placeholder = @"请输入要兑换的金额";
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UILabel *)gold {
    if (!_gold) {
        _gold = [[UILabel alloc]init];
        _gold.text = @"获得金币：0";
        _gold.textColor = TITLE_COLOR;
        _gold.font = TEXT_FONT_16;
        _gold.textAlignment = NSTextAlignmentRight;
    }
    return _gold;
}

- (UIButton *)submit {
    if (!_submit) {
        _submit = [[UIButton alloc]init];
        [_submit setTitle:@"立即兑换" forState:UIControlStateNormal];
        _submit.titleLabel.font = TEXT_FONT_18;
        _submit.layer.cornerRadius = SCALES(25);
        _submit.layer.masksToBounds = YES;
        [_submit setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
        [_submit setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        _submit.userInteractionEnabled = NO;
        kWeakSelf(self);
        [[_submit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [wself.textField resignFirstResponder];
            NSString *content = [NSString stringWithFormat:@"将消耗%@元，获得%zd金币，（兑换金币成功后不可撤销）", wself.textField.text, wself.textField.text.integerValue * 100];
            [ASAlertViewManager defaultPopTitle:@"兑换金币" content:content left:@"确定" right:@"取消" affirmAction:^{
                [ASCommonRequest requestChangeCoinWithMoney:wself.textField.text success:^(id  _Nullable data) {
                    kShowToast(@"兑换成功");
                    if (wself.backBlock) {
                        wself.backBlock();
                    }
                    wself.textField.text = @"";
                    [wself.submit setBackgroundColor:BUTTON_GRAY_COLOR];
                    wself.submit.userInteractionEnabled = NO;
                } errorBack:^(NSInteger code, NSString *msg) {
                    
                }];
            } cancelAction:^{
                
            }];
        }];
    }
    return _submit;
}

- (UILabel *)hintText {
    if (!_hintText) {
        _hintText = [[UILabel alloc]init];
        _hintText.text = @"注意：兑换比例 1元=100金币";
        _hintText.textColor = TEXT_SIMPLE_COLOR;
        _hintText.font = TEXT_FONT_14;
    }
    return _hintText;
}
@end
