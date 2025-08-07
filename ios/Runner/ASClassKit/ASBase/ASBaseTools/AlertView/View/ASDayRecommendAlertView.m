//
//  ASDayRecommendAlertView.m
//  AS
//
//  Created by SA on 2025/4/18.
//

#import "ASDayRecommendAlertView.h"
#import "CustomButton.h"

@interface ASDayRecommendAlertView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, strong) UIButton* selectBtn;
@property (nonatomic, copy) NSString *zhaohuyu;//招呼语
@property (nonatomic, strong) ASRecommendUserListModel *model;
@property (nonatomic, strong) UIView *userBgView;//今日缘分推荐用户的背景
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UIButton *dazhaohuBtn;
@property (nonatomic, strong) NSMutableArray *userIds;
@end

@implementation ASDayRecommendAlertView

- (instancetype)initDayRecommendViewWithModel:(ASRecommendUserListModel *)model {
    if (self = [super init]) {
        self.model = model;
        self.backgroundColor = [UIColor clearColor];
        self.size = CGSizeMake(SCALES(327), SCALES(480));
        kWeakSelf(self);
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"recommend_pop"];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [bgView addSubview:self.userBgView];
        [self.userBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(78));
            make.left.right.equalTo(bgView);
            make.height.mas_equalTo(SCALES(220));
        }];
        //数据列表
        [self setItemUI];
        //换一批
        [bgView addSubview:self.changeBtn];
        [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView);
            make.height.mas_equalTo(SCALES(30));
            make.width.mas_equalTo(SCALES(200));
            make.top.equalTo(self.userBgView.mas_bottom);
        }];
        NSString *freeBeckonTimesText = [NSString stringWithFormat:@"%zd次", model.freeBeckonTimes];
        UILabel *hintLabel = [[UILabel alloc] init];
        hintLabel.textColor = TITLE_COLOR;
        hintLabel.font = TEXT_FONT_14;
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今日还剩%zd次免费搭讪", model.freeBeckonTimes]];
        [attributed addAttribute:NSForegroundColorAttributeName
                                value:MAIN_COLOR
                                range:NSMakeRange(4, freeBeckonTimesText.length)];
        [hintLabel setAttributedText:attributed];
        [bgView addSubview:hintLabel];
        [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView);
            make.height.mas_equalTo(SCALES(44));
            make.bottom.equalTo(bgView.mas_bottom);
        }];
        //打招呼
        self.dazhaohuBtn = ({
            UIButton *button = [[UIButton alloc] init];
            button.titleLabel.font = TEXT_FONT_18;
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = SCALES(24);
            [button setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
            button.adjustsImageWhenHighlighted = NO;
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (wself.userIds.count == 0) {
                    kShowToast(@"请选择搭讪用户");
                    return;
                }
                NSString *users = [wself.userIds componentsJoinedByString:@","];
                [ASCommonRequest requestRecommendBeckonWithUserIds:users zhaohuyu:wself.zhaohuyu success:^(id  _Nullable data) {
                    kShowToast(@"搭讪成功");
                    if (wself.cancelBlock) {
                        wself.cancelBlock();
                        [wself removeView];
                    }
                } errorBack:^(NSInteger code, NSString *msg) {
                    
                }];
            }];
            [bgView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(bgView.mas_bottom).offset(SCALES(-44));
                make.centerX.equalTo(bgView);
                make.width.mas_equalTo(SCALES(278));
                make.height.mas_equalTo(SCALES(48));
            }];
            button;
        });
        //选择招呼语
        self.selectBtn = ({
            UIButton *button = [[UIButton alloc] init];
            button.titleLabel.font = TEXT_FONT_18;
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = SCALES(24);
            button.layer.borderWidth = SCALES(1);
            button.layer.borderColor = MAIN_COLOR.CGColor;
            [button setTitle:@"选择招呼语" forState:UIControlStateNormal];
            [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, SCALES(14), 0, SCALES(42));
            button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;//省略...显示在最后
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                [wself requestRecommendRand];
            }];
            [bgView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.dazhaohuBtn.mas_top).offset(SCALES(-8));
                make.centerX.width.height.equalTo(self.dazhaohuBtn);
            }];
            button;
        });
        UIImageView *upIcon = [[UIImageView alloc] init];
        upIcon.image = [UIImage imageNamed:@"recommend_more"];
        [self.selectBtn addSubview:upIcon];
        [upIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(SCALES(-14));
            make.height.width.mas_equalTo(SCALES(16));
            make.centerY.equalTo(self.selectBtn);
        }];
        [bgView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.width.equalTo(self.selectBtn);
            make.centerX.equalTo(bgView);
            make.height.mas_equalTo(SCALES(294));
        }];
        [self modelDataDispose];
    }
    return self;
}

