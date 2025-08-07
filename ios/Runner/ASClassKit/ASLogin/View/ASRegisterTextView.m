//
//  ASRegisterTextView.m
//  AS
//
//  Created by SA on 2025/4/15.
//

#import "ASRegisterTextView.h"

@interface ASRegisterTextView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation ASRegisterTextView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.textField];
        [self addSubview:self.icon];
        [self addSubview:self.lineView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self.icon addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.changeNameBlock) {
                wself.changeNameBlock();
            }
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(24));
        make.left.mas_equalTo(SCALES(16));
        make.right.offset(SCALES(-48));
        make.height.mas_equalTo(SCALES(22));
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(SCALES(-16));
        make.centerY.equalTo(self.textField);
        make.height.width.mas_equalTo(SCALES(16));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(SCALES(0.5));
    }];
}

- (void)setViewType:(RegisterTextViewType)viewType {
    _viewType = viewType;
    
    switch (viewType) {
        case kTextViewName:
        {
            self.textField.placeholder = @"请输入昵称";
            self.textField.keyboardType = UIKeyboardTypeDefault;
            self.textField.userInteractionEnabled = YES;
            self.icon.userInteractionEnabled = YES;
            self.icon.hidden = NO;
            self.icon.image = [UIImage imageNamed:@"name_change"];
        }
            break;
        case kTextViewSelectAge:
        {
            self.textField.placeholder = @"请选择生日";
            self.textField.userInteractionEnabled = NO;
            self.textField.clearButtonMode = UITextFieldViewModeNever;
            self.icon.image = [UIImage imageNamed:@"sel_age"];
            self.icon.hidden = NO;
            self.icon.userInteractionEnabled = NO;
            self.textField.text = @"35岁";
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [self addGestureRecognizer:tap];
            kWeakSelf(self);
            [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                [[ASDataSelectManager alloc] selectViewOneDataWithType:kOneSelectViewAge value:@"35岁" listArray:@[] action:^(NSInteger index, id  _Nonnull value) {
                    wself.textField.text = [NSString stringWithFormat:@"%@",value];
                    if (wself.inputBlock) {
                        wself.inputBlock(value);
                    }
                }];
            }];
        }
            break;
        case kTextViewInvitation:
        {
            self.textField.placeholder = @"请输入邀请码(非必填)";
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.textField.userInteractionEnabled = YES;
            self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.icon.hidden = YES;
        }
            break;
        default:
            break;
    }
}

- (void)setIsMan:(BOOL)isMan {
    _isMan = isMan;
    if (self.viewType == kTextViewName) {
        if (isMan == YES) {
            self.icon.image = [UIImage imageNamed:@"name_change"];
        } else {
            self.icon.image = [UIImage imageNamed:@"text_clear"];
        }
    }
}

//按钮输入监听
- (void)textFieldDidChange:(UITextField *)textField {
    if (self.inputBlock) {
        self.inputBlock(textField.text);
    }
}

#pragma mark textField Delegate
//文本框输入时处理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //昵称不超过10 超过禁止输入
    if (self.viewType == kTextViewName) {
        if (textField.text.length > 9 && ![string isEqualToString:@""]){
            return NO;
        }
    }
    //邀请人不超过10位 超过禁止输入
    if (self.viewType == kTextViewInvitation) {
        if (textField.text.length > 9 && ![string isEqualToString:@""]){
            return NO;
        }
    }
    return YES;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = LINE_COLOR;
    }
    return _lineView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.textColor = TITLE_COLOR;
        _textField.font = TEXT_FONT_16;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.userInteractionEnabled = YES;
        _icon.hidden = YES;
    }
    return _icon;
}
@end
