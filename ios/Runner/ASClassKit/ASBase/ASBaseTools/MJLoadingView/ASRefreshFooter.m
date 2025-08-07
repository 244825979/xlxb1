
#import "ASRefreshFooter.h"

@interface ASRefreshFooter()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@end

@implementation ASRefreshFooter

- (void)prepare {
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = SCALES(50);
    
    //添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = TEXT_SIMPLE_COLOR;
    label.font = TEXT_FONT_12;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    self.label.frame = self.bounds;
    self.loading.center = CGPointMake(self.mj_w/2, self.mj_h - SCALES(20));
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            [self.loading startAnimating];
            break;
        case MJRefreshStateWillRefresh:
            [self.loading startAnimating];
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"暂无更多数据";
            [self.loading stopAnimating];
            break;
        case MJRefreshStatePulling:
            self.label.text = @"加载完成";
            [self.loading startAnimating];
            break;
        default:
            break;
    }
}

@end
