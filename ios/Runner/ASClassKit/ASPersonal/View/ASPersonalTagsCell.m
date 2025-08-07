//
//  ASPersonalTagsCell.m
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASPersonalTagsCell.h"

@interface ASPersonalTagsCell ()
@property (nonatomic,strong) UIView *tagsBgView;
@end

@implementation ASPersonalTagsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.tagsBgView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.tagsBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.mas_equalTo(SCALES(16));
        make.bottom.equalTo(self);
        make.right.equalTo(self).offset(SCALES(-16));
    }];
}

- (void)setModel:(ASUserInfoModel *)model {
    _model = model;
    if (model.label.count > 0) {
        NSInteger currentRight = 0;
        NSInteger currentBotton = 0;
        CGFloat bgheight = 0.0;
        for (int i = 0; i < model.label.count; i++) {
            ASTagsModel *nameModel = model.label[i];
            UILabel *label = [[UILabel alloc] init];
            label.frame =CGRectMake(currentRight, currentBotton + SCALES(4), SCALES(50), SCALES(32));
            CGSize size = [nameModel.name boundingRectWithSize:CGSizeMake(self.tagsBgView.width, 30000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:TEXT_FONT_15}
                                                       context:nil].size;
            currentRight = currentRight + size.width + SCALES(48);
            if (i < model.label.count -1) {
                ASTagsModel *nameStr = model.label[i + 1];
                CGSize size = [nameStr.name boundingRectWithSize:CGSizeMake(self.tagsBgView.width, 30000)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:TEXT_FONT_15}
                                                         context:nil].size;

                if (currentRight + size.width > SCREEN_WIDTH - SCALES(60)) {
                    currentRight = 0;
                    currentBotton = currentBotton + SCALES(48);
                }
            }
            CGRect frame = CGRectMake(label.frame.origin.x,
                                      label.frame.origin.y,
                                      size.width + SCALES(36),
                                      SCALES(32));
            label.frame = frame;
            label.text = nameModel.name;
            label.font = TEXT_FONT_15;
            label.textColor = TITLE_COLOR;
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = SCALES(16);
            label.layer.masksToBounds = YES;
            label.layer.borderColor = UIColorRGB(0xF5F5F5).CGColor;
            label.layer.borderWidth = SCALES(1);
            label.backgroundColor = UIColorRGB(0xF5F5F5);
            [self.tagsBgView addSubview:label];
            bgheight = currentBotton + SCALES(45);
        }
        model.labelsHeight = bgheight;
    }
}

- (UIView *)tagsBgView {
    if (!_tagsBgView) {
        _tagsBgView = [[UIView alloc]init];
    }
    return _tagsBgView;
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
