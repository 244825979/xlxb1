//
//  ASInvitePosterAlertView.m
//  AS
//
//  Created by SA on 2025/7/25.
//

#import "ASInvitePosterAlertView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "ASPageControl.h"

@interface ASInvitePosterAlertView ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) ASPageControl *pageControl;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *closeBtn;
/**数据**/
@property (nonatomic, strong) UIImage *selecImage;
@end

@implementation ASInvitePosterAlertView

- (instancetype)init {
    if (self = [super init]) {
        self.size = CGSizeMake(SCREEN_WIDTH, SCALES(501));
        self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,
                                                                                 0,
                                                                                 SCREEN_WIDTH,
                                                                                 SCALES(400)) delegate:self placeholderImage:nil];
        self.bannerView.backgroundColor = UIColor.clearColor;
        self.bannerView.autoScroll = NO;
        self.bannerView.infiniteLoop = NO;
        self.bannerView.showPageControl = NO;//显示分页控制器
        self.bannerView.isSetFlowLayoutSize = YES;
        self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.bannerView];
        [self addSubview:self.pageControl];
        [self addSubview:self.closeBtn];
        [self addSubview:self.saveBtn];
        [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerView.mas_bottom).offset(SCALES(10));
            make.height.mas_equalTo(SCALES(34));
            make.centerX.width.equalTo(self.bannerView);
        }];
        self.pageControl.frame = CGRectMake(self.bannerView.left, self.bannerView.bottom + SCALES(15), self.bannerView.width, SCALES(34));
        [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerView.mas_bottom).offset(SCALES(50));
            make.width.mas_equalTo(SCALES(120));
            make.height.mas_equalTo(SCALES(44));
            make.left.mas_equalTo(SCALES(53));
        }];
        [self.saveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(self.closeBtn);
            make.right.equalTo(self).offset(SCALES(-53));
        }];
        self.bannerView.flowLayout.itemSize = CGSizeMake(SCALES(300), SCALES(400));
        self.bannerView.flowLayout.minimumLineSpacing = SCALES(21);
        self.bannerView.flowLayout.sectionInset = UIEdgeInsetsMake(0, (SCREEN_WIDTH - SCALES(300))/2, 0, (SCREEN_WIDTH - SCALES(300))/2);
    }
    return self;
}

- (void)setBodyModel:(ASWebJsBodyModel *)bodyModel {
    _bodyModel = bodyModel;
    NSMutableArray *array = [NSMutableArray array];
    for (ASWebPosterListModel *model in bodyModel.posterList) {
        [array addObject:STRING(model.posterPicUrl)];
    }
    self.bannerView.imageURLStringsGroup = array;
    self.pageControl.numberOfPages = array.count;
}

#pragma mark - SDCycleScrollViewDelegate
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    self.pageControl.currentPage = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    ASInvitePosterCell *cell = [cycleScrollView.mainView cellForItemAtIndexPath:indexPath];
    self.selecImage = [ASCommonFunc captureView:cell.contentView frame:cell.contentView.frame];
}

// 如果要实现自定义cell的轮播图，必须先实现customCollectionViewCellClassForCycleScrollView:和setupCustomCell:forIndex:代理方法
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
    if (view != self.bannerView) {
        return nil;
    }
    return [ASInvitePosterCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
    ASInvitePosterCell *myCell = (ASInvitePosterCell *)cell;
    myCell.model = self.bodyModel.posterList[index];
    if (index == 0) {
        [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{//加1s延时执行，避免云信数据未返回查询不到列表数据情况
            self.selecImage = [ASCommonFunc captureView:myCell.contentView frame:myCell.contentView.frame];
        }];
    }
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setTitle:@"暂不保存" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"poster_btn"] forState:UIControlStateNormal];
        _closeBtn.adjustsImageWhenHighlighted = NO;
        _closeBtn.titleLabel.font = TEXT_FONT_18;
        _closeBtn.layer.cornerRadius = SCALES(22);
        _closeBtn.layer.masksToBounds = YES;
        kWeakSelf(self);
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
        }];
    }
    return _closeBtn;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc]init];
        [_saveBtn setTitle:@"保存海报" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_saveBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = TEXT_FONT_18;
        _saveBtn.adjustsImageWhenHighlighted = NO;
        _saveBtn.layer.cornerRadius = SCALES(22);
        _saveBtn.layer.masksToBounds = YES;
        kWeakSelf(self);
        [[_saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (kObjectIsEmpty(wself.selecImage)) {
                return;
            }
            if (wself.cancelBlock) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    //写入图片到相册
                    [PHAssetChangeRequest creationRequestForAssetFromImage:wself.selecImage];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    if (success == YES) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            kShowToast(@"保存成功！");
                        });
                    } else {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            kShowToast(@"保存失败！");
                        });
                    }
                }];
                wself.cancelBlock();
            }
        }];
    }
    return _saveBtn;
}

- (ASPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[ASPageControl alloc]init];
        _pageControl.currentPointSize = CGSizeMake(SCALES(10), SCALES(10));
        _pageControl.otherPointSize = CGSizeMake(SCALES(10), SCALES(10));
        _pageControl.currentColor = UIColorRGB(0xffffff);
        _pageControl.otherColor = UIColorRGB(0x999999);
        _pageControl.controlSpacing = SCALES(20);
        _pageControl.pointCornerRadius = SCALES(5);
    }
    return _pageControl;
}
@end

@interface ASInvitePosterCell ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *posterTitle;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *codeImage;
@property (nonatomic, strong) UILabel *title;
@end

@implementation ASInvitePosterCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = SCALES(16);
        self.contentView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.contentView addSubview:self.bottomView];
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_equalTo(SCALES(100));
        }];
        [self.bottomView addSubview:self.title];
        [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(16));
            make.left.mas_equalTo(SCALES(20));
            make.height.mas_equalTo(SCALES(22));
        }];
        [self.bottomView addSubview:self.posterTitle];
        [self.posterTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title);
            make.top.equalTo(self.title.mas_bottom).offset(SCALES(5));
            make.right.equalTo(self.bottomView.mas_right).offset(SCALES(-115));
        }];
        [self.bottomView addSubview:self.codeImage];
        [self.codeImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomView).offset(SCALES(-18));
            make.top.mas_equalTo(SCALES(18));
            make.width.height.mas_equalTo(SCALES(64));
        }];
    }
    return self;
}

- (void)setModel:(ASWebPosterListModel *)model {
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, STRING(model.posterPicUrl)]]];
    self.posterTitle.attributedText = [ASCommonFunc attributedWithString:STRING(model.content) lineSpacing:SCALES(5)];
    self.codeImage.image = [ASCommonFunc createQRCodeImageWithString:STRING(model.qCodeContent) imageSize:CGSizeMake(SCALES(55), SCALES(55))];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = UIColor.whiteColor;
    }
    return _bottomView;
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UILabel *)posterTitle {
    if (!_posterTitle) {
        _posterTitle = [[UILabel alloc]init];
        _posterTitle.numberOfLines = 0;
        _posterTitle.textColor = TITLE_COLOR;
        _posterTitle.font = TEXT_FONT_14;
    }
    return _posterTitle;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.textColor = TITLE_COLOR;
        _title.font = TEXT_MEDIUM(16);
        _title.text = @"一个温暖的心灵小窝";
    }
    return _title;
}

- (UIImageView *)codeImage {
    if (!_codeImage) {
        _codeImage = [[UIImageView alloc]init];
    }
    return _codeImage;
}
@end
