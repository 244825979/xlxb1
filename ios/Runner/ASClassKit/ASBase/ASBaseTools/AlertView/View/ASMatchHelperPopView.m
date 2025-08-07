//
//  ASMatchHelperPopView.m
//  AS
//
//  Created by SA on 2025/7/4.
//

#import "ASMatchHelperPopView.h"
#import <NEChatUIKit/NEChatUIKit-Swift.h>
#import <NIMSDK/NIMSDK.h>
#import "ASIMRequest.h"
#import "ASGreetTpListModel.h"
#import "ASConvenienceLanListController.h"
#import "ASSendImBatchListModel.h"
#import "心聊想伴-Swift.h"

@interface ASMatchHelperPopView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIButton *oneClickLoginBtn;//一键回复
@property (nonatomic, strong) ASBaseTableView *tableView;
/**数据**/
@property (nonatomic, strong) NSArray *lists;
@property (nonatomic, strong) NSMutableArray *userIDs;//选中的用户ID
@property (nonatomic, assign) NSInteger sendMessageCount;//需要发送的消息条数
@end

@implementation ASMatchHelperPopView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.icon];
        [self addSubview:self.title];
        [self addSubview:self.tableView];
        [self addSubview:self.oneClickLoginBtn];
        self.backgroundColor = UIColor.whiteColor;
        self.size = CGSizeMake(SCREEN_WIDTH, SCALES(430) + TAB_BAR_MAGIN);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(SCALES(16), SCALES(16))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        //来消息通知更新匹配数量
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"refreshListLittleHelperNotify" object:nil];
    }
    return self;
}

- (void)refreshList:(NSNotification *)notification {
    [self refreshList];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(14));
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(153), SCALES(30)));
    }];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(SCALES(7));
        make.centerX.equalTo(self);
        make.height.mas_equalTo(SCALES(16));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(80));
        make.left.right.equalTo(self);
    }];
    [self.oneClickLoginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(SCALES(6));
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALES(319), SCALES(50)));
        make.bottom.equalTo(self).offset(-TAB_BAR_MAGIN - SCALES(6));
    }];
}

- (void)setModel:(ASFateHelperStatusModel *)model {
    _model = model;
    self.title.text = STRING(model.helperTitle);
    [self refreshList];
}

