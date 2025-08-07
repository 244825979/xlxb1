//
//  ASVipGradeListView.m
//  AS
//
//  Created by AS on 2025/6/27.
//

#import "ASVipGradeListView.h"

@interface ASVipGradeListView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UICollectionView *collectionView;//底部选择的图片
@property (nonatomic, assign) CGFloat collectionViewH;
@end

@implementation ASVipGradeListView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.bgImage];
        CGFloat itemW = floorf(((SCREEN_WIDTH - SCALES(32)) / 3));
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemW, SCALES(120));
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = UIColor.clearColor;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        [self.bgImage addSubview:self.collectionView];
        [self.collectionView registerClass:[ASVipGradeItemCell class] forCellWithReuseIdentifier:@"vipGradeItemCell"];
    }
    return self;
}

- (void)setLists:(NSArray<ASVipPrivilegesModel *> *)lists {
    _lists = lists;
    NSInteger rols = lists.count / 3;
    self.collectionViewH = ((lists.count % 3) > 0 ? rols + 1 : rols) * SCALES(120) + SCALES(1);
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(self.collectionViewH + SCALES(68));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(68));
        make.left.right.equalTo(self.bgImage);
        make.height.mas_equalTo(self.collectionViewH);
    }];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASVipGradeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"vipGradeItemCell" forIndexPath:indexPath];
    cell.model = self.lists[indexPath.row];
    return cell;
}

- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]init];
        _bgImage.image = [[UIImage imageNamed:@"vip_list_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(SCALES(68), 0, SCALES(20), 0) resizingMode:UIImageResizingModeStretch];
    }
    return _bgImage;
}
@end

@interface ASVipGradeItemCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@end

@implementation ASVipGradeItemCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.content];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.width.mas_equalTo(SCALES(34));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self.contentView);
        make.top.equalTo(self.icon.mas_bottom).offset(SCALES(6));
        make.height.mas_equalTo(SCALES(16));
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.title.mas_bottom).offset(SCALES(4));
    }];
}

- (void)setModel:(ASVipPrivilegesModel *)model {
    _model = model;
    self.title.text = STRING(model.name);
    self.content.attributedText = [ASCommonFunc attributedWithString:STRING(model.des) lineSpacing:SCALES(3)];
    self.content.textAlignment = NSTextAlignmentCenter;
    [self.icon sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.img]]];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.textColor = UIColorRGB(0xFDE6E6);
        _title.font = TEXT_FONT_14;
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.textColor = UIColorRGB(0xC39A8E);
        _content.font = TEXT_FONT_10;
        _content.numberOfLines = 0;
    }
    return _content;
}
@end
