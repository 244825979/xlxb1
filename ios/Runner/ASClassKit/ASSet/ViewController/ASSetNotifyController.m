//
//  ASSetNotifyController.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASSetNotifyController.h"
#import "ASSetRequest.h"

@interface ASSetNotifyController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSArray *> *lists;
@property (nonatomic, strong) NSArray *headTitles;
@property (nonatomic, assign) BOOL isLotPull;//是否开启牵线
@property (nonatomic, assign) BOOL isLike;//是否开启点赞通知
@end

@implementation ASSetNotifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"消息通知";
    [self createUI];
    [self requestData];
}

- (void)createUI {
    self.headTitles = @[@"推荐设置", @"推送设置", @"通知权限设置"];
    [self.lists addObject:@[[self lotPull]]];
    [self.lists addObject:@[[self topNotify], [self like]]];
    [self.lists addObject:@[[self notificationLimit]]];
    [self.tableView registerClass:[ASBaseCommonCell class] forCellReuseIdentifier:@"baseCommonCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)requestData {
    kWeakSelf(self);
    [ASSetRequest requestFateMatchStateSuccess:^(NSNumber* _Nullable data) {
        wself.isLotPull = data.boolValue;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        ASBaseCommonCell *cell = [wself.tableView cellForRowAtIndexPath:indexPath];
        [cell.setSwitch setOn: wself.isLotPull];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
    
    [ASSetRequest requestLikeStateSuccess:^(NSNumber*  _Nullable data) {
        wself.isLike = data.boolValue;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        ASBaseCommonCell *cell = [wself.tableView cellForRowAtIndexPath:indexPath];
        [cell.setSwitch setOn: !wself.isLike];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (ASSetCellModel *)lotPull {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellSwitch;
    model.leftTitleFont = TEXT_FONT_15;
    model.leftTitle = @"缘分牵线";
    model.isSwitch = self.isLotPull;
    model.valueDidBlock = ^(UISwitch *switchs) {
        [ASSetRequest requestSetFateMatchWithState:switchs.on success:^(id  _Nullable data) {
            kShowToast(@"设置成功");
        } errorBack:^(NSInteger code, NSString *msg) {
            [switchs setOn:!switchs.on];
        }];
    };
    return model;
}

- (ASSetCellModel *)topNotify {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellSwitch;
    model.leftTitleFont = TEXT_FONT_15;
    model.leftTitle = @"顶部新消息提醒";
    NSString *isPop = [ASUserDefaults valueForKey:kIsChatMessageNotifyPop];//是否开启顶部消息提醒，默认开启
    if (kStringIsEmpty(isPop) || isPop.integerValue == 1) {
        model.isSwitch = YES;
    } else {
        model.isSwitch = NO;
    }
    model.valueDidBlock = ^(UISwitch *switchs) {
        [ASUserDefaults setValue:[NSString stringWithFormat:@"%d",switchs.on] forKey:kIsChatMessageNotifyPop];
    };
    return model;
}

- (ASSetCellModel *)like {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellSwitch;
    model.leftTitleFont = TEXT_FONT_15;
    model.leftTitle = @"点赞通知";
    model.isSwitch = !self.isLike;
    model.valueDidBlock = ^(UISwitch *switchs) {
        [ASSetRequest requestSetLikeStateWithState:switchs.on == YES ? @"0" : @"1" success:^(id  _Nullable data) {
            kShowToast(@"设置成功");
        } errorBack:^(NSInteger code, NSString *msg) {
            [switchs setOn:!switchs.on];
        }];
    };
    return model;
}

- (ASSetCellModel *)notificationLimit {
    ASSetCellModel *model = [[ASSetCellModel alloc]init];
    model.cellType = kSetCommonCellDefault;
    model.leftTitleFont = TEXT_FONT_15;
    model.leftTitle = @"消息通知权限设置";
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(49);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ASSetCellModel *model = self.lists[indexPath.section][indexPath.row];
    if ([model.leftTitle isEqualToString:@"消息通知权限设置"]) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        };
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCALES(46);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BACKGROUNDCOLOR;
    UILabel *text = [[UILabel alloc] init];
    text.font = TEXT_FONT_14;
    text.text = self.headTitles[section];
    text.textColor = TITLE_COLOR;
    [view addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(15));
        make.height.equalTo(view);
        make.centerY.equalTo(view).offset(SCALES(3));
    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSString *title = self.headTitles[section];
    if ([title isEqualToString:@"推荐设置"]) {
        return SCALES(50);
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString *title = self.headTitles[section];
    if ([title isEqualToString:@"推荐设置"]) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = UIColor.whiteColor;
        UILabel *text = [[UILabel alloc] init];
        text.font = TEXT_FONT_13;
        text.textColor = TEXT_SIMPLE_COLOR;
        text.attributedText = [ASCommonFunc attributedWithString: @"开启后，心聊想伴将用大数据为您匹配有缘人，牵线成功会发送缘分消息，关闭后，将不会收到缘分牵线。"
                                                     lineSpacing: SCALES(3.0)];
        text.numberOfLines = 2;
        [view addSubview:text];
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(4));
            make.left.mas_equalTo(SCALES(15));
            make.right.equalTo(view).offset(SCALES(-20));
        }];
        return view;
    }
    return [[UIView alloc]init];
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

- (NSMutableArray *)lists {
    if (!_lists) {
        _lists = [[NSMutableArray alloc]init];
    }
    return _lists;
}
@end