//列表数据刷新
- (void)refreshList {
    if ([ASIMHelperDataManager shared].helperList.count > 0) {
        self.oneClickLoginBtn.hidden = NO;
        self.lists = [ASIMHelperDataManager shared].helperList;
        for (NSString *userid in self.lists) {
            if (![self.userIDs containsObject:userid]) {
                [self.userIDs addObject:userid];
            }
        }
        if (self.userIDs.count > 0) {
            self.oneClickLoginBtn.userInteractionEnabled = YES;
            [self.oneClickLoginBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
            [self.oneClickLoginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        } else {
            self.oneClickLoginBtn.userInteractionEnabled = NO;
            [self.oneClickLoginBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
            [self.oneClickLoginBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
    } else {
        self.oneClickLoginBtn.hidden = YES;
    }
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.image = [UIImage imageNamed:@"zhushou_top"];
    }
    return _icon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.textColor = TITLE_COLOR;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = TEXT_FONT_12;
    }
    return _title;
}

- (UIButton *)oneClickLoginBtn {
    if (!_oneClickLoginBtn) {
        _oneClickLoginBtn = [[UIButton alloc]init];
        [_oneClickLoginBtn setTitle:@"一键回复" forState:UIControlStateNormal];
        _oneClickLoginBtn.titleLabel.font = TEXT_FONT_18;
        _oneClickLoginBtn.layer.cornerRadius = SCALES(25);
        _oneClickLoginBtn.layer.masksToBounds = YES;
        _oneClickLoginBtn.hidden = YES;
        [_oneClickLoginBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
        [_oneClickLoginBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        _oneClickLoginBtn.userInteractionEnabled = NO;
        _oneClickLoginBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_oneClickLoginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.userIDs.count == 0) {
                kShowToast(@"请至少选择一个用户");
                return;
            }
            [ASMsgTool showLoading];
            [ASIMRequest requestGreetTplListSuccess:^(id  _Nullable data) {
                NSArray *list = data;
                if (list.count == 0) {
                    [ASMsgTool hideMsg];
                    if (wself.cancelBlock) {
                        [wself removeView];
                        wself.cancelBlock();
                    }
                    [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"有通过审核的快捷用语才能使用一键回复" left:@"确认" right:@"取消" affirmAction:^{
                        ASConvenienceLanListController *vc = [[ASConvenienceLanListController alloc]init];
                        [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
                    } cancelAction:^{
                        
                    }];
                } else {
                    NSMutableArray *parameters = [NSMutableArray array];
                    NSMutableArray *messages = [NSMutableArray array];
                    for (NSString *userID in wself.userIDs) {
                        int r = arc4random() % list.count;//随机数
                        ASGreetTpListModel *greetTpListModel = list[r];
                        NSArray *bodys = greetTpListModel.body;
                        for (ASGreetTpBodyModel *bodyModel in bodys) {
                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                            dict[@"to_uid"] = STRING(userID);
                            dict[@"is_tid"] = @"1";//1表示是从匹配列表里的用户发的消息 0表示不是
                            dict[@"tid"] = STRING(greetTpListModel.ID);
                            if (bodyModel.type == 0) {//文本
                                NIMMessage *message = [[NIMMessage alloc] init];//构造出具体消息
                                message.setting = [MessageUtils messageSetting];
                                message.text = STRING(bodyModel.content);
                                dict[@"msgId"] = STRING(message.messageId);
                                dict[@"content"] = STRING(bodyModel.content);
                                dict[@"type"] = @"1";
                                [messages addObject:message];//把要发送的消息数据保存起来
                            }
                            if (bodyModel.type == 1) {//图片
                                NIMCustomObject *object = [[NIMCustomObject alloc] init];
                                IMCustomAttachment *attachment = [[IMCustomAttachment alloc] init];
                                attachment.type = 100;
                                attachment.data = @{@"url": [NSString stringWithFormat:@"%@%@", SERVER_IMAGE_URL, STRING(bodyModel.file)],
                                                    @"path": @"",
                                                    @"width": @(bodyModel.width),
                                                    @"height": @(bodyModel.height)};
                                object.attachment = attachment;
                                NIMMessage *message = [[NIMMessage alloc] init];
                                message.setting = [MessageUtils messageSetting];
                                message.text = @"【图片】";
                                message.messageObject = object;
                                dict[@"msgId"] = STRING(message.messageId);
                                dict[@"content"] = [NSString stringWithFormat:@"%@%@", SERVER_IMAGE_URL, STRING(bodyModel.file)];
                                dict[@"type"] = @"3";
                                [messages addObject:message];//把要发送的消息数据保存起来
                            }
                            if (bodyModel.type == 2) {//语音
                                NIMCustomObject *object = [[NIMCustomObject alloc] init];
                                IMCustomAttachment *attachment = [[IMCustomAttachment alloc] init];
                                attachment.type = 101;
                                attachment.data = @{@"url": [NSString stringWithFormat:@"%@%@", SERVER_IMAGE_URL, STRING(bodyModel.file)],
                                                    @"duration": @(bodyModel.len *1000),
                                                    @"path": @""};
                                object.attachment = attachment;
                                NIMMessage *message = [[NIMMessage alloc] init];
                                message.setting = [MessageUtils messageSetting];
                                message.text = @"【语音】";
                                message.messageObject = object;
                                dict[@"msgId"] = STRING(message.messageId);
                                dict[@"content"] = [NSString stringWithFormat:@"%@%@", SERVER_IMAGE_URL, STRING(bodyModel.file)];
                                dict[@"type"] = @"2";
                                [messages addObject:message];//把要发送的消息数据保存起来
                            }
                            //增加参数的数组
                            [parameters addObject:dict];
                        }
                    }
                    //一键回复接口请求
                    [ASIMRequest requestOneClickReplyWithParams:parameters success:^(id  _Nullable data) {
                        NSArray *list = data;
                        if (list.count == 0) {
                            [ASMsgTool hideMsg];
                            if (wself.refreshBlock) {
                                wself.refreshBlock();
                            }
                            return;
                        }
                        wself.sendMessageCount = list.count;
                        //遍历已经根据后台校验过，需要发送的消息数据
                        for (int i = 0; i < list.count; i++) {
                            ASSendImBatchListModel *batchModel = list[i];
                            NIMSession *session = [NIMSession session:STRING(batchModel.to_uid) type:NIMSessionTypeP2P];
                            //是否需要推送设置
                            NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
                            setting.apnsEnabled = batchModel.is_push; //是否进行推送
                            //遍历所有校验前消息数组匹配消息
                            for (NIMMessage *message in messages) {
                                if ([batchModel.msgId isEqualToString:message.messageId]) {
                                    NSDictionary *remoteExt = @{@"is_cut": @(batchModel.is_cut),
                                                                @"is_chat_card": @(batchModel.is_chat_card),
                                                                @"vip": @(batchModel.vip),
                                                                @"money": STRING(batchModel.money),
                                                                @"cut_coin": @(batchModel.cut_coin),
                                                                @"coin": @(batchModel.coin),
                                                                @"is_beckon_un": @(batchModel.is_beckon_un),
                                                                @"is_fold": @(batchModel.is_fold),
                                                                @"is_pop": @(batchModel.is_pop)
                                    };
                                    message.remoteExt = remoteExt;
                                    message.env = SERVER_IM_ENV;
                                    message.apnsPayload = [MessageUtils apnsPayloadWithSession:session myUserID:USER_INFO.user_id];
                                    message.setting = setting;
                                    //发送消息
                                    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session completion:^(NSError * _Nullable error) {
                                        if (error == nil) {
                                            //1、发送成功一条就移除一条保存本地的匹配列表数据
                                            if ([[ASIMHelperDataManager shared].helperList containsObject: session.sessionId]) {
                                                [[ASIMHelperDataManager shared].helperList removeObject:STRING(session.sessionId)];
                                            }
                                            //2、确保全部移除后，同步保存本地的小助手数据，关闭当前匹配小助手的弹窗
                                            if (i == list.count - 1) {
                                                //同步本地数据
                                                [ASUserDefaults setValue:[ASIMHelperDataManager shared].helperList forKey:[NSString stringWithFormat:@"userinfo_helper_list_%@",STRING(USER_INFO.user_id)]];
                                                //关闭弹窗
                                                [ASMsgTool hideMsg];
                                                if (wself.cancelBlock) {
                                                    wself.cancelBlock();
                                                }
                                                //同步更新一下悬浮窗显条数及加入到搭讪的数据逻辑
                                                if (wself.refreshBlock) {
                                                    wself.refreshBlock();
                                                }
                                            }
                                        }
                                    }];
                                    break;
                                }
                            }
                        }
                        [[RACScheduler mainThreadScheduler] afterDelay:30 schedule:^{//加1s延时执行，避免云信数据未返回查询不到列表数据情况
                            [ASMsgTool hideMsg];
                        }];
                    } errorBack:^(NSInteger code, NSString *msg) {
                        [ASMsgTool hideMsg];
                        if (wself.cancelBlock) {
                            [wself removeView];
                            wself.cancelBlock();
                        }
                    }];
                }
            } errorBack:^(NSInteger code, NSString *msg) {
                [ASMsgTool hideMsg];
                if (wself.cancelBlock) {
                    [wself removeView];
                    wself.cancelBlock();
                }
            }];
        }];
    }
    return _oneClickLoginBtn;
}

- (void)removeView {
    [self removeFromSuperview];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    ASMatchHelperListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASMatchHelperListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    NSString *userid = self.lists[indexPath.row];
    NIMSession *session = [NIMSession session:userid type:NIMSessionTypeP2P];
    cell.session = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
    cell.isSelect = [self.userIDs containsObject:userid];//包含说明选中了，未包含表示没有选中
    kWeakSelf(self);
    cell.selectBlock = ^(BOOL isSelect, NSString *userID) {
        if (isSelect) {
            [wself.userIDs addObject:STRING(userID)];
        } else {
            [wself.userIDs removeObject:STRING(userID)];
        }
        if (wself.userIDs.count > 0) {
            wself.oneClickLoginBtn.userInteractionEnabled = YES;
            [wself.oneClickLoginBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
            [wself.oneClickLoginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        } else {
            wself.oneClickLoginBtn.userInteractionEnabled = NO;
            [wself.oneClickLoginBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
            [wself.oneClickLoginBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(68);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    NSString *userid = self.lists[indexPath.row];
    kWeakSelf(self);
    [ASMyAppCommonFunc littleHelperChatWithUserID:userid nickName:@"" sendMsgBlock:^{
        if (wself.refreshBlock) {
            wself.refreshBlock();
        }
    }];
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.emptyType = kTableViewEmptyNoData;
        _tableView.verticalOffset = SCALES(40);
    }
    return _tableView;
}

- (NSMutableArray *)userIDs {
    if (!_userIDs) {
        _userIDs = [[NSMutableArray alloc]init];
    }
    return _userIDs;
}
@end

@interface ASMatchHelperListCell()
@property (nonatomic, strong) UIButton *selectBtn;//是否选中
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UIView *onLineState;//在线状态
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *time;
@end

@implementation ASMatchHelperListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.clearColor;
        self.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:self.selectBtn];
        [self.contentView addSubview:self.header];
        [self.header addSubview:self.onLineState];
        [self.contentView addSubview:self.nickName];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.time];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLineState:) name:@"userStatusNotification" object:nil];
    }
    return self;
}

- (void)refreshLineState:(NSNotification *)notification {
    NSArray<NIMSubscribeEvent *> *events = (NSArray<NIMSubscribeEvent *> *)notification.object;
    for (NIMSubscribeEvent *state in events) {
        if ([state.from isEqualToString:STRING(self.session.session.sessionId)]) {
            if (state.value == 1) {
                //检查是否在隐藏列表中
                if ([[ASUserDataManager shared].usesHiddenListModel.hiddenMeUsersID containsObject:STRING(self.session.session.sessionId)]) {
                    self.onLineState.hidden = YES;
                } else {
                    self.onLineState.hidden = NO;
                }
            } else {
                self.onLineState.hidden = YES;
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(8));
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(SCALES(32));
    }];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtn.mas_right).offset(SCALES(4));
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(SCALES(56));
    }];
    [self.onLineState mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.header);
        make.width.height.mas_equalTo(SCALES(10));
    }];
    [self.nickName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.header.mas_right).offset(SCALES(12));
        make.top.equalTo(self.header.mas_top).offset(SCALES(2));
        make.height.mas_equalTo(SCALES(24));
        make.right.equalTo(self.contentView.mas_right).offset(SCALES(-70));
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nickName);
        make.top.equalTo(self.nickName.mas_bottom).offset(SCALES(8));
        make.height.mas_equalTo(SCALES(18));
    }];
    [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(SCALES(-16));
        make.centerY.equalTo(self.nickName);
    }];
}

