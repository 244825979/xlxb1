//
//  ASWithdrawRecordController.m
//  AS
//
//  Created by SA on 2025/6/27.
//

#import "ASWithdrawRecordController.h"
#import "ASWithdrawRecordListController.h"
#import "ASWithdrawRecordListsController.h"

@interface ASWithdrawRecordController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) UIButton *screenBtn;
@property (nonatomic, strong) ASWithdrawRecordListController *earningsVc;//收益列表
@property (nonatomic, strong) ASWithdrawRecordListController *expenditureVc;//支出列表
@property (nonatomic, strong) ASWithdrawRecordListController *sendBackVc;//退还列表
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation ASWithdrawRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"收益记录";
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
    self.screenBtn = ({
        UIButton *screen = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        screen.adjustsImageWhenHighlighted = NO;
        [screen setImage:[UIImage imageNamed:@"saixuan_time"] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:screen];
        [[screen rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            switch (wself.selectIndex) {
                case 0:
                    [wself.earningsVc selectDateOnRefresh];
                    break;
                case 1:
                    [wself.expenditureVc selectDateOnRefresh];
                    break;
                case 3:
                    [wself.sendBackVc selectDateOnRefresh];
                    break;
                default:
                    break;
            }
        }];
        screen;
    });
}

#pragma mark - JXCategoryViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 2) {
        ASWithdrawRecordListsController *vc = [[ASWithdrawRecordListsController alloc] init];
        return vc;
    } else {
        ASWithdrawRecordListController *vc = [[ASWithdrawRecordListController alloc] init];
        vc.type = index;
        if (index == 0) {
            self.earningsVc = vc;
        } else if (index == 1) {
            self.expenditureVc = vc;
        } else if (index == 3) {
            self.sendBackVc = vc;
        }
        return vc;
    }
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 4;
}

#pragma mark - JXCategoryViewDelegate
//是否可以点击item
- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index {
    return YES;
}

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.selectIndex = index;
    if (index == 2) {
        self.screenBtn.hidden = YES;
    } else {
        self.screenBtn.hidden = NO;
    }
    
    if (index == 0 || index == 1 || index == 2) {
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
        _categoryView.titles = @[@"收益", @"支出", @"提现", @"退还"];
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
@end
