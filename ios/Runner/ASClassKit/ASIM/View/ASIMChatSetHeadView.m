//
//  ASIMChatSetHeadView.m
//  AS
//
//  Created by SA on 2025/5/15.
//

#import "ASIMChatSetHeadView.h"

@interface ASIMChatSetHeadView ()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *signature;
@property (nonatomic, strong) UIImageView *back;
@end

@implementation ASIMChatSetHeadView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.header];
        [self addSubview:self.name];
        [self addSubview:self.signature];
        [self addSubview:self.back];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            [ASMyAppCommonFunc goPersonalHomeWithUserID:wself.model.info.user_id viewController:[ASCommonFunc currentVc] action:^(id  _Nonnull data) {
                
            }];
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(50), SCALES(50)));
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.header.mas_right).offset(SCALES(12));
        make.top.equalTo(self.header);
        make.height.mas_equalTo(SCALES(20));
        make.right.offset(SCALES(-100));
    }];
    [self.signature mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.name);
        make.top.equalTo(self.name.mas_bottom).offset(SCALES(4));
    }];
    [self.back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(SCALES(-16));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
    }];
}

- (void)setModel:(ASIMChatSetModel *)model {
    _model = model;
    [self.header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.info.avatar]]];
    self.name.text = STRING(model.info.nickname);
    self.signature.text = STRING(model.info.sign);
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.layer.cornerRadius = SCALES(25);
        _header.layer.masksToBounds = YES;
    }
    return _header;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.textColor = TITLE_COLOR;
        _name.font = TEXT_MEDIUM(16);
        _name.text = @"昵称";
    }
    return _name;
}

- (UILabel *)signature {
    if (!_signature) {
        _signature = [[UILabel alloc]init];
        _signature.font = TEXT_FONT_14;
        _signature.textColor = TEXT_SIMPLE_COLOR;
        _signature.text = @"这家伙很懒，不留下一句话";
        _signature.numberOfLines = 2;
    }
    return _signature;
}

- (UIImageView *)back {
    if (!_back) {
        _back = [[UIImageView alloc]init];
        _back.image = [UIImage imageNamed:@"cell_back"];
    }
    return _back;
}
@end
