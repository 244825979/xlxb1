//
//  ASEditAvatarCell.m
//  AS
//
//  Created by SA on 2025/4/21.
//

#import "ASEditAvatarCell.h"

@interface ASEditAvatarCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *backIcon;
@property (nonatomic, strong) UILabel *moneyHint;
@property (nonatomic, strong) UIImageView *stateIcon;
@end

@implementation ASEditAvatarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.backIcon];
    [self.contentView addSubview:self.moneyHint];
    [self.contentView addSubview:self.stateIcon];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
        make.right.equalTo(self.contentView).offset(SCALES(-14));
    }];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.backIcon.mas_left).offset(SCALES(-8));
        make.size.mas_equalTo(CGSizeMake(SCALES(40), SCALES(40)));
    }];
    
    [self.stateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.avatar.mas_left).offset(SCALES(-8));
        make.size.mas_equalTo(CGSizeMake(SCALES(42), SCALES(18)));
    }];
    
    [self.moneyHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(SCALES(8));
        make.centerY.equalTo(self.titleLabel);
        make.height.mas_equalTo(SCALES(20));
    }];
}

- (void)setModel:(ASSetCellModel *)model {
    _model = model;
    self.titleLabel.text = STRING(model.leftTitle);
    if (!kStringIsEmpty(model.avatarUrl)) {
        [self.avatar sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatarUrl]]];
    } else {
        self.avatar.image = model.avatarImage;
    }
    self.moneyHint.hidden = model.taskModel.is_show == 1 ? NO : YES;
    self.moneyHint.text = [NSString stringWithFormat:@"   %@   ",model.taskModel.des];
    if (model.stateHiden == 1) {
        self.stateIcon.hidden = YES;
    } else {
        self.stateIcon.hidden = NO;
    }
}

- (UIImageView *)stateIcon {
    if (!_stateIcon) {
        _stateIcon = [[UIImageView alloc]init];
        _stateIcon.image = [UIImage imageNamed:@"state_review"];
        _stateIcon.hidden = YES;
    }
    return _stateIcon;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TITLE_COLOR;
        _titleLabel.font = TEXT_FONT_15;
    }
    return _titleLabel;
}

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc]init];
        _avatar.contentMode = UIViewContentModeScaleAspectFill;
        _avatar.layer.cornerRadius = SCALES(20);
        _avatar.layer.masksToBounds = YES;
    }
    return _avatar;
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
        _moneyHint.text = @"  上传本人头像 +20金币  ";
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
