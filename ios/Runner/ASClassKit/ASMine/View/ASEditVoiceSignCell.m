//
//  ASEditVoiceSignCell.m
//  AS
//
//  Created by SA on 2025/4/21.
//

#import "ASEditVoiceSignCell.h"
#import "ASBaseVoicePlayView.h"

@interface ASEditVoiceSignCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *hintText;
@property (nonatomic, strong) UIImageView *state;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) ASBaseVoicePlayView *voicePlayView;
@property (nonatomic, strong) UIImageView *backIcon;
@property (nonatomic, strong) UILabel *moneyHint;
@end

@implementation ASEditVoiceSignCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.hintText];
    [self.contentView addSubview:self.state];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.voicePlayView];
    [self.contentView addSubview:self.backIcon];
    [self.contentView addSubview:self.moneyHint];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.top.mas_equalTo(SCALES(12));
        make.height.mas_equalTo(SCALES(24));
    }];
    
    [self.moneyHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(SCALES(8));
        make.centerY.equalTo(self.titleLabel);
        make.height.mas_equalTo(SCALES(20));
    }];
    
    [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(SCALES(8));
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(SCALES(42), SCALES(18)));
    }];
    
    [self.hintText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(SCALES(4));
        make.height.mas_equalTo(SCALES(18));
    }];
    
    [self.backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
        make.right.equalTo(self.contentView).offset(SCALES(-14));
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.backIcon.mas_left).offset(SCALES(-8));
    }];
    
    [self.voicePlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.rightLabel.mas_left).offset(SCALES(-8));
        make.size.mas_equalTo(CGSizeMake(SCALES(58), SCALES(28)));
    }];
}

- (void)setModel:(ASSetCellModel *)model {
    _model = model;
    if (!kStringIsEmpty(model.voice.voice)) {
        if (model.voice.voice_status == 0) {
            self.state.hidden = NO;
        } else {
            self.state.hidden = YES;
        }
        self.rightLabel.text = @"重新录制";
        self.voicePlayView.hidden = NO;
        self.voicePlayView.model = model.voice;
    } else {
        self.rightLabel.text = @"去录制";
        self.voicePlayView.hidden = YES;
        self.state.hidden = YES;
        self.moneyHint.hidden = model.taskModel.is_show == 1 ? NO : YES;
        self.moneyHint.text = [NSString stringWithFormat:@"   %@   ",model.taskModel.des];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TITLE_COLOR;
        _titleLabel.font = TEXT_FONT_15;
        _titleLabel.text = @"语音签名";
    }
    return _titleLabel;
}

- (UIImageView *)state {
    if (!_state) {
        _state = [[UIImageView alloc]init];
        _state = [[UIImageView alloc]init];
        _state.image = [UIImage imageNamed:@"state_review"];
        _state.hidden = YES;
    }
    return _state;
}

- (UILabel *)hintText {
    if (!_hintText) {
        _hintText = [[UILabel alloc]init];
        _hintText.text = @"添加语音签名，关注度可提升9倍";
        _hintText.font = TEXT_FONT_12;
        _hintText.textColor = TITLE_COLOR;
    }
    return _hintText;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.text = @"去录制";
        _rightLabel.font = TEXT_FONT_12;
        _rightLabel.textColor = TEXT_SIMPLE_COLOR;
    }
    return _rightLabel;
}

- (ASBaseVoicePlayView *)voicePlayView {
    if (!_voicePlayView) {
        _voicePlayView = [[ASBaseVoicePlayView alloc]init];
        _voicePlayView.layer.cornerRadius = SCALES(14);
        _voicePlayView.layer.masksToBounds = YES;
        _voicePlayView.type = 0;
        _voicePlayView.hidden = YES;
    }
    return _voicePlayView;
}

- (UIImageView *)backIcon {
    if (!_backIcon) {
        _backIcon = [[UIImageView alloc]init];
        _backIcon.image = [UIImage imageNamed:@"cell_back"];
    }
    return _backIcon;
}

- (UILabel *)moneyHint {
    if (!_moneyHint) {
        _moneyHint = [[UILabel alloc]init];
        _moneyHint.backgroundColor = UIColorRGB(0xFFF1F3);
        _moneyHint.font = TEXT_FONT_11;
        _moneyHint.layer.cornerRadius = SCALES(10);
        _moneyHint.layer.masksToBounds = YES;
        _moneyHint.textColor = MAIN_COLOR;
        _moneyHint.hidden = YES;
    }
    return _moneyHint;
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
