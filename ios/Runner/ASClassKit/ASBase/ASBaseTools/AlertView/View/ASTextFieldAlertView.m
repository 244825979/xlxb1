//
//  ASTextFieldAlertView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASTextFieldAlertView.h"

@interface ASTextFieldAlertView ()<UITextFieldDelegate>
@property (nonatomic, assign) NSInteger maxTextCount;//最多字数
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) NSInteger isNumber;
@property (nonatomic, copy) NSString *textNumberValue;//默认进入时的text
@end

@implementation ASTextFieldAlertView

//构造方法 单行输入弹窗
- (instancetype)initTextFieldViewWithTitle:(NSString *)title
                                   content:(NSString *)content
                               placeholder:(NSString *)titleplaceholder
                                    length:(NSInteger)length
                                affirmText:(NSString *)affirmText
                                    remark:(NSString *)remark
                                  isNumber:(BOOL)isNumber
                                   isEmpty:(BOOL)isEmpty {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = SCALES(12);
        self.size = CGSizeMake(SCALES(288), !kStringIsEmpty(remark) ? SCALES(255) : SCALES(229));
        self.maxTextCount = length;
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = TITLE_COLOR;
        titleLabel.font = TEXT_MEDIUM(16);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = STRING(title);
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(30));
            make.height.mas_equalTo(SCALES(25));
            make.centerX.equalTo(self);
        }];
        
        UIView *textFieldBg = [[UIView alloc] init];
        textFieldBg.backgroundColor = UIColorRGB(0xF8F8F8);
        textFieldBg.layer.cornerRadius = SCALES(8);
        [self addSubview:textFieldBg];
        [textFieldBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(SCALES(20));
            make.left.mas_equalTo(SCALES(20));
            make.right.offset(SCALES(-20));
            make.height.mas_equalTo(SCALES(50));
        }];
        
        UITextField *textField = [[UITextField alloc]init];
        textField.textColor = TITLE_COLOR;
        textField.font = TEXT_FONT_15;
        textField.delegate = self;
        textField.placeholder = kStringIsEmpty(titleplaceholder) ? @"请输入" : STRING(titleplaceholder);
        textField.text = STRING(content);
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [textFieldBg addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(14));
            make.right.offset(SCALES(-14));
            make.centerY.equalTo(textFieldBg);
        }];
        self.textField = textField;
        //如果是纯数值处理
        self.isNumber = isNumber;
        if (isNumber == YES) {//是否纯文本
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.textNumberValue = STRING(content);
        }
        
        if (!kStringIsEmpty(remark)) {
            UILabel *remarkLabel = [[UILabel alloc]init];
            remarkLabel.font = TEXT_FONT_14;
            remarkLabel.textAlignment = NSTextAlignmentCenter;
            remarkLabel.text = STRING(remark);
            remarkLabel.textColor = TEXT_SIMPLE_COLOR;
            [self addSubview:remarkLabel];
            [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(SCALES(20));
                make.right.equalTo(textFieldBg.mas_right).offset(SCALES(-20));
                make.top.equalTo(textFieldBg.mas_bottom).offset(SCALES(14));
                make.height.mas_equalTo(SCALES(19));
            }];
        }
        
        UIButton* closeBtn = [[UIButton alloc] init];
        closeBtn.titleLabel.font = TEXT_FONT_18;
        [closeBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        [closeBtn setBackgroundColor:UIColorRGB(0xF8F8F8)];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        closeBtn.layer.cornerRadius = SCALES(24.5);
        closeBtn.layer.masksToBounds = YES;
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
        }];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textFieldBg.mas_bottom).offset(!kStringIsEmpty(remark) ? SCALES(58) : SCALES(25));
            make.left.mas_equalTo(SCALES(15));
            make.height.mas_equalTo(SCALES(49));
        }];
        
        UIButton* affirmBtn = [[UIButton alloc] init];
        affirmBtn.titleLabel.font = TEXT_FONT_18;
        [affirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [affirmBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [affirmBtn setTitle:STRING(affirmText) forState:UIControlStateNormal];
        affirmBtn.layer.cornerRadius = SCALES(24.5);
        affirmBtn.layer.masksToBounds = YES;
        affirmBtn.adjustsImageWhenHighlighted = NO;//去掉点击效果
        __weak typeof(textField) wTextField = textField;
        [[affirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (kStringIsEmpty(wTextField.text) && isEmpty == NO) {//数据为空，且不允许输入为空才提示
                kShowToast(@"请输入内容");
                return;
            }
            if (wself.affirmBlock) {
                [wself removeView];
                wself.affirmBlock(wTextField.text);
            }
        }];
        [self addSubview:affirmBtn];
        [affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.width.equalTo(closeBtn);
            make.right.offset(SCALES(-15));
            make.left.equalTo(closeBtn.mas_right).offset(SCALES(10));
        }];
    }
    return self;
}

//按钮输入监听
- (void)textFieldDidChange:(UITextField *)textField {
    if (self.isNumber == YES) {//如果是数值的，就处理数值
        if (textField.text.integerValue > self.textNumberValue.integerValue) {
            textField.text = self.textNumberValue;
        }
    }
}

#pragma mark textField Delegate
//文本框输入时处理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length > self.maxTextCount - 1 && ![string isEqualToString:@""]){
        return NO;
    }
    return YES;
}

- (void)removeView {
    [self removeFromSuperview];
}

@end
