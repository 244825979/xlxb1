//
//  ASSearchBarView.m
//  AS
//
//  Created by SA on 2025/4/17.
//

#import "ASSearchBarView.h"

@interface ASSearchBarView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIView *searchTextBg;
@end

@implementation ASSearchBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.searchTextBg];
        [self.searchTextBg addSubview:self.icon];
        [self.searchTextBg addSubview:self.searchTextField];
        [self addSubview:self.searchBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.searchTextBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.centerY.equalTo(self);
        make.right.offset(SCALES(-78));
        make.height.mas_equalTo(SCALES(44));
    }];
    
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.centerY.equalTo(self.searchTextBg);
        make.height.width.mas_equalTo(SCALES(20));
    }];
    
    [self.searchTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(SCALES(8));
        make.centerY.equalTo(self.searchTextBg);
        make.height.mas_equalTo(SCALES(24));
        make.right.equalTo(self.searchTextBg).offset(SCALES(-16));
    }];
    
    [self.searchBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(SCALES(-14));
        make.centerY.equalTo(self.searchTextBg);
        make.size.mas_equalTo(CGSizeMake(SCALES(50), SCALES(32)));
    }];
}

//按钮输入监听
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length > 0) {
        _searchBtn.userInteractionEnabled = YES;
        [_searchBtn setBackgroundColor:GRDUAL_CHANGE_BG_COLOR(SCALES(50), SCALES(32))];
    } else {
        _searchBtn.userInteractionEnabled = NO;
        [_searchBtn setBackgroundColor:UIColorRGB(0xCCCCCC)];
    }
}

- (UIView *)searchTextBg {
    if (!_searchTextBg) {
        _searchTextBg = [[UIView alloc]init];
        _searchTextBg.backgroundColor = UIColorRGB(0xF5F5F5);
        _searchTextBg.layer.cornerRadius = SCALES(22);
        _searchTextBg.layer.masksToBounds = YES;
    }
    return _searchTextBg;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.image = [UIImage imageNamed:@"search1"];
    }
    return _icon;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入用户ID"  attributes:@{NSFontAttributeName:TEXT_FONT_15,NSForegroundColorAttributeName: PLACEHOLDER_COLOR}];
        _searchTextField.font = TEXT_FONT_15;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.keyboardType = UIKeyboardTypeNumberPad;
        _searchTextField.delegate = self;
        [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTextField;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = TEXT_FONT_14;
        [_searchBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_searchBtn setBackgroundColor:UIColorRGB(0xCCCCCC)];
        _searchBtn.layer.cornerRadius = SCALES(16);
        _searchBtn.layer.masksToBounds = YES;
        _searchBtn.userInteractionEnabled = NO;
        kWeakSelf(self);
        [[_searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (kStringIsEmpty(wself.searchTextField.text)) {
                kShowToast(@"请输入搜索内容");
                return;
            }
            if (wself.textBlock) {
                wself.textBlock(wself.searchTextField.text);
            }
        }];
    }
    return _searchBtn;
}
@end
