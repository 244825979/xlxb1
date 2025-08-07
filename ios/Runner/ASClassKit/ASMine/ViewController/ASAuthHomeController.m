//
//  ASAuthHomeController.m
//  AS
//
//  Created by SA on 2025/5/21.
//

#import "ASAuthHomeController.h"
#import "ASAuthOrSafetyItemView.h"
#import "ASCertificationOneController.h"

@interface ASAuthHomeController ()
@property (nonatomic, strong) ASAuthOrSafetyItemView *phoneAuth;
@property (nonatomic, strong) ASAuthOrSafetyItemView *nameAuth;
@property (nonatomic, strong) ASAuthOrSafetyItemView *rpAuth;
@end

@implementation ASAuthHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)requestData {
    kWeakSelf(self);
    [ASCommonRequest requestAuthStateWithIsRequest:NO success:^(id  _Nullable data) {
        wself.nameAuth.stateValue = USER_INFO.is_auth;
        wself.rpAuth.stateValue = USER_INFO.is_rp_auth;
    } errorBack:^(NSInteger code, NSString *msg) {
    }];
}

- (void)createUI {
    kWeakSelf(self);
    UIImageView *headBg = [[UIImageView alloc] init];
    headBg.image = [UIImage imageNamed:@"auth_top"];
    [self.view addSubview:headBg];
    [headBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(STATUS_BAR_HEIGHT > 20 ? 0 : -24);
        make.height.mas_equalTo(SCALES(154)+44+STATUS_BAR_HEIGHT);
    }];
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.adjustsImageWhenHighlighted = NO;
    [backBtn setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
    [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    UIView *itemBg = [[UIView alloc] init];
    itemBg.backgroundColor = UIColor.whiteColor;
    itemBg.frame = CGRectMake(0, SCALES(135)+44+STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - (SCALES(135)+44+STATUS_BAR_HEIGHT));
    [self.view addSubview:itemBg];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:itemBg.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(SCALES(12), SCALES(12))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = itemBg.bounds;
    maskLayer.path = maskPath.CGPath;
    itemBg.layer.mask = maskLayer;
    if (USER_INFO.gender == 1) {//女
        [itemBg addSubview:self.phoneAuth];
        [self.phoneAuth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(itemBg);
            make.top.mas_equalTo(SCALES(7));
            make.height.mas_equalTo(SCALES(82));
        }];
        [itemBg addSubview:self.nameAuth];
        [self.nameAuth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(self.phoneAuth);
            make.top.equalTo(self.phoneAuth.mas_bottom);
        }];
        [itemBg addSubview:self.rpAuth];
        [self.rpAuth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(self.phoneAuth);
            make.top.equalTo(self.nameAuth.mas_bottom);
        }];
    } else {
        [itemBg addSubview:self.phoneAuth];
        [self.phoneAuth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(itemBg);
            make.top.mas_equalTo(SCALES(7));
            make.height.mas_equalTo(SCALES(82));
        }];
        [itemBg addSubview:self.nameAuth];
        [self.nameAuth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(self.phoneAuth);
            make.top.equalTo(self.phoneAuth.mas_bottom);
        }];
    }
}

- (ASAuthOrSafetyItemView *)phoneAuth {
    if (!_phoneAuth) {
        _phoneAuth = [[ASAuthOrSafetyItemView alloc]init];
        _phoneAuth.icon.image = [UIImage imageNamed:@"auth_phone"];
        _phoneAuth.title.text = @"手机认证";
        _phoneAuth.itemType = kAuthItemType;
        _phoneAuth.stateValue = 1;
        _phoneAuth.actionBlock = ^{
            kShowToast(@"你已经认证过啦！");
        };
    }
    return _phoneAuth;
}

- (ASAuthOrSafetyItemView *)nameAuth {
    if (!_nameAuth) {
        _nameAuth = [[ASAuthOrSafetyItemView alloc]init];
        _nameAuth.icon.image = [UIImage imageNamed:@"auth_shiming"];
        _nameAuth.title.text = @"实名认证";
        _nameAuth.itemType = kAuthItemType;
        kWeakSelf(self);
        _nameAuth.actionBlock = ^{
            [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthPopIDCard succeed:^{
                if (USER_INFO.is_auth == 1) {
                    kShowToast(@"你已经认证过啦！");
                    return;
                }
                if (USER_INFO.is_auth == 2) {
                    kShowToast(@"认证审核中，请耐心等待审核");
                    return;
                }
                ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                vc.webUrl = USER_INFO.systemIndexModel.faceAuth;
                [wself.navigationController pushViewController:vc animated:YES];
            }];
        };
    }
    return _nameAuth;
}

- (ASAuthOrSafetyItemView *)rpAuth {
    if (!_rpAuth) {
        _rpAuth = [[ASAuthOrSafetyItemView alloc]init];
        _rpAuth.icon.image = [UIImage imageNamed:@"auth_zhenren"];
        _rpAuth.title.text = @"真人认证";
        _rpAuth.itemType = kAuthItemType;
        kWeakSelf(self);
        _rpAuth.actionBlock = ^{
            if (USER_INFO.is_rp_auth == 1) {
                kShowToast(@"你已经认证过啦！");
                return;
            }
            if (USER_INFO.is_rp_auth == 2) {
                kShowToast(@"认证审核中，请耐心等待审核");
                return;
            }
            ASCertificationOneController *vc = [[ASCertificationOneController alloc]init];
            vc.userAvatar = USER_INFO.avatar;
            [wself.navigationController pushViewController:vc animated:YES];
        };
    }
    return _rpAuth;
}
@end
