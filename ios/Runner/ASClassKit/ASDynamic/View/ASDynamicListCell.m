//
//  ASDynamicListCell.m
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASDynamicListCell.h"
#import "ASDynamicListUserView.h"
#import "ASDynamicListMediaView.h"
#import "ASDynamicListBottomView.h"

@interface ASDynamicListCell ()
@property (nonatomic, strong) UILabel *reviewView;
@property (nonatomic, strong) ASDynamicListUserView *userView;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) ASDynamicListMediaView *mediaView;
@property (nonatomic, strong) ASDynamicListBottomView *bottomView;
@end

@implementation ASDynamicListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.reviewView];
        [self.contentView addSubview:self.userView];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.mediaView];
        [self.contentView addSubview:self.bottomView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.reviewView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(34);
    }];
    [self.userView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((self.model.status == 0) ? SCALES(34) : SCALES(8));
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(SCALES(66));
    }];
    CGFloat textMaxLayoutWidth = floorf(SCREEN_WIDTH - SCALES(90));
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(SCALES(74));
        make.top.equalTo(self.userView.mas_bottom);
        make.width.mas_equalTo(textMaxLayoutWidth);
    }];
    self.content.preferredMaxLayoutWidth = textMaxLayoutWidth;
    [self.mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.content);
        make.top.equalTo(self.content.mas_bottom).offset(SCALES(12));
        make.height.mas_equalTo(self.model.mediaHeight);
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.right.equalTo(self.mediaView);
        make.height.mas_equalTo(SCALES(72));
    }];
}

- (void)setModel:(ASDynamicListModel *)model {
    _model = model;
    self.reviewView.hidden = model.status == 0 ? NO : YES;
    self.userView.model = model;
    self.mediaView.model = model;
    self.bottomView.model = model;
    self.content.text = model.content;
    if (self.content.text.length > 0 && self.content.text) {
        self.content.attributedText = [ASCommonFunc attributedWithString:model.content lineSpacing:SCALES(4.0)];
    }
}

- (void)setHiddenMore:(BOOL)hiddenMore {
    _hiddenMore = hiddenMore;
    self.bottomView.more.hidden = hiddenMore;
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

- (ASDynamicListUserView *)userView {
    if (!_userView) {
        _userView = [[ASDynamicListUserView alloc]init];
    }
    return _userView;
}

- (UILabel *)reviewView {
    if (!_reviewView) {
        _reviewView = [[UILabel alloc]init];
        _reviewView.text = @"动态将在审核完成后发布…";
        _reviewView.textColor = TITLE_COLOR;
        _reviewView.backgroundColor = UIColorRGB(0xFFF1F1);
        _reviewView.textAlignment = NSTextAlignmentCenter;
        _reviewView.font = TEXT_FONT_15;
    }
    return _reviewView;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = TITLE_COLOR;
        _content.numberOfLines = 0;
        _content.font = TEXT_FONT_14;
    }
    return _content;
}

- (ASDynamicListMediaView *)mediaView {
    if (!_mediaView) {
        _mediaView = [[ASDynamicListMediaView alloc]init];
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
