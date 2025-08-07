//
//  ASEditSetVoiceSignController.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASEditSetVoiceSignController.h"
#import "ASBaseTranscribeAudioView.h"
#import "ASMineRequest.h"

@interface ASEditSetVoiceSignController ()
@property (nonatomic, strong) UILabel *signLabel;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) NSArray *lists;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) ASBaseTranscribeAudioView *recordView;
@end

@implementation ASEditSetVoiceSignController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"语音签名";
    [self createUI];
    [self requestData];
}

- (void)createUI {
    self.view.backgroundColor = BACKGROUNDCOLOR;
    kWeakSelf(self);
    UILabel *textHint = [[UILabel alloc]init];
    textHint.font = TEXT_FONT_15;
    textHint.textColor = TITLE_COLOR;
    textHint.text = @"读出你的声音，让你更有魅力。";
    [self.view addSubview:textHint];
    [textHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(14));
        make.left.mas_equalTo(SCALES(14));
        make.height.mas_equalTo(SCALES(24));
    }];
    
    UIView *textBg = [[UIView alloc] init];
    textBg.backgroundColor = UIColor.whiteColor;
    textBg.layer.cornerRadius = SCALES(16);
    [self.view addSubview:textBg];
    [textBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textHint.mas_bottom).offset(SCALES(12));
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).offset(SCALES(-28));
        make.height.mas_equalTo(SCALES(197));
    }];
    
    self.changeBtn = ({
        UIButton *button = [[UIButton alloc]init];
        [button setBackgroundImage:[UIImage imageNamed:@"signature_change"] forState:UIControlStateNormal];
        button.layer.cornerRadius = SCALES(14);
        button.layer.masksToBounds = YES;
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.lists.count > wself.index) {
                wself.signLabel.text = wself.lists[wself.index];
                wself.index++;
            } else {
                if (wself.lists.count > 0) {
                    wself.index = 0;
                    wself.signLabel.text = wself.lists[wself.index];
                    wself.index++;
                }
            }
        }];
        [textBg addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(textBg).offset(SCALES(-14));
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCALES(82), SCALES(28)));
        }];
        button;
    });
    
    UIImageView *icon1 = [[UIImageView alloc] init];
    icon1.image = [UIImage imageNamed:@"signature_up"];
    [textBg addSubview:icon1];
    [icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(SCALES(14));
        make.size.mas_equalTo(CGSizeMake(SCALES(26), SCALES(22)));
    }];
    
    UIImageView *icon2 = [[UIImageView alloc] init];
    icon2.image = [UIImage imageNamed:@"signature_down"];
    [textBg addSubview:icon2];
    [icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(SCALES(-14));
        make.size.mas_equalTo(CGSizeMake(SCALES(26), SCALES(22)));
    }];
    
    [textBg addSubview:self.signLabel];
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(15));
        make.top.equalTo(icon1.mas_bottom).offset(SCALES(15));
        make.right.equalTo(textBg).offset(SCALES(-12));
    }];
    
    [self.view addSubview:self.recordView];
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset((SCALES(-34) - TAB_BAR_MAGIN));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(SCALES(170));
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}

- (void)requestData {
    kWeakSelf(self);
    [ASMineRequest requestVoiceTextListSuccess:^(id  _Nullable data) {
        wself.lists = data;
        if (wself.lists.count > wself.index) {
            wself.signLabel.attributedText = [ASCommonFunc attributedWithString:wself.lists[wself.index] lineSpacing:SCALES(3.0)];
            wself.index++;
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}
//上传音频文件
- (void)updateAudioWithFilePath:(NSString *)path time:(NSInteger)time {
    kWeakSelf(self);
    [[ASUploadImageManager shared] audioUpdateWithType:@"voice" filePath:path success:^(id  _Nonnull response) {
        NSString *url = response;
        kShowToast(@"语音签名录制成功");
        if (wself.saveBlock) {
            wself.saveBlock(url, time);
        }
        [wself.navigationController popViewControllerAnimated:YES];
    } fail:^{
        
    }];
}

- (UILabel *)signLabel {
    if (!_signLabel) {
        _signLabel = [[UILabel alloc]init];
        _signLabel.font = TEXT_FONT_15;
        _signLabel.textColor = TITLE_COLOR;
        _signLabel.numberOfLines = 0;
    }
    return _signLabel;
}

- (ASBaseTranscribeAudioView *)recordView {
    if (!_recordView) {
        _recordView = [[ASBaseTranscribeAudioView alloc]init];
        _recordView.type = 1;
        kWeakSelf(self);
        _recordView.saveBlock = ^(NSString * _Nonnull filePath, NSInteger voiceTime) {
            [wself updateAudioWithFilePath:filePath time:voiceTime];
        };
    }
    return _recordView;
}
@end
