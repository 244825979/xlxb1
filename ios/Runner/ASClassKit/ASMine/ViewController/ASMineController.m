//
//  ASMineController.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASMineController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "ASMineTopView.h"
#import "ASMineCell.h"
#import "ASMineVipView.h"
#import "ASMineAccountView.h"
#import "ASMineSignView.h"
#import "ASMineRequest.h"
#import "ASSignInModel.h"
#import "ASMineUserModel.h"
#import "ASEditDataController.h"
#import "ASSetHomeController.h"
#import "ASVideoShowMyListContrller.h"
#import "ASFansListController.h"
#import "ASFollowListController.h"
#import "ASVipDetailsController.h"
#import "ASAuthHomeController.h"
#import "ASConvenienceLanListController.h"
#import "ASSecurityCenterController.h"
#import "ASChongZhiController.h"
#import "ASWithdrawChangeHomeController.h"
#import "ASLookListController.h"
#import "ASVisitorListController.h"
#import "ASVideoShowRequest.h"
#import "ASVideoShowDemonstrationController.h"

@interface ASMineController ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) ASMineTopView *topView;
@property (nonatomic, strong) ASMineSignView *signInView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
/**数据**/
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, assign) CGFloat tableHeaderHeight;
@property (nonatomic, strong) ASMineUserModel *mineUserModel;
@property (nonatomic, strong) ASAccountMoneyModel *accountModel;
@property (nonatomic, strong) NSArray *banners;
@end

