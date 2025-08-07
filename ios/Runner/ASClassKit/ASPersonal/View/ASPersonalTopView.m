//
//  ASPersonalTopView.m
//  AS
//
//  Created by SA on 2025/4/24.
//

#import "ASPersonalTopView.h"
#import "ASPersonalTopBannerCell.h"
#import "ASVideoShowPlayController.h"
#import "ASPersonalSmallBannerCell.h"
#import "ASBaseVoicePlayView.h"
#import "ASPersonalTopUserView.h"

@interface ASPersonalTopView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *wallBannerView;
@property (nonatomic, strong) UICollectionView *smallWallBannerView;
@property (nonatomic, strong) ASBaseVoicePlayView *voicePlayer;
@property (nonatomic, strong) ASPersonalTopUserView *userDataView;
/**数据**/
@property (nonatomic, strong) ASAlbumsModel *videoShowModel;
@property (nonatomic, strong) NSMutableArray<ASAlbumsModel *> *banners;
@property (nonatomic, strong) NSArray *bannerUrls;
@end

@implementation ASPersonalTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat itemW = SCREEN_WIDTH;
        CGFloat itemH = floorf(SCALES(242) + HEIGHT_NAVBAR);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        self.wallBannerView = ({
            UICollectionView *bannerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, itemW, itemH) collectionViewLayout:layout];
            bannerView.tag = 1;
            bannerView.dataSource = self;
            bannerView.delegate = self;
            bannerView.showsHorizontalScrollIndicator = NO;
            bannerView.showsVerticalScrollIndicator = NO;
            bannerView.pagingEnabled = YES;
            [self addSubview:bannerView];
            bannerView;
        });
        CGFloat itemWH = SCALES(48);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = SCALES(4);
        flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.smallWallBannerView = ({
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCALES(92), SCALES(162) + HEIGHT_NAVBAR, SCREEN_WIDTH - SCALES(106), itemWH) collectionViewLayout:flowLayout];
            collectionView.tag = 2;
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.backgroundColor = UIColor.clearColor;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            [self addSubview:collectionView];
            collectionView;
        });
        [self.smallWallBannerView registerClass:[ASPersonalSmallBannerCell class] forCellWithReuseIdentifier:@"smallBannerViewCell"];
        [self addSubview:self.voicePlayer];
        self.voicePlayer.frame = CGRectMake(SCALES(16), SCALES(182) + HEIGHT_NAVBAR, SCALES(64), SCALES(28));
        self.userDataView.frame = CGRectMake(0, SCALES(226) + HEIGHT_NAVBAR, SCREEN_WIDTH, SCALES(112));
        [self addSubview:self.userDataView];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.userDataView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(SCALES(16), SCALES(16))];
         CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.userDataView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.userDataView.layer.mask = maskLayer;
    }
    return self;
}

- (void)initPlayer {
    TXVodPlayer *voidPlayer = [[TXVodPlayer alloc] init];
    TXVodPlayConfig *cfg = voidPlayer.config;
    if (cfg == nil) {
        cfg = [[TXVodPlayConfig alloc] init];
    }
    cfg.cacheFolderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/txcache"];
    cfg.maxCacheItems = 30;
    voidPlayer.config = cfg;
    voidPlayer.isAutoPlay = YES;
    [voidPlayer setMute:YES];
    voidPlayer.enableHWAcceleration = YES;
    [voidPlayer setRenderRotation:HOME_ORIENTATION_DOWN];
    [voidPlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
    voidPlayer.loop = YES;
    self.currentPlayer = voidPlayer;
}

- (void)setHomeModel:(ASUserInfoModel *)homeModel {
    _homeModel = homeModel;
    self.banners = [NSMutableArray arrayWithArray:homeModel.albums];
    self.userDataView.model = homeModel;
    BOOL hasVideoShow = NO;
    //循环拿到banner的url数组
    NSMutableArray *smallUrls = [NSMutableArray array];
    for (int i = 0; i < homeModel.albums.count; i++) {
        ASAlbumsModel *model = homeModel.albums[i];
        if (model.is_video_show == 1) {//有视频秀
            hasVideoShow = YES;
            [smallUrls addObject:STRING(model.cover_img_url)];
            [smallUrls addObject:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, homeModel.avatar]];
            ASAlbumsModel *imageModel = [[ASAlbumsModel alloc] init];
            imageModel.url = STRING(homeModel.avatar);
            imageModel.is_video = 0;
            imageModel.is_video_show = 0;
            [self.banners insertObject:imageModel atIndex:1];
            self.videoShowModel = model;
        } else {
            [smallUrls addObject:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL,model.url]];
        }
    }
    if (homeModel.gender == 1 && !kObjectIsEmpty(self.videoShowModel)) {//女用户且有视频秀数据，初始化视频秀
        if (self.currentPlayer == nil) {
            [self initPlayer];
        }
    }
    self.bannerUrls = smallUrls;
    [self.wallBannerView reloadData];
    [self.smallWallBannerView reloadData];
    if (hasVideoShow == YES) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.wallBannerView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    CGFloat countW;
    if (self.bannerUrls.count == 1) {
        countW = SCALES(48);
    } else {
        countW = (self.bannerUrls.count * (SCALES(48) + SCALES(6))) - SCALES(6);
    }
    if (!kStringIsEmpty(homeModel.voice.voice)) {
        CGFloat collectionViewW = (countW > (SCREEN_WIDTH - SCALES(106))) ? SCREEN_WIDTH - SCALES(106) : countW;
        self.smallWallBannerView.frame = CGRectMake(SCREEN_WIDTH - collectionViewW - SCALES(14),
                                                    SCALES(162) + HEIGHT_NAVBAR,
                                                    collectionViewW,
                                                    SCALES(48));
    } else {
        CGFloat collectionViewW = (countW > SCREEN_WIDTH - SCALES(28)) ? SCREEN_WIDTH - SCALES(28) : countW;
        self.smallWallBannerView.frame = CGRectMake(SCREEN_WIDTH - collectionViewW - SCALES(14),
                                                    SCALES(162) + HEIGHT_NAVBAR,
                                                    collectionViewW,
                                                    SCALES(48));
    }
    if (!kStringIsEmpty(homeModel.voice.voice)) {
        self.voicePlayer.hidden = NO;
        self.voicePlayer.model = homeModel.voice;
    } else {
        self.voicePlayer.hidden = YES;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.smallWallBannerView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)setUserRemarkStr:(NSString *)userRemarkStr {
    _userRemarkStr = userRemarkStr;
    self.userDataView.userRemarkStr = userRemarkStr;
}

