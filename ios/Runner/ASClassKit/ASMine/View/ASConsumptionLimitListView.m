//
//  ASConsumptionLimitListView.m
//  AS
//
//  Created by SA on 2025/5/22.
//

#import "ASConsumptionLimitListView.h"
#import "ASAuthHomeController.h"

@interface ASConsumptionLimitListView()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) ASConsumptionListView *dayQuotaView;
@property (nonatomic, strong) ASConsumptionListView *giftQuotaView;
@property (nonatomic, strong) ASConsumptionListView *sumUpQuotaView;
@property (nonatomic, strong) ASConsumptionListView *extraQuotaView;
/**数据**/
@property (nonatomic, assign) NSInteger hiddenNumber;
@end

@implementation ASConsumptionLimitListView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = UIColor.clearColor;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.dayQuotaView];
        [self.bgView addSubview:self.giftQuotaView];
        [self.bgView addSubview:self.sumUpQuotaView];
        [self.bgView addSubview:self.extraQuotaView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(SCALES(100)*self.hiddenNumber);
    }];
    if (self.dayQuotaView.hidden == NO) {
        [self.dayQuotaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.bgView);
            make.height.mas_equalTo(SCALES(100));
        }];
    }
    if (self.giftQuotaView.hidden == NO) {
        if (self.dayQuotaView.hidden == NO) {
            [self.giftQuotaView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.dayQuotaView.mas_bottom);
                make.height.mas_equalTo(SCALES(100));
            }];
        } else {
            [self.giftQuotaView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self.bgView);
                make.height.mas_equalTo(SCALES(100));
            }];
        }
    }
    if (self.sumUpQuotaView.hidden == NO) {
        if (self.giftQuotaView.hidden == NO) {
            [self.sumUpQuotaView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.giftQuotaView.mas_bottom);
                make.height.mas_equalTo(SCALES(100));
            }];
        } else {
            if (self.dayQuotaView.hidden == NO) {
                [self.sumUpQuotaView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.bgView);
                    make.top.equalTo(self.dayQuotaView.mas_bottom);
                    make.height.mas_equalTo(SCALES(100));
                }];
            } else {
                [self.sumUpQuotaView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.equalTo(self.bgView);
                    make.height.mas_equalTo(SCALES(100));
                }];
            }
        }
    }
    if (self.extraQuotaView.hidden == NO) {
        if (self.sumUpQuotaView.hidden == NO) {
            [self.extraQuotaView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.sumUpQuotaView.mas_bottom);
                make.height.mas_equalTo(SCALES(100));
            }];
        } else {
            if (self.giftQuotaView.hidden == NO) {
                [self.extraQuotaView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.bgView);
                    make.top.equalTo(self.giftQuotaView.mas_bottom);
                    make.height.mas_equalTo(SCALES(100));
                }];
            } else {
                if (self.dayQuotaView.hidden == NO) {
                    [self.extraQuotaView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.equalTo(self.bgView);
                        make.top.equalTo(self.dayQuotaView.mas_bottom);
                        make.height.mas_equalTo(SCALES(100));
                    }];
                } else {
                    [self.extraQuotaView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.top.equalTo(self.bgView);
                        make.height.mas_equalTo(SCALES(100));
                    }];
                }
            }
        }
    }
}

