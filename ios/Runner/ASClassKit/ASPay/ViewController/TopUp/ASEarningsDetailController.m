//
//  ASEarningsDetailController.m
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASEarningsDetailController.h"
#import "ASSendBackDetailModel.h"
#import "ASEarningsDetailCell.h"
#import "ASPayRequest.h"

@interface ASEarningsDetailController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) NSArray *lists;
@end

@implementation ASEarningsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = self.type == 0 ? @"退还详情" : @"退回详情";
    [self createUI];
    [self requestData];
}

- (void)createUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCALES(10))];
}

- (void)requestData {
    kWeakSelf(self);
    [ASPayRequest requestGiftRefundDetailWithID:self.giftID success:^(id  _Nullable data) {
        ASSendBackDetailModel *model = data;
        wself.lists = model.list;
        CGFloat textHeight = [ASCommonFunc getSizeWithText:STRING(model.tips) maxLayoutWidth:SCREEN_WIDTH - SCALES(28) lineSpacing:SCALES(3.0) font:TEXT_FONT_13];
        UIView *footerView = [[UIView alloc] init];
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, textHeight + SCALES(60) + TAB_BAR_MAGIN);
        
        UILabel *footerTitle = [[UILabel alloc] init];
        footerTitle.text = @"风险提示:";
        footerTitle.font = TEXT_FONT_16;
        footerTitle.textColor = TITLE_COLOR;
        [footerView addSubview:footerTitle];
        footerTitle.frame = CGRectMake(SCALES(14), SCALES(12), SCALES(200), SCALES(22));
        
        UILabel *footerText = [[UILabel alloc] init];
        footerText.font = TEXT_FONT_13;
        footerText.textColor = TEXT_COLOR;
        footerText.numberOfLines = 0;
        footerText.attributedText = [ASCommonFunc attributedWithString:STRING(model.tips) lineSpacing:SCALES(3.0)];
        [footerView addSubview:footerText];
        footerText.frame = CGRectMake(SCALES(14), footerTitle.bottom + SCALES(8), SCREEN_WIDTH - SCALES(28), textHeight);
        
        wself.tableView.tableFooterView = footerView;
        [wself.tableView reloadData];
    } errorBack:^(NSInteger code, NSString *msg) {
    }];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    ASEarningsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASEarningsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.model = self.lists[indexPath.row];
    cell.type = self.type;
    if (indexPath.row == self.lists.count -1) {
        cell.isLast = YES;
    } else {
        cell.isLast = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(40);
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
