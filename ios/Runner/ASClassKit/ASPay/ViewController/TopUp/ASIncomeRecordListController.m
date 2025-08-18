//
//  ASIncomeRecordListController.m
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASIncomeRecordListController.h"
#import "ASPayRequest.h"
#import "ASEarningsListModel.h"
#import "ASEarningsListCell.h"
#import "ASEarningsDetailController.h"

@interface ASIncomeRecordListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *date;//筛选的时间
@property (nonatomic, copy) NSString *createTime;//创建时间，月份
@end

@implementation ASIncomeRecordListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self onRefresh];
}

- (void)selectDateOnRefresh {
    kWeakSelf(self);
    [[ASDataSelectManager alloc] selectViewMoreDataWithType:kMoreSelectViewTime listArray:@[] action:^(NSString * _Nonnull key, id  _Nonnull value) {
        wself.date = [NSString stringWithFormat:@"%@-%@",key, value];
        [wself onRefresh];
    }];
}

- (void)createUI {
    self.tableView.mj_header = [ASRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefresh)];
    self.tableView.mj_footer = [ASRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(onNextPage)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)onRefresh {
    self.page = 1;
    self.createTime = @"";
    [self requestList];
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = NO;
}

- (void)onNextPage{
    if (kObjectIsEmpty(self.listArray)){
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    [self requestList];
}

#pragma mark -  请求列表数据
- (void)requestList {
    kWeakSelf(self);
    NSString *category;
    NSString *newType;
    if (self.type == 0) {
        category = @"1";
        newType = @"1";
    } else if (self.type == 1) {
        category = @"4";
        newType = @"4";
    }
    [ASPayRequest requestEarningsListWithPage:self.page date:self.date category:category newType:newType success:^(id  _Nullable data) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:data];
        for (int i = 0; i < array.count; i++) {
            ASEarningsListModel *model = array[i];
            if (!kStringIsEmpty(model.create_time)) {
                NSString *create_time = [model.create_time substringToIndex:7];
                if (![create_time isEqualToString:wself.createTime]) {
                    wself.createTime = create_time;
                    [array insertObject:create_time atIndex:i];
                }
            }
        }
        if(wself.page == 1){
            wself.listArray = [NSMutableArray arrayWithArray:array];
            [wself.tableView.mj_header endRefreshing];
            if (wself.listArray.count == 0) {
                wself.tableView.mj_footer.hidden = YES;
            }
        } else {
            [wself.listArray addObjectsFromArray:array];
            [wself.tableView.mj_footer endRefreshing];
        }
        wself.page++;
        [wself.tableView reloadData];
        wself.tableView.emptyType = kTableViewEmptyNoData;
    } errorBack:^(NSInteger code, NSString *msg) {
        [wself.tableView.mj_footer endRefreshing];
        [wself.tableView.mj_header endRefreshing];
        wself.tableView.emptyType = kTableViewEmptyLoadFail;
    }];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    ASEarningsListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASEarningsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    id model = self.listArray[indexPath.row];
    if ([model isKindOfClass:NSString.class]) {
        cell.isTimeCell = YES;
        cell.dayTimeOrIncomeStr = model;
    } else {
        cell.isTimeCell = NO;
        cell.model = model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.listArray[indexPath.row];
    if ([model isKindOfClass:NSString.class]) {
        return SCALES(34);
    } else {
        return SCALES(66);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.listArray[indexPath.row];
    if ([model isKindOfClass:[ASEarningsListModel class]]) {
        ASEarningsListModel *listModel = model;
        if (listModel.is_detail == 1) {
            ASEarningsDetailController *vc = [[ASEarningsDetailController alloc] init];
            vc.type = 1;
            vc.giftID = listModel.user_gift_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//滑动删除执行的代理方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 0) {
        kWeakSelf(self);
        id model = self.listArray[indexPath.row];
        if ([model isKindOfClass:[ASEarningsListModel class]]) {
            ASEarningsListModel *listModel = model;
            [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"确定删除这一条记录吗？" left:@"确认删除" right:@"我再想想" isTouched:YES affirmAction:^{
                [ASPayRequest requestDelMoneyRecordWithRecordID:listModel.ID type:2 success:^(id  _Nullable data) {
                        [wself.listArray  removeObjectAtIndex:indexPath.row];
                        [wself.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                } errorBack:^(NSInteger code, NSString *msg) {
                    
                }];
            } cancelAction:^{
                
            }];
        }
    }
}

//修改默认Delete按钮的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//判断是否显示左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 0) {
        id model = self.listArray[indexPath.row];
        if ([model isKindOfClass:NSString.class]) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}

- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc]init];
    }
    return _listArray;
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
@end
