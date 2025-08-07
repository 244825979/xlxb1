//
//  ASConvenienceLanListController.m
//  AS
//
//  Created by SA on 2025/5/21.
//

#import "ASConvenienceLanListController.h"
#import "ASConvenienceLanAddController.h"
#import "ASMineRequest.h"
#import "ASConvenienceLanListCell.h"
#import "ASConvenienceLanListModel.h"

@interface ASConvenienceLanListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
/**数据**/
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, assign) NSInteger selectIndexPath;
@property (nonatomic, assign) BOOL isFirst;
@end

@implementation ASConvenienceLanListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"快捷用语设置";
    self.selectIndexPath = -1;
    [self createUI];
    [self requestList];
}

- (void)createUI {
    UIView *topBg = [[UIView alloc]init];
    topBg.backgroundColor = UIColorRGB(0xFFF1F1);
    [self.view addSubview:topBg];
    [topBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(SCALES(64));
    }];
    UIImageView *icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"convenience_top"];
    [topBg addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.centerY.equalTo(topBg);
        make.size.mas_equalTo(CGSizeMake(SCALES(34), SCALES(34)));
    }];
    UILabel *text = [[UILabel alloc]init];
    text.numberOfLines = 0;
    text.font = TEXT_FONT_14;
    text.textColor = MAIN_COLOR;
    text.attributedText = [ASCommonFunc attributedWithString:@"优质搭讪语+甜美声音+妹妹照片是完美的快捷用语组合，设置越多，系统牵线流量也越多哦！" lineSpacing:SCALES(3.0)];
    [topBg addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(65));
        make.centerY.equalTo(topBg);
        make.right.equalTo(topBg).offset(SCALES(-13));
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topBg.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    UIView *fotterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TAB_BAR_MAGIN20 + 14 + SCALES(50))];
    [self.tableView setTableFooterView:fotterView];
    UIButton *edit = [[UIButton alloc]init];
    edit.titleLabel.font = TEXT_FONT_18;
    edit.layer.cornerRadius = SCALES(25);
    edit.layer.masksToBounds = YES;
    [edit setTitle:@"新建模版" forState:UIControlStateNormal];
    edit.adjustsImageWhenHighlighted = NO;
    [edit setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    kWeakSelf(self);
    [[edit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ASConvenienceLanAddController *vc = [[ASConvenienceLanAddController alloc] init];
        vc.refreshBolck = ^{
            wself.selectIndexPath = wself.selectIndexPath + 1;
            [wself requestList];
        };
        [wself.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:edit];
    [edit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCALES(319), SCALES(50)));
        make.bottom.mas_equalTo(-TAB_BAR_MAGIN20 - 14);
    }];
    self.tableView.mj_header = [ASRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestList)];
}

- (void)requestList {
    kWeakSelf(self);
    [ASMineRequest requestConvenienceLanListSuccess:^(id _Nullable data) {
        NSArray *array = data;
        wself.lists = [NSMutableArray arrayWithArray:array];
        [wself.tableView.mj_header endRefreshing];
        [wself.tableView reloadData];
        wself.tableView.emptyType = kTableViewEmptyBianJieYu;
    } errorBack:^(NSInteger code, NSString *msg) {
        [wself.tableView.mj_header endRefreshing];
        wself.tableView.emptyType = kTableViewEmptyLoadFail;
    }];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    ASConvenienceLanListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASConvenienceLanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    ASConvenienceLanListModel *model = self.lists[indexPath.row];
    cell.model = model;
    if (model.is_default == 1 && self.isFirst == NO) {
        self.isFirst = YES;//记录首次进入selectIndex
        self.selectIndexPath = indexPath.row;
    }
    kWeakSelf(self);
    cell.delBlock = ^{
        [wself requestList];
        if (wself.selectIndexPath == indexPath.row) {
            wself.selectIndexPath = -1;
        } else if (indexPath.row < wself.selectIndexPath) {
            wself.selectIndexPath = wself.selectIndexPath - 1;
        }
    };
    cell.selectBlock = ^(NSString * _Nonnull ID) {
        if (wself.selectIndexPath != indexPath.row) {
            [ASMineRequest requestSetDefaultConvenienceLanWithID:ID success:^(id  _Nullable data) {
                kShowToast(@"设置成功！");
                wself.selectIndexPath = indexPath.row;
                [wself.tableView reloadData];
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        }
    };
    if (self.selectIndexPath == indexPath.row) {
        cell.selectBtn.selected = YES;
    } else {
        cell.selectBtn.selected = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASConvenienceLanListModel *model = self.lists[indexPath.row];
    return model.cellHeight;
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyType = kTableViewEmptyBianJieYu;
    }
    return _tableView;
}
@end
