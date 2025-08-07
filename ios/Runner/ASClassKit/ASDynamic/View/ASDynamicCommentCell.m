//
//  ASDynamicCommentCell.m
//  AS
//
//  Created by SA on 2025/5/8.
//

#import "ASDynamicCommentCell.h"

@interface ASDynamicCommentCell ()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) YYLabel *nickName;
@property (nonatomic, strong) UILabel *createTime;
@property (nonatomic, strong) UILabel *content;
@end

@implementation ASDynamicCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.header];
    [self.contentView addSubview:self.nickName];
    [self.contentView addSubview:self.createTime];
    [self.contentView addSubview:self.content];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.top.mas_equalTo(SCALES(16));
        make.width.height.mas_equalTo(40);
    }];
    
    [self.nickName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.header.mas_right).offset(SCALES(8));
        make.top.equalTo(self.header.mas_top);
        make.height.mas_equalTo(SCALES(14));
    }];
    
    CGFloat textMaxLayoutWidth = floorf(SCREEN_WIDTH - SCALES(172));
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickName.mas_left);
        make.top.equalTo(self.nickName.mas_bottom).offset(SCALES(8));
        make.width.mas_equalTo(textMaxLayoutWidth);
    }];
    self.content.preferredMaxLayoutWidth = textMaxLayoutWidth;
    
    [self.createTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(SCALES(-14));
        make.top.equalTo(self.content);
    }];
}

- (void)setModel:(ASDynamicCommentModel *)model {
    _model = model;
    [self.header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar]]];
    if (kObjectIsEmpty(model.nameAgreement)) {
        self.nickName.text = STRING(model.nickname);
    } else {
        self.nickName.attributedText = model.nameAgreement;
    }
    self.createTime.text = STRING(model.create_time);
    self.content.text = model.content;
    if (self.content.text.length > 0 && self.content.text) {
        self.content.attributedText = [ASCommonFunc attributedWithString:model.content lineSpacing:SCALES(3.0)];
    }
    model.clikedBlock = ^(NSString * _Nonnull text) {
        [ASMyAppCommonFunc goPersonalHomeWithUserID:text viewController:[ASCommonFunc currentVc] action:^(id  _Nonnull data) {
        
        }];
    };
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.layer.cornerRadius = SCALES(8);
        _header.layer.masksToBounds = YES;
        _header.contentMode = UIViewContentModeScaleAspectFill;
        _header.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_header addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            [ASMyAppCommonFunc goPersonalHomeWithUserID:wself.model.user_id viewController:[ASCommonFunc currentVc] action:^(id  _Nonnull data) {
            
            }];
        }];
    }
    return _header;
}

- (YYLabel *)nickName {
    if (!_nickName) {
        _nickName = [[YYLabel alloc]init];
        _nickName.textColor = TEXT_SIMPLE_COLOR;
        _nickName.font = TEXT_FONT_14;
    }
    return _nickName;
}

- (UILabel *)createTime {
    if (!_createTime) {
        _createTime = [[UILabel alloc]init];
        _createTime.textColor = TEXT_SIMPLE_COLOR;
        _createTime.font = TEXT_FONT_12;
    }
    return _createTime;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.font = TEXT_FONT_14;
        _content.textColor = TITLE_COLOR;
        _content.numberOfLines = 0;
        _content.preferredMaxLayoutWidth = floorf(SCREEN_WIDTH-SCALES(172));
    }
    return _content;
}

@end
