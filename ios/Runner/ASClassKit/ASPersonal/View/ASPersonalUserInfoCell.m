//
//  ASPersonalUserInfoCell.m
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASPersonalUserInfoCell.h"

@implementation ASPersonalUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setModel:(ASUserInfoModel *)model {
    _model = model;
    NSInteger corlmax = 2;
    CGFloat viewW = (SCREEN_WIDTH - SCALES(32) - SCALES(12))/corlmax;
    CGFloat viewH = SCALES(16);
    for (int i = 0; i < model.basic_info.count; i++) {
        ASBasicInfoModel *infoModel = model.basic_info[i];
        if ([infoModel.title isEqualToString:@"ID"]) {
            break;
        }
        int row = i/corlmax;
        int col = i%corlmax;
        CGFloat x = (viewW + SCALES(12)) * col + SCALES(16);
        CGFloat y = (viewH + SCALES(14)) * row;
        NSString *iconText;
        if ([infoModel.title isEqualToString:@"性别"]) {
            iconText = @"personal_user1";
            infoModel.value = [infoModel.value isEqualToString:@"1"] ? @"女" : @"男";
        }
        if ([infoModel.title isEqualToString:@"年龄"]) {
            iconText = @"personal_user2";
        }
        if ([infoModel.title isEqualToString:@"所在地"]) {
            iconText = @"personal_user3";
        }
        if ([infoModel.title isEqualToString:@"情感"]) {
            iconText = @"personal_user4";
        }
        if ([infoModel.title isEqualToString:@"身高"]) {
            iconText = @"personal_user5";
        }
        if ([infoModel.title isEqualToString:@"体重"]) {
            iconText = @"personal_user6";
        }
        if ([infoModel.title isEqualToString:@"学历"]) {
            iconText = @"personal_user7";
        }
        if ([infoModel.title isEqualToString:@"职业"]) {
            iconText = @"personal_user8";
        }
        if ([infoModel.title isEqualToString:@"收入"]) {
            iconText = @"personal_user9";
        }
        if ([infoModel.title isEqualToString:@"家乡"]) {
            iconText = @"personal_user10";
        }
        UIView *view = [self createView:iconText title:infoModel.title content:infoModel.value];
        view.frame = CGRectMake(x, y, viewW, viewH);
        [self.contentView addSubview:view];
    }
}

- (UIView *)createView:(NSString *)icon title:(NSString *)title content:(NSString *)content {
    UIView *item = [[UIView alloc] init];
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.image = [UIImage imageNamed:STRING(icon)];
    [item addSubview:iconImage];
    [iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(item);
        make.width.mas_equalTo(SCALES(14));
     }];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = STRING(title);
    titleLabel.textColor = TEXT_SIMPLE_COLOR;
    titleLabel.font = TEXT_FONT_13;
    [item addSubview:titleLabel];
    [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImage.mas_right).offset(SCALES(8));
        make.centerX.equalTo(item);
     }];
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = STRING(content);
    contentLabel.textColor = TITLE_COLOR;
    contentLabel.font = TEXT_FONT_14;
    contentLabel.adjustsFontSizeToFitWidth = YES;
    contentLabel.minimumScaleFactor = 0.5;
    [item addSubview:contentLabel];
    [contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(item.mas_left).offset(SCALES(68));
        make.centerX.equalTo(item);
        make.right.equalTo(item);
     }];
    return item;
}
@end
