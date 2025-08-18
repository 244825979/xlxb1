//
//  ASSetHomeController.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASSetHomeController.h"
#import "ASSetBackListController.h"
#import "ASSetReportListController.h"
#import "ASSetNotifyController.h"
#import "ASSetPrivacyController.h"
#import "ASFaceUnitySetController.h"
#import "ASSetAboutController.h"
#import "ASSetCostController.h"
#import "ASSetTeenagerHomeController.h"
#import "ASSetBindViewController.h"
#import "ASSetRequest.h"

@interface ASSetHomeController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSArray *> *lists;
@end

@implementation ASSetHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"设置";
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)createUI {
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self.tableView registerClass:[ASBaseCommonCell class] forCellReuseIdentifier:@"baseCommonCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.lists addObject:@[[self blackList], [self reportList]]];
    if (kAppType == 0) {
        [self.lists addObject:@[[self messageNotification], [self privacySet]]];
    } else {
        [self.lists addObject:@[[self messageNotification]]];
    }
    if (USER_INFO.gender == 1) {
        if (kAppType == 0) {
            [self.lists addObject:@[[self accountBind],
                                    [self beautySet],
                                    [self collectFeeSet],
                                    [self adolescentType],
                                    [self clearCache],
                                    [self aboutUs]]];
        } else {
            [self.lists addObject:@[[self accountBind],
                                    [self beautySet],
                                    [self adolescentType],
                                    [self clearCache],
                                    [self aboutUs]]];
        }
    } else {
        [self.lists addObject:@[[self accountBind],
                                [self beautySet],
                                [self adolescentType],
                                [self clearCache],
                                [self aboutUs]]];
    }
#ifdef DEBUG
    [self.lists addObject:@[[self serverSet]]];
    [self.lists addObject:@[[self bundleID]]];
#else
    
#endif
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(49));
    footerView.backgroundColor = BACKGROUNDCOLOR;
    self.tableView.tableFooterView = footerView;
    UIButton *outLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    outLogin.backgroundColor = UIColor.whiteColor;
    outLogin.titleLabel.font = TEXT_MEDIUM(15);
    [outLogin setTitle:@"退出账号" forState:UIControlStateNormal];
    [outLogin setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [[outLogin rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [ASAlertViewManager defaultPopTitle:@"提示" content:@"您确定要退出当前账号吗？" left:@"确定" right:@"取消" isTouched:YES affirmAction:^{
            [ASLoginRequest requestOutLoginSuccess:^(id  _Nullable data) {
                
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        } cancelAction:^{
            
        }];
    }];
    [footerView addSubview:outLogin];
    [outLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerView);
    }];
}

