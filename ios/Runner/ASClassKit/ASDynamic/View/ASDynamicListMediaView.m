//
//  ASDynamicListMediaView.m
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASDynamicListMediaView.h"

@interface ASDynamicListMediaView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIImageView *image1;//单张
@property (nonatomic, strong) UIImageView *image2;//两张
@property (nonatomic, strong) UICollectionView *collectionView;//多张
@property (nonatomic, strong) UIImageView *videoIcon;//视频图标
@end

@implementation ASDynamicListMediaView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.image1];
        [self addSubview:self.image2];
        [self.image1 addSubview:self.videoIcon];
        CGFloat itemWH = floor((SCREEN_WIDTH - SCALES(90) - SCALES(12))/3);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = SCALES(6);
        flowLayout.minimumInteritemSpacing = SCALES(6);
        flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionView = ({
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
            collectionView.showsVerticalScrollIndicator = NO;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.hidden = YES;
            collectionView;
        });
        [self addSubview:self.collectionView];
        [self.collectionView registerClass:[ASDynamicMediaCell class] forCellWithReuseIdentifier:@"dynamicMediaCell"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    if (self.model.mediaType == kDynamicMediaImageTwo) {
        CGFloat itemW = floor((SCREEN_WIDTH - SCALES(90) - SCALES(9))/2);
        [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.mas_equalTo(itemW);
        }];
        [self.image2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.width.equalTo(self.image1);
        }];
    } else {
        [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.mas_equalTo(SCALES(175));
        }];
        [self.videoIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.image1);
            make.width.height.mas_equalTo(SCALES(42));
        }];
    }
}

- (void)setModel:(ASDynamicListModel *)model {
    _model = model;
    switch (model.mediaType) {
        case kDynamicMediaImageOne:
        {
            self.image1.hidden = NO;
            self.image2.hidden = YES;
            self.videoIcon.hidden = YES;
            self.collectionView.hidden = YES;
            ASDynamicPictureModel *imageModel = model.images[0];
            [self.image1 setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, imageModel.url]] placeholder:nil];
        }
            break;
        case kDynamicMediaImageTwo:
        {
            self.image1.hidden = NO;
            self.image2.hidden = NO;
            self.videoIcon.hidden = YES;
            self.collectionView.hidden = YES;
            ASDynamicPictureModel *imageModel = model.images[0];
            [self.image1 setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, imageModel.url]] placeholder:nil];
            ASDynamicPictureModel *imageModel1 = model.images[1];
            [self.image2 setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, imageModel1.url]] placeholder:nil];
        }
            break;
        case kDynamicMediaImageMore:
        {
            self.image1.hidden = YES;
            self.image2.hidden = YES;
            self.videoIcon.hidden = YES;
            self.collectionView.hidden = NO;
            [self.collectionView reloadData];
        }
            break;
        case kDynamicMediaVideo:
        {
            self.image1.hidden = NO;
            self.videoIcon.hidden = NO;
            self.image2.hidden = YES;
            self.collectionView.hidden = YES;
            [self.image1 setImageWithURL:[NSURL URLWithString: model.cover_url] placeholder:nil];
        }
            break;
        default:
        {
            self.videoIcon.hidden = YES;
            self.image1.hidden = YES;
            self.image2.hidden = YES;
            self.collectionView.hidden = YES;
        }
            break;
    }
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASDynamicMediaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dynamicMediaCell" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[ASDynamicMediaCell alloc] init];
    }
    cell.model = self.model.images[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ASDynamicMediaCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (self.imageBlock) {
        self.imageBlock(self.model.mediaType, indexPath.row, cell.coverImage.image);
    }
}

- (UIImageView *)image1 {
    if (!_image1) {
        _image1 = [[UIImageView alloc]init];
        _image1.contentMode = UIViewContentModeScaleAspectFill;
        _image1.userInteractionEnabled = YES;
        _image1.layer.cornerRadius = SCALES(8);
        _image1.layer.masksToBounds = YES;
        _image1.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_image1 addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.imageBlock) {
                wself.imageBlock(wself.model.mediaType, 0, wself.image1.image);
            }
        }];
    }
    return _image1;
}

- (UIImageView *)image2 {
    if (!_image2) {
        _image2 = [[UIImageView alloc]init];
        _image2.contentMode = UIViewContentModeScaleAspectFill;
        _image2.userInteractionEnabled = YES;
        _image2.layer.cornerRadius = SCALES(8);
        _image2.layer.masksToBounds = YES;
        _image2.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_image2 addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.imageBlock) {
                wself.imageBlock(wself.model.mediaType, 1, wself.image2.image);
            }
        }];
    }
    return _image2;
}

- (UIImageView *)videoIcon {
    if (!_videoIcon) {
        _videoIcon = [[UIImageView alloc]init];
        _videoIcon.image = [UIImage imageNamed:@"video_play"];
        _videoIcon.hidden = YES;
    }
    return _videoIcon;
}
@end

@interface ASDynamicMediaCell ()
@end

@implementation ASDynamicMediaCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.coverImage];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.coverImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setModel:(ASDynamicPictureModel *)model {
    _model = model;
    [self.coverImage setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.url]] placeholder:nil];
}

- (UIImageView *)coverImage {
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc]init];
        _coverImage.layer.cornerRadius = SCALES(8);
        _coverImage.clipsToBounds = YES;
        _coverImage.contentMode = UIViewContentModeScaleAspectFill;
        _coverImage.userInteractionEnabled = YES;
    }
    return _coverImage;
}

@end