- (void)setModel:(ASConsumptionModel *)model {
    _model = model;
    self.hiddenNumber = 0;
    self.dayQuotaView.is_auth = model.is_auth;
    self.giftQuotaView.is_auth = model.is_auth;
    self.sumUpQuotaView.is_auth = model.is_auth;
    self.extraQuotaView.is_auth = model.is_auth;
    self.extraQuotaView.is_extra = model.is_extra;
    for (int i = 0; i < model.limit.count; i++) {
        ASConsumptionListModel *limitModel = model.limit[i];
        if ([limitModel.key isEqualToString:@"day"]) {
            self.dayQuotaView.model = limitModel;
            self.dayQuotaView.hidden = !limitModel.is_show;
        } else if ([limitModel.key isEqualToString:@"accumulation"]) {
            self.giftQuotaView.model = limitModel;
            self.giftQuotaView.hidden = !limitModel.is_show;
        } else if ([limitModel.key isEqualToString:@"total"]) {
            self.sumUpQuotaView.model = limitModel;
            self.sumUpQuotaView.hidden = !limitModel.is_show;
        } else if ([limitModel.key isEqualToString:@"extra"]) {
            self.extraQuotaView.model = limitModel;
            self.extraQuotaView.hidden = !limitModel.is_show;
        }
        if (limitModel.is_show == YES) {
            self.hiddenNumber++;
            self.hiddenNumber = self.hiddenNumber > 4 ? 4 : self.hiddenNumber;
        }
    }
    if (model.is_auth == 0) {
        self.dayQuotaView.cliekIcon.hidden = NO;
        self.giftQuotaView.cliekIcon.hidden = NO;
        self.sumUpQuotaView.cliekIcon.hidden = NO;
        self.extraQuotaView.cliekIcon.hidden = NO;
    } else {
        self.dayQuotaView.cliekIcon.hidden = NO;
        self.giftQuotaView.cliekIcon.hidden = YES;
        self.sumUpQuotaView.cliekIcon.hidden = YES;
        self.extraQuotaView.cliekIcon.hidden = NO;
    }
    if (self.hiddenNumber == 1) {
        self.dayQuotaView.line.hidden = YES;
    }
    if (self.hiddenNumber == 3) {
        self.sumUpQuotaView.line.hidden = YES;
    }
    if (self.hiddenNumber == 2 || self.hiddenNumber == 4) {
        self.extraQuotaView.line.hidden = YES;
    }
    [self layoutSubviews];
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
        _bgView.userInteractionEnabled = YES;
        _bgView.image = [[UIImage imageNamed:@"consumption_limit_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    }
    return _bgView;
}

- (ASConsumptionListView *)dayQuotaView {
    if (!_dayQuotaView) {
        _dayQuotaView = [[ASConsumptionListView alloc]init];
        _dayQuotaView.title.text = @"每日送礼限额";
        _dayQuotaView.content.attributedText = [ASCommonFunc attributedWithString:@"当日对任意一个用户的累计送礼金额达到限额后,平台将自动限制礼物消费" lineSpacing:SCALES(4.0)];
        _dayQuotaView.hidden = YES;
        kWeakSelf(self);
        _dayQuotaView.actionBlock = ^{
            if (wself.model.limit.count > 0) {
                ASConsumptionListModel *model = wself.model.limit[0];
                [ASAlertViewManager popTextFieldWithTitle:@"每日送礼限额"
                                                  content:[NSString stringWithFormat:@"%zd", model.defaultValue]
                                              placeholder:@"输入整数"
                                                   length:[NSString stringWithFormat:@"%zd", model.defaultValue].length
                                               affirmText:@"确认"
                                                   remark:[NSString stringWithFormat:@"*仅支持输入≤%zd的正整数", model.defaultValue]
                                                 isNumber:YES
                                                  isEmpty:NO
                                             affirmAction:^(NSString * _Nonnull text) {
                    [ASCommonRequest requestSetConsumeWithIsExtra:NO value:text success:^(id  _Nullable data) {
                        wself.dayQuotaView.rightTitle.text = STRING(text);
                    } errorBack:^(NSInteger code, NSString *msg) {
                        
                    }];
                } cancelAction:^{
                    
                }];
            }
        };
    }
    return _dayQuotaView;
}

- (ASConsumptionListView *)giftQuotaView {
    if (!_giftQuotaView) {
        _giftQuotaView = [[ASConsumptionListView alloc]init];
        _giftQuotaView.title.text = @"累计送礼限额";
        _giftQuotaView.content.attributedText = [ASCommonFunc attributedWithString:@"当累计对任意一个用户的送礼金额达到设定限额，平台将自动限制礼物消费" lineSpacing:SCALES(4.0)];
        _giftQuotaView.hidden = YES;
    }
    return _giftQuotaView;
}

- (ASConsumptionListView *)sumUpQuotaView {
    if (!_sumUpQuotaView) {
        _sumUpQuotaView = [[ASConsumptionListView alloc]init];
        _sumUpQuotaView.title.text = @"送礼总限额";
        _sumUpQuotaView.content.attributedText = [ASCommonFunc attributedWithString:@"当累计送礼金额达到设定限额后，平台将自动限制礼物消费" lineSpacing:SCALES(4.0)];
        _sumUpQuotaView.hidden = YES;
    }
    return _sumUpQuotaView;
}

- (ASConsumptionListView *)extraQuotaView {
    if (!_extraQuotaView) {
        _extraQuotaView = [[ASConsumptionListView alloc]init];
        _extraQuotaView.title.text = @"每日额外1000礼物限额";
        _extraQuotaView.content.text = @"对任意用户都可使用";
        _extraQuotaView.hidden = YES;
        kWeakSelf(self);
        _extraQuotaView.actionBlock = ^{
            if (wself.model.is_extra == 1) {
                [ASAlertViewManager defaultPopTitle:@"提示" content:@"申请前需完成真人人脸核验" left:@"去验证" right:@"取消" isTouched:YES affirmAction:^{
                    ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                    vc.webUrl = USER_INFO.systemIndexModel.matchAuth;
                    vc.backBlock = ^{
                        [ASCommonRequest requestSetConsumeWithIsExtra:YES value:@"1000" success:^(id  _Nullable data) {
                            wself.model.is_extra = 2;
                            kShowToast(@"申请成功！");
                            wself.extraQuotaView.rightTitle.text = @"申请中";
                            wself.extraQuotaView.rightTitle.textColor = UIColorRGB(0xFF8419);
                        } errorBack:^(NSInteger code, NSString *msg) {
                            
                        }];
                    };
                    [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                } cancelAction:^{
                    
                }];
            }
        };
    }
    return _extraQuotaView;
}
@end

@implementation ASConsumptionListView
- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.title];
        [self addSubview:self.content];
        [self addSubview:self.rightTitle];
        [self addSubview:self.cliekIcon];
        [self addSubview:self.line];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.is_auth == 0) {
                ASAuthHomeController *vc = [[ASAuthHomeController alloc]init];
                [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
            } else {
                if (wself.actionBlock) {
                    wself.actionBlock();
                }
            }
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.mas_equalTo(SCALES(15));
        make.height.mas_equalTo(SCALES(21));
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(SCALES(10));
        make.left.equalTo(self.title);
        make.right.equalTo(self).offset(SCALES(-58));
    }];
    [self.cliekIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title);
        make.right.equalTo(self.mas_right).offset(SCALES(-12));
        make.height.width.mas_equalTo(SCALES(16));
    }];
    [self.rightTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title);
        make.right.equalTo(self.cliekIcon.mas_left).offset(SCALES(-2));
    }];
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.right.equalTo(self).offset(SCALES(-16));
        make.height.mas_equalTo(SCALES(0.5));
        make.bottom.equalTo(self);
    }];
}

