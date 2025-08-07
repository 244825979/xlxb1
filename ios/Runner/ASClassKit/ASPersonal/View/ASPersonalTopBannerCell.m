//
//  ASPersonalTopBannerCell.m
//  AS
//
//  Created by SA on 2025/4/24.
//

#import "ASPersonalTopBannerCell.h"

@interface ASPersonalTopBannerCell ()
@property (nonatomic, strong) UIImageView *imageBg;
@end

@implementation ASPersonalTopBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:self.imageBg];
        [self.contentView addSubview:self.portraitView];
    }
    return self;
}

#pragma mark - 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.portraitView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.imageBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setModel:(ASAlbumsModel *)model {
    _model = model;
    if (model.is_video_show == 1) {
        [self.imageBg sd_setImageWithURL:[NSURL URLWithString:model.cover_img_url]];
    } else {
        [self.imageBg sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.url]]];
    }
}

- (UIImageView *)imageBg {
    if (!_imageBg) {
        _imageBg = [[UIImageView alloc]init];
        _imageBg.contentMode = UIViewContentModeScaleAspectFill;
        _imageBg.userInteractionEnabled = YES;
    }
    return _imageBg;
}

- (UIView *)portraitView {
    if (!_portraitView) {
        _portraitView = [[UIView alloc] init];
        _portraitView.backgroundColor = UIColor.clearColor;
    }
    return _portraitView;
}
@end