@implementation ASMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    self.view.backgroundColor = BACKGROUNDCOLOR;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self createUI];
    [self setData];
    //弹窗引导
    [[ASPopViewManager shared] minePopViewWithVc:self complete:^{
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([ASPopViewManager shared].popGoodAnchorState == 2 || [ASPopViewManager shared].popGoodAnchorState == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goodAnchorConfigNotification" object:nil];
    }
    [self requestData];
}

- (void)requestData {
    //获取个人主页数据
    kWeakSelf(self);
    [ASMineRequest requestMineHomeSuccess:^(id _Nullable data) {
        wself.mineUserModel = data;
        wself.topView.model = data;
        //更新vip状态
        USER_INFO.vip = wself.mineUserModel.userinfo.vip;
        [ASUserDefaults setValue:@(wself.mineUserModel.userinfo.vip) forKey:@"userinfo_vip"];
        //更新实名认证状态
        USER_INFO.is_auth = wself.mineUserModel.userinfo.is_auth;
        [ASUserDefaults setValue:@(wself.mineUserModel.userinfo.is_auth) forKey:@"userinfo_is_auth"];
        //更新真人认证状态
        USER_INFO.is_rp_auth = wself.mineUserModel.userinfo.is_rp_auth;
        [ASUserDefaults setValue:@(wself.mineUserModel.userinfo.is_rp_auth) forKey:@"userinfo_is_rp_auth"];
    } errorBack:^(NSInteger code, NSString *msg) {
    }];
    //获取账户金额数据
    [ASMineRequest requestWalletIndexSuccess:^(id _Nullable model) {
        wself.accountModel = model;
        wself.topView.moneyModel = wself.accountModel;
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
    [self requestTodaySign];
    //获取banner图数据
    [ASMineRequest requestBannerWithType:@"4" success:^(NSArray * _Nullable banner) {
        wself.banners = banner;
        NSMutableArray *urls = [NSMutableArray array];
        for (ASBannerModel *model in wself.banners) {
            [urls addObject:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL,model.image]];
        }
        if (urls.count == 0) {
            wself.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, wself.tableHeaderHeight);
            wself.bannerView.hidden = YES;
        } else {
            wself.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, wself.tableHeaderHeight + SCALES(84));
            wself.bannerView.hidden = NO;
        }
        [wself.tableView reloadData];
        wself.bannerView.imageURLStringsGroup = urls;
        [wself.bannerView adjustWhenControllerViewWillAppera];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)requestTodaySign {
    kWeakSelf(self);
    [ASMineRequest requestTodaySignDataSuccess:^(ASSignInModel * _Nullable signInModel) {
        wself.signInView.model = signInModel;
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)createUI {
    kWeakSelf(self);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIImageView *statusBar = [[UIImageView alloc] init];
    statusBar.image = [UIImage imageNamed:@"mine_start"];
    [self.view addSubview:statusBar];
    [statusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(STATUS_BAR_HEIGHT);
    }];
    CGFloat tableHeaderViewHeight = STATUS_BAR_HEIGHT;
    [self.tableHeaderView addSubview:self.topView];
    self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(315) + STATUS_BAR_HEIGHT);
    tableHeaderViewHeight += SCALES(315);
    self.topView.clipsToBounds = YES;
    self.topView.indexNameBlock = ^(NSString *titleName) {
        if ([titleName isEqualToString:@"我的主页"]) {
            [ASMyAppCommonFunc goPersonalHomeWithUserID:USER_INFO.user_id viewController:wself action:^(id  _Nonnull data) {
                
            }];
            return;
        }
        if ([titleName isEqualToString:@"编辑资料"]) {
            ASEditDataController *vc = [[ASEditDataController alloc] init];
            [wself.navigationController pushViewController:vc animated:YES];
            return;
        }
        if ([titleName isEqualToString:@"关注"]) {
            ASFollowListController *vc = [[ASFollowListController alloc] init];
            [wself.navigationController pushViewController:vc animated:YES];
            return;
        }
        if ([titleName isEqualToString:@"粉丝"]) {
            ASFansListController *vc = [[ASFansListController alloc] init];
            [wself.navigationController pushViewController:vc animated:YES];
            return;
        }
        if ([titleName isEqualToString:@"看过"]) {
            ASLookListController *vc = [[ASLookListController alloc] init];
            [wself.navigationController pushViewController:vc animated:YES];
            return;
        }
        if ([titleName isEqualToString:@"访客"]) {
            ASVisitorListController *vc = [[ASVisitorListController alloc] init];
            vc.isVip = wself.mineUserModel.userinfo.vip;
            [wself.navigationController pushViewController:vc animated:YES];
            return;
        }
        if ([titleName isEqualToString:@"开通vip"]) {
            ASVipDetailsController *vc = [[ASVipDetailsController alloc] init];
            [wself.navigationController pushViewController:vc animated:YES];
            return;
        }
        if ([titleName isEqualToString:@"我的收益"]) {
            [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthPopEarnings succeed:^{
                ASWithdrawChangeHomeController *vc = [[ASWithdrawChangeHomeController alloc] init];
                vc.model = wself.accountModel;
                [wself.navigationController pushViewController:vc animated:YES];
            }];
            return;
        }
        if ([titleName isEqualToString:@"充值金币"]) {
            ASChongZhiController *vc = [[ASChongZhiController alloc] init];
            vc.accountModel = wself.accountModel;
            [wself.navigationController pushViewController:vc animated:YES];
            return;
        }
    };
    //签到样式
    [self.tableHeaderView addSubview:self.signInView];
    self.signInView.clikedBlock = ^{
        [wself requestTodaySign];
    };
    self.signInView.frame = CGRectMake(SCALES(16), self.topView.bottom + SCALES(10), SCREEN_WIDTH - SCALES(32), SCALES(145));
    tableHeaderViewHeight += (self.signInView.height + SCALES(10));
    self.bannerView = ({
        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(SCALES(16),
                                                                                               self.signInView.bottom + SCALES(10),
                                                                                               floorf(SCREEN_WIDTH - SCALES(32)),//取整
                                                                                               SCALES(70)) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        bannerView.hidden = YES;
        bannerView.backgroundColor = UIColor.whiteColor;
        bannerView.autoScrollTimeInterval = 3.0f;
        bannerView.layer.masksToBounds = YES;
        bannerView.showPageControl = NO;
        bannerView.layer.cornerRadius = SCALES(8);
        bannerView.delegate = self;
        [self.tableHeaderView addSubview:bannerView];
        bannerView;
    });
    self.tableHeaderHeight = tableHeaderViewHeight + SCALES(10);
    self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.tableHeaderHeight);
    self.tableView.tableHeaderView = self.tableHeaderView;
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(16));
    self.tableView.tableFooterView = footerView;
}

