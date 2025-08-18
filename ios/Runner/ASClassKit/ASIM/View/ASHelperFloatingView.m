//
//  ASHelperFloatingView.m
//  AS
//
//  Created by SA on 2025/7/4.
//

#import "ASHelperFloatingView.h"

@interface ASHelperFloatingView ()
@property (nonatomic, strong) UIImageView *matchHelperIcon;
@property (nonatomic, strong) UIButton *textBtn;
@property (nonatomic, strong) UILabel *pauseAcount;//匹配暂停提示数量
@end

@implementation ASHelperFloatingView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.matchHelperIcon];
        [self addSubview:self.textBtn];
        [self addSubview:self.pauseAcount];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.clickBlock) {
                wself.clickBlock();
            }
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAcount:) name:@"refreshLittleHelperAcountNotify" object:nil];
    }
    return self;
}

- (void)refreshAcount:(NSNotification *)notification {
    if (self.model.fateHelperStatus == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textBtn setTitle:[NSString stringWithFormat:@"%zd个新匹配", [ASIMHelperDataManager shared].helperList.count] forState:UIControlStateNormal];
        });
    } else {
        if ([ASIMHelperDataManager shared].helperList.count > 0) {
            self.pauseAcount.hidden = NO;
            self.pauseAcount.text = [NSString stringWithFormat:@"%zd", [ASIMHelperDataManager shared].helperList.count];
        } else {
            self.pauseAcount.hidden = YES;
        }
        [self.textBtn setTitle:@"点击回复" forState:UIControlStateNormal];
    }
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.matchHelperIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(58), SCALES(51)));
    }];
    [self.textBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.matchHelperIcon);
        make.top.equalTo(self.matchHelperIcon.mas_bottom).offset(SCALES(2));
        make.height.mas_equalTo(self.model.fateHelperStatus == 1 ? SCALES(22.5) : SCALES(21));
        make.width.mas_equalTo(self.model.fateHelperStatus == 1 ? SCALES(76) : SCALES(62));
    }];
    [self.pauseAcount mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.mas_equalTo(SCALES(35));
        make.height.mas_equalTo(SCALES(20));
        make.width.mas_equalTo(self.model.waitReplyNum > 9 ? SCALES(28) : SCALES(20));
    }];
}

- (void)setModel:(ASFateHelperStatusModel *)model {
    _model = model;
    if (model.fateHelperStatus == 1) {
        self.pauseAcount.hidden = YES;
        [self.textBtn setTitle:[NSString stringWithFormat:@"%zd个新匹配", [ASIMHelperDataManager shared].helperList.count] forState:UIControlStateNormal];
    } else {
        if ([ASIMHelperDataManager shared].helperList.count > 0) {
            self.pauseAcount.hidden = NO;
            self.pauseAcount.text = [NSString stringWithFormat:@"%zd", [ASIMHelperDataManager shared].helperList.count];
        } else {
            self.pauseAcount.hidden = YES;
        }
        [self.textBtn setTitle:@"点击回复" forState:UIControlStateNormal];
    }
    [self layoutSubviews];
}

- (UIImageView *)matchHelperIcon {
    if (!_matchHelperIcon) {
        _matchHelperIcon = [[UIImageView alloc]init];
        _matchHelperIcon.image = [UIImage imageNamed:@"zhushou_icon"];
    }
    return _matchHelperIcon;
}

- (UIButton *)textBtn {
    if (!_textBtn) {
        _textBtn = [[UIButton alloc] init];
        [_textBtn setBackgroundImage:[UIImage imageNamed:@"zhushou_btn"] forState:UIControlStateNormal];
        _textBtn.titleLabel.font = TEXT_FONT_11;
        [_textBtn setTitle:@"点击回复" forState:UIControlStateNormal];
        _textBtn.adjustsImageWhenHighlighted = NO;
        _textBtn.userInteractionEnabled = NO;
    }
    return _textBtn;
}

- (UILabel *)pauseAcount {
    if (!_pauseAcount) {
        _pauseAcount = [[UILabel alloc]init];
        _pauseAcount.font = TEXT_FONT_12;
        _pauseAcount.backgroundColor = UIColor.redColor;
        _pauseAcount.textAlignment = NSTextAlignmentCenter;
        _pauseAcount.textColor = UIColor.whiteColor;
        _pauseAcount.layer.cornerRadius = SCALES(10);
        _pauseAcount.layer.masksToBounds = YES;
        _pauseAcount.layer.borderColor = UIColor.whiteColor.CGColor;
        _pauseAcount.layer.borderWidth = SCALES(1);
        _pauseAcount.hidden = YES;
    }
    return _pauseAcount;
}

@end
