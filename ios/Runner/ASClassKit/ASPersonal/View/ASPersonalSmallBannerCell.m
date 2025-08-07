//
//  ASPersonalSmallBannerCell.m
//  AS
//
//  Created by SA on 2025/5/6.
//

#import "ASPersonalSmallBannerCell.h"

@interface ASPersonalSmallBannerCell()
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation ASPersonalSmallBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = SCALES(8);
        self.contentView.layer.borderColor = UIColor.whiteColor.CGColor;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setPhotoUrl:(NSString *)photoUrl {
    _photoUrl = photoUrl;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:STRING(photoUrl)]];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.contentView.layer.borderWidth = SCALES(1);
    } else {
        self.contentView.layer.borderWidth = SCALES(0);
    }
}
@end