- (void)setData {
    if (USER_INFO.gender == 2) {
        self.items = @[@"我的认证",
                       @"邀请好友",
                       @"每日任务",
                       @"安全中心",
                       @"净网公告",
                       @"在线客服",
                       @"系统设置"];
        self.icons = @[@"mine_cell2",
                       @"mine_cell8",
                       @"mine_cell3",
                       @"mine_cell4",
                       @"mine_cell5",
                       @"mine_cell6",
                       @"mine_cell7"];
    } else {
        self.items = @[@"快捷用语",
                       @"我的视频秀",
                       @"我的认证",
                       @"邀请好友",
                       @"每日任务",
                       @"安全中心",
                       @"净网公告",
                       @"在线客服",
                       @"系统设置"];
        self.icons = @[@"mine_cell9",
                       @"mine_cell10",
                       @"mine_cell2",
                       @"mine_cell8",
                       @"mine_cell3",
                       @"mine_cell4",
                       @"mine_cell5",
                       @"mine_cell6",
                       @"mine_cell7"];
    }
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    ASMineCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.title = self.items[indexPath.row];
    cell.icon = self.icons[indexPath.row];
    cell.type = kMineCellDefault;
    cell.isFirstCell = NO;
    cell.isLastCell = NO;
    NSString *title = self.items[indexPath.row];
    if ([title isEqualToString:@"快捷用语"]) {
        cell.type = kMineCellConvenient;
    }
    if ([title isEqualToString:@"邀请好友"]) {
        cell.type = kMineCellInvite;
    }
    if ([title isEqualToString:@"每日任务"]) {
        cell.type = kMineCellTask;
    }
    if ([title isEqualToString:@"在线客服"]) {
        cell.type = kMineCellService;
    }
    if (indexPath.row == 0) {
        cell.isFirstCell = YES;
    }
    if (indexPath.row == self.items.count - 1) {
        cell.isLastCell = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(54);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *title = self.items[indexPath.row];
    if ([title isEqualToString:@"快捷用语"]) {
        ASConvenienceLanListController *vc = [[ASConvenienceLanListController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([title isEqualToString:@"我的视频秀"]) {
        ASVideoShowMyListContrller *vc = [[ASVideoShowMyListContrller alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([title isEqualToString:@"我的认证"]) {
        ASAuthHomeController *vc = [[ASAuthHomeController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([title isEqualToString:@"邀请好友"]) {
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = USER_INFO.configModel.webUrl.share;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([title isEqualToString:@"每日任务"]) {
        ASBaseWebViewController *h5Vc = [[ASBaseWebViewController alloc]init];
        h5Vc.webUrl = USER_INFO.configModel.webUrl.taskCenter;
        [self.navigationController pushViewController:h5Vc animated:YES];
        return;
    }
    if ([title isEqualToString:@"净网公告"]) {
        ASBaseWebViewController *h5Vc = [[ASBaseWebViewController alloc]init];
        h5Vc.webUrl = USER_INFO.configModel.webUrl.publish;
        [self.navigationController pushViewController:h5Vc animated:YES];
        return;
    }
    if ([title isEqualToString:@"在线客服"]) {
        ASBaseWebViewController *h5Vc = [[ASBaseWebViewController alloc]init];
        h5Vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Customer];
        [self.navigationController pushViewController:h5Vc animated:YES];
        return;
    }
    if ([title isEqualToString:@"系统设置"]) {
        ASSetHomeController *vc = [[ASSetHomeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([title isEqualToString:@"安全中心"]) {
        ASSecurityCenterController *vc = [[ASSecurityCenterController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    ASBannerModel *model = self.banners[index];
    [ASMyAppCommonFunc bannerClikedWithBannerModel:model viewController:self action:^(id  _Nonnull data) {
    }];
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc]init];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc]init];
    }
    return _tableHeaderView;
}

- (ASMineTopView *)topView {
    if (!_topView) {
        _topView = [[ASMineTopView alloc]init];
    }
    return _topView;
}

- (ASMineSignView *)signInView {
    if (!_signInView) {
        _signInView = [[ASMineSignView alloc]init];
        _signInView.backgroundColor = UIColor.whiteColor;
        _signInView.layer.cornerRadius = SCALES(8);
        _signInView.layer.masksToBounds = YES;
    }
    return _signInView;
}
@end
