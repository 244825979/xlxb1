//
//  ASTextViewAlertView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASTextViewAlertView.h"

@interface ASTextViewAlertView ()<UITextViewDelegate>
@property (nonatomic, assign) NSInteger maxTextCount;//最多字数
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *textCount;
@end

@implementation ASTextViewAlertView

//构造方法 个性签名
- (instancetype)initTextViewWithTitle:(NSString *)title
                              content:(NSString *)content
                          placeholder:(NSString *)titleplaceholder
                               length:(NSInteger)length
                               affirm:(NSString *)affirm {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor whiteColor];
        self.size = CGSizeMake(SCREEN_WIDTH, SCALES(312) + TAB_BAR_MAGIN20);
        self.maxTextCount = length;
        
        //监听当键盘将要出现时
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        //监听当键将要退出时
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = TITLE_COLOR;
        titleLabel.font = TEXT_MEDIUM(16);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = STRING(title);
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(28));
            make.height.mas_equalTo(SCALES(21));
            make.centerX.equalTo(self);
        }];
        
        UIView *textViewBg = [[UIView alloc] init];
        textViewBg.backgroundColor = UIColorRGB(0xF8F8F8);
        [self addSubview:textViewBg];
        [textViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(SCALES(14));
            make.left.mas_equalTo(SCALES(14));
            make.right.offset(SCALES(-14));
            make.height.mas_equalTo(SCALES(160));
        }];
        
        UITextView *textView = [[UITextView alloc]init];
        textView.ug_placeholderStr = STRING(titleplaceholder);
        textView.font = TEXT_FONT_15;
        textView.delegate = self;
        textView.returnKeyType = UIReturnKeyDefault;
        textView.text = STRING(content);
        textView.ug_maximumLimit = length;
        textView.backgroundColor = UIColor.clearColor;
        [textViewBg addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(14));
            make.left.mas_equalTo(SCALES(14));
            make.right.offset(SCALES(-14));
            make.height.mas_equalTo(SCALES(110));
        }];
        self.textView = textView;
        
        UILabel *textCount = [[UILabel alloc]init];
        textCount = [[UILabel alloc]init];
        textCount.text = [NSString stringWithFormat:@"0/%zd",self.maxTextCount];
        textCount.textColor = TEXT_SIMPLE_COLOR;
        textCount.font = TEXT_FONT_12;
        textCount.textAlignment = NSTextAlignmentRight;
        [textViewBg addSubview:textCount];
        [textCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(SCALES(-14));
            make.right.offset(SCALES(-14));
        }];
        self.textCount = textCount;
        
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
            make.top.equalTo(textViewBg.mas_bottom).offset(SCALES(20));
            make.left.mas_equalTo(SCALES(14));
            make.height.mas_equalTo(SCALES(49));
        }];
        
        UIButton* affirmBtn = [[UIButton alloc] init];
        affirmBtn.titleLabel.font = TEXT_FONT_18;
        [affirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [affirmBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [affirmBtn setTitle:STRING(affirm) forState:UIControlStateNormal];
        affirmBtn.layer.cornerRadius = SCALES(24.5);
        affirmBtn.layer.masksToBounds = YES;
        affirmBtn.adjustsImageWhenHighlighted = NO;//去掉点击效果
        
        __weak typeof(textView) wTextView = textView;
        [[affirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (kStringIsEmpty(wTextView.text)) {
                kShowToast(@"请输入内容");
                return;
            }
            if (wself.affirmBlock) {
                [wself removeView];
                wself.affirmBlock(wTextView.text);
            }
        }];
        [self addSubview:affirmBtn];
        [affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.width.equalTo(closeBtn);
            make.right.offset(SCALES(-14));
            make.left.equalTo(closeBtn.mas_right).offset(SCALES(12));
        }];
        //半圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(SCALES(10), SCALES(10))];
         CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        self.textCount.text = [NSString stringWithFormat:@"%@/%@",@(content.length),@(self.maxTextCount)];
    }
    return self;
}

//当键盘出现
- (void)keyboardWillShow:(NSNotification*)notification {
    // 获取键盘frame
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 获取键盘弹出时长
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 修改底部视图距离底部的间距=
    if (self.keyboardHeight) {
        self.keyboardHeight((CGRectGetHeight(endFrame)), duration);
    }
}

//当键退出
- (void)keyboardWillHide:(NSNotification*)notification {
    // 获取键盘弹出时长
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 修改底部视图距离底部的间距=
    if (self.keyboardHeight) {
        self.keyboardHeight(0, duration);
    }
}

#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    //字数限制
    NSInteger length = 0;//定义length来保存字数
    NSInteger textLength;
    NSString *toBeString = textView.text;
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > self.maxTextCount && textView.markedTextRange == nil) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxTextCount];
            if (rangeIndex.length == 1) {
                textView.text = [toBeString substringToIndex:self.maxTextCount];
                textLength = textView.text.length;
            } else {
                textView.text = [toBeString substringWithRange:NSMakeRange(0, length)];
            }
            self.textCount.text = [NSString stringWithFormat:@"%@/%@",@(textView.text.length),@(self.maxTextCount)];
        } else {
            length = toBeString.length;
            self.textCount.text = [NSString stringWithFormat:@"%@/%@",@(textView.text.length),@(self.maxTextCount)];
        }
    }
}

- (void)removeView {
    [self removeFromSuperview];
}
@end
