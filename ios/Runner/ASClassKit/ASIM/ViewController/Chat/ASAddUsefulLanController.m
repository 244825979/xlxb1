//
//  ASAddUsefulLanController.m
//  AS
//
//  Created by SA on 2025/5/16.
//

#import "ASAddUsefulLanController.h"
#import "ASIMRequest.h"
#import "ASAddUsefulLanModel.h"
#import "ASAddUsefulLanCell.h"

@interface ASAddUsefulLanController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *lists;
@end

@implementation ASAddUsefulLanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"聊天常用语";
    [self createUI];
    [self onRefresh];
}

- (void)createUI {
    kWeakSelf(self);
    self.tableView.mj_header = [ASRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefresh)];
    UIButton *add = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [add setImage:[UIImage imageNamed:@"useful_add"] forState:UIControlStateNormal];
    [[add rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [ASAlertViewManager popTextViewWithTitle:@"添加自定义常用语" content:@"" placeholder:@"自定义常用语" length:50 affirmText:@"提交" affirmAction:^(NSString * _Nonnull text) {
            [wself addRequest:text];
        } cancelAction:^{
            
        }];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:add];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(80));
    self.tableView.tableFooterView = footerView;
    UIButton *changeBtn = [[UIButton alloc] init];
    [changeBtn setImage:[UIImage imageNamed:@"useful_change"] forState:UIControlStateNormal];
    changeBtn.adjustsImageWhenHighlighted = NO;
    [[changeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wself.tableView.mj_header beginRefreshing];
    }];
    [footerView addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(SCALES(135), SCALES(44)));
    }];
}

- (void)onRefresh {
    [self requestList];
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = NO;
}

#pragma mark -  请求列表数据
- (void)requestList {
    kWeakSelf(self);
    [ASIMRequest requestUsefulExpressionsListWithScene:0 isReply:0 success:^(id  _Nullable data) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"usefulExpressionsNotification" object: data];
        NSArray *array = [ASAddUsefulLanModel mj_objectArrayWithKeyValuesArray:data];
        wself.lists = [NSMutableArray arrayWithArray:array];
        [wself.tableView.mj_header endRefreshing];
        [wself.tableView reloadData];
        wself.tableView.emptyType = kTableViewEmptyNoData;
    } errorBack:^(NSInteger code, NSString *msg) {
        [wself.tableView.mj_footer endRefreshing];
        [wself.tableView.mj_header endRefreshing];
        wself.tableView.emptyType = kTableViewEmptyLoadFail;
    }];
}

- (void)addRequest:(NSString *)text {
    kWeakSelf(self);
    [ASIMRequest requestAddUsefulExpressionsWithText:text success:^(id  _Nullable data) {
        [wself.tableView.mj_header beginRefreshing];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    ASAddUsefulLanCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASAddUsefulLanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.model = self.lists[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASAddUsefulLanModel *model = self.lists[indexPath.row];
    return model.cellHeight;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    kWeakSelf(self);
    ASAddUsefulLanModel *model = self.lists[indexPath.row];
    if (model.is_system == 1) {
        return nil;
    } else {
        UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            completionHandler(YES);
            [ASIMRequest requestDelUsefulExpressionsWithID:model.ID success:^(id  _Nullable data) {
                [wself requestList];
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        }];
        deleteRowAction.backgroundColor = [UIColor redColor];
        deleteRowAction.title = @"删除";
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
        return config;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ASAddUsefulLanModel *model = self.lists[indexPath.row];
    if (model.status == 0) {
        return;
    }
    if (self.sendTextBlock) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.sendTextBlock) {
            self.sendTextBlock(model.word);
        }
    }
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyType = kTableViewEmptyNoData;
    }
    return _tableView;
}

- (NSMutableArray *)lists {
    if (!_lists) {
        _lists = [[NSMutableArray alloc]init];
    }
    return _lists;
}
@end
