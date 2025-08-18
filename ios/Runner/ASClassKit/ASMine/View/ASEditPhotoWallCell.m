//
//  ASEditPhotoWallCell.m
//  AS
//
//  Created by SA on 2025/4/21.
//

#import "ASEditPhotoWallCell.h"

@interface ASEditPhotoWallCell ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyHint;
@property (nonatomic, strong) UIImageView *backIcon;
@property (nonatomic, strong) UICollectionView *collectionView;
/**数据显示**/
@property (nonatomic, assign) NSInteger maxImageCount;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@end

@implementation ASEditPhotoWallCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.moneyHint];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.backIcon];
    
    self.maxImageCount = 6;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCALES(113), SCALES(117));//设置每个item的大小
    layout.minimumLineSpacing = SCALES(5);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:collectionView];
        collectionView;
    });
    [self.collectionView registerClass:[ASBasePhotoCell class] forCellWithReuseIdentifier:@"basePhotoCell"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.mas_equalTo(SCALES(44));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(28));
        make.height.mas_equalTo(SCALES(117));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.top.mas_equalTo(SCALES(12));
        make.height.mas_equalTo(SCALES(24));
    }];
    
    [self.moneyHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(SCALES(8));
        make.centerY.equalTo(self.titleLabel);
        make.height.mas_equalTo(SCALES(20));
    }];
        
    [self.backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
        make.right.equalTo(self.contentView).offset(SCALES(-14));
    }];
}

- (void)setModel:(ASSetCellModel *)model {
    _model = model;
    self.selectedPhotos = [NSMutableArray arrayWithArray:model.images];
    [self.collectionView reloadData];
    
    self.moneyHint.hidden = model.taskModel.is_show == 1 ? NO : YES;
    self.moneyHint.text = [NSString stringWithFormat:@"   %@   ",model.taskModel.des];
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
        cell.state.hidden = YES;
    } else {
        id data = self.selectedPhotos[indexPath.row];
        if ([data isKindOfClass:UIImage.class]) {
            cell.image = self.selectedPhotos[indexPath.item];
            cell.state.hidden = YES;
        } else {
            ASAlbumsModel *model = self.selectedPhotos[indexPath.row];
            cell.url = model.url;
            cell.state.hidden = model.status;
        }
    }
    cell.isHidenDel = YES;
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
           //同步一下模型数据
           wself.model.images = wself.selectedPhotos;
           [wself.collectionView reloadData];
           
           if (wself.model.valueDidBlock) {
               wself.model.valueDidBlock(@"1");//是否改变了图片数据
           }
       }];
   } else {
       NSMutableArray *photos = [NSMutableArray array];
       [self.selectedPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
       [[ASUploadImageManager shared] showMediaWithPhotos:photos index:indexPath.row btnText:@"删除" viewController:[ASCommonFunc currentVc] backBlock:^(NSInteger index, GKPhotoBrowser * _Nonnull browser) {
           [ASAlertViewManager defaultPopTitle:@"提示" content:@"是否删除这张图片" left:@"删除" right:@"取消" isTouched:YES affirmAction:^{
               [wself.selectedPhotos removeObjectAtIndex:index];
               [wself.collectionView reloadData];
               //同步一下模型数据
               wself.model.images = wself.selectedPhotos;
               [browser dismiss];
               if (wself.model.valueDidBlock) {
                   wself.model.valueDidBlock(@"1");//是否改变了图片数据
               }
           } cancelAction:^{
               
           }];
       }];
   }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TITLE_COLOR;
        _titleLabel.font = TEXT_FONT_15;
        _titleLabel.text = @"个人相册";
    }
    return _titleLabel;
}

- (UILabel *)moneyHint {
    if (!_moneyHint) {
        _moneyHint = [[UILabel alloc]init];
        _moneyHint.backgroundColor = UIColorRGB(0xFFF1F3);
        _moneyHint.font = TEXT_FONT_11;
        _moneyHint.layer.cornerRadius = SCALES(10);
        _moneyHint.layer.masksToBounds = YES;
        _moneyHint.textColor = MAIN_COLOR;
        _moneyHint.hidden = YES;
    }
    return _moneyHint;
}

- (UIImageView *)backIcon {
    if (!_backIcon) {
        _backIcon = [[UIImageView alloc]init];
        _backIcon.image = [UIImage imageNamed:@"cell_back"];
    }
    return _backIcon;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
