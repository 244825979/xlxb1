//
//  ASIncomeRecordHomeController.m
//  AS
//
//  Created by SA on 2025/6/26.
//

#import "ASIncomeRecordHomeController.h"
#import <JXCategoryView/JXCategoryView.h>
#import <JXPagerView.h>
#import "ASIncomeRecordListController.h"

@interface ASIncomeRecordHomeController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) ASIncomeRecordListController *payIncomeVc;//收支记录
@property (nonatomic, strong) ASIncomeRecordListController *sendBackVc;//退回列表
@property (nonatomic, strong) NSArray *titles;
@end

@implementation ASIncomeRecordHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"收支记录";
    [self createUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.listContainerView.scrollView.scrollEnabled = NO;
}

- (void)createUI {
    kWeakSelf(self);
    [self.view addSubview:self.categoryView];
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerView.frame = CGRectMake(0,
                                              SCALES(44),
                                              SCREEN_WIDTH,
                                              SCREEN_HEIGHT - SCALES(44));
    [self.view addSubview:self.listContainerView];
    self.categoryView.listContainer = self.listContainerView;
    //导航按钮
    UIButton *screen = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    screen.adjustsImageWhenHighlighted = NO;
    [screen setImage:[UIImage imageNamed:@"saixuan_time"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:screen];
    [[screen rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        switch (wself.selectIndex) {
            case 0:
                [wself.payIncomeVc selectDateOnRefresh];
                break;
            case 1:
                [wself.sendBackVc selectDateOnRefresh];
                break;
            default:
                break;
        }
    }];
}

#pragma mark - JXCategoryViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    ASIncomeRecordListController *vc = [[ASIncomeRecordListController alloc] init];
    vc.type = index;
    if (index == 0) {
        self.payIncomeVc = vc;
    } else if (index == 1) {
        self.sendBackVc = vc;
    }
    return vc;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

#pragma mark - JXCategoryViewDelegate
//是否可以点击item
- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index {
    return YES;
}
//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.selectIndex = index;
    if (index == 0) {
        self.listContainerView.scrollView.scrollEnabled = NO;
    } else {
        self.listContainerView.scrollView.scrollEnabled = YES;
    }
}
- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, SCALES(44))];
        _categoryView.backgroundColor = UIColor.whiteColor;
        _categoryView.delegate = self;
        _categoryView.titleColor = TEXT_SIMPLE_COLOR;
        _categoryView.titleSelectedColor = TITLE_COLOR;
        _categoryView.titleFont = TEXT_FONT_16;
        _categoryView.titleSelectedFont = TEXT_MEDIUM(20);
        _categoryView.titles = self.titles;
        _categoryView.contentEdgeInsetLeft = SCALES(18);
        _categoryView.cellSpacing = SCALES(24);
        _categoryView.averageCellSpacingEnabled = NO;
        // 初始化指示器视图
        JXCategoryIndicatorImageView *indicatorImageView = [[JXCategoryIndicatorImageView alloc] init];
        indicatorImageView.verticalMargin = 0;
        indicatorImageView.indicatorImageView.image = [UIImage imageNamed:@"bottom_icon"];
        indicatorImageView.indicatorImageViewSize = CGSizeMake(SCALES(24), SCALES(8));
        _categoryView.indicators = @[indicatorImageView];
    }
    return _categoryView;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = kAppType == 0 ? @[@"收支", @"退回"] : @[@"收支"];
    }
    return _titles;
}
@end
