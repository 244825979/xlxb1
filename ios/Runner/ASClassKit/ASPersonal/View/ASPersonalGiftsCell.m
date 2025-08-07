//
//  ASPersonalGiftsCell.m
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASPersonalGiftsCell.h"
#import "ASPersonalGiftCollectionCell.h"

@interface ASPersonalGiftsCell()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ASPersonalGiftsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    CGFloat itemW = floorf((SCREEN_WIDTH - SCALES(16)*2 - SCALES(7)*2) / 3);
    CGFloat itemH = SCALES(111);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = SCALES(7);
    flowLayout.minimumInteritemSpacing = SCALES(7);
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCALES(16), 0, SCREEN_WIDTH - SCALES(32), itemH) collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self.contentView addSubview:collectionView];
        collectionView;
    });
    [self.collectionView registerClass:[ASPersonalGiftCollectionCell class] forCellWithReuseIdentifier:@"personalGiftCollectionCell"];
}

- (void)setGifts:(NSArray *)gifts {
    _gifts = gifts;
    [self.collectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gifts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASPersonalGiftCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"personalGiftCollectionCell" forIndexPath:indexPath];
    cell.model = self.gifts[indexPath.row];
    return cell;
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
