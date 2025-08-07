//
//  ASVideoShowPublishSetCoverView.m
//  AS
//
//  Created by SA on 2025/5/13.
//

#import "ASVideoShowPublishSetCoverView.h"

@interface ASVideoShowPublishSetCoverView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *coverImage;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *line;
@end

@implementation ASVideoShowPublishSetCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.title];
        [self addSubview:self.coverImage];
        [self addSubview:self.collectionView];
        [self addSubview:self.line];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = CGSizeMake(SCALES(34), SCALES(44));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = ({
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCALES(16), SCALES(334), SCREEN_WIDTH - SCALES(32),SCALES(44)) collectionViewLayout:flowLayout];
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.backgroundColor = UIColor.clearColor;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.layer.cornerRadius = SCALES(4);
            collectionView.layer.masksToBounds = YES;
            [self addSubview:collectionView];
            collectionView;
        });
        [self.collectionView registerClass:[ASVideoShowCoverCell class] forCellWithReuseIdentifier:@"videoShowCoverCell"];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.mas_equalTo(SCALES(16));
        make.right.equalTo(self).offset(SCALES(-16));
        make.height.mas_equalTo(0.5);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.mas_equalTo(SCALES(16));
        make.height.mas_equalTo(28);
    }];
    [self.coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.title.mas_bottom).offset(SCALES(16));
        make.size.mas_equalTo(CGSizeMake(SCALES(192), SCALES(260)));
    }];
}

- (void)setImages:(NSArray<UIImage *> *)images {
    _images = images;
    [self.collectionView reloadData];
    if (images.count > 0) {
        self.coverImage.image = images[0];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASVideoShowCoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoShowCoverCell" forIndexPath:indexPath];
    cell.coverImage.image = self.images[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.coverImage.image = self.images[indexPath.row];
    if (self.backBlock) {
        self.backBlock(self.images[indexPath.row]);
    }
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.text = @"设置视频封面：";
        _title.font = TEXT_FONT_20;
        _title.textColor = RED_COLOR;
    }
    return _title;
}

- (UIImageView *)coverImage {
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc]init];
        _coverImage.layer.cornerRadius = SCALES(8);
        _coverImage.layer.masksToBounds = YES;
        _coverImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImage;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}
@end

@implementation ASVideoShowCoverCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderColor = MAIN_COLOR.CGColor;
        [self.contentView addSubview:self.coverImage];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UIImageView *)coverImage {
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc]init];
        _coverImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImage;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.contentView.layer.borderWidth = SCALES(1.5);
        self.contentView.layer.cornerRadius = SCALES(4);
    } else {
        self.contentView.layer.borderWidth = SCALES(0);
        self.contentView.layer.cornerRadius = SCALES(0);
    }
}
@end
