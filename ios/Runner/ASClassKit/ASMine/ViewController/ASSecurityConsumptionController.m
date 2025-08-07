//
//  ASSecurityConsumptionController.m
//  AS
//
//  Created by SA on 2025/5/22.
//

#import "ASSecurityConsumptionController.h"
#import "ASConsumptionNameView.h"
#import "ASConsumptionRenzhengView.h"
#import "ASConsumptionModel.h"
#import "ASConsumptionLimitListView.h"
#import "ASAuthHomeController.h"

@interface ASSecurityConsumptionController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ASConsumptionNameView *nameView;
@property (nonatomic, strong) ASConsumptionRenzhengView *cardView;
@property (nonatomic, strong) ASConsumptionLimitListView *listView;
/**数据**/
@property (nonatomic, strong) ASConsumptionModel *consumeModel;
@end

@implementation ASSecurityConsumptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self createUI];
    [self requestData];
}

- (void)createUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    kWeakSelf(self);
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.image = [UIImage imageNamed:@"consumption_top"];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:bgImageView];
    [bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(STATUS_BAR_HEIGHT > 20 ? 0 : -24);
        make.left.equalTo(self.scrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCALES(169)+ HEIGHT_NAVBAR);
    }];
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    [bgImageView addSubview:backBtn];
    [backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.height.width.mas_equalTo(44);
    }];
    [self.scrollView addSubview:self.nameView];
    [self.nameView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.mas_equalTo(HEIGHT_NAVBAR + SCALES(71));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(32));
        make.height.mas_equalTo(SCALES(126));
    }];
    [self.scrollView addSubview:self.cardView];
    [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameView);
        make.top.equalTo(self.nameView.mas_bottom).offset(SCALES(14));
        make.height.mas_equalTo(SCALES(94));
    }];
    [self.scrollView addSubview:self.listView];
    [self.listView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameView);
        make.top.equalTo(self.cardView.mas_bottom).offset(SCALES(14));
        make.height.mas_equalTo(SCALES(400));
    }];
    self.scrollView.contentSize = CGSizeMake(0, wself.consumeModel.is_extra == 0 ? SCALES(730) : SCALES(830));
}

- (void)requestData {
    kWeakSelf(self);
    [ASCommonRequest requestMyConsumeInfoSuccess:^(id  _Nullable data) {
        wself.consumeModel = data;
        wself.cardView.model = data;
        wself.listView.model = data;
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = NO;//隐藏滚动条
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (ASConsumptionNameView *)nameView {
    if (!_nameView) {
        _nameView = [[ASConsumptionNameView alloc]init];
    }
    return _nameView;
}

- (ASConsumptionRenzhengView *)cardView {
    if (!_cardView) {
        _cardView = [[ASConsumptionRenzhengView alloc]init];
        kWeakSelf(self);
        _cardView.actionBlock = ^{
            ASAuthHomeController *vc = [[ASAuthHomeController alloc]init];
            [wself.navigationController pushViewController:vc animated:YES];
        };
    }
    return _cardView;
}

- (ASConsumptionLimitListView *)listView {
    if (!_listView) {
        _listView = [[ASConsumptionLimitListView alloc]init];
    }
    return _listView;
}

@end
