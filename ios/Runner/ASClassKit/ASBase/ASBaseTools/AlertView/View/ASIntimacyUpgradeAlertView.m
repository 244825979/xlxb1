//
//  ASIntimacyUpgradeAlertView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASIntimacyUpgradeAlertView.h"

@implementation ASIntimacyUpgradeAlertView

//构造方法 亲密度升级弹窗
- (instancetype)initIntimacyUpgradeWithModel:(ASIMSystemNotifyModel *)model {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor clearColor];
        UIImageView *bgImage = [[UIImageView alloc] init];
        bgImage.image = [UIImage imageNamed:@"qinmidu_shenji_bg"];
        bgImage.userInteractionEnabled = YES;
        [self addSubview:bgImage];
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(SCALES(234));
            make.left.right.top.equalTo(self);
        }];
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = UIColor.whiteColor;
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(SCALES(150));
            make.left.right.bottom.equalTo(self);
        }];
        UIImageView *leftHeader = [[UIImageView alloc] init];
        [leftHeader sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, STRING(model.data.avatar)]]];
        leftHeader.layer.cornerRadius = SCALES(32);
        leftHeader.layer.masksToBounds = YES;
        leftHeader.layer.borderWidth = SCALES(1);
        leftHeader.layer.borderColor = UIColor.whiteColor.CGColor;
        leftHeader.contentMode = UIViewContentModeScaleAspectFill;
        [bgImage addSubview:leftHeader];
        [leftHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(4));
            make.left.mas_equalTo(SCALES(56));
            make.height.width.mas_equalTo(SCALES(64));
        }];
        UIImageView *rightHeader = [[UIImageView alloc] init];
        [rightHeader sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, STRING(model.data.to_avatar)]]];
        rightHeader.layer.cornerRadius = SCALES(32);
        rightHeader.layer.masksToBounds = YES;
        rightHeader.layer.borderWidth = SCALES(1);
        rightHeader.layer.borderColor = UIColor.whiteColor.CGColor;
        rightHeader.contentMode = UIViewContentModeScaleAspectFill;
        [bgImage addSubview:rightHeader];
        [rightHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(4));
            make.height.width.equalTo(leftHeader);
            make.right.offset(SCALES(-54));
        }];
        UILabel *title = [[UILabel alloc]init];
        title.font = TEXT_MEDIUM(20);
        title.text = @"恭喜您";
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = TITLE_COLOR;
        [bgImage addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(86));
            make.centerX.equalTo(bgImage);
            make.height.mas_equalTo(SCALES(28));
        }];
        CGFloat contentHeight = [ASCommonFunc getSizeWithText:STRING(model.data.des) maxLayoutWidth:SCALES(270) lineSpacing:SCALES(4.0) font:TEXT_FONT_14];
        UILabel *content = [[UILabel alloc] init];
        content.font = TEXT_FONT_14;
        content.attributedText = [ASCommonFunc attributedWithString:STRING(model.data.des) lineSpacing:SCALES(4.0)];
        content.textAlignment = NSTextAlignmentCenter;
        content.numberOfLines = 0;
        content.textColor = TITLE_COLOR;
        [bgImage addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(SCALES(20));
            make.centerX.equalTo(title);
            make.width.mas_equalTo(SCALES(270));
        }];
        UILabel *hintLabel = [[UILabel alloc]init];
        hintLabel.font = TEXT_FONT_14;
        hintLabel.text = STRING(model.data.msg2);
        hintLabel.textColor = MAIN_COLOR;
        [bgImage addSubview:hintLabel];
        [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(content.mas_bottom).offset(SCALES(8));
            make.centerX.equalTo(bgImage);
            make.height.mas_equalTo(SCALES(24));
        }];
        UIImageView *lvIcon = [[UIImageView alloc]init];
        lvIcon.contentMode = UIViewContentModeScaleAspectFit;
        [lvIcon sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, STRING(model.data.grade_img)]]];
        [bgImage addSubview:lvIcon];
        [lvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(hintLabel.mas_bottom).offset(SCALES(12));
            make.centerX.equalTo(bgImage);
            make.size.mas_equalTo(CGSizeMake(SCALES(38), SCALES(29)));
        }];
        UILabel *lvText1 = [[UILabel alloc]init];
        lvText1.font = TEXT_FONT_14;
        lvText1.text = @"获得";
        lvText1.textColor = TITLE_COLOR;
        [lvIcon addSubview:lvText1];
        [lvText1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lvIcon.mas_left).offset(SCALES(-4));
            make.centerY.equalTo(lvIcon);
        }];
        UILabel *lvText2 = [[UILabel alloc]init];
        lvText2.font = TEXT_FONT_14;
        lvText2.text = @"徽章";
        lvText2.textColor = TITLE_COLOR;
        [lvIcon addSubview:lvText2];
        [lvText2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lvIcon.mas_right).offset(SCALES(4));
            make.centerY.equalTo(lvIcon);
        }];
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirm setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        confirm.adjustsImageWhenHighlighted = NO;
        confirm.layer.cornerRadius = SCALES(25);
        confirm.layer.masksToBounds = YES;
        [confirm setTitle:@"我知道了" forState:UIControlStateNormal];
        confirm.titleLabel.font = TEXT_FONT_18;
        [bgImage addSubview:confirm];
        [[confirm rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.affirmBlock) {
                wself.affirmBlock();
            }
        }];
        [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lvIcon.mas_bottom).offset(SCALES(17));
            make.centerX.equalTo(bgImage);
            make.size.mas_equalTo(CGSizeMake(SCALES(227), SCALES(50)));
        }];
        self.size = CGSizeMake(SCALES(311), SCALES(294) + contentHeight);
    }
    return self;
}
@end
