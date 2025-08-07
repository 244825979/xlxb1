//
//  ASReportDetailsCell.m
//  AS
//
//  Created by SA on 2025/7/1.
//

#import "ASReportDetailsCell.h"

@interface ASReportDetailsCell ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *contentTitle;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UILabel *proofTitle;
@property (nonatomic, strong) UILabel *contentTitle1;
@property (nonatomic, strong) UILabel *content1;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *line2;
@end

@implementation ASReportDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.contentTitle];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.line1];
        [self.contentView addSubview:self.proofTitle];
        [self.contentView addSubview:self.contentTitle1];
        [self.contentView addSubview:self.content1];
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.line2];
        [self.collectionView registerClass:[ASBasePhotoCell class] forCellWithReuseIdentifier:@"basePhotoCell"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.mas_equalTo(SCALES(18));
        make.size.mas_equalTo(CGSizeMake(SCALES(4), SCALES(16)));
    }];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.line);
        make.left.equalTo(self.line.mas_right).offset(SCALES(6));
    }];
    [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.line);
        make.right.equalTo(self.contentView.mas_right).offset(SCALES(-16));
    }];
    [self.contentTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(SCALES(20));
        make.left.equalTo(self.line);
        make.height.mas_equalTo(SCALES(18));
    }];
    CGFloat textMaxLayoutWidth = SCREEN_WIDTH - SCALES(102);
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(SCALES(20));
        make.left.mas_equalTo(SCALES(86));
        make.width.mas_equalTo(textMaxLayoutWidth);
    }];
    self.content.preferredMaxLayoutWidth = textMaxLayoutWidth;
    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content.mas_bottom).offset(SCALES(16));
        make.left.equalTo(self.line);
        make.right.equalTo(self.contentView.mas_right).offset(SCALES(-16));
        make.height.mas_equalTo(SCALES(1));
    }];
    [self.proofTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line);
        make.top.equalTo(self.line1.mas_bottom).offset(SCALES(16));
        make.height.mas_equalTo(SCALES(24));
    }];
    [self.contentTitle1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line);
        make.top.equalTo(self.proofTitle.mas_bottom).offset(SCALES(16));
        make.height.mas_equalTo(SCALES(18));
        make.width.mas_equalTo(SCALES(70));
    }];
    [self.content1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTitle1);
        make.left.mas_equalTo(SCALES(86));
        make.width.mas_equalTo(textMaxLayoutWidth);
    }];
    self.content1.preferredMaxLayoutWidth = textMaxLayoutWidth;
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content1.mas_bottom).offset(SCALES(8));
        make.left.equalTo(self.contentTitle1);
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(32));
        make.bottom.equalTo(self.contentView);
    }];
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(SCALES(10));
    }];
}

- (void)setModel:(ASReportDetailsMoreModel *)model {
    _model = model;
    self.time.text = STRING(model.reasonTime);
    self.content.attributedText = [ASCommonFunc attributedWithString: STRING(model.reason) lineSpacing:SCALES(4.0)];
    self.content1.attributedText = [ASCommonFunc attributedWithString: STRING(model.content) lineSpacing:SCALES(4.0)];
    [self.collectionView reloadData];
}

#pragma mark UICollectionView
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
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_IMAGE_URL, STRING(obj)]];
        [photos addObject:photo];
    }];
    [[ASUploadImageManager shared] showMediaWithPhotos:photos index:indexPath.row viewController:[ASCommonFunc currentVc]];
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
        _title.text = @"客服回复";
    }
    return _title;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.textColor = TEXT_SIMPLE_COLOR;
        _time.font = TEXT_FONT_12;
    }
    return _time;
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

- (UILabel *)proofTitle {
    if (!_proofTitle) {
        _proofTitle = [[UILabel alloc]init];
        _proofTitle.textColor = UIColorRGB(0xF55F4E);
        _proofTitle.text = @"请补充凭证";
        _proofTitle.font = TEXT_FONT_14;
    }
    return _proofTitle;
}

- (UILabel *)contentTitle1 {
    if (!_contentTitle1) {
        _contentTitle1 = [[UILabel alloc]init];
        _contentTitle1.textColor = TEXT_SIMPLE_COLOR;
        _contentTitle1.text = @"内容描述：";
        _contentTitle1.font = TEXT_FONT_14;
    }
    return _contentTitle1;
}

- (UILabel *)content1 {
    if (!_content1) {
        _content1 = [[UILabel alloc]init];
        _content1.textColor = TITLE_COLOR;
        _content1.font = TEXT_FONT_14;
        _content1.numberOfLines = 0;
    }
    return _content1;
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

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc]init];
        _line2.backgroundColor = BACKGROUNDCOLOR;
    }
    return _line2;
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
