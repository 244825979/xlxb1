//
//  ASReportPhotoCell.m
//  AS
//
//  Created by SA on 2025/5/9.
//

#import "ASReportPhotoCell.h"

@interface ASReportPhotoCell ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
/**数据**/
@property (nonatomic, assign) NSInteger maxImageCount;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@end

@implementation ASReportPhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.maxImageCount = 9;
        CGFloat itemWH = floorf((SCREEN_WIDTH - SCALES(32) - SCALES(10)) / 3);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = SCALES(5);
        flowLayout.minimumLineSpacing = SCALES(5);
        flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionView = ({
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.showsVerticalScrollIndicator = NO;
            collectionView.backgroundColor = UIColor.whiteColor;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            [self.contentView addSubview:collectionView];
            collectionView;
        });
        [self.collectionView registerClass:[ASBasePhotoCell class] forCellWithReuseIdentifier:@"basePhotoCell"];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(16));
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(SCALES(-16));
        }];
    }
    return self;
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.selectedPhotos.count >= self.maxImageCount) {
        return self.selectedPhotos.count;
    }
    return self.selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASBasePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"basePhotoCell" forIndexPath:indexPath];
    if (indexPath.row == self.selectedPhotos.count) {
        cell.image = [UIImage imageNamed:@"add_photo"];
        cell.isHidenDel = YES;
    } else {
        cell.image = self.selectedPhotos[indexPath.row];
        cell.isHidenDel = NO;
    }
    kWeakSelf(self);
    cell.delBlock = ^{
        [wself.selectedPhotos removeObjectAtIndex:indexPath.row];
        [wself.collectionView reloadData];
        if (wself.backBlock) {
            wself.backBlock(wself.selectedPhotos);
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    kWeakSelf(self);
    if (indexPath.row == self.selectedPhotos.count) {
        [[ASUploadImageManager shared] selectImagePickerWithMaxCount:self.maxImageCount - self.selectedPhotos.count isSelfieCamera:NO viewController:[ASCommonFunc currentVc] didFinish:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
            if (wself.selectedPhotos.count == 0) {
                wself.selectedPhotos = [NSMutableArray arrayWithArray:photos];
            } else {
                [wself.selectedPhotos addObjectsFromArray:photos];
            }
            [wself.collectionView reloadData];
            if (wself.backBlock) {
                wself.backBlock(wself.selectedPhotos);
            }
        }];
    } else {
        NSMutableArray *photos = [NSMutableArray array];
        [self.selectedPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GKPhoto *photo = [[GKPhoto alloc] init];
            photo.image = obj;
            [photos addObject:photo];
        }];
        [[ASUploadImageManager shared] showMediaWithPhotos:photos index:indexPath.row viewController:[ASCommonFunc currentVc]];
    }
}

- (NSMutableArray *)selectedPhotos {
    if (!_selectedPhotos) {
        _selectedPhotos = [[NSMutableArray alloc]init];
    }
    return _selectedPhotos;
}
@end
