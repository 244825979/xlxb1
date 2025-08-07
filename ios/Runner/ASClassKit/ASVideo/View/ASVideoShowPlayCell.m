//
//  ASVideoShowPlayCell.m
//  AS
//
//  Created by SA on 2025/5/12.
//

#import "ASVideoShowPlayCell.h"

@implementation ASVideoShowPlayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.blackColor;
        CGRect frame = self.contentView.bounds;
        self.videoCoverView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        self.videoCoverView.contentMode = UIViewContentModeScaleAspectFill;
        self.videoCoverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.videoCoverView];
        
        self.videoParentView = [[UIView alloc] initWithFrame:frame];
        self.videoParentView.tag = 10000;
        self.videoParentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.videoParentView];
        
        self.maskView = [[ASVideoShowMaskView alloc] initWithFrame:frame];
        self.maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.maskView.delegate = self;
        [self.contentView addSubview:self.maskView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
}
- (void)setPopType:(VideoPlayListType)popType {
    _popType = popType;
    self.maskView.popType = popType;
}

- (void)setModel:(ASVideoShowDataModel *)model {
    _model = model;
    for (UIView *subview in self.videoParentView.subviews) {
        [subview removeFromSuperview];
    }
    [self.videoCoverView setImageWithURL:[NSURL URLWithString: self.model.cover_img_url] placeholder:[UIImage imageNamed:@"video_show_player_bg"]];
    self.maskView.model = model;
}

- (void)setIsFollow:(BOOL)isFollow {
    _isFollow = isFollow;
    self.maskView.isFollow = isFollow;
}

- (void)setIsSilence:(BOOL)isSilence {
    _isSilence = isSilence;
    self.maskView.isSilence = isSilence;
}

- (void)setNotifictionAcount:(NSString *)notifictionAcount {
    _notifictionAcount = notifictionAcount;
    self.maskView.notifictionAcount = notifictionAcount;
}

#pragma QWVideoDecorateDelegate
- (void)cellClickBackBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellClickBackBtn)]) {
        [self.delegate cellClickBackBtn];
    }
}

- (void)clickScreen:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickScreen:)]) {
        [self.delegate clickScreen:gestureRecognizer];
    }
}

- (void)cellClickPublishBtn:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellClickPublishBtn:)]) {
        [self.delegate cellClickPublishBtn:button];
    }
}

- (void)cellClickVoiceOnOffBtn:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellClickVoiceOnOffBtn:)]) {
        [self.delegate cellClickVoiceOnOffBtn:button];
    }
}

- (void)cellClickVoicePause {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellClickVoicePause)]) {
        [self.delegate cellClickVoicePause];
    }
}

- (void)cellClickVoiceAttention:(BOOL)isAttention videoShowModel:(ASVideoShowDataModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellClickVoiceAttention:videoShowModel:)]) {
        [self.delegate cellClickVoiceAttention:isAttention videoShowModel:model];
    }
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
