//
//  ASUMShareAlertView.m
//  AS
//
//  Created by SA on 2025/7/11.
//

#import "ASUMShareAlertView.h"

@interface ASUMShareAlertView ()
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *closeBtn;
/**数据**/
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *icons;
@end

@implementation ASUMShareAlertView

- (instancetype)init {
    if (self = [super init]) {
        self.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.line];
        [self.alertView addSubview:self.closeBtn];
        self.backgroundColor = UIColor.clearColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
        }];
        self.titles = @[@"分享海报", @"微信好友", @"朋友圈", @"复制链接"];
        self.icons = @[@"share_item1", @"share_item2", @"share_item3", @"share_item4"];
        CGFloat btnW = SCREEN_WIDTH/4;
        for (int i = 0; i < self.titles.count; i++) {
            UIButton *btn = [self createBtn: self.icons[i] andTitle:self.titles[i]];
            btn.frame = CGRectMake(i*btnW, SCALES(21), btnW, SCALES(90));
            btn.adjustsImageWhenHighlighted = NO;
            [self.alertView addSubview:btn];
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (wself.affirmBlock) {
                    if (i == 0) {
//                        //截取view绘制成图片
//                        UIImage *image = [ASCommonFunc captureView:wself.sharePoster frame:wself.sharePoster.frame];
//                        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                            //写入图片到相册
//                            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
//                        } completionHandler:^(BOOL success, NSError * _Nullable error) {
//                            if (success == YES) {
//                                dispatch_sync(dispatch_get_main_queue(), ^{
//                                    kShowToast(@"保存成功！");
//                                });
//                            } else {
//                                dispatch_sync(dispatch_get_main_queue(), ^{
//                                    kShowToast(@"保存失败！");
//                                });
//                            }
//                        }];
                        [wself removeFromSuperview];
                        wself.affirmBlock(UMSocialPlatformType_UserDefine_Begin, @"");
                    }
                    if (i == 1) {
                        [wself removeFromSuperview];
                        wself.affirmBlock(UMSocialPlatformType_WechatSession, @"");
                    }
                    if (i == 2) {
                        [wself removeFromSuperview];
                        wself.affirmBlock(UMSocialPlatformType_WechatTimeLine, @"");
                    }
                    if (i == 3) {
                        [wself removeFromSuperview];
                        UIPasteboard *pab = [UIPasteboard generalPasteboard];
                        pab.string = STRING(wself.bodyModel.shareData.linkUrl);
                        if (pab == nil) {
                            kShowToast(@"复制失败");
                        } else {
                            kShowToast(@"复制成功");
                        }
                        if (wself.cancelBlock) {
                            wself.cancelBlock();
                        }
                    }
                }
            }];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.alertView.frame = CGRectMake(0, SCREEN_HEIGHT - SCALES(170) - TAB_BAR_MAGIN, SCREEN_WIDTH,  SCALES(170) + TAB_BAR_MAGIN);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.alertView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(SCALES(12), SCALES(12))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.alertView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.alertView.layer.mask = maskLayer;
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(124));
        make.width.mas_equalTo(SCALES(320));
        make.height.mas_equalTo(SCALES(0.5));
        make.centerX.equalTo(self);
    }];
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(SCALES(15));
        make.width.mas_equalTo(SCALES(28));
        make.height.mas_equalTo(SCALES(28));
        make.centerX.equalTo(self);
    }];
}

- (void)setBodyModel:(ASWebJsBodyModel *)bodyModel {
    _bodyModel = bodyModel;
}

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = UIColor.whiteColor;
    }
    return _alertView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close5"] forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
        }];
    }
    return _closeBtn;
}

- (UIButton *)createBtn:(NSString *)icon andTitle:(NSString *)title {
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:STRING(icon)] forState:UIControlStateNormal];
    titleBtn.imageEdgeInsets = UIEdgeInsetsMake(SCALES(-20), 0, 0, 0);
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    UILabel *subTitleLabel = [[UILabel alloc]init];
    subTitleLabel.text = title;
    subTitleLabel.textColor = TITLE_COLOR;
    subTitleLabel.font = TEXT_FONT_15;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBtn addSubview:subTitleLabel];
    [subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleBtn.mas_centerX);
        make.bottom.equalTo(titleBtn.mas_bottom).offset(SCALES(-5));
        make.width.equalTo(titleBtn.mas_width);
    }];
    return titleBtn;
}
@end
