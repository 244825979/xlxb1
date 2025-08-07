//
//  ASHeadPopRemindView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASHeadPopRemindView.h"

@implementation ASHeadPopRemindView

- (instancetype)initHeadPopViewWithCoin:(NSInteger)coin {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.size = CGSizeMake(SCALES(303), SCALES(340));
        kWeakSelf(self);
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"header_pop"];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        UILabel *title = [[UILabel alloc] init];
        title.font = TEXT_MEDIUM(36);
        title.text = [NSString stringWithFormat:@"%zd金币", coin];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = MAIN_COLOR;
        [bgView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView);
            make.top.mas_equalTo(SCALES(149));
            make.height.mas_equalTo(SCALES(48));
        }];
        UIButton *lingBtn = [[UIButton alloc] init];
        [lingBtn setBackgroundImage:[UIImage imageNamed:@"header_pop_btn"] forState:UIControlStateNormal];
        lingBtn.adjustsImageWhenHighlighted = NO;
        [self addSubview:lingBtn];
        [lingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(266));
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCALES(219), SCALES(50)));
        }];
        [[lingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.affirmBlock) {
                wself.affirmBlock();
            }
        }];
    }
    return self;
}
@end
