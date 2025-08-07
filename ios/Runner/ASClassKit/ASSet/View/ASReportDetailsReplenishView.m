//
//  ASReportDetailsReplenishView.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASReportDetailsReplenishView.h"

@interface ASReportDetailsReplenishView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *contentTitle;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UILabel *proofTitle;
@property (nonatomic, strong) UILabel *contentTitle1;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
/**数据**/
@property (nonatomic, assign) NSInteger maxTextCount;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, assign) NSInteger maxImageCount;
@end

@implementation ASReportDetailsReplenishView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.line];
        [self addSubview:self.title];
        [self addSubview:self.time];
        [self addSubview:self.contentTitle];
        [self addSubview:self.content];
        [self addSubview:self.line1];
        [self addSubview:self.proofTitle];
        [self addSubview:self.contentTitle1];
        [self addSubview:self.textField];
        [self addSubview:self.collectionView];
        [self.collectionView registerClass:[ASBasePhotoCell class] forCellWithReuseIdentifier:@"basePhotoCell"];
        self.maxTextCount = 100;
        self.maxImageCount = 9;
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
        make.right.equalTo(self.mas_right).offset(SCALES(-16));
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
    if (self.model.status == 4 || self.model.status == 5) {
        [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.content.mas_bottom).offset(SCALES(16));
            make.left.equalTo(self.line);
            make.right.equalTo(self.mas_right).offset(SCALES(-16));
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
            make.height.mas_equalTo(SCALES(24));
            make.width.mas_equalTo(SCALES(70));
        }];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentTitle1.mas_right);
            make.centerY.equalTo(self.contentTitle1);
            make.right.equalTo(self.mas_right).offset(SCALES(-16));
        }];
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentTitle1.mas_bottom).offset(SCALES(8));
            make.left.equalTo(self.contentTitle1);
            make.width.mas_equalTo(SCREEN_WIDTH - SCALES(32));
            make.bottom.equalTo(self);
        }];
    }
}

- (void)setModel:(ASReportListModel *)model {
    _model = model;
    self.time.text = STRING(model.reasonTime);
    self.content.attributedText = [ASCommonFunc attributedWithString: STRING(model.reason) lineSpacing:SCALES(4.0)];
    if (model.status == 4 || model.status == 5) {
        self.line1.hidden = NO;
        self.proofTitle.hidden = NO;
        self.contentTitle1.hidden = NO;
        self.textField.hidden = NO;
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
    } else {
        self.line1.hidden = YES;
        self.proofTitle.hidden = YES;
        self.contentTitle1.hidden = YES;
        self.textField.hidden = YES;
        self.collectionView.hidden = YES;
    }
}

//按钮输入监听
- (void)textFieldDidChange:(UITextField *)textField {
    if (self.backBlock) {
        self.backBlock(self.textField.text, self.selectedPhotos);
    }
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
            wself.backBlock(wself.textField.text, wself.selectedPhotos);
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
                wself.backBlock(wself.textField.text, wself.selectedPhotos);
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
        _line1.hidden = YES;
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

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.textColor = TITLE_COLOR;
        _textField.font = TEXT_FONT_14;
        _textField.placeholder = @"请输入";
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
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