- (void)setItemUI {
    kWeakSelf(self);
    [self.userIds removeAllObjects];
    [self.userBgView removeAllSubviews];
    CGFloat gap = SCALES(14);
    NSInteger cols = 3;
    CGFloat itemW = SCALES(75);
    CGFloat itemH = SCALES(110);
    for (int i = 0; i < self.model.list.count; i++) {
        if (i < 6) {
            NSInteger col = i/cols;
            NSInteger row = i%cols;
            UIButton *itemBg = [[UIButton alloc] init];
            itemBg.selected = YES;
            [self.userBgView addSubview:itemBg];
            itemBg.frame = CGRectMake(SCALES(37) + row*(itemW + gap), col * (itemH), itemW, itemH);
            ASRecommendUserModel *model = self.model.list[i];
            UIImageView *header = [[UIImageView alloc]init];
            header.frame = CGRectMake(0, 0, itemW, itemW);
            [header sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar]]];
            header.layer.cornerRadius = SCALES(8);
            header.layer.masksToBounds = YES;
            header.contentMode = UIViewContentModeScaleAspectFill;
            [itemBg addSubview:header];
            UILabel *nickName = [[UILabel alloc] init];
            nickName.textColor = TITLE_COLOR;
            nickName.font = TEXT_FONT_12;
            nickName.text = STRING(model.nickname);
            nickName.textAlignment = NSTextAlignmentCenter;
            [itemBg addSubview:nickName];
            nickName.frame = CGRectMake(0, itemW, itemW, SCALES(32));
            UIImageView *selectIcon = [[UIImageView alloc]init];
            selectIcon.image = [UIImage imageNamed:@"recommend_sel"];
            selectIcon.hidden = NO;
            [header addSubview:selectIcon];
            selectIcon.frame = CGRectMake(header.width - SCALES(15), 0, SCALES(15), SCALES(15));
            UIView *isOnlineView = [[UIView alloc] init];
            isOnlineView.backgroundColor = UIColorRGB(0x35D78F);
            isOnlineView.layer.cornerRadius = SCALES(4);
            isOnlineView.layer.masksToBounds = YES;
            isOnlineView.layer.borderWidth = SCALES(1);
            isOnlineView.layer.borderColor = UIColor.whiteColor.CGColor;
            isOnlineView.hidden = !model.isOnline;
            [header addSubview:isOnlineView];
            isOnlineView.frame = CGRectMake(header.width - SCALES(11), header.height - SCALES(11), SCALES(9), SCALES(9));
            [self.userIds addObject:model.user_id];
            [[itemBg rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                itemBg.selected = !itemBg.selected;
                if (itemBg.selected) {
                    selectIcon.image = [UIImage imageNamed:@"recommend_sel"];
                    [wself.userIds addObject:model.user_id];
                } else {
                    selectIcon.image = [UIImage imageNamed:@"recommend_sel1"];
                    [wself.userIds removeObject:model.user_id];
                }
            }];
        }
    }
}

- (void)modelDataDispose {
    if (self.model.is_beckon_free == 0) {//收费
        [self.dazhaohuBtn setTitle:@"一键搭讪" forState:UIControlStateNormal];
    } else {
        [self.dazhaohuBtn setTitle:@"免费搭讪" forState:UIControlStateNormal];
    }
    if (self.model.coin > 0) {//收费
        [self.changeBtn setTitle:[NSString stringWithFormat:@" 换一批(%zd金币一次)", self.model.coin] forState:UIControlStateNormal];
    } else {
        [self.changeBtn setTitle:@" 换一批" forState:UIControlStateNormal];
    }
}

- (void)removeView {
    [self removeFromSuperview];
}

