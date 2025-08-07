//
//  ASFriendHomeController.m
//  AS
//
//  Created by SA on 2025/5/14.
//

#import "ASFriendHomeController.h"
#import "心聊想伴-Swift.h"
#import "ASFansListController.h"
#import "ASFollowListController.h"

@interface ASFriendHomeController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) UIView *titlesView;
@property (nonatomic, strong) UIScrollView *contentView;
@end

@implementation ASFriendHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
    [self setupChildVC];
    [self setupTitlesView];
    [self setupContentView];
}

- (void)setupChildVC {
    UIViewController *vc1 = [ASIMFuncManager friendListController];
    [self addChildViewController:vc1];
    ASFollowListController *vc2 = [[ASFollowListController alloc]init];
    vc2.view.backgroundColor = UIColor.clearColor;
    [self addChildViewController:vc2];
    ASFansListController *vc3 = [[ASFansListController alloc]init];
    vc3.view.backgroundColor = UIColor.clearColor;
    [self addChildViewController:vc3];
}

- (void)setupTitlesView {
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor clearColor];
    titlesView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    NSArray *titles = @[@"亲密", @"关注", @"粉丝"];
    CGFloat width = 48;
    CGFloat height = 26;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.frame = CGRectMake(i*(width + 20) + 14, 7, width, height);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [button setBackgroundImage:[ASCommonFunc createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[ASCommonFunc createImageWithColor:MAIN_COLOR] forState:UIControlStateSelected];
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = TEXT_FONT_14;
        button.layer.cornerRadius = 13;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        if (i == 0) {
            button.selected = YES;
            self.selectedBtn = button;
            [button.titleLabel sizeToFit];
        }
    }
}

- (void)titleClick:(UIButton *)button{
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

- (void)setupContentView {
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = UIColor.clearColor;
    contentView.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - HEIGHT_NAVBAR);
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.showsHorizontalScrollIndicator = NO;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    [self scrollViewDidEndScrollingAnimation:contentView];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;
    vc.view.height = scrollView.height;
    [scrollView addSubview:vc.view];
    if (index == 0) {
        scrollView.scrollEnabled = NO;
    } else {
        scrollView.scrollEnabled = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}

#pragma mark - JXPagingViewListViewDelegate
- (UIView *)listView {
    return self.view;
}
@end