- (void)requestData {
    kWeakSelf(self);
    if (USER_INFO.isLogin == NO) {
        return;
    }
    [ASSetRequest requestSetRedStatusSuccess:^(id _Nullable data) {
        NSNumber *redStatus = data[@"red_status"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        ASBaseCommonCell *cell = [wself.tableView cellForRowAtIndexPath:indexPath];
        if (redStatus.integerValue == 1) {
            wself.accountBind.isRed = YES;
            cell.redView.hidden = NO;
        } else {
            wself.accountBind.isRed = NO;
            cell.redView.hidden = YES;
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

#pragma mark - 数据源
- (ASSetCellModel *)blackList {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = @"黑名单";
    return model;
}

- (ASSetCellModel *)reportList {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = @"举报记录";
    return model;
}

- (ASSetCellModel *)messageNotification {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = @"消息通知";
    return model;
}

- (ASSetCellModel *)privacySet {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = @"隐私设置";
    return model;
}

- (ASSetCellModel *)accountBind {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellText;
    model.leftTitle = @"账号绑定";
    model.isRed = NO;
    return model;
}

- (ASSetCellModel *)beautySet {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = @"美颜设置";
    return model;
}

- (ASSetCellModel *)adolescentType {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = @"青少年模式";
    return model;
}

- (ASSetCellModel *)clearCache {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellText;
    model.rightText = [ASCommonFunc getCacheSize];
    model.leftTitle = @"清除缓存";
    return model;
}

- (ASSetCellModel *)serverSet {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellText;
    model.leftTitle = @"环境设置";
    model.rightText = STRING([ASConfigConst shared].server_name);
    return model;
}

- (ASSetCellModel *)bundleID {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellText;
    model.leftTitle = @"包名";
    model.rightText = kAppBundleID;
    return model;
}

- (ASSetCellModel *)aboutUs {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = [NSString stringWithFormat:@"关于%@",kAppName];
    return model;
}

- (ASSetCellModel *)collectFeeSet {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = @"收费设置";
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
    ASSetCellModel* model = self.lists[indexPath.section][indexPath.row];
    id cell = [tableView dequeueReusableCellWithIdentifier:model.cellIndentify forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    kWeakSelf(self);
    ASSetCellModel *model = self.lists[indexPath.section][indexPath.row];
    if ([model.leftTitle isEqualToString:@"黑名单"]) {
        ASSetBackListController *vc = [[ASSetBackListController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([model.leftTitle isEqualToString:@"举报记录"]) {
        ASSetReportListController *vc = [[ASSetReportListController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([model.leftTitle isEqualToString:@"消息通知"]) {
        ASSetNotifyController *vc = [[ASSetNotifyController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([model.leftTitle isEqualToString:@"隐私设置"]) {
        ASSetPrivacyController *vc = [[ASSetPrivacyController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([model.leftTitle isEqualToString:@"账号绑定"]) {
        ASSetBindViewController *vc = [[ASSetBindViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([model.leftTitle isEqualToString:@"美颜设置"]) {
        [ASMyAppCommonFunc verifyCameraPermissionBlock:^{
            ASFaceUnitySetController *vc = [[ASFaceUnitySetController alloc] init];
            [wself.navigationController pushViewController:vc animated:YES];
        }];
        return;
    }
    if ([model.leftTitle isEqualToString:@"收费设置"]) {
        [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthDefaultPop succeed:^{
            ASSetCostController *vc = [[ASSetCostController alloc] init];
            [wself.navigationController pushViewController:vc animated:YES];
        }];
        return;
    }
    if ([model.leftTitle isEqualToString:@"青少年模式"]) {
        ASSetTeenagerHomeController *vc = [[ASSetTeenagerHomeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([model.leftTitle isEqualToString:@"清除缓存"]) {
        [ASAlertViewManager defaultPopTitle:@"提示" content:@"是否删除心聊想伴数据？" left:@"确定" right:@"取消" isTouched:YES affirmAction:^{
            [ASCommonFunc clearAppCache];
            kShowToast(@"清除成功");
            ASBaseCommonCell *cell = [wself.tableView cellForRowAtIndexPath:indexPath];
            cell.rightLabel.text = @"0.00MB";
        } cancelAction:^{
            
        }];
        return;
    }
    if ([model.leftTitle isEqualToString:[NSString stringWithFormat:@"关于%@",kAppName]]) {
        ASSetAboutController *vc = [[ASSetAboutController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([model.leftTitle isEqualToString:@"环境设置"]) {
        [ASAlertViewManager bottomPopTitles:@[@"测试环境", @"预发环境", @"线上环境"] indexAction:^(NSString *indexName) {
            [ASLoginRequest requestOutLoginSuccess:^(id  _Nullable data) {
                if ([indexName isEqualToString:@"测试环境"]) {
                    [ASUserDefaults setValue:@"0" forKey:kServerUrlType];
                    exit(0);
                    return;
                }
                if ([indexName isEqualToString:@"预发环境"]) {
                    [ASUserDefaults setValue:@"1" forKey:kServerUrlType];
                    exit(0);
                    return;
                }
                if ([indexName isEqualToString:@"线上环境"]) {
                    [ASUserDefaults setValue:@"2" forKey:kServerUrlType];
                    exit(0);
                    return;
                }
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        } cancelAction:^{
            
        }];
        return;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BACKGROUNDCOLOR;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SCALES(10);
}

- (NSMutableArray *)lists {
    if (!_lists) {
        _lists = [[NSMutableArray alloc]init];
    }
    return _lists;
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
    }
    return _tableView;
}
@end
