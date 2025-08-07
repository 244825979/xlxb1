//
//  ASSecurityCenterController.m
//  AS
//
//  Created by SA on 2025/5/22.
//

#import "ASSecurityCenterController.h"
#import "ASAuthOrSafetyItemView.h"
#import "ASMineRequest.h"
#import "ASSecurityCenterModel.h"
#import "ASSecurityConsumptionController.h"

@interface ASSecurityCenterController ()
@property (nonatomic, strong) ASAuthOrSafetyItemView *rationalView;
@property (nonatomic, strong) ASAuthOrSafetyItemView *peiliaoView;
@property (nonatomic, strong) ASAuthOrSafetyItemView *inviteView;
@property (nonatomic, strong) ASAuthOrSafetyItemView *userView;
/**数据**/
@property (nonatomic, strong) ASSecurityCenterModel *inviteModel;
@property (nonatomic, strong) ASSecurityCenterModel *peiliaoModel;
@property (nonatomic, strong) ASSecurityCenterModel *userModel;
@end

@implementation ASSecurityCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"安全中心";
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)createUI {
    if (USER_INFO.gender == 2) {
        [self.view addSubview:self.rationalView];
        [self.rationalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(14));
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(SCALES(82));
        }];
        [self.view addSubview:self.peiliaoView];
        [self.peiliaoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rationalView.mas_bottom);
            make.left.right.height.equalTo(self.rationalView);
        }];
    } else {
        [self.view addSubview:self.peiliaoView];
        [self.peiliaoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(14));
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(SCALES(82));
        }];
    }
    [self.view addSubview:self.inviteView];
    [self.inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.peiliaoView.mas_bottom);
        make.left.right.height.equalTo(self.peiliaoView);
    }];
    [self.view addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inviteView.mas_bottom);
        make.left.right.height.equalTo(self.peiliaoView);
    }];
}

- (void)requestData {
    kWeakSelf(self);
    [ASMineRequest requestSecurityCenterWithSuccess:^(id  _Nonnull response) {
        NSArray *list = response;
        for (int i = 0; i < list.count; i++) {
            ASSecurityCenterModel *model = list[i];
            if ([model.name isEqualToString:@"邀请须知"]) {
                wself.inviteModel = model;
                wself.inviteView.stateValue = wself.inviteModel.status.integerValue;
            }
            if ([model.name isEqualToString:@"陪聊须知"]) {
                wself.peiliaoModel = model;
                wself.peiliaoView.stateValue = wself.peiliaoModel.status.integerValue;
            }
            if ([model.name isEqualToString:@"用户须知"]) {
                wself.userModel = model;
                wself.userView.stateValue = wself.userModel.status.integerValue;
            }
        }
    } errorBack:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}

- (ASAuthOrSafetyItemView *)rationalView {
    if (!_rationalView) {
        _rationalView = [[ASAuthOrSafetyItemView alloc]init];
        _rationalView.icon.image = [UIImage imageNamed:@"anquan1"];
        _rationalView.title.text = @"理性消费";
        _rationalView.hidden = USER_INFO.gender == 2 ? NO : YES;
        _rationalView.itemType = kSafetyItemType;
        kWeakSelf(self);
        _rationalView.actionBlock = ^{
            ASSecurityConsumptionController *vc = [[ASSecurityConsumptionController alloc] init];
            [wself.navigationController pushViewController:vc animated:YES];
        };
    }
    return _rationalView;
}

- (ASAuthOrSafetyItemView *)peiliaoView {
    if (!_peiliaoView) {
        _peiliaoView = [[ASAuthOrSafetyItemView alloc]init];
        _peiliaoView.icon.image = [UIImage imageNamed:@"anquan2"];
        _peiliaoView.title.text = @"陪聊须知";
        _peiliaoView.itemType = kSafetyItemType;
        kWeakSelf(self);
        _peiliaoView.actionBlock = ^{
            if (kStringIsEmpty(wself.peiliaoModel.url)) {
                return;
            }
            ASBaseWebViewController *h5Vc = [[ASBaseWebViewController alloc]init];
            h5Vc.webUrl = wself.peiliaoModel.url;
            h5Vc.notifylogID = wself.peiliaoModel.logId;
            [wself.navigationController pushViewController:h5Vc animated:YES];
        };
    }
    return _peiliaoView;
}

- (ASAuthOrSafetyItemView *)inviteView {
    if (!_inviteView) {
        _inviteView = [[ASAuthOrSafetyItemView alloc]init];
        _inviteView.icon.image = [UIImage imageNamed:@"anquan3"];
        _inviteView.title.text = @"邀请须知";
        _inviteView.itemType = kSafetyItemType;
        kWeakSelf(self);
        _inviteView.actionBlock = ^{
            if (kStringIsEmpty(wself.inviteModel.url)) {
                return;
            }
            ASBaseWebViewController *h5Vc = [[ASBaseWebViewController alloc]init];
            h5Vc.webUrl = wself.inviteModel.url;
            h5Vc.notifylogID = wself.inviteModel.logId;
            [wself.navigationController pushViewController:h5Vc animated:YES];
        };
    }
    return _inviteView;
}

- (ASAuthOrSafetyItemView *)userView {
    if (!_userView) {
        _userView = [[ASAuthOrSafetyItemView alloc]init];
        _userView.icon.image = [UIImage imageNamed:@"anquan4"];
        _userView.title.text = @"用户须知";
        _userView.itemType = kSafetyItemType;
        kWeakSelf(self);
        _userView.actionBlock = ^{
            if (kStringIsEmpty(wself.userModel.url)) {
                return;
            }
            ASBaseWebViewController *h5Vc = [[ASBaseWebViewController alloc]init];
            h5Vc.webUrl = wself.userModel.url;
            h5Vc.notifylogID = wself.userModel.logId;
            [wself.navigationController pushViewController:h5Vc animated:YES];
        };
    }
    return _userView;
}
@end
