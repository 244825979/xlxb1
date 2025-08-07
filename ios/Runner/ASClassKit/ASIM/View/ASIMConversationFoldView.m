//
//  ASIMConversationFoldView.m
//  AS
//
//  Created by SA on 2025/5/14.
//

#import "ASIMConversationFoldView.h"
#import "心聊想伴-Swift.h"

@interface ASIMConversationFoldView ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIImageView *back;
@property (nonatomic, strong) UIView *redView;
@end

@implementation ASIMConversationFoldView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.icon];
        [self addSubview:self.redView];
        [self addSubview:self.title];
        [self addSubview:self.content];
        [self addSubview:self.back];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            //进入到搭讪会话列表，清空搭讪数据
            [ASIMHelperDataManager shared].dashanAmount = 0;
            self.title.attributedText = [self setAttributedWithText:USER_INFO.gender == 1 ? @"你已搭讪0人" : @"0人搭讪了你"];
            UIViewController *vc = [ASIMFuncManager dashanListController];
            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated: YES];
        }];
    }
    return self;
}

- (void)setDashanAmount:(NSInteger)dashanAmount {
    _dashanAmount = dashanAmount;
    if (USER_INFO.gender == 1) {//我是女
        NSString *acount = [ASIMHelperDataManager shared].dashanAmount > 99 ? @"99+" : [NSString stringWithFormat:@"%zd", dashanAmount];
        self.title.attributedText = [self setAttributedWithText:[NSString stringWithFormat:@"你已搭讪%@人",acount]];
        self.content.text = @"资料越完善，回复率越高哦~";
        self.redView.hidden = YES;
    }
    if (USER_INFO.gender == 2) {//我是男
        NSString *acount = dashanAmount >= USER_INFO.systemIndexModel.foldVol ? [NSString stringWithFormat:@"%zd+", USER_INFO.systemIndexModel.foldVol - 1] : [NSString stringWithFormat:@"%zd", dashanAmount];
        self.title.attributedText = [self setAttributedWithText:[NSString stringWithFormat:@"%@人搭讪了你",acount]];
        if ([ASIMHelperDataManager shared].dashanList.count > 0) {//获取最后一条消息的文本
            NSString *userid = [ASIMHelperDataManager shared].dashanList[[ASIMHelperDataManager shared].dashanList.count -1];
            NIMSession *session = [NIMSession session:userid type:NIMSessionTypeP2P];
            NIMRecentSession *recentSession = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
            NIMMessage *lastMessage = recentSession.lastMessage;
            if (kObjectIsEmpty(recentSession) || kObjectIsEmpty(lastMessage)) {
                self.content.text = @"";
            } else {
                NSString *contentStr = [ASMyAppCommonFunc lastMessgeHint:lastMessage];;
                self.content.text = [NSString stringWithFormat:@"%@：%@",STRING(lastMessage.senderName), contentStr];
            }
        }
    }
}

- (void)setIsUnread:(BOOL)isUnread {
    _isUnread = isUnread;
    if (USER_INFO.gender == 2) {//我是男
        self.redView.hidden = ![[ASIMManager shared] dashanIsUnread];
    }
}

- (NSMutableAttributedString *)setAttributedWithText:(NSString *)text {
    //富文本设置
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:text];
    if (USER_INFO.gender == 1) {
        [attributed addAttribute:NSForegroundColorAttributeName
                                value:TITLE_COLOR
                                range:NSMakeRange(0, 4)];
        [attributed addAttribute:NSForegroundColorAttributeName
                                value:TITLE_COLOR
                                range:NSMakeRange(text.length - 1, 1)];
    } else {
        [attributed addAttribute:NSForegroundColorAttributeName
                                value:TITLE_COLOR
                                range:NSMakeRange(text.length - 5, 5)];
    }
    return attributed;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(60);
    }];
    [self.redView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.icon.mas_right).offset(-2);
        make.top.equalTo(self.icon).offset(4);
        make.height.width.mas_equalTo(10);
    }];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(12);
        make.top.equalTo(self.icon.mas_top).offset(7);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.mas_right).offset(-44);
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.title);
        make.top.equalTo(self.title.mas_bottom).offset(10);
        make.height.mas_equalTo(18);
    }];
    [self.back mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-16);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.image = [UIImage imageNamed:@"im_fold"];
    }
    return _icon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.text = @"0人搭讪了你";
        _title.textColor = UIColorRGB(0xFF1832);
        _title.font = TEXT_MEDIUM(16);
    }
    return _title;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.text = @"资料越完善，回复率越高哦~";
        _content.textColor = TEXT_SIMPLE_COLOR;
        _content.font = TEXT_FONT_13;
    }
    return _content;
}

- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc]init];
        _redView.backgroundColor = RED_COLOR;
        _redView.layer.cornerRadius = 5;
        _redView.layer.masksToBounds = YES;
        _redView.layer.borderColor = UIColor.whiteColor.CGColor;
        _redView.layer.borderWidth = 1;
        _redView.hidden = YES;
    }
    return _redView;
}

- (UIImageView *)back {
    if (!_back) {
        _back = [[UIImageView alloc]init];
        _back.image = [UIImage imageNamed:@"cell_back"];
    }
    return _back;
}
@end
