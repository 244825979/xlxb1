//
//  ASSetPrivacyController.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASSetPrivacyController.h"
#import "ASSetRequest.h"

@interface ASSetPrivacyController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) NSArray *lists;
@property (nonatomic, assign) BOOL isSet;
@end

@implementation ASSetPrivacyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"隐私设置";
    [self createUI];
    [self requestData];
}

- (void)createUI {
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self.tableView registerClass:[ASBaseCommonCell class] forCellReuseIdentifier:@"baseCommonCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.lists = @[[self topNotify]];
    UIView *footerView = [[UIView alloc]init];
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(20));
    UILabel *text = [[UILabel alloc] init];
    text.frame = CGRectMake(SCALES(12), 0, SCREEN_WIDTH - SCALES(32), SCALES(20));
    text.font = TEXT_FONT_14;
    text.textColor = TEXT_SIMPLE_COLOR;
    text.text = @"关闭后送礼飘屏时您的昵称可正常显示。";
    [footerView addSubview:text];
    [self.tableView setTableFooterView:footerView];
}

- (ASSetCellModel *)topNotify {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellSwitch;
    model.leftTitleFont = TEXT_FONT_15;
    model.leftTitle = @"匿名显示上礼物飘屏昵称";
    model.isSwitch = self.isSet;
    model.valueDidBlock = ^(UISwitch *switchs) {
        [ASSetRequest requestSetAnonymityWithIsOpen:switchs.on success:^(id  _Nullable data) {
            kShowToast(@"设置成功");
        } errorBack:^(NSInteger code, NSString *msg) {
            [switchs setOn:!switchs.on];
        }];
    };
    return model;
}

#pragma mark - 请求获取数据
- (void)requestData {
    kWeakSelf(self);
    [ASSetRequest requestAnonymityStateSuccess:^(NSNumber* _Nullable data) {
        wself.isSet = data.boolValue;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        ASBaseCommonCell *cell = [wself.tableView cellForRowAtIndexPath:indexPath];
        [cell.setSwitch setOn: wself.isSet];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

#pragma mark tableViewDelegate
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCALES(46);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BACKGROUNDCOLOR;
    UILabel *text = [[UILabel alloc] init];
    text.font = TEXT_FONT_14;
    text.text = @"飘屏设置";
    text.textColor = TITLE_COLOR;
    [view addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(15));
        make.height.equalTo(view);
        make.centerY.equalTo(view).offset(SCALES(3));
    }];
    return view;
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
    }
    return _tableView;
}
@end
