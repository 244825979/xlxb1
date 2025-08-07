//
//  ASBasePhotoCell.m
//  AS
//
//  Created by SA on 2025/4/21.
//

#import "ASBasePhotoCell.h"

@interface ASBasePhotoCell ()
@property (nonatomic, strong) UIButton *del;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ASBasePhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = SCALES(8);
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.del];
        [self.contentView addSubview:self.state];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView);
        make.top.mas_equalTo(SCALES(8));
        make.right.equalTo(self.contentView).offset(SCALES(-4));
    }];
    [self.del mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.height.width.mas_equalTo(SCALES(18));
    }];
    [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.imageView);
        make.size.mas_equalTo(CGSizeMake(SCALES(42), SCALES(18)));
    }];
}

- (void)setUrl:(NSString *)url {
    _url = url;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_IMAGE_URL, STRING(url)]]];
}

- (void)setIsHidenDel:(BOOL)isHidenDel {
    _isHidenDel = isHidenDel;
    self.del.hidden = isHidenDel;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = SCALES(8);
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UIImageView *)state {
    if (!_state) {
        _state = [[UIImageView alloc]init];
        _state.image = [UIImage imageNamed:@"state_review1"];
        _state.hidden = YES;
    }
    return _state;
}

- (UIButton *)del {
    if (!_del) {
        _del = [[UIButton alloc]init];
        [_del setBackgroundImage:[UIImage imageNamed:@"del_image"] forState:UIControlStateNormal];
        _del.adjustsImageWhenHighlighted = NO;
        _del.hidden = YES;
        kWeakSelf(self);
        [[_del rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.delBlock) {
                wself.delBlock();
            }
        }];
    }
    return _del;
}
@end
