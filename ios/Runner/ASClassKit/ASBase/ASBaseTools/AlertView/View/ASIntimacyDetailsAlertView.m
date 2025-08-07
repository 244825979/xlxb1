//
//  ASIntimacyDetailsPopView.m
//  AS
//
//  Created by SA on 2025/4/15.
//

#import "ASIntimacyDetailsAlertView.h"

@interface ASIntimacyDetailsAlertView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) NSArray *lists;
@end

@implementation ASIntimacyDetailsAlertView

- (instancetype)initIntimacyDetailsWithModel:(ASIMIntimateUserModel *)model {
    if (self = [super init]) {
        self.size = CGSizeMake(SCALES(327), SCALES(452));
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"chat_qingmidu_bg"];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        UIImageView *leftHeader = [[UIImageView alloc] init];
        [leftHeader sd_setImageWithURL:[NSURL URLWithString: STRING(model.current.woman_url)]];
        leftHeader.layer.cornerRadius = SCALES(32);
        leftHeader.layer.masksToBounds = YES;
        leftHeader.layer.borderWidth = SCALES(1);
        leftHeader.layer.borderColor = UIColor.whiteColor.CGColor;
        leftHeader.contentMode = UIViewContentModeScaleAspectFill;
        [bgView addSubview:leftHeader];
        [leftHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(4));
            make.left.mas_equalTo(SCALES(63));
            make.height.width.mas_equalTo(SCALES(64));
        }];
        UIImageView *rightHeader = [[UIImageView alloc] init];
        [rightHeader sd_setImageWithURL:[NSURL URLWithString: STRING(model.current.man_url)]];
        rightHeader.layer.cornerRadius = SCALES(32);
        rightHeader.layer.masksToBounds = YES;
        rightHeader.layer.borderWidth = SCALES(1);
        rightHeader.layer.borderColor = UIColor.whiteColor.CGColor;
        rightHeader.contentMode = UIViewContentModeScaleAspectFill;
        [bgView addSubview:rightHeader];
        [rightHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(4));
            make.height.width.equalTo(leftHeader);
            make.right.offset(SCALES(-63));
        }];
        UIButton *strategyBtn = [[UIButton alloc]init];
        [strategyBtn setBackgroundImage:[UIImage imageNamed:@"qinmidu_strategy"] forState:UIControlStateNormal];
        strategyBtn.adjustsImageWhenHighlighted = NO;
        [[strategyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASAlertViewManager defaultPopTitle:@"亲密值升级攻略" content:@"1、在你们私信聊天当中，每产生消耗金币的行为即可增加亲密度（消息、私聊送礼、音视频通话都包括在内）；\n2、1亲密度=10金币，不同等级可解锁不同特权奖励；\n3、奖励最终解释权归平台所有。" left:@"确认" right:@"" affirmAction:^{
                
            } cancelAction:^{
                
            }];
        }];
        [bgView addSubview:strategyBtn];
        [strategyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(46));
            make.right.offset(SCALES(-12));
            make.height.width.mas_equalTo(SCALES(20));
        }];
        UILabel *intimacyText = [[UILabel alloc]init];
        intimacyText.font = [UIFont systemFontOfSize:36];
        intimacyText.textColor = TITLE_COLOR;
        [bgView addSubview:intimacyText];
        [intimacyText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(84));
            make.centerX.equalTo(bgView);
            make.height.mas_equalTo(SCALES(34));
        }];
        NSString *scoreStr = [NSString stringWithFormat:@"亲密度%@℃",model.current.score];
        NSMutableAttributedString *scoreAtt = [[NSMutableAttributedString alloc] initWithString:scoreStr];
        [scoreAtt addAttribute:NSFontAttributeName
                          value:TEXT_FONT_18
                          range:NSMakeRange(0, 3)];
        [scoreAtt addAttribute:NSFontAttributeName
                          value:TEXT_FONT_18
                          range:NSMakeRange(scoreStr.length - 1, 1)];
        [intimacyText setAttributedText:scoreAtt];
        UILabel *upgradeHint = [[UILabel alloc]init];
        upgradeHint.font = TEXT_FONT_14;
        upgradeHint.textColor = UIColor.whiteColor;
        upgradeHint.text = [NSString stringWithFormat:@"    %@    ",model.current.des];
        upgradeHint.backgroundColor = MAIN_COLOR;
        upgradeHint.layer.cornerRadius = SCALES(12);
        upgradeHint.layer.masksToBounds = YES;
        [bgView addSubview:upgradeHint];
        [upgradeHint mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(intimacyText.mas_bottom).offset(SCALES(14));
            make.centerX.equalTo(bgView);
            make.height.mas_equalTo(SCALES(24));
        }];
        [self addSubview:self.tableView];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(upgradeHint.mas_bottom).offset(SCALES(16));
            make.left.mas_equalTo(SCALES(14));
            make.right.offset(SCALES(-14));
            make.bottom.equalTo(self);
        }];
        self.lists = model.list;
        [self.tableView reloadData];
    }
    return self;
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    ASIntimacyPopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASIntimacyPopViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.model = self.lists[indexPath.row];
    cell.lvTitle.text = [NSString stringWithFormat:@"LV.%zd",indexPath.row+1];
    cell.backgroundColor = UIColor.clearColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASIntimateUserListModel *model = self.lists[indexPath.row];
    return model.cellHeight;
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
@end

