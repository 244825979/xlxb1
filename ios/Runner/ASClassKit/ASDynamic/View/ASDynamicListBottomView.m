//
//  ASDynamicListBottomView.m
//  AS
//
//  Created by SA on 2025/5/7.
//

#import "ASDynamicListBottomView.h"
#import "ASDynamicRequest.h"

@interface ASDynamicListBottomView()
@property (nonatomic, strong) UILabel *createTime;
@property (nonatomic, strong) UIButton *zan;
@property (nonatomic, strong) UIButton *comment;
@end

@implementation ASDynamicListBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.createTime];
        [self addSubview:self.zan];
        [self addSubview:self.comment];
        [self addSubview:self.more];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.createTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(SCALES(32));
    }];
    [self.zan mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.createTime.mas_bottom);
        make.left.equalTo(self);
        make.height.mas_equalTo(SCALES(24));
    }];
    [self.comment mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(110));
        make.centerY.height.equalTo(self.zan);
    }];
    [self.more mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.createTime);
        make.centerY.height.equalTo(self.zan);
    }];
}

- (void)setModel:(ASDynamicListModel *)model {
    _model = model;
    self.createTime.text = model.create_time;
    if (model.like_count > 0 && model.like_count < 1000) {
        [self.zan setTitle:[NSString stringWithFormat:@" %zd", model.like_count] forState:UIControlStateNormal];
    } else if (model.like_count > 999) {
        [self.zan setTitle:@" 999+" forState:UIControlStateNormal];
    } else {
        [self.zan setTitle:@" 点赞" forState:UIControlStateNormal];
    }
    if (model.comment_count > 0 && model.comment_count < 1000) {
        [self.comment setTitle:[NSString stringWithFormat:@" %zd", model.comment_count] forState:UIControlStateNormal];
    } else if (model.comment_count > 999) {
        [self.comment setTitle:@" 999+" forState:UIControlStateNormal];
    } else {
        [self.comment setTitle:@" 评论" forState:UIControlStateNormal];
    }
    if (model.is_like) {
        self.zan.selected = YES;
    } else {
        self.zan.selected = NO;
    }
    self.more.hidden = [self.model.user_id isEqualToString:USER_INFO.user_id];
}

- (UILabel *)createTime {
    if (!_createTime) {
        _createTime = [[UILabel alloc]init];
        _createTime.font = TEXT_FONT_11;
        _createTime.textColor = TEXT_SIMPLE_COLOR;
    }
    return _createTime;
}

- (UIButton *)zan {
    if (!_zan) {
        _zan = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zan setTitle:@" 点赞" forState:UIControlStateNormal];
        [_zan setImage:[UIImage imageNamed:@"zan2"] forState:UIControlStateNormal];
        [_zan setImage:[UIImage imageNamed:@"zan3"] forState:UIControlStateSelected];
        _zan.adjustsImageWhenHighlighted = NO;
        _zan.titleLabel.font = TEXT_FONT_14;
        [_zan setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_zan rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASMyAppCommonFunc likeWithDynamicID:wself.model.ID isLike:wself.model.is_like action:^(id  _Nonnull data) {
                wself.model.is_like = !wself.model.is_like;
                if (wself.model.is_like) {
                    wself.zan.selected = YES;
                    wself.model.like_count += 1;
                } else {
                    wself.zan.selected = NO;
                    wself.model.like_count -= 1;
                }
                
                if (wself.model.like_count > 0 && wself.model.like_count < 1000) {
                    [wself.zan setTitle:[NSString stringWithFormat:@" %zd", wself.model.like_count] forState:UIControlStateNormal];
                } else if (wself.model.like_count > 999) {
                    [wself.zan setTitle:@" 999+" forState:UIControlStateNormal];
                } else {
                    [wself.zan setTitle:@" 点赞" forState:UIControlStateNormal];
                }
            }];
        }];
    }
    return _zan;
}

- (UIButton *)comment {
    if (!_comment) {
        _comment = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comment setTitle:@" 评论" forState:UIControlStateNormal];
        [_comment setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        _comment.titleLabel.font = TEXT_FONT_14;
        [_comment setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        _comment.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_comment rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.clikedBlock) {
                wself.clikedBlock(@"评论");
            }
        }];
    }
    return _comment;
}

- (UIButton *)more {
    if (!_more) {
        _more = [UIButton buttonWithType:UIButtonTypeCustom];
        [_more setImage:[UIImage imageNamed:@"more2"] forState:UIControlStateNormal];
        _more.adjustsImageWhenHighlighted = NO;
        _more.hidden = YES;
        kWeakSelf(self);
        [[_more rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [ASAlertViewManager bottomPopTitles:@[@"减少该内容推荐"] indexAction:^(NSString * _Nonnull indexName) {
                [ASDynamicRequest requestDynamicDisLikeWithID:wself.model.ID success:^(id  _Nonnull response) {
                    if (wself.clikedBlock) {
                        wself.clikedBlock(@"删除");
                    }
                } errorBack:^(NSInteger code, NSString * _Nonnull message) {
                    
                }];
            } cancelAction:^{
                
            }];
        }];
    }
    return _more;
}
@end
