//
//  ASIMChatSetController.m
//  AS
//
//  Created by SA on 2025/5/15.
//

#import "ASIMChatSetController.h"
#import "ASIMRequest.h"
#import "ASIMChatSetModel.h"
#import "ASSetRequest.h"
#import "ASIMChatSetHeadView.h"
#import "ASReportController.h"

@interface ASIMChatSetController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) ASIMChatSetHeadView *headView;
/**数据**/
@property (nonatomic, strong) NSMutableArray<NSArray *> *lists;
@property (nonatomic, assign) BOOL isBlack;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL isHiddenVisit;
@property (nonatomic, copy) NSString *userRemarkStr;
@end

@implementation ASIMChatSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"好友设置";
    [self createUI];
    [self requestData];
}

- (void)createUI {
    NIMSession *session = [NIMSession session:self.userID type:NIMSessionTypeP2P];
    NIMStickTopSessionInfo *info = [NIMSDK.sharedSDK.chatExtendManager stickTopInfoForSession:session];
    if (info) {
        self.isTop = YES;
    } else {
        self.isTop = NO;
    }
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self.tableView registerClass:[ASBaseCommonCell class] forCellReuseIdentifier:@"baseCommonCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.lists addObject:@[[self setRemark], [self topChat]]];
    [self.lists addObject:@[[self addBlacklist], [self report]]];
    if (kAppType == 1) {
        [self.lists addObject:@[[self emptyRecord]]];
    } else {
        [self.lists addObject:@[[self emptyRecord], [self openHiding]]];
    }
    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(74));
    self.tableView.tableHeaderView = self.headView;
}

