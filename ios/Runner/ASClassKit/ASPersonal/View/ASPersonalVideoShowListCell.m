//
//  ASPersonalVideoShowListCell.m
//  AS
//
//  Created by SA on 2025/5/16.
//

#import "ASPersonalVideoShowListCell.h"
#import "ASDynamicListBottomView.h"
#import "ASVideoShowRequest.h"

@interface ASPersonalVideoShowListCell ()
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIImageView *coverImage;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *shangBtn;
@end

@implementation ASPersonalVideoShowListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.coverImage];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.shangBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (kStringIsEmpty(self.model.title)) {
        [self.coverImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(SCALES(16));
            make.top.mas_equalTo(SCALES(16));
            make.height.mas_equalTo(SCALES(234));
            make.width.mas_equalTo(SCALES(175));
        }];
    } else {
        CGFloat textMaxLayoutWidth = floorf(SCREEN_WIDTH - SCALES(32));
        [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(SCALES(16));
            make.top.mas_equalTo(SCALES(16));
            make.width.mas_equalTo(textMaxLayoutWidth);
        }];
        self.content.preferredMaxLayoutWidth = textMaxLayoutWidth;
        [self.coverImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.content);
            make.top.equalTo(self.content.mas_bottom).offset(SCALES(12));
            make.height.mas_equalTo(SCALES(234));
            make.width.mas_equalTo(SCALES(175));
        }];
    }
    [self.likeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImage.mas_bottom).offset(SCALES(20));
        make.left.mas_equalTo(SCALES(16));
        make.height.mas_equalTo(SCALES(24));
    }];
    [self.shangBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.likeBtn);
        make.centerX.equalTo(self.contentView);
    }];
}

- (void)setModel:(ASVideoShowDataModel *)model {
    _model = model;
    self.content.text = model.title;
    if (self.content.text.length > 0 && self.content.text) {
        self.content.attributedText = [ASCommonFunc attributedWithString:model.title lineSpacing:SCALES(4.0)];
    }
    [self.coverImage setImageWithURL:[NSURL URLWithString: STRING(model.cover_img_url)] placeholder:nil];
    self.likeBtn.selected = model.like;
    if (model.like_num < 1) {
        [self.likeBtn setTitle:@" 点赞" forState:UIControlStateNormal];
    } else {
        [self.likeBtn setTitle:[NSString stringWithFormat:@" %@",[ASCommonFunc changeNumberAcount:model.like_num]] forState:UIControlStateNormal];
    }
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = TITLE_COLOR;
        _content.numberOfLines = 0;
        _content.font = TEXT_FONT_15;
    }
    return _content;
}

- (UIImageView *)coverImage {
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc]init];
        _coverImage.contentMode = UIViewContentModeScaleAspectFill;
        _coverImage.userInteractionEnabled = NO;
        _coverImage.layer.cornerRadius = SCALES(8);
        _coverImage.layer.masksToBounds = YES;
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"video_play"];
        [_coverImage addSubview:icon];
        [icon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(SCALES(42));
            make.centerX.centerY.equalTo(_coverImage);
        }];
    }
    return _coverImage;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setTitle:@" 点赞" forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"zan1"] forState:UIControlStateSelected];
        _likeBtn.adjustsImageWhenHighlighted = NO;
        _likeBtn.titleLabel.font = TEXT_FONT_14;
        [_likeBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_likeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASVideoShowRequest requestVideoShowZanWithVideoID:wself.model.ID success:^(id  _Nullable data) {
                NSNumber *isLike = data;
                if (isLike.integerValue == 1) {
                    wself.likeBtn.selected = YES;
                    wself.model.like_num += 1;
                } else {
                    wself.likeBtn.selected = NO;
                    wself.model.like_num -= 1;
                }
                wself.model.like = isLike.integerValue;
                if (wself.model.like_num < 1) {
                    [wself.likeBtn setTitle:@" 点赞" forState:UIControlStateNormal];
                } else {
                    [wself.likeBtn setTitle:[NSString stringWithFormat:@" %@",[ASCommonFunc changeNumberAcount:wself.model.like_num]] forState:UIControlStateNormal];
                }
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        }];
    }
    return _likeBtn;
}

- (UIButton *)shangBtn {
    if (!_shangBtn) {
        _shangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shangBtn setTitle:@" 赞赏" forState:UIControlStateNormal];
        [_shangBtn setImage:[UIImage imageNamed:@"shang"] forState:UIControlStateNormal];
        _shangBtn.titleLabel.font = TEXT_FONT_14;
        [_shangBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        _shangBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_shangBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASAlertViewManager popVideoShowGiftWithModel:wself.model];
        }];
    }
    return _shangBtn;
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
