//
//  ASIMRollScrollView.m
//  AS
//
//  Created by SA on 2025/5/15.
//

#import "ASIMRollScrollView.h"
@interface ASIMRollScrollView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) ASIMRollScrollPageView *rollScrollView;
@end

@implementation ASIMRollScrollView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.icon];
        [self.bgView addSubview:self.rollScrollView];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (kAppType == 1) {
                return;
            }
            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
            vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_ChatConvention];
            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgView.frame = CGRectMake(20, 10, self.width - 40, 26);
    self.icon.frame = CGRectMake(14, 5, 16, 16);
    self.rollScrollView.frame = CGRectMake(37, -2, self.bgView.width - 37, 30);
}

- (void)invTimer {
    [self.rollScrollView invTimer];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = UIColorRGBA(0x000000, 0.4);
        _bgView.layer.cornerRadius = 13;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.image = [UIImage imageNamed:@"chat_notify"];
    }
    return _icon;
}

- (ASIMRollScrollPageView *)rollScrollView {
    if (!_rollScrollView) {
        _rollScrollView = [[ASIMRollScrollPageView alloc]init];
        if (kObjectIsEmpty(USER_INFO.textRiskModel) || kObjectIsEmpty(USER_INFO.textRiskModel.chatLabelList)) {
            NSString *text = kAppType == 0 ? @"请文明聊天，严禁低俗、涉黄、涉政、欺诈行为！请遵守《陪聊公约》" : @"请文明聊天，严禁低俗、涉黄、涉政、欺诈行为!";
            _rollScrollView.textArr = [NSMutableArray arrayWithArray:@[text]];
        } else {
            _rollScrollView.textArr = [NSMutableArray arrayWithArray:USER_INFO.textRiskModel.chatLabelList];
        }
        _rollScrollView.userInteractionEnabled = NO;
    }
    return _rollScrollView;
}
@end

@implementation ASIMRollScrollPageView
- (void)dealloc {
    [self invTimer];
}

- (UIScrollView *)textScrollview {
    if (!_textScrollview) {
        _textScrollview = [[UIScrollView alloc] init];
        _textScrollview.delegate = self;
        _textScrollview.showsHorizontalScrollIndicator=NO;
    }
    return _textScrollview;
}

- (instancetype)init {
    self=[super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        [self addSubview:self.textScrollview];
        [self.textScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        self.scrX = 0;
    }
    return self;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
}

- (void)setTextArr:(NSMutableArray *)textArr {
    _textArr = textArr;
    [self addCatryButton:textArr];
}

- (void)setBgHeight:(CGFloat)bgHeight {
    _bgHeight = bgHeight;
}

- (void)addCatryButton:(NSMutableArray *)theArr {
    [theArr addObjectsFromArray:[NSArray arrayWithArray:theArr]];
    NSMutableArray *tmp=[NSMutableArray array];
    CGFloat pointX = 0;
    CGFloat pointY = 0;
    CGFloat padding = 120.0;
    CGFloat btnHeight = self.bgHeight > 0 ? self.bgHeight : 30;
    for (int i = 0; i < theArr.count; i++) {
        CGRect rect = [theArr[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, btnHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : TEXT_FONT_12} context:nil];
        CGFloat btnWidth = rect.size.width + 15 + 25;
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.backgroundColor = [UIColor clearColor];
        [but setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [but setTitle:[NSString stringWithFormat:@"%@",theArr[i]] forState:UIControlStateNormal];
        [but setTitleColor:kObjectIsEmpty(self.textColor) ? UIColor.whiteColor : self.textColor forState:UIControlStateNormal];
        but.titleLabel.font = TEXT_FONT_12;
        but.layer.cornerRadius = 13;
        but.layer.masksToBounds = YES;
        but.frame = CGRectMake(pointX, pointY, btnWidth, btnHeight);
        pointX += (btnWidth + padding);
        [tmp addObject:but];
        [self.textScrollview addSubview:but];
        if (i == theArr.count-1) {
            self.scrMaxW = pointX;
        }
    }
}

- (void)setScrMaxW:(NSInteger)scrMaxW {
    _scrMaxW = scrMaxW;
    self.textScrollview.contentSize = CGSizeMake(scrMaxW, 0);
    kWeakSelf(self);
    self.disposable = [[RACSignal interval:0.02 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        wself.scrX = wself.scrX + 1;
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [wself.textScrollview setContentOffset:CGPointMake(wself.scrX, 0) animated:NO];
        } completion:nil];
        if (wself.textScrollview.contentOffset.x + 1 >= wself.textScrollview.contentSize.width/2) {
            wself.scrX = 0;
            [wself.textScrollview setContentOffset:CGPointMake(wself.scrX, 0) animated:NO];
        }
    }];
}

- (void)invTimer {
    if (self.disposable) {
        [self.disposable dispose];
    }
}
@end
