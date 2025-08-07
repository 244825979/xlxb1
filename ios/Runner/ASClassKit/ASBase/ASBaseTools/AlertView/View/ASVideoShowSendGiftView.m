//
//  ASVideoShowSendGiftView.h
//  AS
//
//  Created by SA on 2025/5/13.
//

#import "ASVideoShowSendGiftView.h"
#import <SVGA.h>
#import "ASVideoShowRequest.h"

@interface ASVideoShowSendGiftView ()<UICollectionViewDataSource, UICollectionViewDelegate, SVGAPlayerDelegate>
@property (nonatomic ,strong) UIView *alertView;
@property (nonatomic, strong) UIImageView *imageBg;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIImageView *moneyIcon;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UIButton *awardBtn;
@property (nonatomic, strong) YYLabel *agreementView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *thankAward;
/**数据**/
@property (nonatomic, strong) NSArray *lists;
@property (nonatomic, strong) ASGiftListModel *selectGiftModel;
@property (nonatomic, strong) ASGiftDataModel *giftsModel;
@property (nonatomic, strong) SVGAPlayer *giftPlayer;
@end

@implementation ASVideoShowSendGiftView

- (instancetype)init {
    if (self = [super init]) {
        self.size = CGSizeMake(SCREEN_WIDTH, SCALES(362) + TAB_BAR_MAGIN + SCALES(50));
        self.backgroundColor = UIColor.clearColor;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.alertView];
    self.alertView.frame = CGRectMake(0, SCALES(50), SCREEN_WIDTH, SCALES(362) + TAB_BAR_MAGIN);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.alertView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(SCALES(12), SCALES(12))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.alertView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.alertView.layer.mask = maskLayer;
    [self.alertView addSubview:self.imageBg];
    [self addSubview:self.header];
    [self.alertView addSubview:self.closeBtn];
    [self.alertView addSubview:self.title];
    [self.alertView addSubview:self.nickName];
    [self.alertView addSubview:self.awardBtn];
    [self.alertView addSubview:self.payBtn];
    [self.alertView addSubview:self.moneyLabel];
    [self.alertView addSubview:self.moneyIcon];
    [self.alertView addSubview:self.agreementView];
    [self addSubview:self.thankAward];
    [self addSubview:self.giftPlayer];
    
    CGFloat itemW = (SCREEN_WIDTH - SCALES(30) - SCALES(22)) /3;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = SCALES(10);
    flowLayout.itemSize = CGSizeMake(itemW, SCALES(140));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCALES(15), SCALES(115), SCREEN_WIDTH - SCALES(30),SCALES(141)) collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self.alertView addSubview:collectionView];
        collectionView;
    });
    [self.collectionView registerClass:[ASVideoShowAwardGiftCell class] forCellWithReuseIdentifier:@"videoShowAwardGiftCell"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertView).offset(SCALES(-35));
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(SCALES(70));
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.alertView.mas_right).offset(SCALES(-16));
        make.top.mas_equalTo(SCALES(16));
        make.height.width.mas_equalTo(SCALES(24));
    }];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(46));
        make.centerX.equalTo(self.alertView);
        make.height.mas_equalTo(SCALES(22.5));
    }];
    [self.nickName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(SCALES(6));
        make.centerX.equalTo(self.title);
        make.height.mas_equalTo(SCALES(20));
    }];
    [self.awardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertView).offset(SCALES(275));
        make.right.equalTo(self.alertView).offset(SCALES(-16));
        make.size.mas_equalTo(CGSizeMake(SCALES(172), SCALES(40)));
    }];
    [self.payBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.awardBtn);
        make.right.equalTo(self.awardBtn.mas_left).offset(SCALES(-20));
        make.width.mas_equalTo(SCALES(40));
    }];
    [self.moneyIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.centerY.equalTo(self.awardBtn);
        make.width.height.mas_equalTo(SCALES(30));
    }];
    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.awardBtn);
        make.right.equalTo(self.payBtn.mas_left).offset(SCALES(-15));
        make.left.equalTo(self.moneyIcon.mas_right).offset(SCALES(8));
    }];
    [self.agreementView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.awardBtn.mas_bottom).offset(SCALES(14));
        make.centerX.equalTo(self.alertView);
        make.height.mas_equalTo(SCALES(20));
    }];
    [self.thankAward mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertView).offset(SCALES(-63));
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(SCALES(145));
    }];
}

