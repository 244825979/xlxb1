//
//  ASReportDetailsTopDataView.m
//  AS
//
//  Created by SA on 2025/7/1.
//

#import "ASReportDetailsTopDataView.h"
#import "ASBasePhotoCell.h"

@interface ASReportDetailsTopDataView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UILabel *beReported;
@property (nonatomic, strong) UILabel *reportedType;
@property (nonatomic, strong) UILabel *reportedTime;
//投诉内容
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *contentTitle;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ASReportDetailsTopDataView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.beReported];
        [self addSubview:self.reportedType];
        [self addSubview:self.reportedTime];
        [self addSubview:self.line];
        [self addSubview:self.title];
        [self addSubview:self.contentTitle];
        [self addSubview:self.content];
        [self addSubview:self.line1];
        [self addSubview:self.collectionView];
        [self.collectionView registerClass:[ASBasePhotoCell class] forCellWithReuseIdentifier:@"basePhotoCell"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.beReported mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(14));
        make.left.mas_equalTo(SCALES(16));
        make.height.mas_equalTo(SCALES(20));
        make.right.equalTo(self.mas_right).offset(SCALES(-16));
    }];
    [self.reportedType mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beReported.mas_bottom).offset(SCALES(8));
        make.left.right.height.equalTo(self.beReported);
    }];
    [self.reportedTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reportedType.mas_bottom).offset(SCALES(8));
        make.left.right.height.equalTo(self.beReported);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.equalTo(self.reportedTime.mas_bottom).offset(SCALES(20));
        make.size.mas_equalTo(CGSizeMake(SCALES(4), SCALES(16)));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.line);
        make.left.equalTo(self.line.mas_right).offset(SCALES(6));
    }];
    [self.contentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(SCALES(20));
        make.left.equalTo(self.line);
        make.height.mas_equalTo(SCALES(18));
    }];
    CGFloat textMaxLayoutWidth = SCREEN_WIDTH - SCALES(102);
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(SCALES(20));
        make.left.mas_equalTo(SCALES(86));
        make.width.mas_equalTo(textMaxLayoutWidth);
    }];
    self.content.preferredMaxLayoutWidth = textMaxLayoutWidth;
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content.mas_bottom).offset(SCALES(16));
        make.left.equalTo(self.line);
        make.right.equalTo(self.mas_right).offset(SCALES(-16));
        make.height.mas_equalTo(SCALES(1));
    }];
    self.collectionView.frame = CGRectMake(SCALES(16),
                                           self.line1.bottom + SCALES(8),
                                           SCREEN_WIDTH - SCALES(32),
                                           self.model.collectionHeight);
}

- (void)setModel:(ASReportListModel *)model {
    _model = model;
    NSMutableAttributedString *beReportedAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"被举报人：%@", STRING(model.toNickname)]];
    [beReportedAtt addAttribute:NSForegroundColorAttributeName
                            value:TEXT_SIMPLE_COLOR
                            range:NSMakeRange(0, 5)];
    [self.beReported setAttributedText:beReportedAtt];
    
    NSMutableAttributedString *reportedTypeAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"被举类型：%@", STRING(model.cateName)]];
    [reportedTypeAtt addAttribute:NSForegroundColorAttributeName
                            value:TEXT_SIMPLE_COLOR
                            range:NSMakeRange(0, 5)];
    [self.reportedType setAttributedText:reportedTypeAtt];
    
    NSMutableAttributedString *reportedTimeAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"举报时间：%@", STRING(model.ctime)]];
    [reportedTimeAtt addAttribute:NSForegroundColorAttributeName
                            value:TEXT_SIMPLE_COLOR
                            range:NSMakeRange(0, 5)];
    [self.reportedTime setAttributedText:reportedTimeAtt];
    
    self.content.attributedText = [ASCommonFunc attributedWithString: STRING(model.content) lineSpacing:SCALES(4.0)];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASBasePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"basePhotoCell" forIndexPath:indexPath];
    cell.url = self.model.images[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photos = [NSMutableArray array];
    [self.model.images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GKPhoto *photo = [[GKPhoto alloc] init];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, obj]];
        [photos addObject:photo];
    }];
    [[ASUploadImageManager shared] showMediaWithPhotos:photos index:indexPath.row viewController:[ASCommonFunc currentVc]];
}

- (UILabel *)beReported {
    if (!_beReported) {
        _beReported = [[UILabel alloc] init];
        _beReported.textColor = TITLE_COLOR;
        _beReported.font = TEXT_FONT_14;
        _beReported.text = @"被举报人：";
    }
    return _beReported;
}

- (UILabel *)reportedType {
    if (!_reportedType) {
        _reportedType = [[UILabel alloc] init];
        _reportedType.textColor = TITLE_COLOR;
        _reportedType.font = TEXT_FONT_14;
        _reportedType.text = @"被举类型：";
    }
    return _reportedType;
}

- (UILabel *)reportedTime {
    if (!_reportedTime) {
        _reportedTime = [[UILabel alloc] init];
        _reportedTime.textColor = TITLE_COLOR;
        _reportedTime.font = TEXT_FONT_14;
        _reportedTime.text = @"举报时间：";
    }
    return _reportedTime;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = MAIN_COLOR;
        _line.layer.masksToBounds = YES;
        _line.layer.cornerRadius = SCALES(2);
    }
    return _line;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = TITLE_COLOR;
        _title.font = TEXT_FONT_16;
        _title.text = @"投诉内容";
    }
    return _title;
}

- (UILabel *)contentTitle {
    if (!_contentTitle) {
        _contentTitle = [[UILabel alloc]init];
        _contentTitle.textColor = TEXT_SIMPLE_COLOR;
        _contentTitle.font = TEXT_FONT_14;
        _contentTitle.text = @"内容描述：";
    }
    return _contentTitle;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = TITLE_COLOR;
        _content.font = TEXT_FONT_14;
        _content.text = @"";
        _content.numberOfLines = 0;
    }
    return _content;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc]init];
        _line1.backgroundColor = UIColorRGB(0xE7E7E7);
    }
    return _line1;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemWH = (SCREEN_WIDTH - SCALES(48))/ 3;
        _layout.itemSize = CGSizeMake(itemWH, itemWH);
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = SCALES(8);
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
    }
    return _collectionView;
}
@end
