//
//  ASDynamicController.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASDynamicController.h"
#import <JXCategoryView/JXCategoryView.h>
#import <JXPagerView.h>
#import "ASDynamicListController.h"
#import "ASDynamicPublishController.h"
#import "ASDynamicNotifyController.h"
#import "ASDynamicRequest.h"

@interface ASDynamicController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) UIButton *notifiBtn;
@property (nonatomic, strong) UIButton *publishBtn;
@property (nonatomic, strong) UIView *redView;
/**数据**/
@property (nonatomic, strong) ASDynamicListController *dynamicVc;
@property (nonatomic, strong) ASDynamicListController *attentionVc;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation ASDynamicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    [self createUI];
    [[ASPopViewManager shared] activityPopWithPlacement:2 vc:self isPopWindow:YES affirmAction:^{
        
    } cancelBlock:^{
        
    }];//活动弹窗
    kWeakSelf(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"updataDynamicNotifyCountNitification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [wself requestNotifyCount];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dynamicListHomeNotification" object:nil];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"dynamicListRefreshNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSArray *array = x.object[@"list"];
        if (array.count > 0) {
            [wself.dynamicVc refreshWithArray:array];
        } else {
            [wself.dynamicVc onRefresh];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([ASPopViewManager shared].popGoodAnchorState == 2 || [ASPopViewManager shared].popGoodAnchorState == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goodAnchorConfigNotification" object:nil];
    }
    [self requestNotifyCount];
}

- (void)createUI {
    kWeakSelf(self);
    UIImageView *topBg = [[UIImageView alloc]init];
    topBg.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(108) + STATUS_BAR_HEIGHT);
    topBg.image = [UIImage imageNamed:@"dynamic_top"];
    topBg.contentMode = UIViewContentModeScaleAspectFill;
    topBg.userInteractionEnabled = YES;
    [self.view addSubview:topBg];
    [self.view addSubview:self.categoryView];
    self.listContainerView.backgroundColor = UIColor.clearColor;
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerView.frame = CGRectMake(0,
                                              STATUS_BAR_HEIGHT + 44,
                                              SCREEN_WIDTH,
                                              SCREEN_HEIGHT - STATUS_BAR_HEIGHT - 44 - TAB_BAR_HEIGHT);
    [self.view addSubview:self.listContainerView];
    self.categoryView.listContainer = self.listContainerView;
    self.publishBtn = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageNamed:@"publish"] forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthDefaultPop succeed:^{
                ASDynamicPublishController *vc = [[ASDynamicPublishController alloc]init];
                vc.refreshBlock = ^{
                    [wself.dynamicVc onRefresh];
                };
                [wself.navigationController pushViewController:vc animated:YES];
            }];
        }];
        [self.view addSubview:button];
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-SCALES(16));
            make.centerY.equalTo(self.categoryView);
            make.width.mas_equalTo(SCALES(64));
            make.height.mas_equalTo(SCALES(26));
        }];
        button;
    });
    UIButton *notifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [[notifyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ASDynamicNotifyController *vc = [[ASDynamicNotifyController alloc]init];
        [wself.navigationController pushViewController:vc animated:YES];
    }];
    [notifyBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [self.view addSubview:notifyBtn];
    [notifyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.publishBtn.mas_left).offset(SCALES(-16));
        make.centerY.equalTo(self.publishBtn);
        make.width.height.mas_equalTo(SCALES(24));
    }];
    [notifyBtn addSubview:self.redView];
    [self.redView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(notifyBtn);
        make.width.height.mas_equalTo(SCALES(8));
    }];
}

- (void)requestNotifyCount {
    kWeakSelf(self);
    [ASDynamicRequest requestUnreadDynamicCountSuccess:^(NSNumber * _Nullable data) {
        if (data.integerValue > 0) {
            wself.redView.hidden = NO;
        } else {
            wself.redView.hidden = YES;
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

#pragma mark - JXCategoryViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    ASDynamicListController *vc = [[ASDynamicListController alloc] init];
    vc.type = index;
    if (index == 0) {
        self.dynamicVc = vc;
    }
    if (index == 1) {
        self.attentionVc = vc;
    }
    return vc;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index {
    return YES;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = [[NSArray alloc]init];
        _titles = @[@"推荐", @"关注"];
    }
    return _titles;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH - 150, 44)];
        _categoryView.backgroundColor = UIColor.clearColor;
        _categoryView.delegate = self;
        _categoryView.titleColor = TEXT_SIMPLE_COLOR;
        _categoryView.titleSelectedColor = TITLE_COLOR;
        _categoryView.titleFont = TEXT_FONT_16;
        _categoryView.titleSelectedFont = TEXT_MEDIUM(20);
        _categoryView.titles = self.titles;
        _categoryView.contentEdgeInsetLeft = SCALES(18);
        _categoryView.cellSpacing = SCALES(24);
        _categoryView.averageCellSpacingEnabled = NO;
        JXCategoryIndicatorImageView *indicatorImageView = [[JXCategoryIndicatorImageView alloc] init];
        indicatorImageView.verticalMargin = 0;
        indicatorImageView.indicatorImageView.image = [UIImage imageNamed:@"bottom_icon"];
        indicatorImageView.indicatorImageViewSize = CGSizeMake(SCALES(24), SCALES(8));
        _categoryView.indicators = @[indicatorImageView];
    }
    return _categoryView;
}

- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc]init];
        _redView.backgroundColor = RED_COLOR;
        _redView.layer.cornerRadius = SCALES(4);
        _redView.layer.masksToBounds = YES;
        _redView.layer.borderColor = UIColor.whiteColor.CGColor;
        _redView.layer.borderWidth = SCALES(1);
        _redView.hidden = YES;
    }
    return _redView;
}

@end
