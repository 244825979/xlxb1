//
//  ASEditUserPhotoWallController.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASEditUserPhotoWallController.h"

@interface ASEditUserPhotoWallController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, assign) NSInteger maxImageCount;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UILabel *subTitle;
@end

@implementation ASEditUserPhotoWallController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"个人相册";
    [self createUI];
    
}

- (void)createUI {
    kWeakSelf(self);
    //导航按钮
    self.saveBtn = ({
        UIButton *save = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCALES(48), SCALES(26))];
        [save setTitle:@"保存" forState:UIControlStateNormal];
        if (self.photos.count > 0) {
            [save setBackgroundColor: GRDUAL_CHANGE_BG_COLOR(SCALES(48), SCALES(26))];
            save.userInteractionEnabled = YES;
        } else {
            [save setBackgroundColor: UIColorRGB(0xCCCCCC)];
            save.userInteractionEnabled = NO;
        }
        save.titleLabel.font = TEXT_FONT_14;
        save.layer.cornerRadius = SCALES(13);
        save.layer.masksToBounds = YES;
        [[save rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.photos.count == 0) {
                return;
            }
            if (wself.saveBlock) {
                wself.saveBlock(wself.photos);
                [wself.navigationController popViewControllerAnimated:YES];
            }
        }];
        save;
    });
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.saveBtn];
    
    UILabel *subTitle = [[UILabel alloc]init];
    subTitle.text = [NSString stringWithFormat:@"选择图片（%zd/6）",self.photos.count];
    subTitle.font = TEXT_FONT_16;
    subTitle.textColor = TITLE_COLOR;
    [self.view addSubview:subTitle];
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(16));
        make.left.mas_equalTo(SCALES(16));
        make.height.mas_equalTo(SCALES(22));
    }];
    self.subTitle = subTitle;
    
    self.maxImageCount = 6;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWH = floorf((SCREEN_WIDTH - SCALES(24) - SCALES(8)) / 3);
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = SCALES(3);
    layout.minimumLineSpacing = SCALES(3);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:collectionView];
        collectionView;
    });
    [self.collectionView registerClass:[ASBasePhotoCell class] forCellWithReuseIdentifier:@"basePhotoCell"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.top.equalTo(subTitle.mas_bottom).offset(SCALES(12));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(24));
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.photos.count >= self.maxImageCount) {
        return self.photos.count;
    }
    return self.photos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASBasePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"basePhotoCell" forIndexPath:indexPath];
    if (indexPath.row == self.photos.count) {
        cell.image = [UIImage imageNamed:@"add_photo"];
    } else {
        id data = self.photos[indexPath.row];
        if ([data isKindOfClass:UIImage.class]) {
            cell.image = self.photos[indexPath.item];
            cell.state.hidden = YES;
        } else {
            ASAlbumsModel *model = self.photos[indexPath.row];
            cell.url = model.url;
            cell.state.hidden = model.status;
        }
    }
    cell.isHidenDel = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   kWeakSelf(self);
   if (indexPath.row == self.photos.count) {
       [[ASUploadImageManager shared] selectImagePickerWithMaxCount:self.maxImageCount - self.photos.count isSelfieCamera:NO viewController:self didFinish:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
           if (wself.photos.count == 0) {
               wself.photos = [NSMutableArray arrayWithArray:photos];
           } else {
               [wself.photos addObjectsFromArray:photos];
           }
           [wself.collectionView reloadData];
           wself.subTitle.text = [NSString stringWithFormat:@"选择图片（%zd/6）",wself.photos.count];
           [wself.saveBtn setBackgroundColor: GRDUAL_CHANGE_BG_COLOR(SCALES(48), SCALES(26))];
           wself.saveBtn.userInteractionEnabled = YES;
       }];
   } else {
       NSMutableArray *photos = [NSMutableArray array];
       [self.photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           GKPhoto *photo = [[GKPhoto alloc] init];
           if ([obj isKindOfClass:UIImage.class]) {
               photo.image = obj;
           } else {
               ASAlbumsModel *model = obj;
               NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.url];
               photo.url = [NSURL URLWithString:url];
           }
           [photos addObject:photo];
       }];
       [[ASUploadImageManager shared] showMediaWithPhotos:photos index:indexPath.row btnText:@"删除" viewController:self backBlock:^(NSInteger index, GKPhotoBrowser * _Nonnull browser) {
           [ASAlertViewManager defaultPopTitle:@"提示" content:@"是否删除这张图片" left:@"删除" right:@"取消" affirmAction:^{
               [wself.photos removeObjectAtIndex:index];
               [wself.collectionView reloadData];
               [browser dismiss];
               if (wself.photos.count == 0) {
                   [wself.saveBtn setBackgroundColor: UIColorRGB(0xCCCCCC)];
                   wself.saveBtn.userInteractionEnabled = NO;
               } else {
                   [wself.saveBtn setBackgroundColor: GRDUAL_CHANGE_BG_COLOR(SCALES(48), SCALES(26))];
                   wself.saveBtn.userInteractionEnabled = YES;
               }
           } cancelAction:^{
               
           }];
       }];
   }
}
@end
