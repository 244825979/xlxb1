//
//  ASSetBindViewController.m
//  AS
//
//  Created by SA on 2025/7/23.
//

#import "ASSetBindViewController.h"
#import "ASSetBindViewCell.h"
#import "ASSetRequest.h"
#import "ASSetBindStateModel.h"
#import "ASSetCancelAccountController.h"

@interface ASSetBindViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) ASSetBindStateModel *model;
@end

@implementation ASSetBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"账号绑定";
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)createUI {
    kWeakSelf(self);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(100));
    [self.tableView setTableFooterView:footerView];
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.frame = CGRectMake(0, SCALES(17), SCREEN_WIDTH, SCALES(18));
    hintLabel.font = TEXT_FONT_13;
    hintLabel.text = @"*账号绑定后可任意选择一种方式登录此账号";
    hintLabel.textColor = TEXT_SIMPLE_COLOR;
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:hintLabel];
    UIButton *zhuxiaoBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    zhuxiaoBtn.frame = CGRectMake(SCREEN_WIDTH/2 - SCALES(100), SCALES(50), SCALES(200), SCALES(32));
    [zhuxiaoBtn setTitle:@"注销账号" forState:UIControlStateNormal];
    zhuxiaoBtn.titleLabel.font = TEXT_FONT_16;
    [zhuxiaoBtn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [footerView addSubview:zhuxiaoBtn];
    [[zhuxiaoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ASSetCancelAccountController *vc = [[ASSetCancelAccountController alloc] init];
        [wself.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)requestData {
    kWeakSelf(self);
    [ASSetRequest requestBindStatusSuccess:^(id _Nullable data) {
        wself.model = data;
        [wself.tableView reloadData];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    ASSetBindViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASSetBindViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.model = self.model;
    cell.type = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0 && kStringIsEmpty(self.model.mobile)) {
        //去绑定手机号
        [[ASLoginManager shared] TX_BindPhonePopViewWithController:self hitnText:@"" isPopWindow:YES close:^{
            
        }];
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

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end
