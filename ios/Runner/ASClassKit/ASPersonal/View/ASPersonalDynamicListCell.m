//
//  ASPersonalDynamicListCell.m
//  AS
//
//  Created by SA on 2025/5/16.
//

#import "ASPersonalDynamicListCell.h"
#import "ASDynamicListBottomView.h"
#import "ASDynamicListMediaView.h"

@interface ASPersonalDynamicListCell ()
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) ASPersonalDynamicMediaView *mediaView;
@property (nonatomic, strong) ASDynamicListBottomView *bottomView;
@end

@implementation ASPersonalDynamicListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.mediaView];
        [self.contentView addSubview:self.bottomView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat textMaxLayoutWidth = floorf(SCREEN_WIDTH - SCALES(32));
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(SCALES(16));
        make.top.mas_equalTo(SCALES(16));
        make.width.mas_equalTo(textMaxLayoutWidth);
    }];
    self.content.preferredMaxLayoutWidth = textMaxLayoutWidth;
    [self.mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.content);
        make.top.equalTo(self.content.mas_bottom).offset(SCALES(12));
        make.height.mas_equalTo(self.model.mediaPersonalHeight);
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.right.equalTo(self.mediaView);
        make.height.mas_equalTo(SCALES(56));
    }];
}

- (void)setModel:(ASDynamicListModel *)model {
    _model = model;
    self.mediaView.model = model;
    self.bottomView.model = model;
    self.content.text = model.content;
    if (self.content.text.length > 0 && self.content.text) {
        self.content.attributedText = [ASCommonFunc attributedWithString:model.content lineSpacing:SCALES(4.0)];
    }
}

#pragma mark - 处理collectionView不影响点击事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if(!self.userInteractionEnabled || self.hidden || self.alpha <= 0.01) {
        return nil;
    }
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UICollectionView class]]) {
        return self;
    }
    return view;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = TITLE_COLOR;
        _content.numberOfLines = 0;
        _content.font = TEXT_FONT_15;
    }
    return _content;
}

- (ASPersonalDynamicMediaView *)mediaView {
    if (!_mediaView) {
        _mediaView = [[ASPersonalDynamicMediaView alloc]init];
        kWeakSelf(self);
        _mediaView.imageBlock = ^(ASDynamicMediaType mediaType, NSInteger index, UIImage *image) {
            if (mediaType == kDynamicMediaVideo) {
                NSMutableArray *photos = [NSMutableArray array];
                GKPhoto *photo = [[GKPhoto alloc] init];
                photo.image = image;
                photo.videoUrl = [NSURL URLWithString:STRING(wself.model.file_url)];
                [photos addObject:photo];
                [[ASUploadImageManager shared] showMediaWithPhotos:photos index:0 viewController:[ASCommonFunc currentVc]];
            } else {
                NSMutableArray *photos = [NSMutableArray array];
                [wself.model.images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    GKPhoto *photo = [[GKPhoto alloc] init];
                    ASAlbumsModel *model = obj;
                    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.url];
                    if (idx == index) {
                        photo.image = image;
                    }
                    photo.url = [NSURL URLWithString:url];
                    [photos addObject:photo];
                }];
                [[ASUploadImageManager shared] showMediaWithPhotos:photos index:index viewController:[ASCommonFunc currentVc]];
            }
        };
    }
    return _mediaView;
}

- (ASDynamicListBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[ASDynamicListBottomView alloc]init];
        _bottomView.more.hidden = YES;
        kWeakSelf(self);
        _bottomView.clikedBlock = ^(NSString * _Nonnull indexName) {
            wself.clikedBlock(indexName);
        };
    }
    return _bottomView;
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

@interface ASPersonalDynamicMediaView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIImageView *image1;
@property (nonatomic, strong) UIImageView *image2;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *videoIcon;
@end

@implementation ASPersonalDynamicMediaView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.image1];
        [self addSubview:self.image2];
        [self.image1 addSubview:self.videoIcon];
        CGFloat itemWH = floor((SCREEN_WIDTH - SCALES(32) - SCALES(16))/3);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = SCALES(8);
        flowLayout.minimumInteritemSpacing = SCALES(8);
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
    switch (self.model.mediaType) {
        case kDynamicMediaImageOne:
        {
            [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self);
                make.width.mas_equalTo(SCALES(175));
            }];
        }
            break;
        case kDynamicMediaImageTwo:
        {
            CGFloat itemW = floor((SCREEN_WIDTH - SCALES(32) - SCALES(10))/2);
            [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self);
                make.width.mas_equalTo(itemW);
            }];
            [self.image2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(self);
                make.width.equalTo(self.image1);
            }];
        }
            break;
        case kDynamicMediaVideo:
        {
            [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self);
                make.width.mas_equalTo(SCALES(175));
            }];
            [self.videoIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.equalTo(self.image1);
                make.width.height.mas_equalTo(SCALES(42));
            }];
        }
            break;
        default:
            break;
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