- (void)setSession:(NIMRecentSession *)session {
    _session = session;
    NIMMessage *lastMessage = session.lastMessage;
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:lastMessage.from];
    self.nickName.text = STRING(lastMessage.senderName);
    self.content.text = [ASMyAppCommonFunc lastMessgeHint:lastMessage];
    if (kStringIsEmpty(user.userInfo.avatarUrl)) {//本地地址为空，从服务器中获取
        [[NIMSDK sharedSDK].userManager fetchUserInfos:@[STRING(lastMessage.from)] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
            if (users.count > 0) {
                NIMUser *userInfo = users[0];
                [self.header setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, STRING(userInfo.userInfo.avatarUrl)]] placeholder:nil];
            }
        }];
    } else {
        [self.header setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, STRING(user.userInfo.avatarUrl)]] placeholder:nil];
    }
    self.time.text = [ASCommonFunc getTimeStrWithTimeInterval: lastMessage.timestamp];
    NSString *statusValue = [ASUserDefaults objectForKey:[NSString stringWithFormat:@"event_state_%@", STRING(session.session.sessionId)]];
    if (statusValue.integerValue == 1) {
        // 检查用户ID是否在隐藏列表中
        if ([[ASUserDataManager shared].usesHiddenListModel.hiddenMeUsersID containsObject:STRING(session.session.sessionId)]) {
            self.onLineState.hidden = YES;
        } else {
            self.onLineState.hidden = NO;
        }
    } else {
        self.onLineState.hidden = YES;
    }
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    self.selectBtn.selected = isSelect;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc]init];
        [_selectBtn setImage:[UIImage imageNamed:@"potocol1"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"potocol"] forState:UIControlStateSelected];
        _selectBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.selectBlock) {
                wself.selectBtn.selected = !wself.selectBtn.selected;
                wself.selectBlock(wself.selectBtn.selected, STRING(wself.session.session.sessionId));
            }
        }];
    }
    return _selectBtn;
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.contentMode = UIViewContentModeScaleAspectFill;
        _header.layer.cornerRadius = SCALES(8);
        _header.layer.masksToBounds = YES;
    }
    return _header;
}

- (UIView *)onLineState {
    if (!_onLineState) {
        _onLineState = [[UIView alloc] init];
        _onLineState.backgroundColor = UIColor.greenColor;
        _onLineState.layer.borderColor = UIColor.whiteColor.CGColor;
        _onLineState.layer.borderWidth = SCALES(1);
        _onLineState.layer.masksToBounds = YES;
        _onLineState.layer.cornerRadius = SCALES(5);
        _onLineState.hidden = YES;
    }
    return _onLineState;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc] init];
        _nickName.textColor = TITLE_COLOR;
        _nickName.font = TEXT_FONT_16;
        _nickName.text = @"昵称";
    }
    return _nickName;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = TEXT_SIMPLE_COLOR;
        _content.font = TEXT_FONT_14;
        _content.text = @"[新的匹配]";
    }
    return _content;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.textColor = TEXT_SIMPLE_COLOR;
        _time.font = TEXT_FONT_13;
        _time.text = @"01-01";
    }
    return _time;
}
@end
