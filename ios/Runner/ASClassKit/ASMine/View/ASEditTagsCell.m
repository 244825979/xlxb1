//
//  ASEditTagsCell.m
//  AS
//
//  Created by SA on 2025/4/21.
//

#import "ASEditTagsCell.h"

@interface ASEditTagsCell ()
@property (nonatomic,strong) UIImageView *backIcon;
@property (nonatomic,strong) UIView *tagsBgView;
@end

@implementation ASEditTagsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.backIcon];
    [self.contentView addSubview:self.tagsBgView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.top.mas_equalTo(SCALES(15));
        make.height.mas_greaterThanOrEqualTo(SCALES(20));
    }];
    
    [self.backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
        make.right.equalTo(self.contentView).offset(SCALES(-14));
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(SCALES(10));
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.backIcon.mas_left).offset(SCALES(-8));
    }];
    
    [self.tagsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(50));
        make.left.mas_equalTo(SCALES(14));
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(SCALES(-14));
    }];
}

- (void)setModel:(ASSetCellModel *)model {
    _model = model;
    self.titleLabel.text = STRING(model.leftTitle);
    if (!kObjectIsEmpty(model.rightTextColor)) {
        self.rightLabel.textColor = model.rightTextColor;
    } else {
        self.rightLabel.textColor = TEXT_SIMPLE_COLOR;
    }
    self.rightLabel.text = STRING(model.rightText);
    
    [self.tagsBgView removeAllSubviews];
    if (model.tags.count > 0) {
        //创建各个Button
        NSInteger currentRight = 0; // 记录当前Btn的right（右边）
        NSInteger currentBotton = 0; // 记录当前btn的bottom（底部）
        CGFloat bgheight = 0.0;
        for (int i = 0; i < model.tags.count; i++) {
            ASTagsModel *nameModel = model.tags[i];
            
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(currentRight, currentBotton + SCALES(4), SCALES(50), SCALES(28));
            // 计算字体长度
            CGSize size = [nameModel.name boundingRectWithSize:CGSizeMake(self.tagsBgView.width, 30000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:TEXT_FONT_15}
                                                       context:nil].size;
            
            currentRight = currentRight + size.width + SCALES(50);
            // 判断是否换行
            if (i < model.tags.count -1){
                ASTagsModel *nameStr = model.tags[i + 1];
                //计算字体长度
                CGSize size = [nameStr.name boundingRectWithSize:CGSizeMake(self.tagsBgView.width,30000)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:TEXT_FONT_15}
                                                         context:nil].size;
                
                if (currentRight + size.width > SCREEN_WIDTH - SCALES(60)) {
                    currentRight = 0;
                    currentBotton = currentBotton + SCALES(40);
                }
            }
            // 更新每个Btn的frame
            CGRect frame = CGRectMake(label.frame.origin.x,
                                      label.frame.origin.y,
                                      size.width + SCALES(36),
                                      SCALES(28));
            label.frame = frame;
            label.text = nameModel.name;
            label.font = TEXT_FONT_15;
            label.textColor = TITLE_COLOR;
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = SCALES(4);//4是圆角的弧度，根据需求自己更改
            label.layer.masksToBounds = YES;
            label.layer.borderColor = UIColorRGB(0xe4e4e4).CGColor;
            label.layer.borderWidth = SCALES(0.5);
            [self.tagsBgView addSubview:label];
            //更新cell整体高度
            bgheight = currentBotton + SCALES(45);
        }
        model.cellHeight = bgheight + SCALES(59);
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TITLE_COLOR;
        _titleLabel.font = TEXT_FONT_15;
    }
    return _titleLabel;
}

-(UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.font = TEXT_FONT_13;
        _rightLabel.textColor = TEXT_SIMPLE_COLOR;
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}

- (UIImageView *)backIcon {
    if (!_backIcon) {
        _backIcon = [[UIImageView alloc]init];
        _backIcon.image = [UIImage imageNamed:@"cell_back"];
    }
    return _backIcon;
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
