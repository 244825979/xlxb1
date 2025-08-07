//
//  ASFaceunityProtocolAlertView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASFaceunityProtocolAlertView.h"

@implementation ASFaceunityProtocolAlertView

//构造方法
- (instancetype)initFaceunityProtocolPopView {
    if (self = [super init]) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = SCALES(12);
        self.size = CGSizeMake(SCREEN_WIDTH - SCALES(72), SCALES(100));
        kWeakSelf(self);
        YYLabel *agreementView = [[YYLabel alloc] init];
        agreementView.attributedText = [ASTextAttributedManager faceunityProtocolPopAgreement:^{
            if (wself.affirmBlock) {
                wself.affirmBlock();
            }
        }];
        agreementView.numberOfLines = 0;
        agreementView.preferredMaxLayoutWidth = SCREEN_WIDTH - SCALES(72) - SCALES(40);
        agreementView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:agreementView];
        [agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALES(20));
            make.right.equalTo(self.mas_right).offset(SCALES(-20));
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

@end