- (void)setModel:(ASVideoShowDataModel *)model {
    _model = model;
    [self.header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar]]];
    self.nickName.text = [NSString stringWithFormat:@"@%@",STRING(model.nickname)];
    kWeakSelf(self);
    [ASVideoShowRequest requestVideoShowAwardListSuccess:^(id  _Nullable data) {
        ASGiftDataModel *model = data;
        wself.giftsModel = model;
        wself.moneyLabel.text = STRING(model.coin);
        wself.lists = model.list;
        [wself.collectionView reloadData];
        if (model.list.count > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [wself.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            wself.selectGiftModel = wself.lists[0];
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)goPay {
    [ASMyAppCommonFunc balanceDeficiencyPopViewWithPayScene:Pay_Scene_VideoShowAward cancel:^{
        
    }];
    if (self.cancelBlock) {
        self.cancelBlock();
        [self removeView];
    }
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASVideoShowAwardGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoShowAwardGiftCell" forIndexPath:indexPath];
    cell.giftModel = self.lists[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectGiftModel = self.lists[indexPath.row];
}

#pragma mark -- UICollectionViewDataSource
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    self.giftPlayer.hidden = YES;
    kWeakSelf(self);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        wself.header.hidden = NO;
        wself.nickName.hidden = NO;
        wself.title.hidden = NO;
        wself.thankAward.hidden = YES;
    });
}

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        [_alertView setBackgroundColor:UIColorRGB(0xffffff)];
    }
    return _alertView;
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc]init];
        _header.layer.cornerRadius = SCALES(35);
        _header.layer.masksToBounds = YES;
        _header.layer.borderWidth = SCALES(1);
        _header.layer.borderColor = UIColor.whiteColor.CGColor;
        _header.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _header;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close2"] forState:UIControlStateNormal];
        _closeBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.cancelBlock) {
                wself.cancelBlock();
            }
        }];
    }
    return _closeBtn;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.text = @"送出小花吸引她的注意吧";
        _title.textColor = TITLE_COLOR;
        _title.font = TEXT_FONT_16;
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc]init];
        _nickName.text = @"@昵称";
        _nickName.textColor = TITLE_COLOR;
        _nickName.font = TEXT_FONT_14;
        _nickName.textAlignment = NSTextAlignmentCenter;
    }
    return _nickName;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.text = @"0";
        _moneyLabel.font = TEXT_FONT_16;
        _moneyLabel.textColor = TITLE_COLOR;
    }
    return _moneyLabel;
}

- (UIImageView *)moneyIcon {
    if (!_moneyIcon) {
        _moneyIcon = [[UIImageView alloc]init];
        _moneyIcon.image = [UIImage imageNamed:@"money"];
    }
    return _moneyIcon;
}

- (UIButton *)payBtn {
    if (!_payBtn) {
        _payBtn = [[UIButton alloc]init];
        [_payBtn setTitle:@"充值" forState:UIControlStateNormal];
        _payBtn.titleLabel.font = TEXT_FONT_16;
        [_payBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [wself goPay];
        }];
    }
    return _payBtn;
}

