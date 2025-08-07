//
//  ASCallRecordListCell.m
//  AS
//
//  Created by SA on 2025/5/15.
//

#import "ASCallRecordListCell.h"

@interface ASCallRecordListCell ()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UIButton *callBtn;
@end

@implementation ASCallRecordListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.header];
        [self.contentView addSubview:self.nickName];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.callBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(56);
    }];
    [self.nickName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.header.mas_right).offset(10);
        make.top.equalTo(self.header.mas_top).offset(5);
        make.height.mas_equalTo(20);
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickName.mas_left);
        make.bottom.equalTo(self.header.mas_bottom).offset(-5);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.contentView.mas_right).offset(-100);
    }];
    [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.centerY.equalTo(self.nickName);
        make.left.equalTo(self.nickName.mas_right).offset(5);
    }];
    [self.callBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.time);
        make.centerY.equalTo(self.content);
        make.size.mas_equalTo(CGSizeMake(64, 24));
    }];
}

- (void)setModel:(ASCallListModel *)model {
    _model = model;
    [self.header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", SERVER_IMAGE_URL, model.avatar]]];
    self.nickName.text = STRING(model.nickname);
    self.content.text = STRING(model.status_txt);
    if (model.is_video == 1) {
        [self.callBtn setTitle:@"视频通话" forState:UIControlStateNormal];
    } else {
        [self.callBtn setTitle:@"语音通话" forState:UIControlStateNormal];
    }
    if (model.vip == 1) {
        self.nickName.textColor = RED_COLOR;
    } else {
        self.nickName.textColor = TITLE_COLOR;
    }
    self.time.text = STRING(model.create_time);
    if (model.status == 3) {
        if (model.is_video == 1) {
            self.content.textColor = UIColorRGB(0xFF1832);
        } else {
            self.content.textColor = UIColorRGB(0xFC49B1);
        }
    } else if (model.status == 1) {
        if ([model.status_txt containsString:@"对方已取消"]) {
            if (model.is_video == 1) {
                self.content.textColor = UIColorRGB(0xFF1832);
            } else {
                self.content.textColor = UIColorRGB(0xFC49B1);
            }
        } else {
            self.content.textColor = TEXT_SIMPLE_COLOR;
        }
    } else {
        self.content.textColor = TEXT_SIMPLE_COLOR;
    }
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.contentMode = UIViewContentModeScaleAspectFill;
        _header.layer.cornerRadius = 28;
        _header.layer.masksToBounds = YES;
    }
    return _header;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc] init];
        _nickName.textColor = TITLE_COLOR;
        _nickName.font = TEXT_MEDIUM(16);
        _nickName.text = @"昵称";
    }
    return _nickName;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = TEXT_SIMPLE_COLOR;
        _content.font = TEXT_FONT_14;
        _content.text = @"内容";
    }
    return _content;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.textColor = TEXT_SIMPLE_COLOR;
        _time.font = TEXT_FONT_12;
        _time.text = @"2000.01.01";
        _time.textAlignment = NSTextAlignmentRight;
    }
    return _time;
}

- (UIButton *)callBtn {
    if (!_callBtn) {
        _callBtn = [[UIButton alloc] init];
        _callBtn.titleLabel.font = TEXT_FONT_12;
        _callBtn.layer.cornerRadius = 12;
        _callBtn.layer.masksToBounds = YES;
        [_callBtn setBackgroundColor:GRDUAL_CHANGE_BG_COLOR(64, 24)];
        kWeakSelf(self);
        [[_callBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASMyAppCommonFunc callWithUserID:wself.model.userid
                                     callType:wself.model.is_video == 1 ? kCallTypeVideo : kCallTypeVoice
                                        scene:Call_Scene_CallList
                                         back:^(BOOL isSucceed) {
                
            }];
        }];
    }
    return _callBtn;
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
