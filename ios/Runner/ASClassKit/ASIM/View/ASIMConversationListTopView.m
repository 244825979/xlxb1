//
//  ASIMConversationListTopView.m
//  AS
//
//  Created by SA on 2025/5/14.
//

#import "ASIMConversationListTopView.h"

@interface ASIMConversationListTopView ()
@property (nonatomic, strong) UIView *xitongtongzhiRedView;
@property (nonatomic, strong) UIView *huodongzhushouRedView;
@end

@implementation ASIMConversationListTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        kWeakSelf(self);
        NSArray *icons = @[@"im_top1", @"im_top2", @"im_top3", @"im_top4"];
        NSArray *titles = @[@"我的通话", @"系统通知", @"活动通知", @"评论和赞"];
        CGFloat itemW = (SCREEN_WIDTH - 20) /icons.count;
        for (int i = 0; i < icons.count; i++) {
            UIView *itemView = [self createView:icons[i] title:titles[i]];
            itemView.frame = CGRectMake(10 + itemW*i, 0, itemW, 100);
            [self addSubview:itemView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [itemView addGestureRecognizer:tap];
            [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                if (wself.indexBlock) {
                    wself.indexBlock(titles[i]);
                }
            }];
            if (i == 1 || i == 2) {
                UIView *redView = [[UIView alloc] init];
                redView.backgroundColor = RED_COLOR;
                redView.layer.cornerRadius = 5;
                redView.layer.masksToBounds = YES;
                redView.layer.borderColor = UIColor.whiteColor.CGColor;
                redView.layer.borderWidth = 1;
                redView.hidden = YES;
                [itemView addSubview:redView];
                redView.frame = CGRectMake(itemW-35, 15, 10, 10);
                if (i == 1) {
                    self.xitongtongzhiRedView = redView;
                }
                if (i == 2) {
                    self.huodongzhushouRedView = redView;
                }
            }
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRed:) name:@"refreshZushouOrHuodongNotify" object:nil];
        //每次进入初始化一下状态
        self.xitongtongzhiRedView.hidden = ![[ASIMManager shared] xitongIsUnread];
        self.huodongzhushouRedView.hidden = ![[ASIMManager shared] huodongIsUnread];
    }
    return self;
}

- (void)refreshRed:(NSNotification *)notification {
    if (kObjectIsEmpty(notification.object)) {
        NSString *isRed = notification.object;
        if (isRed.integerValue == 0) {
            self.xitongtongzhiRedView.hidden = YES;
            self.huodongzhushouRedView.hidden = YES;
        }
        if (isRed.integerValue == 1) {
            self.xitongtongzhiRedView.hidden = NO;
        }
        if (isRed.integerValue == 2) {
            self.huodongzhushouRedView.hidden = NO;
        }
    }
}

- (void)setHiddenRedWithType:(NSInteger)type {
    if (type == 0) {
        self.xitongtongzhiRedView.hidden = YES;
        self.huodongzhushouRedView.hidden = YES;
    }
    if (type == 1) {
        self.xitongtongzhiRedView.hidden = YES;
    }
    if (type == 2) {
        self.huodongzhushouRedView.hidden = YES;
    }
}

- (UIView *)createView:(NSString *)icon title:(NSString *)title {
    UIView *item = [[UIView alloc] init];
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.image = [UIImage imageNamed:icon];
    [item addSubview:iconImage];
    [iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.centerX.equalTo(item);
        make.width.height.mas_equalTo(45);
     }];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = title;
    titleLabel.textColor = TITLE_COLOR;
    titleLabel.font = TEXT_FONT_11;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [item addSubview:titleLabel];
    [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImage.mas_bottom).offset(2);
        make.centerX.equalTo(iconImage);
        make.height.mas_equalTo(20);
     }];
    return item;
}
@end
