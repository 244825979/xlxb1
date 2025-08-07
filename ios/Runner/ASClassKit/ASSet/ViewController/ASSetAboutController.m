//
//  ASSetAboutController.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASSetAboutController.h"

@interface ASSetAboutController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *lists;
@end

@implementation ASSetAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = [NSString stringWithFormat:@"关于%@",kAppName];
    [self createUI];
}

- (void)createUI {
    [self.tableView registerClass:[ASBaseCommonCell class] forCellReuseIdentifier:@"baseCommonCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(200));
    self.tableView.tableHeaderView = headerView;
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image = [UIImage imageNamed:@"app_logo"];
    [headerView addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(36));
        make.centerX.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(SCALES(81), SCALES(81)));
    }];

    UILabel *appName = [[UILabel alloc] init];
    appName.font = TEXT_FONT_16;
    appName.text = STRING(kAppName);
    appName.textColor = TITLE_COLOR;
    appName.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:appName];
    [appName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logo.mas_bottom).offset(SCALES(14));
        make.centerX.equalTo(headerView);
        make.height.mas_equalTo(SCALES(22));
    }];
    
    UILabel *appVersion = [[UILabel alloc] init];
    appVersion.font = TEXT_FONT_14;
    appVersion.text = [NSString stringWithFormat:@"版本：%@",kAppVersion];
    appVersion.textColor = TEXT_SIMPLE_COLOR;
    appVersion.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:appVersion];
    [appVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(appName.mas_bottom).offset(SCALES(5));
        make.centerX.equalTo(headerView);
        make.height.mas_equalTo(SCALES(18));
    }];
    
    [self.lists addObject:[self userAgreement]];
    [self.lists addObject:[self privacyAgreement]];
//    [self.lists addObject:[self thirdParty]];
    [self.lists addObject:[self nonageProtect]];
    [self.lists addObject:[self limitExplain]];
    [self.lists addObject:[self versionUpdate]];
}

- (ASSetCellModel *)userAgreement {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = @"用户协议";
    return model;
}

- (ASSetCellModel *)privacyAgreement {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = @"隐私保护";
    return model;
}

- (ASSetCellModel *)thirdParty {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = @"第三方共享个人信息清单";
    return model;
}

- (ASSetCellModel *)nonageProtect {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = @"未成年人保护协议";
    return model;
}

- (ASSetCellModel *)limitExplain {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = @"权限申请与使用情况说明";
    return model;
}

- (ASSetCellModel *)versionUpdate {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitle = @"版本更新";
    return model;
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASSetCellModel* model = self.lists[indexPath.row];
    id cell = [tableView dequeueReusableCellWithIdentifier:model.cellIndentify forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ASSetCellModel *model = self.lists[indexPath.row];
    if ([model.leftTitle isEqualToString:@"用户协议"]) {
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_UserProtocol];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([model.leftTitle isEqualToString:@"隐私保护"]) {
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Privacy];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([model.leftTitle isEqualToString:@"第三方共享个人信息清单"]) {
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Privacy];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([model.leftTitle isEqualToString:@"未成年人保护协议"]) {
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = STRING(USER_INFO.configModel.webUrl.teenagerProtocol);
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([model.leftTitle isEqualToString:@"权限申请与使用情况说明"]) {
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_AuthRule];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([model.leftTitle isEqualToString:@"版本更新"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:STRING(USER_INFO.configModel.version.downloadurl)] options:@{} completionHandler:^(BOOL success) {
                    
        }];
        return;
    }
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
    }
    return _tableView;
}

@end
