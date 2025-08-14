//
//  ASConvenienceLanListCell.m
//  AS
//
//  Created by SA on 2025/5/21.
//

#import "ASConvenienceLanListCell.h"
#import "ASBaseVoicePlayView.h"
#import "ASMineRequest.h"

@interface ASConvenienceLanListCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *compileBtn;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIImageView *coverImage;
@property (nonatomic, strong) UILabel *status;
@property (nonatomic, strong) ASBaseVoicePlayView *voicePlayerView;
@end

@implementation ASConvenienceLanListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BACKGROUNDCOLOR;
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.topView];
        [self.topView addSubview:self.titleLabel];
        [self.topView addSubview:self.compileBtn];
        [self.topView addSubview:self.delBtn];
        [self.topView addSubview:self.selectBtn];
        [self.bgView addSubview:self.line];
        [self.bgView addSubview:self.content];
        [self.bgView addSubview:self.coverImage];
        [self.bgView addSubview:self.voicePlayerView];
        [self.bgView addSubview:self.status];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.mas_equalTo(SCALES(16));
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(SCALES(-16));
    }];
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(SCALES(52));
    }];
    if (self.model.status == 0 || self.model.status == 2) {
        [self.delBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.topView).offset(SCALES(-14));
            make.centerY.equalTo(self.topView);
            make.width.height.mas_equalTo(SCALES(16));
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(14));
            make.centerY.equalTo(self.topView);
            make.width.mas_lessThanOrEqualTo(SCALES(220));//最大宽度限制
        }];
        [self.status mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(SCALES(8));
            make.centerY.equalTo(self.titleLabel);
            make.width.mas_equalTo(SCALES(42));
            make.height.mas_equalTo(SCALES(18));
        }];
    } else {
        [self.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.topView).offset(SCALES(-14));
            make.centerY.equalTo(self.topView);
            make.height.mas_equalTo(SCALES(20));
            make.width.mas_equalTo(SCALES(100));
        }];
        [self.delBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.selectBtn.mas_left).offset(SCALES(-8));
            make.centerY.equalTo(self.topView);
            make.width.height.mas_equalTo(SCALES(16));
        }];
        [self.compileBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.delBtn.mas_left).offset(SCALES(-8));
            make.centerY.equalTo(self.topView);
            make.width.height.mas_equalTo(SCALES(16));
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(12));
            make.top.equalTo(self.topView.mas_top);
            make.height.mas_equalTo(SCALES(56));
            make.width.mas_lessThanOrEqualTo(SCALES(160));//最大宽度限制
        }];
    }
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.mas_equalTo(SCALES(52));
        make.height.mas_equalTo(SCALES(0.5));
    }];
    CGFloat textMaxLayoutWidth = SCREEN_WIDTH - SCALES(64);
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.equalTo(self.line.mas_bottom).offset(SCALES(16));
        make.width.mas_equalTo(textMaxLayoutWidth);
        make.height.mas_greaterThanOrEqualTo(SCALES(24));//最小高度
    }];
    self.content.preferredMaxLayoutWidth = textMaxLayoutWidth;
    if (!kStringIsEmpty(self.model.title)) {
        if (!kStringIsEmpty(self.model.file)) {
            [self.coverImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.content);
                make.top.equalTo(self.content.mas_bottom).offset(SCALES(8.5));
                make.width.height.mas_equalTo(SCALES(72));
            }];
            [self.voicePlayerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.content);
                make.top.equalTo(self.coverImage.mas_bottom).offset(SCALES(8));
                make.size.mas_equalTo(CGSizeMake(SCALES(64), SCALES(28)));
            }];
        } else {
            [self.voicePlayerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.content);
                make.top.equalTo(self.content.mas_bottom).offset(SCALES(8.5));
                make.size.mas_equalTo(CGSizeMake(SCALES(64), SCALES(28)));
            }];
        }
    } else {
        if (!kStringIsEmpty(self.model.file)) {
            [self.coverImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.content);
                make.top.equalTo(self.line.mas_bottom).offset(SCALES(16));
                make.width.height.mas_equalTo(SCALES(72));
            }];
            [self.voicePlayerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.content);
                make.top.equalTo(self.coverImage.mas_bottom).offset(SCALES(8));
                make.size.mas_equalTo(CGSizeMake(SCALES(64), SCALES(28)));
            }];
        } else {
            [self.voicePlayerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.content);
                make.top.equalTo(self.line.mas_bottom).offset(SCALES(16));
                make.size.mas_equalTo(CGSizeMake(SCALES(64), SCALES(28)));
            }];
        }
    }
}

