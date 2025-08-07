//
//  ASPersonalGiftsController.m
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASPersonalGiftsController.h"
#import "ASPersonalGiftCollectionCell.h"

@interface ASPersonalGiftsController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ASPersonalGiftsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"收到的礼物";
    [self createUI];
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
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCALES(16), SCALES(8), SCREEN_WIDTH - SCALES(32), SCREEN_HEIGHT - HEIGHT_NAVBAR - SCALES(8)) collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self.view addSubview:collectionView];
        collectionView;
    });
    [self.collectionView registerClass:[ASPersonalGiftCollectionCell class] forCellWithReuseIdentifier:@"personalGiftCollectionCell"];
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
@end