@interface ASIntimacyPopViewCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *lvIcon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@end

@implementation ASIntimacyPopViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.clearColor;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.lvIcon];
    [self.bgView addSubview:self.lvTitle];
    [self.bgView addSubview:self.title];
    [self.bgView addSubview:self.content];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.bottom.offset(SCALES(-8));
    }];
    
    [self.lvIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(6));
        make.centerY.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(SCALES(38), SCALES(29)));
    }];
    
    [self.lvTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lvIcon.mas_right).offset(SCALES(4));
        make.centerY.equalTo(self.lvIcon);
    }];
    
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(94));
        make.top.mas_equalTo(SCALES(10));
        make.height.mas_equalTo(SCALES(16));
        make.width.mas_equalTo(SCALES(194));
    }];

    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.title);
        make.top.equalTo(self.title.mas_bottom).offset(SCALES(8));
    }];
}

- (void)setModel:(ASIntimateUserListModel *)model {
    _model = model;
    [self.lvIcon sd_setImageWithURL:[NSURL URLWithString: STRING(model.icon_url)]];
    self.title.text = STRING(model.title);
    self.content.attributedText = [ASCommonFunc attributedWithString:STRING(model.des) lineSpacing:SCALES(3)];;
    self.content.numberOfLines = 2;
    if (model.unlock == 1) {
        self.title.textColor = MAIN_COLOR;
        self.content.textColor = TITLE_COLOR;
        self.lvTitle.textColor = MAIN_COLOR;
    } else {
        self.title.textColor = UIColorRGB(0xCECECE);
        self.content.textColor = UIColorRGB(0xCECECE);
        self.lvTitle.textColor = UIColorRGB(0xCECECE);
    }
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UIImageView *)lvIcon {
    if (!_lvIcon) {
        _lvIcon = [[UIImageView alloc]init];
        _lvIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _lvIcon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = TEXT_FONT_14;
        _title.textColor = MAIN_COLOR;
        _title.text = @"亲密度达到0.0℃";
    }
    return _title;
}

- (UILabel *)lvTitle {
    if (!_lvTitle) {
        _lvTitle = [[UILabel alloc]init];
        _lvTitle.font = TEXT_FONT_18;
        _lvTitle.textColor = MAIN_COLOR;
        _lvTitle.text = @"LV.1";
    }
    return _lvTitle;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.font = TEXT_FONT_12;
        _content.textColor = TITLE_COLOR;
        _content.text = @"";
    }
    return _content;
}
@end
