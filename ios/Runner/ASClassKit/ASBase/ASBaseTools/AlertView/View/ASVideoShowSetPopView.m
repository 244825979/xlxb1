//
//  ASVideoShowSetPopView.m
//  AS
//
//  Created by SA on 2025/5/12.
//

#import "ASVideoShowSetPopView.h"
#import "ASVideoShowRequest.h"

@interface ASVideoShowSetPopView ()
@property (nonatomic, strong) ASVideoShowSetListView *openView;
@property (nonatomic, strong) ASVideoShowSetListView *closeView;
@property (nonatomic, strong) ASVideoShowSetListView *setCoverView;
@property (nonatomic, strong) ASVideoShowSetListView *delView;
@end

@implementation ASVideoShowSetPopView

- (instancetype)init {
    if (self = [super init]) {
        self.size = CGSizeMake(SCREEN_WIDTH,  SCALES(226) + TAB_BAR_MAGIN20);
        self.backgroundColor = UIColor.whiteColor;
        [self createUI];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(SCALES(12), SCALES(12))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.openView];
    [self addSubview:self.closeView];
    [self addSubview:self.setCoverView];
    [self addSubview:self.delView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.openView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(12));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(SCALES(49));
    }];
    
    [self.closeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.openView.mas_bottom);
        make.left.right.height.equalTo(self.openView);
    }];
    
    [self.setCoverView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.closeView.mas_bottom).offset(SCALES(5));
        make.left.right.height.equalTo(self.openView);
    }];
    
    [self.delView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.setCoverView.mas_bottom);
        make.left.right.height.equalTo(self.openView);
    }];
}

- (void)setModel:(ASVideoShowDataModel *)model {
    _model = model;
    if (model.is_cover.integerValue == 1) {
        self.setCoverView.title.textColor = UIColorRGB(0x999999);
        self.setCoverView.icon.image = [UIImage imageNamed:@"video_top1"];
    } else {
        self.setCoverView.title.textColor = UIColorRGB(0x000000);
        self.setCoverView.icon.image = [UIImage imageNamed:@"video_top"];
    }
    
    if (model.show_status.integerValue == 1) {
        self.openView.selectIcon.hidden = NO;
        self.closeView.selectIcon.hidden = YES;
    } else {
        self.openView.selectIcon.hidden = YES;
        self.closeView.selectIcon.hidden = NO;
    }
}

- (void)videoShowSetStateIsOpen:(NSString *)isOpen {
    kWeakSelf(self);
    [ASVideoShowRequest requestSetStateVideoShowWithVideoID:self.model.ID showStatus:isOpen success:^(id  _Nullable data) {
        wself.model.show_status = isOpen;
        if (wself.model.show_status.integerValue == 1) {
            wself.openView.selectIcon.hidden = NO;
            wself.closeView.selectIcon.hidden = YES;
        } else {
            wself.openView.selectIcon.hidden = YES;
            wself.closeView.selectIcon.hidden = NO;
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (ASVideoShowSetListView *)openView {
    if (!_openView) {
        _openView = [[ASVideoShowSetListView alloc]init];
        _openView.icon.image = [UIImage imageNamed:@"video_lock1"];
        _openView.title.text = @"公开：所有人可见";
        kWeakSelf(self);
        _openView.clikedBlock = ^{
            if (wself.model.show_status.integerValue == 1) {
                kShowToast(@"不需要重复设置！");
                return;
            }
            [wself videoShowSetStateIsOpen:@"1"];
        };
    }
    return _openView;
}

- (ASVideoShowSetListView *)closeView {
    if (!_closeView) {
        _closeView = [[ASVideoShowSetListView alloc]init];
        _closeView.icon.image = [UIImage imageNamed:@"video_lock"];
        _closeView.title.text = @"私密：仅自己可见";
        kWeakSelf(self);
        _closeView.clikedBlock = ^{
            if (wself.model.show_status.integerValue == 0) {
                kShowToast(@"不需要重复设置！");
                return;
            }
            [wself videoShowSetStateIsOpen:@"0"];
        };
    }
    return _closeView;
}

- (ASVideoShowSetListView *)setCoverView {
    if (!_setCoverView) {
        _setCoverView = [[ASVideoShowSetListView alloc]init];
        _setCoverView.icon.image = [UIImage imageNamed:@"video_top"];
        _setCoverView.title.text = @"设为封面视频秀";
        kWeakSelf(self);
        _setCoverView.clikedBlock = ^{
            if (wself.model.is_cover.integerValue == 1) {
                if (wself.cancelBlock) {
                    wself.cancelBlock();
                }
                return;
            }
            [ASVideoShowRequest requestSetVideoShowCoverWithVideoID:wself.model.ID success:^(id  _Nullable data) {
                if (wself.cancelBlock) {
                    wself.cancelBlock();
                }
                wself.model.is_cover = @"1";
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        };
    }
    return _setCoverView;
}

- (ASVideoShowSetListView *)delView {
    if (!_delView) {
        _delView = [[ASVideoShowSetListView alloc]init];
        _delView.icon.image = [UIImage imageNamed:@"video_del"];
        _delView.title.text = @"删除视频秀";
        kWeakSelf(self);
        _delView.clikedBlock = ^{
            [ASAlertViewManager defaultPopTitle:@"温馨提示" content:@"确认删除当前视频秀" left:@"确认" right:@"取消" affirmAction:^{
                [ASVideoShowRequest requestDelVideoShowCoverWithVideoID:wself.model.ID success:^(id  _Nullable data) {
                    if (wself.delBlock) {
                        wself.delBlock();
                    }
                } errorBack:^(NSInteger code, NSString *msg) {
                    
                }];
            } cancelAction:^{
                
            }];
        };
    }
    return _delView;
}

@end

@implementation ASVideoShowSetListView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.icon];
        [self addSubview:self.title];
        [self addSubview:self.selectIcon];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.clikedBlock) {
                wself.clikedBlock();
            }
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.centerY.equalTo(self);
    }];
    
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(SCALES(10));
        make.centerY.equalTo(self);
    }];
    
    [self.selectIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(SCALES(-16));
        make.centerY.equalTo(self);
    }];
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
        _title.textColor = TITLE_COLOR;
        _title.font = TEXT_FONT_14;
    }
    return _title;
}

- (UIImageView *)selectIcon {
    if (!_selectIcon) {
        _selectIcon = [[UIImageView alloc]init];
        _selectIcon.image = [UIImage imageNamed:@"video_select"];
        _selectIcon.hidden = YES;
    }
    return _selectIcon;
}
@end