#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 1) {
        return self.banners.count;
    }
    return self.bannerUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        NSString *identifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
        [collectionView registerClass: [ASPersonalTopBannerCell class] forCellWithReuseIdentifier:identifier];
        ASPersonalTopBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        ASAlbumsModel *model = self.banners[indexPath.row];
        cell.model = model;
        if (!kStringIsEmpty(model.video_url) && self.currentPlayer.isPlaying == NO) {//有视频播放
            [self.currentPlayer setupVideoWidget:cell.portraitView insertIndex:0];
            int result = [self.currentPlayer startVodPlay:STRING(model.video_url)];
            if (result != 0) {
                kShowToast(@"播放失败");
            }
        }
        return cell;
    } else {
        ASPersonalSmallBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"smallBannerViewCell" forIndexPath:indexPath];
        cell.photoUrl = self.bannerUrls[indexPath.row];//设置cell的数据
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        ASAlbumsModel *model = self.banners[indexPath.row];
        if (model.is_video_show == 1) {
            ASVideoShowDataModel *videoModel = [[ASVideoShowDataModel alloc] init];
            videoModel.ID = model.video_show_id;
            videoModel.user_id = self.userID;
            videoModel.cover_img_url = model.cover_img_url;
            ASVideoShowPlayController *vc = [[ASVideoShowPlayController alloc] init];
            vc.model = videoModel;
            if ([self.userID isEqualToString:USER_INFO.user_id]) {
                vc.popType = kVideoPlayMyListVideo;
            } else {
                vc.popType = kVideoPlayPersonalHome;
            }
            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
        } else {
            NSMutableArray *photos = [NSMutableArray array];
            [self.bannerUrls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GKPhoto *photo = [[GKPhoto alloc] init];
                if ([obj isKindOfClass:UIImage.class]) {
                    photo.image = obj;
                } else {
                    NSString *objURL = obj;
                    NSString *url = STRING(objURL);
                    photo.url = [NSURL URLWithString:url];
                }
                [photos addObject:photo];
            }];
            [[ASUploadImageManager shared] showMediaWithPhotos:photos index:indexPath.row viewController:[ASCommonFunc currentVc]];
        }
    } else {
        [self.wallBannerView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        ASAlbumsModel *model = self.banners[indexPath.row];
        if (model.is_video_show == 1) {
            [self.currentPlayer resume];
        } else {
            [self.currentPlayer pause];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        CGFloat indexF = (scrollView.contentOffset.x+1.00) / SCREEN_WIDTH;
        NSInteger index = floor(indexF);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.smallWallBannerView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        UICollectionViewLayoutAttributes *attributes = [self.smallWallBannerView layoutAttributesForItemAtIndexPath:indexPath];
        CGFloat collectionViewW = SCREEN_WIDTH - SCALES(110);
        if (attributes.frame.origin.x > collectionViewW - SCALES(112)) {
            CGPoint offset = CGPointMake(attributes.frame.origin.x - SCALES(112), 0);
            [self.smallWallBannerView setContentOffset:offset animated:YES];
        } else if (attributes.frame.origin.x < collectionViewW) {
            CGPoint offset = CGPointMake(0, 0);
            [self.smallWallBannerView setContentOffset:offset animated:YES];
        }
        if (self.currentPlayer != nil) {
            ASAlbumsModel *model = self.banners[index];
            if (model.is_video_show == 1) {
                [self.currentPlayer resume];
            } else {
                [self.currentPlayer pause];
            }
        }
    }
}

- (ASBaseVoicePlayView *)voicePlayer {
    if (!_voicePlayer) {
        _voicePlayer = [[ASBaseVoicePlayView alloc]init];
        _voicePlayer.layer.cornerRadius = SCALES(14);
        _voicePlayer.layer.masksToBounds = YES;
        _voicePlayer.type = 1;
        _voicePlayer.hidden = YES;
    }
    return _voicePlayer;
}

- (ASPersonalTopUserView *)userDataView {
    if (!_userDataView) {
        _userDataView = [[ASPersonalTopUserView alloc]init];
        _userDataView.backgroundColor = UIColor.whiteColor;
    }
    return _userDataView;
}
@end