- (void)requestData {
    kWeakSelf(self);
    [ASIMRequest requestChatSetWithUserID:self.userID success:^(ASIMChatSetModel *  _Nullable data) {
        wself.headView.model = data;
        wself.isBlack = data.is_black;
        wself.userRemarkStr = data.info.remark_name;
        wself.isHiddenVisit = data.is_hidden_visit;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        ASBaseCommonCell *cell = [wself.tableView cellForRowAtIndexPath:indexPath];
        [cell.setSwitch setOn: wself.isBlack];
        
        NSIndexPath *userRemarkIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        ASBaseCommonCell *userRemarkCell = [wself.tableView cellForRowAtIndexPath:userRemarkIndexPath];
        userRemarkCell.rightLabel.text = wself.userRemarkStr;
        
        NSIndexPath *hiddenVisitIndexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        ASBaseCommonCell *hiddenVisitCell = [wself.tableView cellForRowAtIndexPath:hiddenVisitIndexPath];
        [hiddenVisitCell.setSwitch setOn: wself.isHiddenVisit];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (ASSetCellModel *)setRemark {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellText;
    model.leftTitle = @"设置备注";
    model.rightText = self.userRemarkStr;
    return model;
}

- (ASSetCellModel *)topChat {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellSwitch;
    model.leftTitle = @"置顶聊天";
    model.isSwitch = self.isTop;
    kWeakSelf(self);
    model.valueDidBlock = ^(UISwitch *switchs) {
        NIMSession *session = [NIMSession session:wself.userID type:NIMSessionTypeP2P];
        if (wself.isTop == NO) {//进行置顶
            NIMAddStickTopSessionParams *params = [[NIMAddStickTopSessionParams alloc] initWithSession:session];
            [NIMSDK.sharedSDK.chatExtendManager addStickTopSession:params completion:^(NSError * _Nullable error, NIMStickTopSessionInfo * _Nullable newInfo) {
                if (error) {
                  return;
                }
                wself.isTop = YES;
                [switchs setOn:wself.isTop];
            }];
        } else {
            NIMStickTopSessionInfo *info = [[NIMStickTopSessionInfo alloc] init];
            info.session = session;
            [NIMSDK.sharedSDK.chatExtendManager removeStickTopSession:info completion:^(NSError * _Nullable error, NIMStickTopSessionInfo * _Nullable removedInfo) {
                if (error) {
                  return;
                }
                wself.isTop = NO;
                [switchs setOn:wself.isTop];
            }];
        }
    };
    return model;
}

- (ASSetCellModel *)addBlacklist {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellSwitch;
    model.leftTitle = @"加入黑名单";
    model.isSwitch = self.isBlack;
    kWeakSelf(self);
    model.valueDidBlock = ^(UISwitch *switchs) {
        [ASSetRequest requestSetBlackWithBlackID:wself.userID success:^(id  _Nullable data) {
            NSNumber *status = data;
            if (status.integerValue == 1) {
                wself.isBlack = YES;
                kShowToast(@"成功加入黑名单");
                [switchs setOn:YES];
            } else {//取消拉黑成功
                wself.isBlack = NO;
                kShowToast(@"取消拉黑");
                [switchs setOn:NO];
            }
        } errorBack:^(NSInteger code, NSString *msg) {
            [switchs setOn:!switchs.on];
        }];
    };
    return model;
}

- (ASSetCellModel *)report {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = @"举报";
    return model;
}

- (ASSetCellModel *)emptyRecord {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = @"清空聊天记录";
    return model;
}

- (ASSetCellModel *)openHiding {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellSwitch;
    model.leftTitle = @"隐身访问";
    model.titleRearImage = @"im_set_vip";
    kWeakSelf(self);
    model.valueDidBlock = ^(UISwitch *switchs) {
        if (USER_INFO.vip == 0) {
            [switchs setOn:!switchs.on];
            [ASMyAppCommonFunc openHidingClikedVipAction:^{ }];
            return;
        }
        [ASIMRequest requestSetHideVisitWithUserID:wself.userID isSet:!wself.isHiddenVisit success:^(id  _Nullable data) {
            wself.isHiddenVisit = !wself.isHiddenVisit;
            [switchs setOn:switchs.on];
            kShowToast(@"设置成功");
        } errorBack:^(NSInteger code, NSString *msg) {
            [switchs setOn:!switchs.on];
        }];
    };
    return model;
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.lists.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASSetCellModel *model = self.lists[indexPath.section][indexPath.row];
    id cell = [tableView dequeueReusableCellWithIdentifier:model.cellIndentify forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    kWeakSelf(self);
    ASSetCellModel *model = self.lists[indexPath.section][indexPath.row];
    if ([model.leftTitle isEqualToString:@"设置备注"]) {
        [ASAlertViewManager popTextFieldWithTitle:@"设置备注名"
                                          content:kStringIsEmpty(self.headView.model.info.remark_name) ? self.headView.model.info.nickname : self.headView.model.info.remark_name
                                      placeholder:@"请输入备注名..."
                                           length:12
                                       affirmText:@"确认"
                                           remark:@""
                                         isNumber:NO
                                          isEmpty:YES
                                     affirmAction:^(NSString * _Nonnull text) {
            [ASSetRequest requestChangeUserRemarkWithName:text userID:self.userID success:^(id  _Nullable data) {
                wself.headView.model.info.remark_name = text;
                wself.userRemarkStr = text;
                NSIndexPath *userRemarkIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                ASBaseCommonCell *userRemarkCell = [wself.tableView cellForRowAtIndexPath:userRemarkIndexPath];
                userRemarkCell.rightLabel.text = wself.userRemarkStr;
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        } cancelAction:^{
            
        }];
        return;
    }
    
    if ([model.leftTitle isEqualToString:@"举报"]) {
        ASReportController *vc = [[ASReportController alloc] init];
        vc.uid = self.userID;
        vc.type = kReportTypePersonalHome;
        ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    if ([model.leftTitle isEqualToString:@"清空聊天记录"]) {
        [ASAlertViewManager defaultPopTitle:@"确认删除" content:@"删除后无法恢复，确定删除聊天记录吗？" left:@"确定" right:@"取消" affirmAction:^{
            NIMSession *session = [NIMSession session:wself.userID type:NIMSessionTypeP2P];
            NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc]init];
            option.removeSession = NO;
            option.removeTable = YES;
            [[[NIMSDK sharedSDK] conversationManager] deleteAllmessagesInSession:session option:option];
            NIMClearMessagesOption *cloudOption = [[NIMClearMessagesOption alloc]init];
            [[[NIMSDK sharedSDK] conversationManager] deleteSelfRemoteSession:session option:cloudOption completion:^(NSError * _Nullable error) {
                if (!error) {
                    kShowToast(@"删除成功");
                    if (wself.delBlock) {
                        wself.delBlock();
                    }
                }
            }];
        } cancelAction:^{
            
        }];
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(50);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BACKGROUNDCOLOR;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCALES(10);
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (NSMutableArray *)lists {
    if (!_lists) {
        _lists = [[NSMutableArray alloc]init];
    }
    return _lists;
}

- (ASIMChatSetHeadView *)headView {
    if (!_headView) {
        _headView = [[ASIMChatSetHeadView alloc]init];
        _headView.backgroundColor = UIColor.whiteColor;
    }
    return _headView;
}
@end
