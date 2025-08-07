//
//  ASConsumptionNameView.m
//  AS
//
//  Created by SA on 2025/5/22.
//

#import "ASConsumptionNameView.h"

@interface ASConsumptionNameView()
@property (nonatomic, strong) UIImageView *bgView;
@end

@implementation ASConsumptionNameView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.title];
        [self.bgView addSubview:self.content];
        NSArray *titles = @[@" 消费提醒", @" 限额保护", @" 身份校检"];
        NSArray *icons = @[@"consumption_name1", @"consumption_name2", @"consumption_name3"];
        for (int i = 0; i< titles.count; i++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.frame = CGRectMake(SCALES(16)+ i*SCALES(100), SCALES(88), SCALES(70), SCALES(18));
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
            btn.titleLabel.font = TEXT_MEDIUM(12);
            [self.bgView addSubview:btn];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.mas_equalTo(SCALES(20));
        make.height.mas_equalTo(SCALES(24));
        make.right.equalTo(self.bgView).offset(SCALES(-16));
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(SCALES(10));
        make.left.right.equalTo(self.title);
        make.height.mas_equalTo(SCALES(20));
    }];
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
        _bgView.image = [UIImage imageNamed:@"consumption_name_bg"];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = TITLE_COLOR;
        _title.font = TEXT_MEDIUM(16);
        _title.text = [NSString stringWithFormat:@"Hi,<%@>", STRING(USER_INFO.nickname)];
    }
    return _title;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = TEXT_SIMPLE_COLOR;
        _content.font = TEXT_FONT_14;
        _content.text = @"开启消费保护可获得以下服务";
    }
    return _content;
}
@end
