//
//  ASPersonalUserController.m
//  AS
//
//  Created by SA on 2025/5/6.
//

#import "ASPersonalUserController.h"
#import "ASPersonalRequest.h"
#import "ASPersonalUserInfoCell.h"
#import "ASPersonalSignTextCell.h"
#import "ASPersonalTagsCell.h"
#import "ASPersonalGiftsCell.h"
#import "ASPersonalGiftsController.h"

@interface ASPersonalUserController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
/**数据**/
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@end

@implementation ASPersonalUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.sectionTitles addObject: @"个人信息"];
    [self.sectionTitles addObject: @"个性签名"];
    [self.tableView registerClass:[ASPersonalUserInfoCell class] forCellReuseIdentifier:@"personalUserInfoCell"];
    [self.tableView registerClass:[ASPersonalSignTextCell class] forCellReuseIdentifier:@"personalSignTextCell"];
    [self.tableView registerClass:[ASPersonalTagsCell class] forCellReuseIdentifier:@"personalTagsCell"];
    [self.tableView registerClass:[ASPersonalGiftsCell class] forCellReuseIdentifier:@"personalGiftsCell"];
}

- (void)setHomeModel:(ASUserInfoModel *)homeModel {
    _homeModel = homeModel;
    if (self.homeModel.label.count > 0) {
        [self.sectionTitles addObject:[USER_INFO.user_id isEqualToString:self.userID] ? @"我的标签" : @"Ta的标签"];
    }
    if (self.homeModel.gifts.count > 0) {
        [self.sectionTitles addObject:@"收到礼物"];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.sectionTitles[indexPath.section];
    if ([title isEqualToString:@"个人信息"]) {
        return self.homeModel.personalCardViewHeight;
    }
    if ([title isEqualToString:@"个性签名"]) {
        return self.homeModel.signTextHeight;
    }
    if ([title isEqualToString:@"Ta的标签"] || [title isEqualToString:@"我的标签"]) {
        return self.homeModel.labelsHeight;
    }
    if ([title isEqualToString:@"收到礼物"]) {
        return SCALES(111);
    }
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.sectionTitles[indexPath.section];
    if ([title isEqualToString:@"个人信息"]) {
        ASPersonalUserInfoCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"personalUserInfoCell" forIndexPath:indexPath];
        cell.model = self.homeModel;
        return cell;
    }
    if ([title isEqualToString:@"个性签名"]) {
        ASPersonalSignTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalSignTextCell" forIndexPath:indexPath];
        cell.model = self.homeModel;
        return cell;
    }
    if ([title isEqualToString:@"Ta的标签"] || [title isEqualToString:@"我的标签"]) {
        ASPersonalTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalTagsCell" forIndexPath:indexPath];
        cell.model = self.homeModel;
        return cell;
    }
    if ([title isEqualToString:@"收到礼物"]) {
        ASPersonalGiftsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalGiftsCell" forIndexPath:indexPath];
        if (self.homeModel.gifts.count > 3) {
            cell.gifts = [self.homeModel.gifts subarrayWithRange:NSMakeRange(0, 3)];
        } else {
            cell.gifts = self.homeModel.gifts;
        }
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCALES(50);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    NSString *title = self.sectionTitles[section];
    UILabel *text = [[UILabel alloc] init];
    text.font = TEXT_FONT_20;
    text.text = STRING(title);
    text.textColor = TITLE_COLOR;
    [view addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.height.centerY.equalTo(view);
    }];
    if ([title isEqualToString:@"收到礼物"]) {
        UIButton *more = [[UIButton alloc] init];
        [more setTitle:@"更多" forState:UIControlStateNormal];
        [more setImage:[UIImage imageNamed:@"cell_back"] forState:UIControlStateNormal];
        more.titleLabel.font = TEXT_FONT_14;
        [more setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        [more setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [more setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -65)];
        kWeakSelf(self);
        [[more rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if ([title isEqualToString:@"收到礼物"]) {
                ASPersonalGiftsController *vc = [[ASPersonalGiftsController alloc] init];
                vc.gifts = wself.homeModel.gifts;
                [wself.navigationController pushViewController:vc animated:YES];
                return;
            }
        }];
        [view addSubview:more];
        [more mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(SCALES(-16));
            make.height.centerY.equalTo(view);
        }];
    }
    return view;
}

#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollCallback != nil) {
        self.scrollCallback(scrollView);
    }
}

- (UIView *)listView {
    return self.view;
}

- (void)dealloc {
    self.scrollCallback = nil;
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc]init];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)sectionTitles {
    if (!_sectionTitles) {
        _sectionTitles = [[NSMutableArray alloc]init];
    }
    return _sectionTitles;
}
@end