- (UIButton *)awardBtn {
    if (!_awardBtn) {
        _awardBtn = [[UIButton alloc]init];
        [_awardBtn setTitle:@"给Ta送花" forState:UIControlStateNormal];
        _awardBtn.titleLabel.font = TEXT_FONT_16;
        [_awardBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        _awardBtn.adjustsImageWhenHighlighted = NO;
        _awardBtn.layer.cornerRadius = SCALES(20);
        _awardBtn.layer.masksToBounds = YES;
        kWeakSelf(self);
        [[_awardBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if ([USER_INFO.user_id isEqualToString:self.model.user_id]) {
                kShowToast(@"不支持赞赏本人哦~");
                return;
            }
            if (USER_INFO.gender == 1) {
                kShowToast(@"暂不支持同性赞赏~");
                return;
            }
            if (wself.giftsModel.coin.integerValue < wself.selectGiftModel.price) {
                [wself goPay];
                return;
            }
            [ASVideoShowRequest requestVideoShowSendGiftWithType:2
                                                          showID:wself.model.ID
                                                           toUID:wself.model.user_id
                                                          giftID:wself.selectGiftModel.ID
                                                      giftTypeID:@"4"
                                                          liveID:@"0" success:^(id  _Nullable data) {
                NSString *coin = data;
                wself.moneyLabel.text = STRING(coin);
                wself.header.hidden = YES;
                wself.nickName.hidden = YES;
                wself.title.hidden = YES;
                wself.thankAward.hidden = NO;
                NSString *svgaUrl = [NSString stringWithFormat:@"%@%@", SERVER_IMAGE_URL, wself.selectGiftModel.svga];
                if (svgaUrl.length > 20) {
                    wself.giftPlayer.hidden = NO;
                    SVGAParser *giftParser = [[SVGAParser alloc] init];
                    [giftParser parseWithURL:[NSURL URLWithString:STRING(svgaUrl)] completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
                        if (videoItem != nil) {
                            wself.giftPlayer.videoItem = videoItem;
                            [wself.giftPlayer startAnimation];
                        }
                    } failureBlock:nil];
                }
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        }];
    }
    return _awardBtn;
}

- (SVGAPlayer *)giftPlayer {
    if (!_giftPlayer) {
        _giftPlayer = [[SVGAPlayer alloc]init];
        _giftPlayer.hidden = YES;
        _giftPlayer.frame = CGRectMake(SCREEN_WIDTH/2 - SCALES(100), HEIGHT_NAVBAR, SCALES(200), SCALES(200));
        _giftPlayer.loops = 1;
        _giftPlayer.delegate = self;
    }
    return _giftPlayer;
}

- (YYLabel *)agreementView {
    if (!_agreementView) {
        _agreementView = [[YYLabel alloc]init];
        kWeakSelf(self);
        _agreementView.attributedText = [ASTextAttributedManager videoShowGiftAwardAction:^{
            if (wself.cancelBlock) {
                wself.cancelBlock();
                [wself removeView];
            }
            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
            vc.webUrl = STRING(USER_INFO.configModel.webUrl.likeProtocol);
            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
        }];
        _agreementView.preferredMaxLayoutWidth = SCREEN_WIDTH;
    }
    return _agreementView;
}

- (UIView *)thankAward {
    if (!_thankAward) {
        _thankAward = [[UIView alloc]init];
        _thankAward.backgroundColor = UIColor.clearColor;
        _thankAward.hidden = YES;
        SVGAPlayer *player = [[SVGAPlayer alloc] init];
        SVGAParser *parser = [[SVGAParser alloc] init];
        [parser parseWithNamed:@"sendGift" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            if (videoItem != nil) {
                player.videoItem = videoItem;
                [player startAnimation];
            }
        } failureBlock:nil];
        [_thankAward addSubview:player];
        [player mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(_thankAward);
            make.width.height.mas_equalTo(SCALES(125));
        }];
        UILabel *text = [[UILabel alloc]init];
        text.text = @"“感谢你的赞赏”";
        text.textColor = UIColorRGB(0xFF8634);
        text.font = TEXT_MEDIUM(16);
        text.textAlignment = NSTextAlignmentCenter;
        [_thankAward addSubview:text];
        [text mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(player.mas_bottom);
            make.centerX.equalTo(_thankAward);
            make.height.mas_equalTo(SCALES(22.5));
        }];
    }
    return _thankAward;
}

- (void)removeView {
    [self removeFromSuperview];
}
@end


@interface ASVideoShowAwardGiftCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *giftName;
@property (nonatomic, strong) UIImageView *countIcon;
@property (nonatomic, strong) UILabel *count;
@end

@implementation ASVideoShowAwardGiftCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.giftName];
        [self.contentView addSubview:self.count];
        [self.contentView addSubview:self.countIcon];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(4));
        make.centerX.equalTo(self.contentView);
        make.height.width.mas_equalTo(SCALES(80));
    }];
    [self.giftName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(90));
        make.centerX.equalTo(self.icon);
        make.height.mas_equalTo(SCALES(20.5));
    }];
    [self.count mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.giftName.mas_bottom);
        make.centerX.equalTo(self.giftName).offset(SCALES(9));
        make.height.mas_equalTo(SCALES(20));
    }];
    [self.countIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.count);
        make.right.equalTo(self.count.mas_left).offset(SCALES(-2.5));
        make.height.width.mas_equalTo(SCALES(14));
    }];
}

- (void)setGiftModel:(ASGiftListModel *)giftModel {
    _giftModel = giftModel;
    [self.icon sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, giftModel.img]]];
    self.giftName.text = STRING(giftModel.name);
    self.count.text = [NSString stringWithFormat:@"%zd",giftModel.price];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.borderWidth = SCALES(1);
        _bgView.layer.cornerRadius = SCALES(8);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderColor = UIColor.whiteColor.CGColor;
    }
    return _bgView;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _icon;
}

- (UILabel *)giftName {
    if (!_giftName) {
        _giftName = [[UILabel alloc]init];
        _giftName.textColor = UIColor.blackColor;
        _giftName.font = TEXT_FONT_14;
    }
    return _giftName;
}

- (UILabel *)count {
    if (!_count) {
        _count = [[UILabel alloc]init];
        _count.font = TEXT_FONT_14;
        _count.textColor = TEXT_SIMPLE_COLOR;
    }
    return _count;
}

- (UIImageView *)countIcon {
    if (!_countIcon) {
        _countIcon = [[UIImageView alloc]init];
        _countIcon.image = [UIImage imageNamed:@"money1"];
    }
    return _countIcon;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.bgView.backgroundColor = UIColorRGB(0xFFF1F3);
        self.bgView.layer.borderColor = MAIN_COLOR.CGColor;
    } else {
        self.bgView.backgroundColor = UIColor.whiteColor;
        self.bgView.layer.borderColor = UIColor.whiteColor.CGColor;
    }
}

@end
