//
//  ASHomeTopView.m
//  AS
//
//  Created by SA on 2025/4/16.
//

#import "ASHomeTopView.h"
#import "ASHomeLikeListView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface ASHomeTopView ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) ASHomeLikeListView *likeView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;//banner
@end

@implementation ASHomeTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        kWeakSelf(self);
        NSArray *icons = @[@"home_top_item1", @"home_top_item2", @"home_top_item3", @"home_top_item4"];
        CGFloat itemW = (SCREEN_WIDTH - SCALES(32) - SCALES(27)) /icons.count;
        for (int i = 0; i < icons.count; i++) {
            UIImageView *itemView = [[UIImageView alloc] init];
            itemView.frame = CGRectMake(SCALES(16) + (itemW+SCALES(9))*i, SCALES(12), itemW, SCALES(84));
            itemView.image = [UIImage imageNamed:icons[i]];
            itemView.userInteractionEnabled = YES;
            [self addSubview:itemView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [itemView addGestureRecognizer:tap];
            [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                if (wself.indexBlock) {
                    wself.indexBlock(i);
                }
            }];
        }
        [self addSubview:self.likeView];
        [self.likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(108));
            make.left.right.equalTo(self);
            make.height.mas_equalTo(SCALES(186));
        }];
        
        self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(SCALES(14),
                                                                                 SCALES(106),
                                                                                 floorf(SCREEN_WIDTH - SCALES(28)),//取整
                                                                                 SCALES(70)) delegate:self placeholderImage:nil];
        self.bannerView.hidden = YES;
        self.bannerView.backgroundColor = UIColor.whiteColor;
        self.bannerView.autoScrollTimeInterval = 3.0f;
        self.bannerView.showPageControl = NO;//隐藏分页控制器
        self.bannerView.layer.cornerRadius = SCALES(8);
        self.bannerView.layer.masksToBounds = YES;
        [self addSubview:self.bannerView];
    }
    return self;
}

- (void)setLikes:(NSArray *)likes {
    _likes = likes;
    self.likeView.likes = likes;
    if (likes.count == 0 || USER_INFO.systemIndexModel.you_like_switch_home == 0) {
        self.likeView.hidden = YES;
    } else {
        self.likeView.hidden = NO;
    }
    if (self.banners.count > 0) {
        self.bannerView.hidden = NO;
        [self.likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerView.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(SCALES(186));
        }];
    } else {
        self.bannerView.hidden = YES;
        [self.likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(108));
            make.left.right.equalTo(self);
            make.height.mas_equalTo(SCALES(186));
        }];
    }
}

- (void)setBanners:(NSArray *)banners {
    _banners = banners;
    if (banners.count > 0) {
        NSMutableArray *urls = [NSMutableArray array];
        for (ASBannerModel *model in banners) {
            [urls addObject:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL,model.image]];
        }
        self.bannerView.imageURLStringsGroup = urls;
        [self.bannerView adjustWhenControllerViewWillAppera];
    }
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    ASBannerModel *model = self.banners[index];
    [ASMyAppCommonFunc bannerClikedWithBannerModel:model viewController:[ASCommonFunc currentVc] action:^(id  _Nonnull data) {
    }];
}

- (ASHomeLikeListView *)likeView {
    if (!_likeView) {
        _likeView = [[ASHomeLikeListView alloc]init];
        _likeView.hidden = YES;
        kWeakSelf(self);
        _likeView.actionBlock = ^{
            if (wself.actionBlock) {
                wself.actionBlock();
            }
        };
    }
    return _likeView;
}
@end
