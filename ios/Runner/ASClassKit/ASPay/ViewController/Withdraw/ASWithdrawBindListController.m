//
//  ASWithdrawBindListController.m
//  AS
//
//  Created by SA on 2025/6/27.
//

#import "ASWithdrawBindListController.h"
#import "ASPayRequest.h"
#import "ASBindAccountListModel.h"

@interface ASWithdrawBindListController ()
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *account;
@property (nonatomic, strong) UILabel *mobile;
@property (nonatomic, strong) UIImageView *icon;
@end

@implementation ASWithdrawBindListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"提现账号";
    [self createUI];
    [self requestData];
}

- (void)createUI {
    UIView *accountDataBgView = [[UIView alloc]init];
    accountDataBgView.backgroundColor = UIColorRGB(0xF5F5F5);
    accountDataBgView.layer.cornerRadius = SCALES(10);
    [self.view addSubview:accountDataBgView];
    [accountDataBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(SCALES(16));
        make.top.mas_equalTo(SCALES(16));
        make.right.equalTo(self.view).offset(SCALES(-16));
        make.height.mas_equalTo(SCALES(140));
    }];
    [accountDataBgView addSubview:self.icon];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.mas_equalTo(SCALES(22));
        make.height.width.mas_equalTo(SCALES(24));
    }];
    [self.view addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(SCALES(10));
        make.centerY.equalTo(self.icon);
        make.height.mas_equalTo(SCALES(20));
    }];
    [self.view addSubview:self.account];
    [self.account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.top.equalTo(self.name.mas_bottom).offset(SCALES(16));
        make.height.mas_equalTo(SCALES(20));
    }];
    [self.view addSubview:self.mobile];
    [self.mobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.top.equalTo(self.account.mas_bottom).offset(SCALES(16));
        make.height.mas_equalTo(SCALES(20));
    }];
}

- (void)requestData {
    kWeakSelf(self);
    [ASPayRequest requestAccountListWithSuccess:^(id  _Nullable data) {
        NSArray *list = data;
        if (list.count > 0) {
            ASBindAccountListModel *model = list[0];
            wself.name.text = [NSString stringWithFormat:@"姓名：%@",STRING(model.card_name)];
            wself.account.text = [NSString stringWithFormat:@"提现账号：%@",STRING(model.card_account)];
            wself.mobile.text = [NSString stringWithFormat:@"手机号：%@",STRING(model.mobile)];
            [wself.icon sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.card_icon]]];
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textColor = TITLE_COLOR;
        _name.font = TEXT_FONT_15;
    }
    return _name;
}

- (UILabel *)account {
    if (!_account) {
        _account = [[UILabel alloc]init];
        _account.textColor = TITLE_COLOR;
        _account.font = TEXT_FONT_15;
    }
    return _account;
}

- (UILabel *)mobile {
    if (!_mobile) {
        _mobile = [[UILabel alloc]init];
        _mobile.textColor = TITLE_COLOR;
        _mobile.font = TEXT_FONT_15;
    }
    return _mobile;
}
@end
