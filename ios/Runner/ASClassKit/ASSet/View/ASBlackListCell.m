//
//  ASBlackListCell.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASBlackListCell.h"
#import "ASSetRequest.h"

@interface ASBlackListCell()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *sign;
@property (nonatomic, strong) UIView *delBlack;
@end

@implementation ASBlackListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.header];
        [self.contentView addSubview:self.nickName];
        [self.contentView addSubview:self.sign];
        [self.contentView addSubview:self.delBlack];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(SCALES(16));
        make.size.mas_equalTo(CGSizeMake(SCALES(60), SCALES(60)));
    }];
    
    [self.nickName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.header.mas_right).offset(SCALES(8));
        make.top.equalTo(self.header).offset(SCALES(6));
        make.height.mas_equalTo(SCALES(20));
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH - SCALES(180));//最大宽度限制
    }];
    
    [self.sign mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nickName);
        make.top.equalTo(self.nickName.mas_bottom).offset(SCALES(12));
        make.height.mas_equalTo(SCALES(16));
    }];
    
    [self.delBlack mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(SCALES(-10));
        make.centerY.height.equalTo(self.contentView);
        make.width.mas_equalTo(SCALES(60));
    }];
}

- (void)setModel:(ASUserInfoModel *)model {
    _model = model;
    [self.header sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar]]];
    self.nickName.text = STRING(model.nickname);
    self.sign.text = STRING(model.sign);
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.layer.cornerRadius = SCALES(8);
        _header.layer.masksToBounds = YES;
        _header.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _header;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc] init];
        _nickName.textColor = TITLE_COLOR;
        _nickName.font = TEXT_FONT_16;
    }
    return _nickName;
}

- (UILabel *)sign {
    if (!_sign) {
        _sign = [[UILabel alloc]init];
        _sign.font = TEXT_FONT_14;
        _sign.textColor = TITLE_COLOR;
    }
    return _sign;
}

- (UIView *)delBlack {
    if (!_delBlack) {
        _delBlack = [self createView:@"black_icon" andTitle:@"移除黑名单"];
        kWeakSelf(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_delBlack addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            [ASSetRequest requestSetBlackWithBlackID:wself.model.userid success:^(id  _Nullable data) {
                if (wself.refreshBlock) {
                    wself.refreshBlock();
                }
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        }];
    }
    return _delBlack;
}

- (UIView *)createView:(NSString *)icon andTitle:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.image = [UIImage imageNamed:STRING(icon)];
    [view addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(20));
        make.centerX.equalTo(view);
        make.height.width.mas_equalTo(SCALES(18));
     }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = STRING(title);
    titleLabel.textColor = TITLE_COLOR;
    titleLabel.font = TEXT_FONT_11;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImage.mas_bottom).offset(SCALES(4));
        make.centerX.equalTo(iconImage);
        make.height.mas_equalTo(SCALES(14));
     }];
    return view;
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