- (void)setModel:(ASConsumptionListModel *)model {
    _model = model;
    if (self.is_auth == 0) {
        self.rightTitle.text = @"请先完成实名认证";
        self.rightTitle.textColor = UIColorRGB(0xFF8419);
    } else {
        if ([model.key isEqualToString:@"extra"]) {
            if (self.is_extra == 1) {//0未累计超额不显示，1可申请，2申请中，3成功
                self.rightTitle.text = @"去申请";
                self.rightTitle.textColor = UIColorRGB(0x3C90FF);
            } else if (self.is_extra == 2) {
                self.rightTitle.text = @"申请中";
                self.rightTitle.textColor = UIColorRGB(0xFF8419);
            } else if (self.is_extra == 3) {
                self.rightTitle.text = @"申请成功";
                self.rightTitle.textColor = UIColorRGB(0xFF5B5B);
            } else {
                self.rightTitle.hidden = YES;
                self.cliekIcon.hidden = YES;
            }
        } else {
            if ([model.key isEqualToString:@"day"]) {
                self.rightTitle.textColor = UIColorRGB(0x3C90FF);
            } else {
                self.rightTitle.textColor = UIColorRGB(0x3C90FF);
            }
            if (!kStringIsEmpty(model.defaultText)) {
                self.rightTitle.text = model.defaultText;
            } else {
                self.rightTitle.text = [NSString stringWithFormat:@"%zd", model.value];
            }
        }
    }
}

- (void)setIs_auth:(NSInteger)is_auth {
    _is_auth = is_auth;
}

- (void)setIs_extra:(NSInteger)is_extra {
    _is_extra = is_extra;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = TITLE_COLOR;
        _title.font = TEXT_MEDIUM(15);
    }
    return _title;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = TEXT_SIMPLE_COLOR;
        _content.font = TEXT_FONT_13;
        _content.numberOfLines = 0;
    }
    return _content;
}

- (UILabel *)rightTitle {
    if (!_rightTitle) {
        _rightTitle = [[UILabel alloc]init];
        _rightTitle.textColor = TEXT_SIMPLE_COLOR;
        _rightTitle.font = TEXT_FONT_13;
    }
    return _rightTitle;
}

- (UIImageView *)cliekIcon {
    if (!_cliekIcon) {
        _cliekIcon = [[UIImageView alloc]init];
        _cliekIcon.image = [UIImage imageNamed:@"cell_back"];
    }
    return _cliekIcon;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}
@end