- (void)setModel:(ASConvenienceLanListModel *)model {
    _model = model;
    self.titleLabel.text = kStringIsEmpty(model.name) ? @"我的模板" : STRING(model.name);
    if (kStringIsEmpty(model.title)) {
        self.content.hidden = YES;
    } else {
        self.content.hidden = NO;
        self.content.text = STRING(model.title);
        if (self.content.text.length > 0 && self.content.text) {
            self.content.attributedText = [ASCommonFunc attributedWithString:model.title lineSpacing:SCALES(4.0)];
        }
    }
    if (kStringIsEmpty(model.file)) {
        self.coverImage.hidden = YES;
    } else {
        self.coverImage.hidden = NO;
        [self.coverImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.file]]];
    }
    if (kStringIsEmpty(model.voice_file)) {
        self.voicePlayerView.hidden = YES;
    } else {
        self.voicePlayerView.hidden = NO;
        ASVoiceModel *voiceModel = [[ASVoiceModel alloc] init];
        voiceModel.voice_time = model.len;
        voiceModel.voice = model.voice_file;
        self.voicePlayerView.model = voiceModel;
    }
    if (model.status == 0) {
        self.status.hidden = NO;
        self.compileBtn.hidden = YES;
        self.delBtn.hidden = YES;
        self.selectBtn.hidden = YES;
        self.status.text = @"审核中";
        self.status.textColor = TEXT_SIMPLE_COLOR;
        self.status.backgroundColor = UIColorRGB(0xF5f5f5);
    } else if (model.status == 2) {
        self.status.hidden = NO;
        self.compileBtn.hidden = YES;
        self.delBtn.hidden = NO;
        self.selectBtn.hidden = YES;
        self.status.text = @"不合格";
        self.status.textColor = MAIN_COLOR;
        self.status.backgroundColor = UIColorRGB(0xFFEFF0);
    } else {
        self.status.hidden = YES;
        self.compileBtn.hidden = NO;
        self.delBtn.hidden = NO;
        self.selectBtn.hidden = NO;
    }
    self.selectBtn.selected = NO;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.layer.cornerRadius = SCALES(8);
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = UIColor.whiteColor;
    }
    return _topView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TITLE_COLOR;
        _titleLabel.font = TEXT_FONT_16;
        _titleLabel.text = @"我的模版";
    }
    return _titleLabel;
}

- (UIButton *)compileBtn {
    if (!_compileBtn) {
        _compileBtn = [[UIButton alloc]init];
        [_compileBtn setImage:[UIImage imageNamed:@"convenience_edit"] forState:UIControlStateNormal];
        _compileBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_compileBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASAlertViewManager popTextFieldWithTitle:@"模版备注"
                                              content:STRING(wself.model.name)
                                          placeholder:@"请输入模版备注"
                                               length:10
                                           affirmText:@"确认"
                                               remark:@""
                                             isNumber:NO
                                              isEmpty:NO
                                         affirmAction:^(NSString * _Nonnull text) {
                [ASMineRequest requestConvenienceLanSetNameWithName:text ID:wself.model.ID success:^(id  _Nullable data) {
                    kShowToast(@"设置成功！");
                    wself.model.name = text;
                    wself.titleLabel.text = STRING(text);
                } errorBack:^(NSInteger code, NSString *msg) {

                }];
            } cancelAction:^{
                
            }];
        }];
    }
    return _compileBtn;
}

- (UIButton *)delBtn {
    if (!_delBtn) {
        _delBtn = [[UIButton alloc]init];
        [_delBtn setImage:[UIImage imageNamed:@"convenience_del"] forState:UIControlStateNormal];
        _delBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_delBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASAlertViewManager defaultPopTitle:@"确定删除当前模版？" content:@"" left:@"确认" right:@"取消" affirmAction:^{
                [ASMineRequest requestDelConvenienceLanWithID:wself.model.ID success:^(id  _Nullable data) {
                    kShowToast(@"删除成功！");
                    if (wself.delBlock) {
                        wself.delBlock();
                    }
                } errorBack:^(NSInteger code, NSString *msg) {
                    
                }];
            } cancelAction:^{
                
            }];
        }];
    }
    return _delBtn;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc]init];
        [_selectBtn setImage:[UIImage imageNamed:@"convenience_sel1"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"convenience_sel"] forState:UIControlStateSelected];
        _selectBtn.adjustsImageWhenHighlighted = NO;
        [_selectBtn setTitle:@" 使用此模版" forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = TEXT_FONT_14;
        [_selectBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.selectBlock) {
                wself.selectBlock(wself.model.ID);
            }
        }];
    }
    return _selectBtn;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.numberOfLines = 0;
        _content.textColor = TITLE_COLOR;
        _content.font = TEXT_FONT_14;
    }
    return _content;
}

- (UIImageView *)coverImage {
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc]init];
        _coverImage.layer.cornerRadius = SCALES(10);
        _coverImage.layer.masksToBounds = YES;
        _coverImage.contentMode = UIViewContentModeScaleAspectFill;
        _coverImage.userInteractionEnabled = YES;
        kWeakSelf(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_coverImage addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            GKPhoto *photo = [[GKPhoto alloc] init];
            NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, wself.model.file];
            photo.url = [NSURL URLWithString:url];
            [[ASUploadImageManager shared] showMediaWithPhotos:@[photo] index:0 viewController:[ASCommonFunc currentVc]];
        }];
    }
    return _coverImage;
}

- (ASBaseVoicePlayView *)voicePlayerView {
    if (!_voicePlayerView) {
        _voicePlayerView = [[ASBaseVoicePlayView alloc]init];
        _voicePlayerView.hidden = YES;
        _voicePlayerView.layer.cornerRadius = SCALES(14);
        _voicePlayerView.layer.masksToBounds = YES;
        _voicePlayerView.type = 2;
    }
    return _voicePlayerView;
}

- (UILabel *)status {
    if (!_status) {
        _status = [[UILabel alloc]init];
        _status.font = TEXT_FONT_11;
        _status.textAlignment = NSTextAlignmentCenter;
        _status.hidden = YES;
        _status.layer.cornerRadius = SCALES(9);
        _status.layer.masksToBounds = YES;
    }
    return _status;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