- (void)requestRecommendRand { 
    kWeakSelf(self);
    [ASCommonRequest requestRecommendRandCommonWordSuccess:^(id  _Nullable data) {
        NSArray *list = data;
        if (list.count > 0) {
            if (list.count > 4) {//数据大于4个，截取最多显示4个
                wself.listArray = [list subarrayWithRange:NSMakeRange(0, 4)];
            } else {
                wself.listArray = list;
            }
            wself.tableView.hidden = NO;
            [wself.tableView reloadData];
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (NSMutableArray *)userIds {
    if (!_userIds) {
        _userIds = [[NSMutableArray alloc]init];
    }
    return _userIds;
}

- (UIView *)userBgView {
    if (!_userBgView) {
        _userBgView = [[UIView alloc]init];
        _userBgView.backgroundColor = UIColor.clearColor;
    }
    return _userBgView;
}

- (UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [[UIButton alloc]init];
        _changeBtn.titleLabel.font = TEXT_FONT_13;
        [_changeBtn setTitle:@" 换一批" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [_changeBtn setImage:[UIImage imageNamed:@"recommend_change"] forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_changeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASCommonRequest requestRecommendUserWithScene:1 isHUD:YES success:^(id _Nullable data) {
                ASRecommendUserListModel *model = data;
                wself.model = model;
                [wself setItemUI];
                [wself modelDataDispose];
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        }];
    }
    return _changeBtn;
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc]init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.hidden = YES;
        _tableView.layer.cornerRadius = SCALES(25);
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.borderWidth = SCALES(1.5);
        _tableView.layer.borderColor = MAIN_COLOR.CGColor;
        _tableView.backgroundColor = UIColorRGB(0xFFEEEE);
        _tableView.bounces = YES;
        kWeakSelf(self);
        UIView *footerView = [[UIView alloc] init];
        footerView.frame = CGRectMake(0, 0, SCALES(303), SCALES(97));
        footerView.backgroundColor = UIColorRGB(0xFFEAF6);
        _tableView.tableFooterView = footerView;
        CustomButton *change = [[CustomButton alloc] init];
        change.titleLabel.font = TEXT_MEDIUM(18);
        [change setTitle:@"换一换  " forState:UIControlStateNormal];
        [change setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [change setImage:[UIImage imageNamed:@"recommend_change1"] forState:UIControlStateNormal];
        [[change rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [wself requestRecommendRand];
        }];
        [footerView addSubview:change];
        [change mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(footerView);
            make.height.mas_equalTo(SCALES(48.5));
        }];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = UIColorRGB(0xFFBDE3);
        [footerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(change.mas_bottom);
            make.right.left.equalTo(footerView);
            make.height.mas_equalTo(SCALES(1));
        }];
        UIButton* selectBtn = [[UIButton alloc] init];
        selectBtn.titleLabel.font = TEXT_MEDIUM(18);
        [selectBtn setTitle:@"选择招呼语" forState:UIControlStateNormal];
        [selectBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [[selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            wself.tableView.hidden = YES;
        }];
        [footerView addSubview:selectBtn];
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.left.equalTo(footerView);
            make.height.mas_equalTo(SCALES(48.5));
        }];
        UIImageView *upIcon = [[UIImageView alloc] init];
        upIcon.image = [UIImage imageNamed:@"recommend_more1"];
        [selectBtn addSubview:upIcon];
        [upIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(SCALES(-14));
            make.height.width.mas_equalTo(SCALES(16));
            make.centerY.equalTo(selectBtn);
        }];
    }
    return _tableView;
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    ASDayRecommendZhaohuyuCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil){
        cell = [[ASDayRecommendZhaohuyuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.zhaohuyuText = self.listArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(49);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.hidden = YES;
    NSString *text = self.listArray[indexPath.row];
    self.zhaohuyu = text;
    [self.selectBtn setTitle:STRING(text) forState:UIControlStateNormal];
}
@end

@interface ASDayRecommendZhaohuyuCell()
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, strong) UIView *line;
@end

@implementation ASDayRecommendZhaohuyuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColorRGB(0xFFEEEE);
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.text];
    [self.contentView addSubview:self.line];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.text mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(SCALES(1));
    }];
}

- (void)setZhaohuyuText:(NSString *)zhaohuyuText {
    _zhaohuyuText = zhaohuyuText;
    self.text.text = STRING(zhaohuyuText);
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = UIColorRGB(0xFFD9E2);
    }
    return _line;
}

- (UILabel *)text {
    if (!_text) {
        _text = [[UILabel alloc] init];
        _text.textColor = UIColorRGB(0xFF4545);
        _text.font = TEXT_FONT_16;
        _text.text = @"";
        _text.textAlignment = NSTextAlignmentCenter;
    }
    return _text;
}

@end

