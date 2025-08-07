//
//  ASVideoShowNotifyListCell.m
//  AS
//
//  Created by SA on 2025/5/13.
//

#import "ASVideoShowNotifyListCell.h"

@interface ASVideoShowNotifyListCell ()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UIView *masking;
@end

@implementation ASVideoShowNotifyListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.header];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.nickName];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.cover];
        [self.contentView addSubview:self.masking];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(SCALES(50));
    }];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.header);
        make.width.height.mas_equalTo(SCALES(16));
    }];
    [self.nickName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.header.mas_right).offset(SCALES(8));
        make.top.equalTo(self.header.mas_top).offset(SCALES(2));
        make.height.mas_equalTo(SCALES(18));
        make.right.equalTo(self.contentView.mas_right).offset(SCALES(-78));
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickName.mas_left);
        make.top.equalTo(self.nickName.mas_bottom).offset(SCALES(10));
        make.height.mas_equalTo(SCALES(16));
    }];
    [self.cover mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(SCALES(-16));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCALES(50), SCALES(66)));
    }];
    [self.masking mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setModel:(ASVideoShowNotifyModel *)model {
    _model = model;
    [self.header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.fromAvatar]]];
    [self.cover sd_setImageWithURL:[NSURL URLWithString: STRING(model.cover)]];
    self.nickName.text = STRING(model.fromNickname);
    self.content.text = [NSString stringWithFormat:@"%@ %@",STRING(model.desc), STRING(model.ctime)];
    self.masking.hidden = !model.is_read;
    if (model.type == 0) {
        self.icon.image = [UIImage imageNamed:@"notify_zan"];
        self.icon.hidden = NO;
    } else if (model.type == 1) {
        self.icon.image = [UIImage imageNamed:@"notify_shang"];
        self.icon.hidden = NO;
    } else {
        self.icon.hidden = YES;
    }
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.contentMode = UIViewContentModeScaleAspectFill;
        _header.layer.cornerRadius = SCALES(8);
        _header.layer.masksToBounds = YES;
        _header.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_header addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.indexNameBlock) {
                wself.indexNameBlock(@"去主页");
            }
        }];
    }
    return _header;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc] init];
        _nickName.textColor = TITLE_COLOR;
        _nickName.font = TEXT_FONT_16;
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

- (UIImageView *)cover {
    if (!_cover) {
        _cover = [[UIImageView alloc]init];
        _cover.contentMode = UIViewContentModeScaleAspectFill;
        _cover.layer.cornerRadius = SCALES(8);
        _cover.layer.masksToBounds = YES;
        _cover.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_cover addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.indexNameBlock) {
                wself.indexNameBlock(@"视频秀");
            }
        }];
    }
    return _cover;
}

- (UIView *)masking {
    if (!_masking) {
        _masking = [[UIView alloc]init];
        _masking.hidden = YES;
        _masking.backgroundColor = UIColorRGBA(0xffffff, 0.6);
        _masking.userInteractionEnabled = NO;
    }
    return _masking;
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
