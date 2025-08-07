//
//  ASVideoShowMyListContrller.m
//  AS
//
//  Created by SA on 2025/5/13.
//

#import "ASVideoShowMyListContrller.h"
#import "ASVideoShowDemonstrationController.h"
#import "ASVideoShowRequest.h"
#import "ASVideoShowMyListCell.h"

@interface ASVideoShowMyListContrller ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) ASBaseCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ASVideoShowMyListContrller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"我的视频秀";
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self onRefresh];
}

- (void)popVC {
    [self.view endEditing:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createUI {
    self.collectionView.mj_header = [ASRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefresh)];
    self.collectionView.mj_footer = [ASRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(onNextPage)];
    kWeakSelf(self);
    UIView *hintView = [[UIView alloc] init];
    hintView.backgroundColor = BACKGROUNDCOLOR;
    hintView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(34));
    [self.view addSubview:hintView];
    
    UIButton *hintBtn = [[UIButton alloc]init];
    [hintBtn setTitle:@" 优先展示封面视频" forState:UIControlStateNormal];
    [hintBtn setImage:[UIImage imageNamed:@"video_remind"] forState:UIControlStateNormal];
    hintBtn.titleLabel.font = TEXT_FONT_14;
    [hintBtn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [hintView addSubview:hintBtn];
    [hintBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hintView);
        make.left.mas_equalTo(SCALES(16));
    }];
    
    UIButton *lookExample = [[UIButton alloc]init];
    lookExample.titleLabel.font = TEXT_FONT_14;
    NSDictionary *underAttribtDic = @{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:MAIN_COLOR};
    NSMutableAttributedString *underAttr = [[NSMutableAttributedString alloc] initWithString:@"查看示例图" attributes:underAttribtDic];
    [lookExample setAttributedTitle:underAttr forState:UIControlStateNormal];
    [hintView addSubview:lookExample];
    [lookExample mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hintView);
        make.right.equalTo(hintView).offset(SCALES(-16));
    }];
    [[lookExample rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ASVideoShowDemonstrationController *vc = [[ASVideoShowDemonstrationController alloc] init];
        [wself.navigationController pushViewController:vc animated:YES];
    }];
    if (kAppType == 1) {
        lookExample.hidden = YES;
    }
    CGFloat itemW = floorf((SCREEN_WIDTH - SCALES(32) - SCALES(16)) /3);
    CGFloat itemH = SCALES(132);
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumInteritemSpacing = SCALES(8);
    layout.minimumLineSpacing = SCALES(8);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = ({
        ASBaseCollectionView *collectionView = [[ASBaseCollectionView alloc] initWithFrame:CGRectMake(SCALES(16), SCALES(34), SCREEN_WIDTH - SCALES(32), SCREEN_HEIGHT - SCALES(34)) collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.emptyType = kCollectionViewEmptyVideo;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:collectionView];
        collectionView.contentInset = UIEdgeInsetsMake(SCALES(16), 0, TAB_BAR_MAGIN + SCALES(74), 0);
        collectionView;
    });
    [self.collectionView registerClass:[ASVideoShowMyListCell class] forCellWithReuseIdentifier:@"videoShowMyListCell"];
    
    UIButton *nextBtn = [[UIButton alloc] init];
    [nextBtn setTitle:@"上传视频秀" forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    nextBtn.adjustsImageWhenHighlighted = NO;
    nextBtn.titleLabel.font = TEXT_FONT_18;
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = SCALES(25);
    [[nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthPopVideoShow succeed:^{
            [ASVideoShowRequest requestVideoShowCheckDayAcountSuccess:^(id  _Nullable data) {
                [[ASUploadImageManager shared] selectVideoShowPickerWithViewController:wself didFinish:^(UIImage * _Nonnull coverImage, PHAsset * _Nonnull asset) {
                    [ASVideoShowManager popPublishVideoShowWithAssets:asset];
                }];
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        }];
    }];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-TAB_BAR_MAGIN - SCALES(12));
        make.height.mas_equalTo(SCALES(50));
        make.width.mas_equalTo(SCALES(311));
    }];
}

- (void)onRefresh {
    self.page = 1;
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    [self requestList];
    self.collectionView.mj_footer.hidden = NO;
}

- (void)onNextPage{
    if (kObjectIsEmpty(self.lists)){
        self.collectionView.mj_footer.hidden = YES;
        return;
    }
    [self requestList];
}

- (void)requestList {
    kWeakSelf(self);
    [ASVideoShowRequest requestVideoShowListWithPage:self.page success:^(id  _Nullable data) {
        NSArray *array = data;
        if(wself.page == 1){
            wself.lists = [NSMutableArray arrayWithArray:array];
            if (wself.lists.count < 15) {
                wself.collectionView.mj_footer.hidden = YES;
            }
        } else {
            [wself.lists addObjectsFromArray:array];
        }
        wself.page++;
        [wself.collectionView reloadData];
        [wself.collectionView.mj_header endRefreshing];
        [wself.collectionView.mj_footer endRefreshing];
    } errorBack:^(NSInteger code, NSString *msg) {
        [wself.collectionView.mj_header endRefreshing];
        [wself.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASVideoShowMyListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoShowMyListCell" forIndexPath:indexPath];
    cell.model = self.lists[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ASVideoShowDataModel *model = self.lists[indexPath.row];
    ASVideoShowPlayController *vc = [[ASVideoShowPlayController alloc] init];
    vc.model = model;
    vc.popType = kVideoPlayMyListVideo;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
